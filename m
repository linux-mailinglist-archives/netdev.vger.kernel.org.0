Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB006A1993
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 11:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjBXKIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 05:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjBXKII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 05:08:08 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168D61689E
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 02:07:09 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id i9so17070070lfc.6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 02:07:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ai7hQAOVjAqJd8L3s9WkXNCaqYXI3lU2xYmmJfxsJg=;
        b=a0CNAgTKQJ0vNcGcf1C79BBGqObQr08UeM4yNof2EHvCQqfz6ehPDWZW8GLcGEls/z
         7Gnu0dw7szYhm1iRn2jGy0qvQZRRbAkNE9McYwouAhCNjba9+Aw/pVRz3vf+h0oWMbMX
         IurdaqNWqDLyQrmAfrOCBcJ63Al00R8K3TyOFx2eR4lYy6Xtdn0VLBIVjzhulgFuIqPM
         OkuHLF4ARQOWOC6iAxwzuUaajxGsUTbOlVRw6WsSVqmoz1twr9mk35ol/Kh64LdgrdlT
         5QmmT85co5qedjMgoOtS8wq2Sc54l/ZgMXnqbO9ApX89ajvuFv2KbfajHrcGiGXVzRUY
         Pijw==
X-Gm-Message-State: AO0yUKW9MobGbKsHoYSasWYw4DS3TRGppkVnJgsMblKY4f+WeTJDhJUn
        E9BEstzyk09R45NTN3pTiOjNGI3r4lxjh6oJ
X-Google-Smtp-Source: AK7set/TWEyxqFz/yCxR5FZsrNxxe+g6cJy3QAqqbJWAHGqq27LaVd70e23+3a4QWa+kcwa2C2jMag==
X-Received: by 2002:a19:700d:0:b0:4dc:554b:d27e with SMTP id h13-20020a19700d000000b004dc554bd27emr4723042lfc.65.1677233155377;
        Fri, 24 Feb 2023 02:05:55 -0800 (PST)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id i8-20020ac25228000000b004dcfee9e4a9sm1316406lfl.247.2023.02.24.02.05.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 02:05:54 -0800 (PST)
Received: by mail-lf1-f49.google.com with SMTP id f41so17209189lfv.13
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 02:05:54 -0800 (PST)
X-Received: by 2002:a19:7610:0:b0:4dd:ab9a:24a4 with SMTP id
 c16-20020a197610000000b004ddab9a24a4mr459802lff.5.1677233154479; Fri, 24 Feb
 2023 02:05:54 -0800 (PST)
MIME-Version: 1.0
References: <CACXRmJiuDeBW4in51_TUG5guLHLc7HZqfCTxCwMr6y_xGdUR5g@mail.gmail.com>
 <20230223211735.v62yutmzmwx3awb2@lion.mk-sys.cz>
In-Reply-To: <20230223211735.v62yutmzmwx3awb2@lion.mk-sys.cz>
From:   Thomas Devoogdt <thomas@devoogdt.com>
Date:   Fri, 24 Feb 2023 11:05:43 +0100
X-Gmail-Original-Message-ID: <CACXRmJj8hkni1NdKHvutCQw3An-uwu0MJkHFDS14d+OiwzDHZA@mail.gmail.com>
Message-ID: <CACXRmJj8hkni1NdKHvutCQw3An-uwu0MJkHFDS14d+OiwzDHZA@mail.gmail.com>
Subject: Re: [PATCH ethtool] uapi: if.h: fix linux/libc-compat.h include on
 Linux < 3.12
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Thomas Devoogdt <thomas.devoogdt@barco.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I now remember (while looking at the other patches I had to add) that
I'm also missing __kernel_sa_family_t from /uapi/linux/socket.h (for
Linux < 3.7). So it's indeed not just libc-compat.h which is causing
problems. So perhaps take that one along while at it.

Thx in advance,

Thomas Devoogdt

Op do 23 feb. 2023 om 22:17 schreef Michal Kubecek <mkubecek@suse.cz>:
>
> On Thu, Feb 23, 2023 at 09:38:41PM +0100, Thomas Devoogdt wrote:
> > Hi,
> >
> > I now see that these headers are simply synced with (and even
> > committed to) the upstream kernel. So having a kernel version check
> > there is probably not something we want to do. Better would be to
> > incorporate the "libc-compat.h" header as well to fix compilation on
> > Linux < 3.12. This is similar to the added "if.h" header itself in
> > commit https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/uapi/linux/if.h?id=0b09751eb84178d19e4f92543b7fb1e4f162c236,
> > which added support for Linux < 4.11.
> >
> > Let me know what you think, and if further action is needed from my
>
> Yes, adding libc-compat.h would be a cleaner solution than having
> a modified version of one header file. The easiest way should be
> creating a bogus header file (e.g. "touch uapi/linux/libc-compat.h") and
> running the ethtool-import-uapi script.
>
> Seeing that this is not the first problem of this type - and likely not the
> last either - I'm considering if we shouldn't go all the way and prevent
> mixing potentially incompatible kernel header versions by pulling every
> kernel header included in the source (and every kernel header included
> by those etc.). That's something that could be scripted easily so I'm
> going to try it and see how big the full set would be.
>
> Michal
