Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DADC7C88BF
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 14:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfJBMiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 08:38:19 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39821 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbfJBMiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 08:38:19 -0400
Received: by mail-qk1-f193.google.com with SMTP id 4so14756250qki.6
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 05:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XjGcad+/AEf/LQ6JW0XEmjTyfYLZoWupXny7/907quI=;
        b=BuKfaXOGJkGNN039Bc44rug88lxpIT8oI+YcKkFCeQMvnOv102ztRZn3SwNsZHcFQv
         v7EROximmU2mlCX6FLXNGJHwfUzzoPDW1Oefmyzg39aNXdAC6AqMjwoO6SjQWSKMbudq
         pulzcmolj9dCghigUJiI9p+w8GbPQEUDaHe5LWEgLwfyO809Zo30CTyP4flXdTA2I3RY
         3dd/olg1yHbQ8Rlvq3oSAIkPjSsWmdC7u4ispRQzoFBiHUl3b3bEcf6fEYPibxSXfieg
         0f2oFQcuZQN9y0NZeHXdfHBS1pUWGCf3klcTqlKVfpKC2auiBaZQSEjPN21VvEBadw8Y
         A0zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XjGcad+/AEf/LQ6JW0XEmjTyfYLZoWupXny7/907quI=;
        b=el/XLwnNddG4md4LEW63YCw4/FhvxdbQr5obmC1q3b7A+s9BooQpEfrCBVEES3gUls
         WZTBU6G8okSSm5QDjEVhS4fAt9ZYaQF9ViYbZo/Qhzn/tjjcFz7uYADSlFxKl6ToFm6O
         PCxpgNRTzrNF41pIk88rLqO9+E8iyFHBYIWIYwcCfV31Rp5dah4GaQT2zwEQ1QER3H3f
         L6/dEgRVelS77AAszqYwcFGh0qRVIXxLiER/FCUnqpLcH3+QOy1hPJbsPdc7Po8LGB0t
         aKjRVcpzowh0aPRyEBZJ+X9S7TqinYJqQ9HtlkmT27zyXPsEErxHdhSrs1GvsIE9i/g5
         YnCg==
X-Gm-Message-State: APjAAAVMQqPKmx5hNCez2hx3NU8uVTW0PjlfzQpqzOtIxODy3ddqhNoK
        XpCYxWtDjxKdhbKPAhCM9XLUIRrezTvx0xTO2sEGuw==
X-Google-Smtp-Source: APXvYqwgMZyCWyDd3fnNskodhxm92UgANHaXL7pTyigGGX+fmEMuqAfA/i/iU3ag6oSmB1WW21ZFh/8Qjlo/LOZHEqM=
X-Received: by 2002:a37:9c57:: with SMTP id f84mr3540760qke.250.1570019898066;
 Wed, 02 Oct 2019 05:38:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190911025045.20918-1-chiu@endlessm.com> <20191002042911.2E755611BF@smtp.codeaurora.org>
In-Reply-To: <20191002042911.2E755611BF@smtp.codeaurora.org>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Wed, 2 Oct 2019 20:38:07 +0800
Message-ID: <CAB4CAwdvJSjamjUgu2BJxKxEW_drCyRFVTbwN_v-suXc2ZjeAg@mail.gmail.com>
Subject: Re: [PATCH v2] rtl8xxxu: add bluetooth co-existence support for
 single antenna
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 12:29 PM Kalle Valo <kvalo@codeaurora.org> wrote:

> Failed to apply, please rebase on top of wireless-drivers-next.
>
> fatal: sha1 information is lacking or useless (drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h).
> error: could not build fake ancestor
> Applying: rtl8xxxu: add bluetooth co-existence support for single antenna
> Patch failed at 0001 rtl8xxxu: add bluetooth co-existence support for single antenna
> The copy of the patch that failed is found in: .git/rebase-apply/patch
>
> Patch set to Changes Requested.
>
> --
> https://patchwork.kernel.org/patch/11140223/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>

The failure is because this patch needs the 'enum wireless_mode' from another
patch https://patchwork.kernel.org/patch/11148163/ which I already submit the
new v8 version. I didn't put them in the same series due to it really
took me a long
time to come out after tx performance improvement patch upstream. Please apply
this one after https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2117331.html.
Thanks.

Chris
