Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2B221498B8
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 05:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgAZESx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 23:18:53 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:35500 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729159AbgAZESx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 23:18:53 -0500
Received: by mail-vs1-f67.google.com with SMTP id x123so3723546vsc.2;
        Sat, 25 Jan 2020 20:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lq3lIVfl7ApjZuiHmE6fiMLLbsA7AiogeQoH4ZIMHa8=;
        b=dPwwBpaPryuxcw1l4lbP4vYM1gqsLMCfn2pk9rnI+IhGSlyh81H5QfsAYJOblF9E0C
         l00HSeX59GqSds+G3pSY9GbpX/kL/UyvrGf2ol8vFsjvAepM3o+Fi0kr6WaPYyKLtr/O
         IHIxS9iSD9kaSUAP7FkaGOwriwtdXN8ePW1JaDmTx0hmutHo+8LWb9/j2Ezm1kE2KzPO
         EvH7GZPucbAAG+AJL3DTpJ7msovpYsyozZB+5J2hDuZ6mit8hgAhNMLeeL6BqoBhzBTl
         gqtS8pPa/o1/4Cr4EuqGR+oXKuCS1M17lMA+SlRkNJr4DHfrikt0U+DYMmD94lvAlJAg
         DUeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lq3lIVfl7ApjZuiHmE6fiMLLbsA7AiogeQoH4ZIMHa8=;
        b=MLsMxv5XTs/qR7IT1tzPHbOGM8JC8l0jVutcAPT71ZOqapAxqpB4oe24znKMX37uP5
         qoiA6OocPZNpuh/Zs8+nxMXfwnvgIxJ+Wg/bIg74xDdj7B1Qwc4wm2CNZnIh4lb1ufCu
         nFq+nKdDnbiKuGkJhQiHSq2dMu9/lqwQDZzpUW4w9vvoTpTOIUwa53tDiIqg0NZRo2QI
         Mqr63U0NZph/AqDbCzyTwHSctQrri9Y2a2Yz7s9ta8T0eOy8jLqONVuKBH7J18nIVqgr
         26FpLM43qXajEzYsYFbXYBBGzFF4+XSEL1j6UBCUKi/9kbW2rKKRrMOGCFIMAD5oMN/U
         Bj9g==
X-Gm-Message-State: APjAAAWReIWz6WT30QoRjzrivjQkQpgx+RzUgxDa25QxAtn5vBEUcnjC
        nKIU8fNQEryxMOGgsTETp1+4YezUlI5znfeqGpo=
X-Google-Smtp-Source: APXvYqy6dktF7WcxFxQFinwVQCe98+om3ALC3H32+yhVeALtJYLxCghljNOK0DC9d9HR8Xxnlikix+OwptuLKzGE7DA=
X-Received: by 2002:a67:f10c:: with SMTP id n12mr6652494vsk.208.1580012332237;
 Sat, 25 Jan 2020 20:18:52 -0800 (PST)
MIME-Version: 1.0
References: <20200123232944.39247-1-swboyd@chromium.org>
In-Reply-To: <20200123232944.39247-1-swboyd@chromium.org>
From:   Justin Capella <justincapella@gmail.com>
Date:   Sat, 25 Jan 2020 20:18:40 -0800
Message-ID: <CAMrEMU-e55q7uvd220+1kuYJ4Xa-4ckz5CvYezCj2ahn_K8t9w@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Use device_get_match_data() to simplify code
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maybe use dev here as well?

>                 dev_err(&pdev->dev, "failed to find matching device tree id\n");
