Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3162C3A6D4E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 19:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbhFNRjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 13:39:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36208 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235576AbhFNRjJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 13:39:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=yNJZdu5e9R9IKJLMXzwlJdT1h35Mb6+Vu9cSblpMexw=; b=ZS
        KVZMYvVbzNUjqEwyxpEivD5BHmDXQdFmXDlwsUAfxEy07XyluMcabpUle5H5ZNTlSvWB4khgr7WwR
        SHWWk/hNzMPcEPeXbB3a2+T5/ZVepAo7dFI1ZQsFWtOdM76xQYQ0j9sV2dFWQdkvxLW/kGtDsIIws
        pA0kkT9QLeZtg8s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lsqVy-009MmX-Ti; Mon, 14 Jun 2021 19:36:46 +0200
Date:   Mon, 14 Jun 2021 19:36:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        matthias.bgg@gmail.com, alexandre.torgue@st.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com
Subject: Re: [PATCH v3 2/2] net: stmmac: Add Ingenic SoCs MAC support.
Message-ID: <YMeTrq/j7728lCN0@lunn.ch>
References: <1623690937-52389-1-git-send-email-zhouyanjie@wanyeetech.com>
 <1623690937-52389-3-git-send-email-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1623690937-52389-3-git-send-email-zhouyanjie@wanyeetech.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 01:15:37AM +0800, 周琰杰 (Zhou Yanjie) wrote:
> Add support for Ingenic SoC MAC glue layer support for the stmmac
> device driver. This driver is used on for the MAC ethernet controller
> found in the JZ4775 SoC, the X1000 SoC, the X1600 SoC, the X1830 SoC,
> and the X2000 SoC.
> 
> Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
