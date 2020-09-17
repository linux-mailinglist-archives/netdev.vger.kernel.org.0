Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD95C26D039
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 02:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgIQAxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 20:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgIQAxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 20:53:01 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549ADC061353;
        Wed, 16 Sep 2020 17:45:46 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id b22so203566lfs.13;
        Wed, 16 Sep 2020 17:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hhwWIdmoDfeRtla5zf1ymCAqzs41GJNhIs9x0pXt6Mw=;
        b=YHPv0+IzmbaKgKDSdY0AwJQvcUwj9q/bwOqGnIPsOV7qxVwlBrWutMMObuxwnoLueF
         puEFawK+WyonzflpzIzD8txJ4sW6AfAtS766xUjnVDqRo5OBQxhM3teLushvd7bVzxEm
         ekfqHuiNiZKW4fQqq6NYljp7OFx5g9PTyE4+JVEnt6fAs0cHjKpDVxFBMY+VPrAHMlZs
         YweNUXlUFvvEDJQcomlgpzmZrDZgX7/dqIhcMV0ZOxYq/LFA4HwpgrYkofnPPubKg6T/
         PfDcB9mZKbmWCaW5APy5nP8C0HtWCwDeUk4G8AeBI+WLze0VuHy8LWaHc2ntBTO+I0XV
         Yx1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hhwWIdmoDfeRtla5zf1ymCAqzs41GJNhIs9x0pXt6Mw=;
        b=ODkpsZq95uKZ13Bdm4oY2BGfft6aKMtfRHbCf7Kd4CnmjI8JlpJ5F84irw9rknVLuT
         SXMfo4pY7/5j7KvaUwytxCeyR05hd6WU+/1J4cyfdVPAAS0pbS/+mf1Z8KrNrr7GMhxr
         4aJtX9rbdgorrMrlEe9DM6tICUnN+IENEGWrkBB0nO2MPSFN+3KtKzdBFfSYJbOpFYDI
         hfEOAgVrRxfJ61fcTgKIZCSB1BoT4YPCX+oSHxIF69hsaGea7yZmJusmsBKbfWlmAiM4
         BtZyypLK/gOugdEZL1Uc6ElFHQBm/OxiakSYh5T+/3APe5OeN22PwmX7w/xSmMkHYyc7
         XEZg==
X-Gm-Message-State: AOAM532yUO4DzXkMpoOZb94T4JUerZC6FtCMauc1znZMYSnDaOY4gBHD
        KtNSPEd6PvB0kNcVS1iY445RKR/BAsSiNcLUcB8=
X-Google-Smtp-Source: ABdhPJx/Mkxr1F57JCoOl8++VCiAX4t7jqJtnMR64G6EEPr349WzIUeFGskUi6F4dhMtENrhhPIWdl0iuLfkktuIHAE=
X-Received: by 2002:ac2:4c07:: with SMTP id t7mr7986166lfq.194.1600303544747;
 Wed, 16 Sep 2020 17:45:44 -0700 (PDT)
MIME-Version: 1.0
References: <c2987351e3bdad16510dd35847991c2412a9db6b.camel@nvidia.com> <20200916165748.20927-1-alex.dewar90@gmail.com>
In-Reply-To: <20200916165748.20927-1-alex.dewar90@gmail.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Thu, 17 Sep 2020 10:45:33 +1000
Message-ID: <CAGRGNgWoFfCnK9FcWTf_f0b57JNEjsm6ZNQB5X_AMf8L3FyNcQ@mail.gmail.com>
Subject: Re: [PATCH v2] ath10k: sdio: remove redundant check in for loop
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

On Thu, Sep 17, 2020 at 3:09 AM Alex Dewar <alex.dewar90@gmail.com> wrote:
>
> The for loop checks whether cur_section is NULL on every iteration, but
> we know it can never be NULL as there is another check towards the
> bottom of the loop body. Refactor to avoid this unnecessary check.
>
> Also, increment the variable i inline for clarity

Comments below.

> Addresses-Coverity: 1496984 ("Null pointer dereferences)
> Suggested-by: Saeed Mahameed <saeedm@nvidia.com>
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> ---
> v2: refactor in the manner suggested by Saeed
>
>  drivers/net/wireless/ath/ath10k/sdio.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
> index 81ddaafb6721..486886c74e6a 100644
> --- a/drivers/net/wireless/ath/ath10k/sdio.c
> +++ b/drivers/net/wireless/ath/ath10k/sdio.c
> @@ -2307,8 +2307,8 @@ static int ath10k_sdio_dump_memory_section(struct ath10k *ar,
>         }
>
>         count = 0;
> -
> -       for (i = 0; cur_section; i++) {
> +       i = 0;
> +       for (; cur_section; cur_section = next_section) {

You can have multiple statements in each section of a for() if you need to, e.g.

for (i = 1; cur_section; cur_section = next_section, i++) {

which means that the increment of i isn't hidden deep in the function body.


That said, this function is a mess. Something (approximately) like
this might be more readable:

prev_end = memregion->start;
for (i = 0; i < mem_region->section_table.size; i++) {
    cur_section = &mem_region->section_table.sections[i];

    // fail if prev_end is greater than cur_section->start - message
from line 2329 and 2294
    // check section size - from line 2315

    skip_size = cur_section->start - prev_end;

    // check buffer size - from line 2339 - needs to account for the
skip size too.
    // fill in the skip size amount - from line 2358 and 2304
    // ath10k_sdio_read_mem - from line 2346

    prev_end = cur_section->end;
}

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
