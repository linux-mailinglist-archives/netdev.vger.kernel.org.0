Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025A64D19C5
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 14:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346304AbiCHN6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 08:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239120AbiCHN6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 08:58:12 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9705349F81;
        Tue,  8 Mar 2022 05:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GB1t9ldL61E9UsfsGA7ULpDmv1SW9R1JDfey9v2Hufo=; b=gYo/DpjU99S2QFe/XNEa+mufxY
        jL641jGP8OfRex8LXyccsgsAMSt1wk16U2EX4PdkB7gKmmJ5cgtyE7kn6wenNtPt+nYNbhp4e3+kz
        /Rn8Guj9vpt7S3sYtuUkL5ehMVLMGN/sdYgRA3QcEdn5Jf22JnkqKNCRLNmJECty4Qz0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRaKq-009nto-E4; Tue, 08 Mar 2022 14:57:08 +0100
Date:   Tue, 8 Mar 2022 14:57:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Cai,Huoqing" <caihuoqing@baidu.com>
Cc:     Jianglei Nie <niejianglei2021@163.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: arc_emac: Fix use after free in arc_mdio_probe()
Message-ID: <YidgtERU1PwGywbE@lunn.ch>
References: <20220308111005.4953-1-niejianglei2021@163.com>
 <YiddVEBJvM81u1jJ@lunn.ch>
 <a4c518cf3d5d4ad383ce0856d1641d4a@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4c518cf3d5d4ad383ce0856d1641d4a@baidu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If resend a patch,  you can use prefix "[PATCH v2]" in subject.
> e.g.  git format-patch -1 -v2

Yes.

But please also read the netdev FAQ:

https://docs.kernel.org/networking/netdev-FAQ.html

	Andrew
