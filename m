Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1042D021
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfE1UMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:12:38 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:39500 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbfE1UMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 16:12:37 -0400
Received: by mail-vs1-f65.google.com with SMTP id m1so128822vsr.6
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 13:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gi/kDB0T8blaZ4N3Go9mHKUpJE7iS399aaXlXpsJB/M=;
        b=JLxYOnmDJcrvrx0TjCujM/n0knfusm2CntjGzV4VPzAD+EFhlo8bMTG9t7aal/sQvQ
         KPH6TmOjB26vlVux4qFF2O7y0N3OLKr3gAJH/DJGCfmBrsadoIeWKCNpm3fBOPswf3Ba
         6by4zMVQHchTKPYZV4Sc0dM7vt5MIxMKhWGK8F+toGpf0xixHkbFMljAUDpVxZ/LNjen
         fxCbCXU8wIgSXM+/Nytt81ZkmCUgDWHkB1l6JSa87KEV9ETuHHhjodSJ1RBbqtHpA8SJ
         fE8OC9iG1QauEooEVyrRXOLAFESuw9fIG7TkKzagGOcjZoImxM5Z7R51VbDlxDGe0BcB
         fH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gi/kDB0T8blaZ4N3Go9mHKUpJE7iS399aaXlXpsJB/M=;
        b=o3/cqrnLOFMYAy4yYzYPqzZfckv0Bp1JlwawTgreikTJJPJ4x9c4+T2VofDaeSjl1T
         Ar7v+1kFd1Mwjki6KfOXdshpIJoC98sr/hc2AR9CT3n0u++J5aSR62TqZV093z1d82gp
         l9r0C+kJKgr33Z8SQoKJLy6hU+fUOT0Alqu3s50wEMTmv0OCuMAedPl5uLh1So6532Hg
         CmVdMpxDSs9tblnKJ174ZATPJFPDo5iXNokfEwmgY8bsv6f5CkZiJAeBrjRNTIF3jsro
         X2Ihquw6SNkoFO5pBncP4oAQXd3eR1K/+bUNdFEEViLPZXnTdYn7SBifhZG6WD3i+nEJ
         2xEQ==
X-Gm-Message-State: APjAAAVxMn4fQ2cwOaLTYVLTP3bG+AA/OJP/Jib3sDg+6ceWZNNKTXfk
        T/27iuyJy3FALA8BZx/rI1UwjpTYDDvTwIWMsz+YzA==
X-Google-Smtp-Source: APXvYqyhr2ApjSz9LQBsYYyEvA4OOcCsPCc4JI8zHRQcvXybJdPh+Anw9su0Trv01Aesw4jSdtAj6GclPuv7+IfWTV0=
X-Received: by 2002:a67:ebc5:: with SMTP id y5mr75082391vso.34.1559074351753;
 Tue, 28 May 2019 13:12:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190524111053.12228-1-masneyb@onstation.org> <70782901-a9ac-5647-1abe-89c86a44a01b@intel.com>
 <20190524154958.GB16322@basecamp> <20190526122136.GA26456@basecamp>
 <e8c049ce-07e1-8b34-678d-41b3d6d41983@broadcom.com> <20190526195819.GA29665@basecamp>
 <20190527093711.GA853@basecamp> <ead7f268-b730-3541-31f7-4499556efec0@intel.com>
 <20190527125026.GA4272@basecamp>
In-Reply-To: <20190527125026.GA4272@basecamp>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 28 May 2019 22:11:55 +0200
Message-ID: <CAPDyKFrm=NTKjsEPiwzUVbDDzjW5PwZteXbKtPUi9GTUB4kbMQ@mail.gmail.com>
Subject: Re: Issue with Broadcom wireless in 5.2rc1 (was Re: [PATCH] mmc:
 sdhci: queue work after sdhci_defer_done())
To:     Brian Masney <masneyb@onstation.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 May 2019 at 14:50, Brian Masney <masneyb@onstation.org> wrote:
>
> On Mon, May 27, 2019 at 03:08:07PM +0300, Adrian Hunter wrote:
> > On 27/05/19 12:37 PM, Brian Masney wrote:
> > > On Sun, May 26, 2019 at 03:58:19PM -0400, Brian Masney wrote:
> > >> I attached a patch that shows how I was able to determine what had
> > >> already claimed the host.
> > > On Mon, May 27, 2019 at 10:48:24AM +0300, Adrian Hunter wrote:
> > >> This is because SDHCI is using the IRQ thread to process the SDIO card
> > >> interrupt (sdio_run_irqs()).  When the card driver tries to use the card, it
> > >> causes interrupts which deadlocks since c07a48c26519 ("mmc: sdhci: Remove
> > >> finish_tasklet") has moved the tasklet processing to the IRQ thread.
> > >>
> > >> I would expect to be able to use the IRQ thread to complete requests, and it
> > >> is desirable to do so because it is lower latency.
> > >>
> > >> Probably, SDHCI should use sdio_signal_irq() which queues a work item, and
> > >> is what other drivers are doing.
> > >>
> > >> I will investigate some more and send a patch.
> >
> > Please try the patch below:
> >
> > From: Adrian Hunter <adrian.hunter@intel.com>
> > Date: Mon, 27 May 2019 14:45:55 +0300
> > Subject: [PATCH] mmc: sdhci: Fix SDIO IRQ thread deadlock
> >
> > Since commit c07a48c26519 ("mmc: sdhci: Remove finish_tasklet"), the IRQ
> > thread might be used to complete requests, but the IRQ thread is also used
> > to process SDIO card interrupts. This can cause a deadlock when the SDIO
> > processing tries to access the card since that would also require the IRQ
> > thread. Change SDHCI to use sdio_signal_irq() to schedule a work item
> > instead. That also requires implementing the ->ack_sdio_irq() mmc host op.
> >
> > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > Fixes: c07a48c26519 ("mmc: sdhci: Remove finish_tasklet")
>
> Yes, this fixes the issue for me. You can add my:
>
> Reported-by: Brian Masney <masneyb@onstation.org>
> Tested-by: Brian Masney <masneyb@onstation.org>
>

Applied for fixes, thanks!

Kind regards
Uffe
