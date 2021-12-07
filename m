Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526DB46B6FB
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 10:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbhLGJ0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 04:26:15 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:44171 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbhLGJ0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 04:26:15 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N9doJ-1mXKrO27rJ-015e11; Tue, 07 Dec 2021 10:22:43 +0100
Received: by mail-wr1-f45.google.com with SMTP id v11so28044462wrw.10;
        Tue, 07 Dec 2021 01:22:43 -0800 (PST)
X-Gm-Message-State: AOAM5306SeU6qiheeq6yxl6RKXrkZGMdI/FbbgMfFTZ0bdOI+MC/6x5X
        mdodgmf8mqSy2LcDUbFo1ZE5QgvInK7abOOZ/co=
X-Google-Smtp-Source: ABdhPJzV1ByiFHkEomNrzG+dViLV6kQhgqFfDnCiG93kDJclmvg9u/J3q1Wu4f9334LGE8w+/60/oM4cRW6zP0PSpN4=
X-Received: by 2002:a5d:6886:: with SMTP id h6mr51154859wru.287.1638868960284;
 Tue, 07 Dec 2021 01:22:40 -0800 (PST)
MIME-Version: 1.0
References: <20211207002102.26414-1-paul@crapouillou.net>
In-Reply-To: <20211207002102.26414-1-paul@crapouillou.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 7 Dec 2021 10:22:24 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3xfuFN+0Gb694R_W2tpC7PfFEFcpsAyPdanqZ6FpVoxQ@mail.gmail.com>
Message-ID: <CAK8P3a3xfuFN+0Gb694R_W2tpC7PfFEFcpsAyPdanqZ6FpVoxQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Rework pm_ptr() and *_PM_OPS macros
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <jic23@kernel.org>, list@opendingux.net,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:cfp/lIhgcg8Nc10PzPxe9y+GLo3DlVN017YeecLWApZEsbHXxjx
 chyiiC1hoc6hkh5kGFw+aQltHQUN2vXcuzSpO9/RNHNVw1UkGJXUOpCNkCZkWLaiVp1gL4B
 O7XSBfcMOk535RfnJdmGgcFYD6WTXUg9h6RXfx7xZLGDU/uFQqdNToLSGmRfD3kUmW2Ppr6
 KdHbWGBToShqX8YHrbOWQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EPuPo0WTmX4=:MtufB+ftb5kSGyLZJVFBs9
 tYCCl8wuAvQYOUz7pwvRNvwGWWzky7TyXnOu912ML2FDleUUUV+PZOqr7xwRFsW6Yf5RByhIv
 5mCODGlusXEWdekTPaA7H1oi/8AXDR5KmwR6J3kOIS7pkEqYOGB/Swe73RsJwFhQHFzbvVgoo
 SW0u7lOR2wEGPynWymi3x/+Izusv0c5zpCDc4DDvb508mUF+7znbwUJOSGCI1zCPaQnKi4lnZ
 hbwjuxTcT/2HGhVs3MfWIdA2+tmUkrji0WgSPEX6gHAyTrOYIgEj5B4reS7vCHnJFpm0NuLkL
 NecdXshLyhYCuJhsZux1D18LwphgdqTby+bGFWVq71L6XlnZpHkYcNkakoJaxtYZzZqcv2Ifq
 tzTDETT71wUBiy57kRYYOf0APKUCAcztsCftpmt+4In16YPCF40o7+wQGNdRSuWEyIRx7BT9B
 7QbrCmJrjaz9vJHr9XHm1NpJCEbmTRop2Ez8VI+YmeFCtcGydToleOUXn9wEf2ksfYmZH1gXZ
 ldtFU5ci/pHw13xln04KWzMZpZd7lgO9BckkVRmthy/IxFRw/2OwZY5Fmadw+eflsxsBSRRxt
 yqRzrkuV4O0ZXz10faItknrWJQ2tTRaHvVBz6VRt2o5xEKuy3cNDUPJimZsRqJOB7krsxHiKJ
 ecbRGpM+k3tLuL8VHad/kcr+/fGyIxiqdCjeSQGdqAtcgW0bFaG/xCWG0DkEUXkxndnIIJXhd
 bN0b/w6YKe50ACHafOmJTCydphGyKbd7sVbPv489kldJRp8SDNvswGgTBpzwfCciYmG6iXwzx
 kL5gj63WiiOwsOTirax75+kV/+b6WmyDFRdw2hemcByEVpwS1Y=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 7, 2021 at 1:20 AM Paul Cercueil <paul@crapouillou.net> wrote:
>
> This patchset reworks the pm_ptr() macro I introduced a few versions
> ago, so that it is not conditionally defined.
>
> It applies the same treatment to the *_PM_OPS macros. Instead of
> modifying the existing ones, which would mean a 2000+ patch bomb, this
> patchset introduce two new macros to replace the now deprecated
> UNIVERSAL_DEV_PM_OPS() and SIMPLE_DEV_PM_OPS().
>
> The point of all of this, is to progressively switch from a code model
> where PM callbacks are all protected behind CONFIG_PM guards, to a code
> model where PM callbacks are always seen by the compiler, but discarded
> if not used.
>
> Patch [4/5] and [5/5] are just examples to illustrate the use of the new
> macros. As such they don't really have to be merged at the same time as
> the rest and can be delayed until a subsystem-wide patchset is proposed.
>
> - Patch [4/5] modifies a driver that already used the pm_ptr() macro,
>   but had to use the __maybe_unused flag to avoid compiler warnings;
> - Patch [5/5] modifies a driver that used a #ifdef CONFIG_PM guard
>   around its suspend/resume functions.

This is fantastic, I love the new naming and it should provide a great path
towards converting all drivers eventually. I've added the patches to
my randconfig test build box to see if something breaks, but otherwise
I think these are ready to get into linux-next, at least patches 1-3,
so subsystem
maintainers can start queuing up the conversion patches once the
initial set is merged.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
