Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC1A421E94
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 08:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhJEGDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 02:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232108AbhJEGDV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 02:03:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92CD361506;
        Tue,  5 Oct 2021 06:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633413691;
        bh=8WQC+dzyl2tjTbCuTZwAxt3vQ3mPoLMuElaefonyfAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a31KrGQAWEDUESVLtDZcnrbZoaJM95PzWC4EcMS76iGdwpNCsckN0HWHDZe+RSJuX
         8e5TJ249gyZAGkLjuHWBfIfmxMKOls0pZtojJkJvfW4EKc2i58vVTOJgaYtjGV0vPZ
         o6/fbQBk6u7hBq3g1P/xn6RaD3PFdDydeqp2Kzv2gFft6hypWZPZqq5Wj+U1tFl/mZ
         BhR/SZusSUS9RUXEtnYZJ+jYvJqkNsP76G0zIPUXHx6kdwNeiR0i1YiBLib4jOgYoY
         g+LHT+F6WIXorKg8P0SNgZlWyHCwsYIZ+UJTDAG498NmJ6i8QzeUfK4edpvVSdwCnw
         fA6cdM2LL3jjQ==
Date:   Tue, 5 Oct 2021 14:01:27 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>
Subject: Re: [PATCH devicetree] arm64: dts: ls1028a: mark internal links
 between Felix and ENETC as capable of flow control
Message-ID: <20211005060126.GR20743@dragon>
References: <20210929115226.1383925-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929115226.1383925-1-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 02:52:26PM +0300, Vladimir Oltean wrote:
> The internal Ethernet switch suffers from erratum A-050484 ("Ethernet
> flow control not functional on L2 switch NPI port when XFH is used").
> XFH stands for "Extraction Frame Header" - which basically means the
> default "ocelot" DSA tagging protocol.
> 
> However, the switch supports one other tagging protocol - "ocelot-8021q",
> and this is not subject to the erratum above. So describe the hardware
> ability to pass PAUSE frames in the device tree, and let the driver
> figure out whether it should use flow control on the CPU port or not,
> depending on whether the "ocelot" or "ocelot-8021q" tagging protocol is
> being used.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks!
