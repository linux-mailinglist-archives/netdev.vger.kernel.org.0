Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A411367CD9
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 10:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhDVIsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 04:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235485AbhDVIsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 04:48:52 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72098C06174A;
        Thu, 22 Apr 2021 01:48:18 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id a11so1632031ioo.0;
        Thu, 22 Apr 2021 01:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=DlZ2S3yfolBkgSZWfUNZ5efqdDYy/a5hk5lKfg0x/8I=;
        b=iIfgaliebSblJdZgWZ9DXFfQj94qQb2X/vNvUONGRpJRG7cyQABiDLAfUcCv6Zaizl
         +LaoFbMNLad7k9SthvZXl2A/ZdnM4OxwFr9201kg8KUK/oK9vg6pw94D9RwV6mkMqhbT
         YbPRCYJcjXnrqY153JZVitjpq/rT3hhfpHFGn0BSmCJXYn7TZ2GC0Y2TBms4ddt61RUd
         sLTpVFZkSoB7goWE9gN7RftkvZhNR6sap2aePEsuy8Kd57GjKrdYKWnCdSTdMbzCGMYd
         6x6G9BArMoZxTkDsDh8GB8FWH/3O6pmNPbyhFEqkQ25JiPr8yJOt86yFmdCz3CTtwIY8
         7pQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=DlZ2S3yfolBkgSZWfUNZ5efqdDYy/a5hk5lKfg0x/8I=;
        b=cFdvZ5nWf1w2KMVyc0j0QIxsajFbytwPMTaxuhM8bgvdBs5OutWP2eZAuKjnbMkQ2O
         /OhPlumaAuiBRMFyaTfbyICd5TUOGkCgeGDh6ITKgHawfrPF0HwXDwmdI6jBFTkDGWEJ
         3Yt6yTvwdh7Q81Y96dwsIC2t2x82ffNXJYDB1pplcvNrQ/vJAQRowUdwG94z/AAbwlX6
         sDH9ObtNaUDD0O1LL2dzhavItkzCi8g9hbIZpHV6viT9eGyUmMvLLzpJL3cMilbP1Pd/
         QFKH/YVjPLFqG2nXCWcKHSqASLSbiUPXfgzZpTmowI378XY9j7Y0d42Ed+O2qikgp8uG
         JLBQ==
X-Gm-Message-State: AOAM533xzh8LcqkjYVj6cnBwFAZ7w9UOptaWiMqUH8lOvgViK4WbA3z3
        xm6oBUNnTcDHKaBni8r1yKy6IefeSXbPMwcbesTy184a70D4xA==
X-Google-Smtp-Source: ABdhPJzk/73+6IgSzJIzkW+vei2AXilHp5Wt8OA6VRrjBrhcFR8UjFvOv7hxhU66ZIxEDnjKWhwBUyQslQM8jV+75bk=
X-Received: by 2002:a02:331b:: with SMTP id c27mr2208013jae.30.1619081297835;
 Thu, 22 Apr 2021 01:48:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210421090335.7A50CC4338A@smtp.codeaurora.org>
In-Reply-To: <20210421090335.7A50CC4338A@smtp.codeaurora.org>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 22 Apr 2021 10:47:41 +0200
Message-ID: <CA+icZUV079dCCKJTU6e40bJYcaVT+ofK5S=9xFwxB3Sc+QPrXw@mail.gmail.com>
Subject: Re: pull-request: wireless-drivers-2021-04-21
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 11:04 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Hi,
>
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
>
> Kalle
>
> The following changes since commit d434405aaab7d0ebc516b68a8fc4100922d7f5ef:
>
>   Linux 5.12-rc7 (2021-04-11 15:16:13 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2021-04-21
>
> for you to fetch changes up to e7020bb068d8be50a92f48e36b236a1a1ef9282e:
>
>   iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd() (2021-04-19 20:35:10 +0300)
>

[ CC Joe Perches ]

That patch misses the closing ">" in the Reported-by of Heiner.
My Tested-by seems also to be ignored.
See [1] and [2].

Has checkpatch.pl script an option to check if an email-address for
"credits" tags like
Signed-of-by/Reviewed-by/Tested-by/Reported-by/etc. is correct such as
open/closing "<...>" is not missing?

Thanks.

- Sedat -

[1] https://lore.kernel.org/linux-wireless/CA+icZUWVVRz-=09vowj5gLJ9-OaKpBkkejBXzqSpk-wZ-mDm-Q@mail.gmail.com/
[2] https://lore.kernel.org/linux-wireless/CA+icZUXmNG6TOhtni6Rrs7NZVOg1H8NhYuDsDiyVASF5+VtUAQ@mail.gmail.com/


> ----------------------------------------------------------------
> wireless-drivers fixes for v5.12
>
> As there was -rc8 release, one more important fix for v5.12.
>
> iwlwifi
>
> * fix spinlock warning in gen2 devices
>
> ----------------------------------------------------------------
> Jiri Kosina (1):
>       iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()
>
>  drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
