Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7462749AA55
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1325271AbiAYDgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3416033AbiAYByM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 20:54:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEF0C047CDD;
        Mon, 24 Jan 2022 17:10:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6FC361208;
        Tue, 25 Jan 2022 01:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F27BC340E4;
        Tue, 25 Jan 2022 01:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643073036;
        bh=w0sNNSOpkifO6hGy+QE+n1Pgw1k19GJC6mxvBdgAXY0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MzJYxMuT78+EAeSOgcV1O9EAYeDkr2NnhL6hJ3Dt3qYeAyx+7N10KxGPbAsRYBs76
         Z+aL1rSCS/I9q/LixyDPSehwZiUcljKxYBngiExdaDvAVholx6ylfZVbdUNbH5MQL0
         DEkiehIwrKUneytLd0SlMBcjyyjnuxBHSG8tmtW9Yw2Whbr5fP+OY9vDKgCpxr4USX
         SMTrNXEEFI0a7wj65nJNEy3hkp6DPHNAvG1jxNGxyVV+v/SaPmr8RBTKfgrdurIDT8
         b1vmE+WUXBrLrm+5JC7k2HJMZQEd8VLM/mJqw5uN3dFkkogM00ewjSVdAypDbtLzFk
         TUl3W2rtfAg5A==
Date:   Mon, 24 Jan 2022 17:10:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH] net: dsa|ethernet: use bool values to pass bool param
 of phy_init_eee
Message-ID: <20220124171034.764bbf5e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220123152241.1480-1-jszhang@kernel.org>
References: <20220123152241.1480-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Jan 2022 23:22:41 +0800 Jisheng Zhang wrote:
> The 2nd param of phy_init_eee(): clk_stop_enable is a bool param, use
> true or false instead of 1/0.
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>

Applied, thanks!
