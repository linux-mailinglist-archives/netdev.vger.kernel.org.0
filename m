Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED70B37AC99
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 19:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhEKRCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 13:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbhEKRCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 13:02:37 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F67C061574;
        Tue, 11 May 2021 10:01:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d:444a:d152:279d:1dbb])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 6C8034BF;
        Tue, 11 May 2021 17:01:27 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 6C8034BF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1620752487; bh=QmVYJvT1Kzq68R+QLKACGPLdolv6eNZVx9knetb0KFs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=irQf+xtmaDJZYLKwq3hA8ztA2UhPkWaMvlGfMCect35HeamgThOzqqCroC26BP/Sl
         CZ5fyVVCGLDX5hEb0cnVXCWNegwA+Xs245fqJaayhz/QOZsSyLbOEm6eAcMMVYm6OY
         KYssjOyi8tvqVhDlU9yQOg3yj6ggq5zhGjo6YGvleqEvR4QvYakpL6DYodSr6ne5p2
         POLXDUg/aNRvtMVVTSEj+i7YB0HcWdlIM/5xZz2XEUDjPiyFKgjrJG+D5PIfW0A/ku
         jf3zV8C5QT23k16fFmU0Sd0ej651gdEPXtb2eRRgDOFPAPrnQiy6aPBFrlggpfHlaH
         YTUqF86upi5qg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean Delvare <jdelvare@suse.com>, Jens Axboe <axboe@kernel.dk>,
        intel-wired-lan@lists.osuosl.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] Fix some UTF-8 bad usages
In-Reply-To: <cover.1620744606.git.mchehab+huawei@kernel.org>
References: <cover.1620744606.git.mchehab+huawei@kernel.org>
Date:   Tue, 11 May 2021 11:01:26 -0600
Message-ID: <87fsytdx21.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mauro Carvalho Chehab <mchehab+huawei@kernel.org> writes:

> This series follow up this past series:
> 	https://lore.kernel.org/lkml/cover.1620641727.git.mchehab+huawei@kernel.org/
>
> Containing just the manual fixes from it. I'll respin the remaining
> patches on a separate series.
>
> Please note that patches 1 to 3 are identical to the ones posted
> on the original series.
>
> Patch 1 is special: it fixes some left-overs from a convertion
> from cdrom-standard.tex: there, some characters that are
> valid in C were converted to some visually similar UTF-8 by LaTeX.
>
> Patch 2 remove U+00ac (''): NOT SIGN characters at the end of
> the first line of two files. No idea why those ended being there :-p
>
> Patch 3 replaces:
> 	KernelVersion:3.3
> by:
> 	KernelVersion:	3.3
>
> which is the expected format for the KernelVersion field;
>
> Patches 4 and 5 fix some bad usages of EM DASH/EN DASH on
> places that it should be, instead, a normal hyphen. I suspect
> that they ended being there due to the usage of some conversion
> toolset.
>
> Mauro Carvalho Chehab (5):
>   docs: cdrom-standard.rst: get rid of uneeded UTF-8 chars
>   docs: ABI: remove a meaningless UTF-8 character
>   docs: ABI: remove some spurious characters
>   docs: hwmon: tmp103.rst: fix bad usage of UTF-8 chars
>   docs: networking: device_drivers: fix bad usage of UTF-8 chars
>
>  .../obsolete/sysfs-kernel-fadump_registered   |  2 +-
>  .../obsolete/sysfs-kernel-fadump_release_mem  |  2 +-
>  Documentation/ABI/testing/sysfs-module        |  4 +--
>  Documentation/cdrom/cdrom-standard.rst        | 30 +++++++++----------
>  Documentation/hwmon/tmp103.rst                |  4 +--
>  .../device_drivers/ethernet/intel/i40e.rst    |  4 +--
>  .../device_drivers/ethernet/intel/iavf.rst    |  2 +-
>  7 files changed, 24 insertions(+), 24 deletions(-)

These seem pretty straightforward; I've applied the set, thanks.

jon
