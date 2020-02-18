Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B20162C9D
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgBRRXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:23:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgBRRXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 12:23:05 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5306F20801;
        Tue, 18 Feb 2020 17:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582046584;
        bh=j2Iac1zey820mNpdh5yJdPFMBBkcx1p+/nwylqP9Bj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pGRedyRNM0efhtBXW3mukIv+0Uyx6UFrCDbXNxScGGlS2kUHuf6Z9u5cvnGH2VWIy
         VkGS9156ykY8H/gDdmCTkV+MFWiVdh3DiGfyr7ajOhFrJqs4dkwqrQ6H6z1Yn7urSI
         cJWxWOtaqgY9/KrBPR/ucs/jZ3LiWrbmvtYMmeq8=
Date:   Tue, 18 Feb 2020 17:22:56 +0000
From:   Will Deacon <will@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [RFC PATCH 11/11] dt-bindings: Remove Calxeda platforms bindings
Message-ID: <20200218172255.GG1133@willie-the-truck>
References: <20200218171321.30990-1-robh@kernel.org>
 <20200218171321.30990-12-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218171321.30990-12-robh@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:13:21AM -0600, Rob Herring wrote:
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/arm/calxeda.yaml      | 22 ----------
>  .../devicetree/bindings/arm/calxeda/l2ecc.txt | 15 -------
>  .../devicetree/bindings/ata/sata_highbank.txt | 44 -------------------
>  .../devicetree/bindings/clock/calxeda.txt     | 17 -------
>  .../memory-controllers/calxeda-ddr-ctrlr.txt  | 16 -------
>  .../devicetree/bindings/net/calxeda-xgmac.txt | 18 --------
>  .../bindings/phy/calxeda-combophy.txt         | 17 -------

You can drop the "calxeda,smmu-secure-config-access" from the Arm SMMU
binding doc too (either here, or as part of the other patch).

Will
