Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2B32A1287
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 02:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgJaB1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 21:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgJaB1C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 21:27:02 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC95620727;
        Sat, 31 Oct 2020 01:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604107622;
        bh=gQJ7dBGRie4ucyjiPFTr4xZt3u6251Vqa+K5cK9L4ag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0Ut25fMT5nkkDtHM228uD7d0cuOJKl5QWGkmlRpAb/5HftCH4Yyk4KUcIHL1yjj8F
         cxsSJV4Tr8JN/OJhmcXMi9eh5+SLlUMg1rTzPlAz4om7aAQVT5MKjnL0NTzRkYtWKQ
         p5IsQ0stZNIQTEeHQVSMSXjA4SNJuROzUTbTcgpU=
Date:   Fri, 30 Oct 2020 18:27:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] L2 multicast forwarding for Ocelot switch
Message-ID: <20201030182701.001bf002@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029022738.722794-1-vladimir.oltean@nxp.com>
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 04:27:33 +0200 Vladimir Oltean wrote:
> This series enables the mscc_ocelot switch to forward raw L2 (non-IP)
> mdb entries as configured by the bridge driver after this patch:
> 
> https://patchwork.ozlabs.org/project/netdev/patch/20201028233831.610076-1-vladimir.oltean@nxp.com/

Applied, thanks!
