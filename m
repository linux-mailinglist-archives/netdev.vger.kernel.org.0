Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69CB44C4F1
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 17:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhKJQUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 11:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhKJQUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 11:20:48 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31239C061764
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 08:18:01 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id u17so3403852plg.9
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 08:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xPFsqTvBFg99lksVEWW00qQwuj1+xX7ZhCzbWH3A+S0=;
        b=Plb17ma3mynr9zY2icVtb8f+WeYDb0aTQxWegwF1MtykCySrRkAOh5us382pKb9Gko
         ab0P2TUJcj6W/Rruim9stgjlIGHMS9nytkwcQTEcRjNEpiyxyrGCN631PraB3L9UNgz3
         eeW3QFa7lT+wGfh4BGY9xYW/SVFuQzToPGRZfI9emQHhDbfHmuI5ohgRVG/lFMin9WhN
         /mqUXjmx7Qm8/cClDOKOYQrb0mTGJESyVAKtiClkDvj84eZocLlBAgUzWQITWd8jex3B
         UVgP84qXEp+RuqoQKk6r8RHLwJfBJvL6diNUMotV20ZRZIr6NoVsOy80OG5gzR3bIiO3
         q+iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xPFsqTvBFg99lksVEWW00qQwuj1+xX7ZhCzbWH3A+S0=;
        b=UN/R4Rt67bZhFaE5nCM+3js4Ald638nB21LGdY3CX/uY/3Ati9QPY0irLa9pbgGXmt
         lLL7BH8XMpvF9HaLcw/uieL+JiRut4m61T+UiNY/MHjByFAz3gL4Xx+i16wLJerDRF//
         pwWJp06xFBkOY3F81Kg6rpV1jh/uC9HjVfTOdLF60UmvMax6L0lCJna5+BPuRJZEA26N
         guuBgucrj7/cPQCTtOsr5wWM+/XkTGKxkNkZgCSRX0q6NnrMxNt6i4hKhFZD2JY17HEE
         DVr3qHda1A+0w9ky0Qts9NPFbOkh/U3+cpHf8HCSL1B/MBIR1rrJFzOKnlffu6Iz2QzW
         ozSw==
X-Gm-Message-State: AOAM531YWnAUFwjE776aJ/YUZk6Mmow9fQxL/Zk0wrPOUPM0Ui/DCY44
        aKT1JXnLlmSVOCAG0EP89/oJRghHK2yLa35arw5atg==
X-Google-Smtp-Source: ABdhPJzO/Homkt7R6hSklh6deCAz8PLrK7F6DS32QeUTtxVZGStUy+qWdCgfnhVmXwHoubrHWzVSBejcTPjZS2SD2PQ=
X-Received: by 2002:a17:903:120c:b0:13f:d043:3477 with SMTP id
 l12-20020a170903120c00b0013fd0433477mr16836443plh.89.1636561080570; Wed, 10
 Nov 2021 08:18:00 -0800 (PST)
MIME-Version: 1.0
References: <20211110162036.256158-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20211110162036.256158-1-m.chetan.kumar@linux.intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 10 Nov 2021 17:28:35 +0100
Message-ID: <CAMZdPi_TQcnmzNnMvVk5k1m6hnv7aSYz6m+a786Ui_VX-2nhVw@mail.gmail.com>
Subject: Re: [PATCH] net: wwan: iosm: fix compilation warning
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 at 17:14, M Chetan Kumar
<m.chetan.kumar@linux.intel.com> wrote:
>
> curr_phase is unused. Removed the dead code.
>
> Fixes: 8d9be0634181 ("net: wwan: iosm: transport layer support for fw flashing/cd")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
