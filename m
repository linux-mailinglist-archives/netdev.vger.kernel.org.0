Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5218B58CECF
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 22:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbiHHUC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 16:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiHHUC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 16:02:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CACC61
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 13:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xuax5FyxMCBfCamXC1AuNaZFuy6ezKIaQY6pnyKYcso=; b=IRN6WZOMm6dCI/ccr00IejCv6/
        /tVF28vIrIA8iQhtKe/6nom6TDYAaQ35bzRvPEXvhAbO2wvYmua+HuflQ+DecYn/vwzC267zjNNiw
        YeC+dmkF87c9kWP8yxMmnM0VpkQ3Y/4/k1+pGFyOHA5Y5eZ+/Wo4QvDq1Glmnt0aSGYI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oL8xE-00CksP-FY; Mon, 08 Aug 2022 22:02:24 +0200
Date:   Mon, 8 Aug 2022 22:02:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mahendra SP <mahendra.sp@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: TAHI IPv6 test failures on 4.19 LTS
Message-ID: <YvFr0KbCkm/0ElOb@lunn.ch>
References: <CADDGra1JwDNgjUm6EPUnu+d1cDaCd8VD44jfN9yeevWY45LY_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADDGra1JwDNgjUm6EPUnu+d1cDaCd8VD44jfN9yeevWY45LY_g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 08, 2022 at 10:17:24AM +0530, Mahendra SP wrote:
> Hi,
> 
> We are seeing a total 18 failures when TAHI IPv6 conformance test tool
> is run against kernel version 4.19 ( specifically 4.19.29 )

It is unlikely anybody will help you with 4.19.29.  You might get some
help if you reported problems against the latest 4.19, i.e. currently
4.19.254.

     Andrew
