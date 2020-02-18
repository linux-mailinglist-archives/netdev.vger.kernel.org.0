Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6FE5162CDF
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgBRRau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbgBRRau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 12:30:50 -0500
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFD552467B;
        Tue, 18 Feb 2020 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582047048;
        bh=f24u0w8tQoL2c68hjjz5dANYHmhosIHGEhO+odsYIr8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=T6Skmi1JCrTd0r3/G9yHqfgDHp7hISOOYSjf1yT/GR5p+tYFwRVbw/iSb5LWEArGF
         mZS9hbe10oSvt3Ig1ua9xVU5nZsJCKy9EBaj34hkBoXOshnXt7negsGf1praGgRXnT
         gII8dIhJZp8j5HtUc/Bcr0QjJfcwsoKEc2tOv7OE=
Received: by mail-qt1-f180.google.com with SMTP id l16so10423137qtq.1;
        Tue, 18 Feb 2020 09:30:48 -0800 (PST)
X-Gm-Message-State: APjAAAU/InBx+RKra2+N2Lw6TRCDKt9dIFMND/tUA8t4GfiC3CfenvU1
        1TZnDB0jCaJj/BGj/gYlhm/FhtCC5O7LwSTl9g==
X-Google-Smtp-Source: APXvYqyKj1XrrS2dTlNVqxYWIJKezDSkWldRHC5sXeMDLgXFrTGaR+gYe9EBl+bwCy+V5saC7oDA910oSACmfefPodM=
X-Received: by 2002:ac8:1415:: with SMTP id k21mr18731255qtj.300.1582047047680;
 Tue, 18 Feb 2020 09:30:47 -0800 (PST)
MIME-Version: 1.0
References: <20200218171321.30990-1-robh@kernel.org> <20200218171321.30990-12-robh@kernel.org>
 <20200218172255.GG1133@willie-the-truck>
In-Reply-To: <20200218172255.GG1133@willie-the-truck>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 18 Feb 2020 11:30:36 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJtdJmbWtwV00sa_A2tv-jy-JpKWUfco-LU4Dt2pTvHeg@mail.gmail.com>
Message-ID: <CAL_JsqJtdJmbWtwV00sa_A2tv-jy-JpKWUfco-LU4Dt2pTvHeg@mail.gmail.com>
Subject: Re: [RFC PATCH 11/11] dt-bindings: Remove Calxeda platforms bindings
To:     Will Deacon <will@kernel.org>
Cc:     "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk <linux-clk@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:23 AM Will Deacon <will@kernel.org> wrote:
>
> On Tue, Feb 18, 2020 at 11:13:21AM -0600, Rob Herring wrote:
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
> >  .../devicetree/bindings/arm/calxeda.yaml      | 22 ----------
> >  .../devicetree/bindings/arm/calxeda/l2ecc.txt | 15 -------
> >  .../devicetree/bindings/ata/sata_highbank.txt | 44 -------------------
> >  .../devicetree/bindings/clock/calxeda.txt     | 17 -------
> >  .../memory-controllers/calxeda-ddr-ctrlr.txt  | 16 -------
> >  .../devicetree/bindings/net/calxeda-xgmac.txt | 18 --------
> >  .../bindings/phy/calxeda-combophy.txt         | 17 -------
>
> You can drop the "calxeda,smmu-secure-config-access" from the Arm SMMU
> binding doc too (either here, or as part of the other patch).

Glad someone is paying attention. :)

Will do it as part of this patch.

Rob
