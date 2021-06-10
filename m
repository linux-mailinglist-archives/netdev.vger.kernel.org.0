Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F289F3A2E74
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhFJOom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:44:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56482 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230153AbhFJOoj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 10:44:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=G/4KF+EXeK0CRlPgzQxnXXiJ5+yIDNT85WHr1QHw8N4=; b=bq6a+xbXIB1VsshgmgoWDw7fAT
        /kuSotYXw8oH5HLpnxnKBV4PyCkWApEMh58y6y4Aotl9R0MwhEAwj+aVwrPImpTouEQDSwaRS+zU/
        zO4nYHZVJiwA//O0wt9I9mViPntavLET86XzTsSw3ftWyntMVOZ5mPkRvC1Yl2tROeww=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrLt2-008fqS-RB; Thu, 10 Jun 2021 16:42:24 +0200
Date:   Thu, 10 Jun 2021 16:42:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zhou Yanjie <zhouyanjie@wanyeetech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com, paul@crapouillou.net
Subject: Re: [PATCH v2 2/2] net: stmmac: Add Ingenic SoCs MAC support.
Message-ID: <YMIk0NfOPryoY607@lunn.ch>
References: <1623260110-25842-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623260110-25842-3-git-send-email-zhouyanjie@wanyeetech.com>
 <YMGEutCet7fP1NZ9@lunn.ch>
 <405696cb-5987-0e56-87f8-5a1443eadc19@wanyeetech.com>
 <YMICTvjyEAgPMH9u@lunn.ch>
 <346f64d9-6949-b506-258f-4cfa7eb22784@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <346f64d9-6949-b506-258f-4cfa7eb22784@wanyeetech.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>     We are much more strict about this now than before. You have to use
>     standard units and convert to hardware values. It also makes it a lot
>     easier for DT writers, if they have an idea what the units mean.
> 
>     Having the MAC add small delays is something you can add later,
>     without breaking backwards compatibility. So if you cannot determine
>     what the units are now, just submit the glue driver without support
>     for this feature. If anybody really needs it, they can do the needed
>     research, maybe do some measurements, and then add the code.
> 
> 
> I did an experiment, when the tx delay is not set, RGMII works a

You had rgmii-id in your device tree, so that the PHY added the
delays?

	Andrew
