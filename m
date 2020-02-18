Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94241162D09
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgBRRdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:33:42 -0500
Received: from mail.skyhub.de ([5.9.137.197]:33598 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgBRRdm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 12:33:42 -0500
Received: from zn.tnic (p200300EC2F0C1F0014C3F76BBACA8B76.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:1f00:14c3:f76b:baca:8b76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 97C341EC0CE8;
        Tue, 18 Feb 2020 18:33:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1582047219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=RQeBvXI621OpNJABJKZKVWpEMPbJNSTe+fCxB2Fm/Vo=;
        b=NVQltzJcnErUiTBnCebDnivFmAdUN1V2AohuWTMn272uhHsVO5AZK/O6ZHJRkwej6+Pjtj
        lcIebZUtEpSiNP6fNloDnVP8/5nrBYHAr+mmwFcbARu9bY65pbsJKv6ZG0jSJDQJnQOq9J
        qrcXwykORCUc99KOOqWRygFDieMasww=
Date:   Tue, 18 Feb 2020 18:33:40 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH 05/11] EDAC: Remove Calxeda drivers
Message-ID: <20200218173339.GL14449@zn.tnic>
References: <20200218171321.30990-1-robh@kernel.org>
 <20200218171321.30990-6-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200218171321.30990-6-robh@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 11:13:15AM -0600, Rob Herring wrote:
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Robert Richter <rrichter@marvell.com>
> Cc: linux-edac@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Do not apply yet.
> 
>  MAINTAINERS                     |   6 -
>  drivers/edac/Kconfig            |  14 --
>  drivers/edac/Makefile           |   3 -
>  drivers/edac/highbank_l2_edac.c | 142 -----------------
>  drivers/edac/highbank_mc_edac.c | 272 --------------------------------
>  5 files changed, 437 deletions(-)
>  delete mode 100644 drivers/edac/highbank_l2_edac.c
>  delete mode 100644 drivers/edac/highbank_mc_edac.c

I'd obviously take patches like that any time of the week so lemme know
when... :-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
