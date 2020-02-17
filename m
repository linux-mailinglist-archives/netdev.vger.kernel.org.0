Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E263D161627
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgBQP3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:29:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50082 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgBQP3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 10:29:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=B3MQFO6OCVy3CaonUG+ggsdLMmIu76Cs+DwnBQUzbNE=; b=UcrU4Z6N0sY6vQwq1LiOEY0WJQ
        UZdGGqBcYl6pDrIO0E2I4R379eX8YplMipjv53nsB9QPtcCY6ok5UMDGA926zEictJkl/onyFRicB
        FmDJXsNtk9SZaIxV9Hn6UVRtjv27BMN/jOX2iEk8ozRW1CwYQa1tEDXfH7eu6FHJVoe0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j3iKe-0005L3-6K; Mon, 17 Feb 2020 16:29:12 +0100
Date:   Mon, 17 Feb 2020 16:29:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH devicetree 3/4] arm64: dts: fsl: ls1028a: add node for
 Felix switch
Message-ID: <20200217152912.GE31084@lunn.ch>
References: <20200217144414.409-1-olteanv@gmail.com>
 <20200217144414.409-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217144414.409-4-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir

> +					/* Internal port with DSA tagging */
> +					mscc_felix_port4: port@4 {
> +						reg = <4>;
> +						phy-mode = "gmii";

Is it really using gmii? Often in SoC connections use something else,
and phy-mode = "internal" is more appropriate.

> +						ethernet = <&enetc_port2>;
> +
> +						fixed-link {
> +							speed = <2500>;
> +							full-duplex;
> +						};

gmii and 2500 also don't really go together.

     Andrew
