Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3CB464A3F
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348068AbhLAJCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 04:02:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50068 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237533AbhLAJB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 04:01:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4DBFB81DFA;
        Wed,  1 Dec 2021 08:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2963C53FAD;
        Wed,  1 Dec 2021 08:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638349115;
        bh=KAqHm2emOp1fn6AwK8DHp3+Y2zBiFl2loXGgmj9XZWY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Myxtkr67VEi+ulo11ovyqk7MnOMFvfCDaQcomlQC5vyRAwPTzzQePYemXlPDjZ95v
         S+/+l+EGAdC9YhtBgBDgh4QHHDM/Usfb83kkZZ3uNK8Ml6w73diUNkGtcHGpHWDK9V
         z6vq/9lXoIeGM6gmrv+8Fa/IfBVyQeSYpbKSwqR5CbHdCvmEtbxdWZj2svOvmOsJbU
         91XZQxu/aEU4yKc2jML7wcLfOt2U6EVtlGNWomrT8KKg7ACUIm5+8cSD3g5lnF/Lxi
         Ml9E0fa2KPZIvVIXr7ll/PcE0Jt9SuVD3O0LIa28TuJtAKKfTZ5C1WwKNJdGgDWLQ1
         FAfY8KnVcAACg==
From:   Kalle Valo <kvalo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2021-12-01
References: <20211201084229.4053DC53FAD@smtp.kernel.org>
Date:   Wed, 01 Dec 2021 10:58:33 +0200
In-Reply-To: <20211201084229.4053DC53FAD@smtp.kernel.org> (Kalle Valo's
        message of "Wed, 1 Dec 2021 08:42:29 +0000 (UTC)")
Message-ID: <87ilw8snuu.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Hi,
>
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
>
> Kalle
>
> The following changes since commit fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf:
>
>   Linux 5.16-rc1 (2021-11-14 13:56:52 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-12-01

I switched to use kvalo@kernel.org email address, but I'm using the same
PGP key as before. Hopefully this doesn't cause any issues. I'll submit
updates to the maintainers file later.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
