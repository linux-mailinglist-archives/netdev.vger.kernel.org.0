Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9B8641E9A
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 19:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiLDSRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 13:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiLDSRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 13:17:16 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA92F1180C
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 10:17:15 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id y135so7397236yby.12
        for <netdev@vger.kernel.org>; Sun, 04 Dec 2022 10:17:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=prtTiZV9xKjXzqXTwXtXpRZSHnlTmdBzi/h+leenGwY=;
        b=txy4W2K2uWLnS0zWqQGwx4ekpZlJbkOIOwvAp3bUoBChDTjQxTP7wb0tYm3lTlBsRJ
         kSnuTf5p+0JHJjjHbe6MFSNAnxpI8sP4d9cW+bPF+AsDGe44SKNA0HOz6zwU9npeR1r5
         WtH1khtKpgPwKr7oQoaN9YOcT7I6bw3NTKuUz6ezzNl/pWRy64R2XKvuNMcOTgf4p1ei
         /qJBmh15gsHnX0+JLFMV4i7IrPYGmiFOG/FwPyxiSdfFyHx/nL7s9XZHCzhJaZA96PGD
         W3Dql7OyEjzus0Uq1ZjtEvrQ9k2jZ9Y4uzSaXQlw77GCmQUsg3Ag/T0xVTnaERPDhKVA
         NDoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=prtTiZV9xKjXzqXTwXtXpRZSHnlTmdBzi/h+leenGwY=;
        b=Vpn28GZiZCIF9Ls/FX6W/V3KAXR7OS6y3TH1I38PnbzBGWqrW++n2iuMci68iQmSyk
         pfhpE77NMnaLKpYGpRE8dgnz3uDl1zZG9M7tIOQjAByeH3xFOrXZR47FcuZuAR3Pu/jX
         0xHO5tKc38bycMHnSMuUn9Z1W9HyFaj6jv0Zd224QMlY0yZ+pT7V5n4WafnNLsVeYU5X
         ktBZekvw0AG3BM6Vt8WrgK8kM0RoSSYCjvPqWSthQnYUU5sDE34A7PhHIYNZpTHz9v+J
         K1OnHJDcgT0iMM9kAbhjxKcIW1yKli2qiD4JgtrIxQFwTY5ZSyncE46PoASm4BPYH+Yb
         1nwQ==
X-Gm-Message-State: ANoB5plosdVENmitz9Vdch/0DsUM9G13VXEKQTNhVfW/l1NcNZ4Bqdr5
        SpM5t+ivirkSGKfkNYMfMp0pv/VX0nYieL6TQzfkiZmz0jbDHegZ
X-Google-Smtp-Source: AA0mqf4Z9blRfdgFyRV8LvzsS8EuEpwBjPAWwEsQdPPMIG0Y61mV3GIlIamTQc00qJHSZnrdqQL2x1cE/yJ15hH6kMg=
X-Received: by 2002:a25:cbce:0:b0:6f9:93f:4afd with SMTP id
 b197-20020a25cbce000000b006f9093f4afdmr24977522ybg.188.1670177834965; Sun, 04
 Dec 2022 10:17:14 -0800 (PST)
MIME-Version: 1.0
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
In-Reply-To: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 4 Dec 2022 13:17:03 -0500
Message-ID: <CAM0EoM=aekjeBdrvfuG4bV=VHEJ3X7=58DvF5ZT2U3nzBAbo0w@mail.gmail.com>
Subject: Re: Upstream Homa?
To:     John Ousterhout <ouster@cs.stanford.edu>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And for folks interested in John's work, we just posted his excellent keynote
slides+video from netdevconf 0x16. See:
https://netdevconf.info/0x16/session.html?keynote-ousterhout

cheers,
jamal

On Thu, Nov 10, 2022 at 2:43 PM John Ousterhout <ouster@cs.stanford.edu> wrote:
>
> Several people at the netdev conference asked me if I was working to
> upstream the Homa transport protocol into the kernel. I have assumed
> that this is premature, given that there is not yet significant usage of
> Homa, but they encouraged me to start a discussion about upstreaming
> with the netdev community.
>
> So, I'm sending this message to ask for advice about (a) what state
> Homa needs to reach before it would be appropriate to upstream it,
> and, (b) if/when that time is reached, what is the right way to go about it.
> Homa currently has about 13K lines of code, which I assume is far too
> large for a single patch set; at the same time, it's hard to envision a
> manageable first patch set with enough functionality to be useful by itself.
>
> -John-
