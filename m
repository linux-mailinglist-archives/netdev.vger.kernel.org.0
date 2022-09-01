Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410745A89B3
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 02:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiIAADK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 20:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiIAADJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 20:03:09 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA67F324A
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 17:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5yAjwF1wCI83Hst5wpocJUGsj0xTjkYMw3u/BgUGIrE=; b=s6zhh4BowJgevnKuXRTjw+grda
        ZOeJfopVXMrW/kZVOb0miCV0LoUKFKBs9oBPFvmsFUMUDRI6CT4zP8SuOi60eBXUh7UrMhoEStL9k
        pDfxQkgkZ485x98Uk9TtDhV1HSSI3MQ8FCEW1gqGVLj2NSEVAqsK54WL8Ch6ENfGBNoQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oTXfn-00FFYA-33; Thu, 01 Sep 2022 02:03:07 +0200
Date:   Thu, 1 Sep 2022 02:03:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v2 02/16] net: txgbe: Reset hardware
Message-ID: <Yw/2u746uEk85S7u@lunn.ch>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
 <20220830070454.146211-3-jiawenwu@trustnetic.com>
 <Yw6tsmufKFoHzu4M@lunn.ch>
 <025801d8bce5$0423b010$0c6b1030$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <025801d8bce5$0423b010$0c6b1030$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 10:54:40AM +0800, Jiawen Wu wrote:
> On Wednesday, August 31, 2022 8:39 AM, Andrew Lunn wrote:
> > n Tue, Aug 30, 2022 at 03:04:40PM +0800, Jiawen Wu wrote:
> > >  /* struct txgbe_mac_operations */
> > > +static int txgbe_stop_adapter_dummy(struct txgbe_hw *TUP0) {
> > > +	return -EPERM;
> > 
> > This is a bit of an odd error code. -EOPNOTSUPP would be more normal.
> > 
> > I do wonder what all this dummy stuff is for...
> > 
> 
> Okay, I just think that this way I don't need to determine whether the
> function pointer is NULL every time it is called.

Have you seen many other driver doing this? I don't think i have. They
just check the pointer before calling thought it. You want your driver
to look just like every other Linux Ethernet driver.

   Andrew

