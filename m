Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D81371217
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 09:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhECHjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 03:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232957AbhECHjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 03:39:45 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F59FC061760
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 00:38:37 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id y2so2352789plr.5
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 00:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IYFsPOhEkozhRMhOWjWI11yqPrz5tjAXd8GPZbpcT4M=;
        b=XqxfYNYp/5H+2wt1W9YwZzLSm1v8EPSM0AF/OLqW8tYNoPa2nC1qTrcdw5io1BkLrP
         nJ1QcJjJ9Hr1xbg0PLokqNUqbqIw5jUioZMJRH9vzkrp6e8g7BkLpNk0yPAm6lkja999
         EoG52EM8Mjl1xUrcgAo1lCOWGh1E9IumHHYQPqyPmgKAXJ6NrLeb8XRxmdvtoyl2I2j1
         QBWNTBpfWP0fuEklUdXJ6j7UqIGhBKkcWx6E9YITZ20/73KAYku7EJ+drOtDV+db2wgq
         URszJ3yN0Yt3V12XVsGJX2fBkujF6uOhcUT3VmBpHSwKxCiFs2pFpuSZfu0hfygsN0rk
         RB5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IYFsPOhEkozhRMhOWjWI11yqPrz5tjAXd8GPZbpcT4M=;
        b=Xun5hheq7u01ds1p1E5h1qe9oa2F1HKW8QaHnOIGjPWsJ5dkH9HlxPcS4L5Er1OJZu
         ZGLBOVh9x6CCsTTiljb2Nn2rnVm4+uFSyJMvCGE36/Na/aOLhra/pqUgnpWdAoKyE8Jx
         NqQb/0yJZDQE4+C7dO/W/7pdQvG//5RgHlbYvotvraQT00TmR5zsaFWjSCggGieygtxL
         4W+52a451pbC3mcG6mmonuySVnyFtTzDaRMtoFBcSIOggCeSdXsRgA+dp4xcH2ZhxLZw
         rNRps4Qskyi1Im+QTCNFXUqqn5tp7Zx/BZsKAIHGmgjSXRINv+1RtRdjRbwnTfu+GYdU
         uk5w==
X-Gm-Message-State: AOAM532myizN7uVIG65jUSRExbIzVYyh77Ki0jlaNGjAEyieR5Y8E/8U
        8GqDUf2fDBuLT856UV+klwV609DbaEk3FkC/S8b6qxGQQ67bZQ==
X-Google-Smtp-Source: ABdhPJyFYRXBJAZ5sIncasHAQHWFRQjul8zYGS09rVBKOVpFVSk8arNYcmBT7NZ+2TrxLzf2ZHb9Kls4ePKD0u2UMco=
X-Received: by 2002:a17:90a:19d2:: with SMTP id 18mr3681020pjj.205.1620027516686;
 Mon, 03 May 2021 00:38:36 -0700 (PDT)
MIME-Version: 1.0
References: <1619777783-24116-1-git-send-email-loic.poulain@linaro.org>
 <1619777783-24116-2-git-send-email-loic.poulain@linaro.org>
 <bf02f5ecf84b7eaaa05768edd933a321f701e79f.camel@suse.com> <87a6pek9tn.fsf@miraculix.mork.no>
In-Reply-To: <87a6pek9tn.fsf@miraculix.mork.no>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 3 May 2021 09:47:12 +0200
Message-ID: <CAMZdPi89yOStvH8Z9ZwMkLzUB9QgBBzL1xxkUkSz3mwZ8+1nZA@mail.gmail.com>
Subject: Re: [RFC net-next 2/2] usb: class: cdc-wdm: WWAN framework integration
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        USB <linux-usb@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 May 2021 at 12:49, Bj=C3=B8rn Mork <bjorn@mork.no> wrote:
>
> Oliver Neukum <oneukum@suse.com> writes:
>
> > This absolutely makes sense,
>
> +1

Ok, thanks, then I'll resubmit a proper patch set with comments
addressed once the merge window is closed and net-next open.

Thanks,
Loic
