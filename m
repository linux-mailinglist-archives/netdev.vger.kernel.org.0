Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA41946CE9C
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244624AbhLHID5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 03:03:57 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:33024 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhLHID4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 03:03:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6E193CE2033;
        Wed,  8 Dec 2021 08:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B49C00446;
        Wed,  8 Dec 2021 08:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638950421;
        bh=itzCqr3xP1lv5NYDibFoL0Ql5Ms0lNbRWSc011NXcsg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mHhbDnH23FZWc/ZsMIilwRaHuR8M2fbHuYeq49W8axFWIWUSqSVZB/PXqiBnUg6QY
         svWn84ZXzM13cedrjigTrtPJMmLPWSZHYSDovzQficyr/IgiFghbyqEP1QUHBKU1mP
         CThO5+iNemjnPUG4RiHKz0Xw5ybwec0Y9rYJYxUnPz/g5zMqOwkt6jzxgkC87CQPfM
         DsQ0PKEPABPX1lebnn5G7J37oT/BvZxJh65usQqeQ5glCkFuocPnGWeBfJhC5X/iq9
         eFVYbF63+zq/MaLLgIcBOZkZrPyW6TIYIgQqGT2rpMWa04c4z8z8Assxwdw8ut35DV
         hwgHH/yr6vJAw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next-2021-12-07
References: <20211207144211.A9949C341C1@smtp.kernel.org>
        <20211207211412.13c78ace@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 08 Dec 2021 10:00:15 +0200
In-Reply-To: <20211207211412.13c78ace@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Tue, 7 Dec 2021 21:14:12 -0800")
Message-ID: <87tufjfrw0.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue,  7 Dec 2021 14:42:11 +0000 (UTC) Kalle Valo wrote:
>> here's a pull request to net-next tree, more info below. Please let me know if
>> there are any problems.
>
> Pulled, thanks! Could you chase the appropriate people so that the new
> W=1 C=1 warnings get resolved before the merge window's here?
>
> https://patchwork.kernel.org/project/netdevbpf/patch/20211207144211.A9949C341C1@smtp.kernel.org/

Just so that I understand right, you are referring to this patchwork
test:

  Errors and warnings before: 111 this patch: 115

  https://patchwork.hopto.org/static/nipa/591659/12662005/build_32bit/

And you want the four new warnings to be fixed? That can be quite time
consuming, to be honest I would rather revert the commits than using a
lot of my time trying to get people fix the warnings. Is there an easy
way to find what are the new warnings?

But in the big picture are you saying the net trees now have a rule that
no new W=1 and C=1 warnings are allowed? I do test ath10k and ath11k
drivers for W=1 and C=1 warnings, but all other drivers are on their own
in this regard. At the moment I have no tooling in place to check all
wireless drivers.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
