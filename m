Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CED446FC0
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 19:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbhKFSMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 14:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbhKFSMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 14:12:08 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EF1C061570;
        Sat,  6 Nov 2021 11:09:27 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id v3so23285584uam.10;
        Sat, 06 Nov 2021 11:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pJENZ6NM8JCdNWT5lrr17Z1/9ysbdYmY/1VECMCGWHE=;
        b=Vk/ifs1Ca6UAcnTkV76lxOf5muoBeQB4O/FCZJFquRrHhWpf0rLJlCEsZZHBi1PrGZ
         xRVrxIDSCDMiGiFYowdSrSEt4EX2axkq05G0je3IgaCxXfUeix2YmfLnJBz5eTvIyvBq
         2aTNGf58eLPn0R0aOZZ5FWCU9G57W7tl5GSQu0D+dOkbrIY/EWRZBV6Vp9M/1bIy6VJe
         wVVvLe/mzC5WnPMoH4LyqxDWHodRnuEx3zX5zmohyre0fhu+0DvMGl6wCsNY+qcibZkg
         UqogvQYfsJH/v+MiwhK0i4YWlrU3OX4//nxGNQavX/RWtunXoC2BUkYMtQ1kM1xcgxfD
         pNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pJENZ6NM8JCdNWT5lrr17Z1/9ysbdYmY/1VECMCGWHE=;
        b=6D79J/4u9rTLSs9HRkunM6IUXfby/6xzLC/rNuu1z6b2Fexlw6n8dm4R2ehBM/hvrj
         e3RuNsGbAJFEpOg91mNWulnAXaZEv+mgqczcS9TxnNk6wuQz98DoNfMe5rGhTj0g1XeR
         kTnAiSDg69HbNbFu81eNfLyutcmVHC1XJq7GcEJNHJcC8PI3WmB2FbCgw4nHt8vAPY7M
         /ZFyKfP9XhawOYBQ92R7cpJpZS6A+RVyUyQ9zOI3vU6SQ7TZt+8TYZl9VGc4IM5bfiDT
         463a9507SXj3j3PTkERmJqKNGsmOKEXMY8Ay3NWK4T7OvsM/vTZ/rYUP3j457Q1XqeyM
         Wycg==
X-Gm-Message-State: AOAM533rAK8neTfCQwYmeAIFE/75gW2TV6D+iJCMmJbNwqV1oeVt5GYq
        Sde26JPgi3RZXod1Y9qVk17gc9s8HWJveNTTIPI=
X-Google-Smtp-Source: ABdhPJwx1VndX8EKOty/rbo1Dtl3E5xPH7jyus1MHPh1VdaGEeGosDbzwK2AWy37w7a7+5DpjJKyvbIavC+jXie9FB0=
X-Received: by 2002:a67:d701:: with SMTP id p1mr8527650vsj.21.1636222166359;
 Sat, 06 Nov 2021 11:09:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com> <20211101035635.26999-14-ricardo.martinez@linux.intel.com>
In-Reply-To: <20211101035635.26999-14-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 6 Nov 2021 21:10:29 +0300
Message-ID: <CAHNKnsT_SDUCtisOx9QsfgUbQyi8uY8hUvYXvXtSxno_rfdzOQ@mail.gmail.com>
Subject: Re: [PATCH v2 13/14] net: wwan: t7xx: Add debug and test ports
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Creates char and tty port infrastructure for debug and testing.
> Those ports support use cases such as:
> * Modem log collection
> * Memory dump
> * Loop-back test
> * Factory tests
> * Device Service Streams

A-ha. The purpose of chardev stuff in previous patches becomes much more clear.

Please do not do this in such a way. This is not an everyday usage
operation to be supported via the chardev. Also this will require an
end user to study another one bunch of custom vendor tools for quite
common development tasks.

The kernel already has a rich set of frameworks for device debugging.
If you need to update firmware use the devlink firmware updating
facility, see e.g. Intel iosm driver for reference. For memory dumping
you could utilize devlink or device coredump facilities (see ath10k
driver for reference).

For other debugging tasks I recommend you to use debugfs. The WWAN
subsystem could be extended to provide a driver with a common debugfs
infrastructure (e.g. create common directory for WWAN devices, etc.).

As for modem logs, you could pipe them to the common kernel log via
the dynamic debug logging or export them via the debugfs as well.

Loic, Johannes, do you have some other advice on how to facilitate the
modem debugging/development tasks?

--
Sergey
