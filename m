Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800E8186197
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgCPCdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 22:33:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729329AbgCPCdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 22:33:15 -0400
Received: from dragon (80.251.214.228.16clouds.com [80.251.214.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92B57206BE;
        Mon, 16 Mar 2020 02:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584325995;
        bh=JECNvcwgpBCM8o9+C4c1LowfMDmUIeZF7Y+YMfYbyQY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2ff1qLXS+iJ0mRFvywRJpgkqmkJRDQUzJtasC4snv9dFEbWMnpN8z9nldKCs/nWRz
         grOQkoeW5Tpi2uN6/U8i/WwVc2MYzBhjdLvomg0LHhOaytjUAQnmiRuVsRS/8obwW+
         b7F/hZEG6p9C1nUQ2E6O3V6RqG8/C/jSAIg3VHy0=
Date:   Mon, 16 Mar 2020 10:33:08 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>
Subject: Re: [PATCH 2/2] arm64: dts: ls1028a: disable the felix switch by
 default
Message-ID: <20200316023308.GW17221@dragon>
References: <20200312164320.22349-1-michael@walle.cc>
 <20200312164320.22349-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312164320.22349-2-michael@walle.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 05:43:20PM +0100, Michael Walle wrote:
> Disable the felix switch by default and enable it per board which are
> actually using it.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied, thanks.
