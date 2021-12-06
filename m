Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDCCB46A8E8
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349979AbhLFVB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 16:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349944AbhLFVB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 16:01:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D39C061746;
        Mon,  6 Dec 2021 12:57:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97999B81084;
        Mon,  6 Dec 2021 20:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BB2C341C2;
        Mon,  6 Dec 2021 20:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638824274;
        bh=d3oHX7kwFRR0VxHG4lHD0ytEtwUn0m1TsPaS5dtfOAk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BGCoMWjKZPsPgKSVWKOV5cmPRf2ofEkg1mBluNu/XYWiWolSBI7qyqQ9MPu0seWyi
         YVnwbCbDxFAecIy30/5tMjOQSTWhCidgy2GUsNcA5xsXoZeS8HrsPTTCRoPvzMoaBI
         dcZMgHSo7PmR+TDPErAKm8ccPEvvtq8LgdDuSj0mc8I3dSFuPhR+/ovrg38jia4SkO
         R2eXSW3LGXQPEMPrvFWBhcgRhroJ73IsGZdGVR42/dpU9wJjwMjVU+MsuaTioAtuG4
         h8YH24BWD4vtu/m8oAWAeVCfJA1DtQCT25wdA5AXIR3S8uvI3g0ecq4dUl8hLKPYw9
         FOAzRun4yvE6Q==
Date:   Mon, 6 Dec 2021 12:57:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: mdio: Allow any child node name
Message-ID: <20211206125753.6a5e837c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211206174139.2296497-1-robh@kernel.org>
References: <20211206174139.2296497-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Dec 2021 11:41:39 -0600 Rob Herring wrote:
> An MDIO bus can have devices other than ethernet PHYs on it, so it
> should allow for any node name rather than just 'ethernet-phy'.

Hi Rob, what's your preference for merging these?
