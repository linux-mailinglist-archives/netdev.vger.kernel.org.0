Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD51A5A513E
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiH2QPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 12:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiH2QPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:15:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E301EC54
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 09:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=xxC0Tj0gsN7X8VitoySWsPS/OXwdfc/ktr57m6hbvmw=; b=TY
        DTH0ZWaIsBtj6UMnryBAFIUbuw3Flo+PWZ9/TBFLB07f5uYxDLnI6fohtQKxxI2wwWiYseMJpfAVU
        Qe6KcYUNnff/ZXnZFAf2qrfKtuJPbirdxMgZI8TGXVVC9jHIT2GJ7xOXz0N82blOXsNhexJ7V50/m
        A5iZB9zct8G6X6E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oShPw-00Eyeb-BA; Mon, 29 Aug 2022 18:15:16 +0200
Date:   Mon, 29 Aug 2022 18:15:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/3] sfc: add support for PTP over IPv6 and
 802.3
Message-ID: <YwzmFPrWmmU7XI+i@lunn.ch>
References: <20220819082001.15439-1-ihuguet@redhat.com>
 <20220825090242.12848-1-ihuguet@redhat.com>
 <YwegaWH6yL2RHW+6@lunn.ch>
 <CACT4oufGh++TyEY-FdfUjZpXSxmbC0W2O-y4uprQdYFTevv2pw@mail.gmail.com>
 <YwjB84tvHAPymRRn@lunn.ch>
 <CACT4oudsW5LNdwDbaKK7=DX9wiPua1cYdQ7DLuRsNoZmV8=tmQ@mail.gmail.com>
 <YwzPbIxDOaC5h1pK@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YwzPbIxDOaC5h1pK@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 07:38:36AM -0700, Richard Cochran wrote:
> On Mon, Aug 29, 2022 at 09:09:48AM +0200, Íñigo Huguet wrote:
> > Richard, missed to CC you in this patch series, just in case it's of
> > your interest.
> 
> I do appreciate being on CC for anything PTP related.

Russell King had the issue he was being missed on a lot of PHYLINK
patches. He updated the MAINTAINERS entry with:

K:	phylink\.h|struct\s+phylink|\.phylink|>phylink_|phylink_(autoneg|clear|connect|create|destroy|disconnect|ethtool|helper|mac|mii|of|set|start|stop|test|validate)

Maybe you could add some sort of regex for common ptp functions and structures?

      Andrew
