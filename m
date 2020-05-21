Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7771DCDBA
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 15:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgEUNHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 09:07:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42906 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728208AbgEUNHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 09:07:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yQ6UEpWldvHmnkmYV9FHSOOr9MgmZ9ZSwdsyA6N/K8I=; b=iv9F5StaTY2NkJ2uRwUbWlhCvo
        gw8AGvzWa1bQzRhQrxuR3+P/05xKWcedw8+hWI/Lg2WjSjHEywJLm1IRuKQaEzc3qj8xYChnGH2A9
        yRw/ikE8ZD5zVW6+3HFQxQMtIPajL8vrhS3mi5nGza87au3gAFEHOIX1gNyC16PCDg9k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jbkua-002u1Y-Hm; Thu, 21 May 2020 15:07:00 +0200
Date:   Thu, 21 May 2020 15:07:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martin.fuzzey@flowbird.group" <martin.fuzzey@flowbird.group>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net 3/4] ARM: dts: imx6: update fec gpr
 property to match new format
Message-ID: <20200521130700.GC657910@lunn.ch>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
 <1589963516-26703-4-git-send-email-fugang.duan@nxp.com>
 <20200520170322.GJ652285@lunn.ch>
 <AM6PR0402MB3607541D33B1C61476022D0AFFB70@AM6PR0402MB3607.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR0402MB3607541D33B1C61476022D0AFFB70@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew, patch#1 in the series will parse the property to get register offset and bit.
> Patch#2 describes the property format as below:
>        <&gpr req_gpr req_bit>.
>         gpr is the phandle to general purpose register node.
>         req_gpr is the gpr register offset for ENET stop request.
>         req_bit is the gpr bit offset for ENET stop request.
> 
> All i.MX support wake-on-lan, imx6q/dl/qp is the first platforms in upstream to support it.
> As you know, most of i.MX chips has two ethernet instances, they have different gpr bit.
> 
> gpr is used to enter/exit stop mode for soc. So it can be defined in dtsi file.
> "fsl,magic-packet;" property is define the board wakeup capability.
> 
> I am not sure whether above information is clear for you why to add the patch set.

I understand the patch. What is missing is an actual user, where you
have two interfaces, doing WOL, with different values for gpr. We
don't add new kernel APIs without a user.

    Andrew
