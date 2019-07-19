Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B0B6EA91
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 20:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731353AbfGSSRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 14:17:21 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34495 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbfGSSRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 14:17:21 -0400
Received: by mail-qt1-f194.google.com with SMTP id k10so32039991qtq.1
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 11:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=YmpSkRnhAarf7sfdu47DGWjoGr2XVZ5V5R/hRggcNZM=;
        b=S2I6EN0icF8k0oIklx0ZN46qMRnLc/45tTpdgm+6aakrh8lBK5F0Ye8DO+mYuMwONM
         +ovTEWMg7JxUqrh70xn7GpsvGmSRG/gsm5eYJEVoi3YA553lwmS3jGzPu607wutlVmr4
         e9WTDADDTLVtGfcSkm6gUFBDHGILB7dCV2DAebUygF9+2Tvn5N+3gn3c7FYgJhAa3reC
         MULM8jg8p44djRnn2noqt1pnnWge/5ZZsUFYxwj8czPFfj3arjK9fKcwpAUcD2eikxcm
         pLoWZV3f99U9pRjZDIODmMjJi0A0J9VNvCrpSzwYpsicTHYQzri648tSMZIEn1QFQXGK
         3zZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YmpSkRnhAarf7sfdu47DGWjoGr2XVZ5V5R/hRggcNZM=;
        b=kDI/R6laSaNDjZNyU0/jDumQ+uaEdQo1DcEs60EFM4uj6UoQWcs/ux68d4o0xuWF5J
         xajx5/HNttLIZwl6fXMOMwR0x1XSmmQVwx1cenNC/sa7oI42ju4bUoaXPWIUx/781yQN
         G14KDjdPaHvrLOUnqd2xIAMYJPHMRnmYxQ3Qlw0xkJSQMfnNj0gnwHIuDNracT2kocBq
         zgO1ClmrVjMzt69GfhZ3esNEe+EOXW4VfpgkU/Y2YCeSekscoTk7ZYKHitAkSeC4yNYD
         Ycp5lJmOGQwBVwDmutf/ZhS2lL7alY4kCcFpE3R3nAGqDJqNU+3RIEbHFLfbDNfZxop7
         gwPw==
X-Gm-Message-State: APjAAAX7AnVQW93nyHPgA21T7uGS0+VgDjAFmkc26lT8774of+4FftBo
        oMYnrNr+aLOS4VTa7DmMZMJbdcNQp8E=
X-Google-Smtp-Source: APXvYqyMnaxzIv8OJy3eWtHKuu77AmQFzzwiQiestKiExj2qy2NvYXsnz+9J14HDMrImV2w8sajNYg==
X-Received: by 2002:a0c:ad7a:: with SMTP id v55mr38108254qvc.130.1563560240190;
        Fri, 19 Jul 2019 11:17:20 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e125sm13401161qkd.120.2019.07.19.11.17.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 11:17:20 -0700 (PDT)
Date:   Fri, 19 Jul 2019 11:17:16 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, lmb@cloudflare.com,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH bpf] tools/bpf: fix bpftool build with OUTPUT set
Message-ID: <20190719111716.1cbf62d1@cakuba.netronome.com>
In-Reply-To: <43FB794B-6200-4560-BF10-BBF4B9247913@linux.ibm.com>
References: <CACAyw9-CWRHVH3TJ=Tke2x8YiLsH47sLCijdp=V+5M836R9aAA@mail.gmail.com>
        <20190718142041.83342-1-iii@linux.ibm.com>
        <20190718115111.643027cf@cakuba.netronome.com>
        <43FB794B-6200-4560-BF10-BBF4B9247913@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jul 2019 15:12:24 +0200, Ilya Leoshkevich wrote:
> > Am 18.07.2019 um 20:51 schrieb Jakub Kicinski <jakub.kicinski@netronome=
.com>:
> >=20
> > We should probably make a script with all the ways of calling make
> > should work. Otherwise we can lose track too easily. =20
>=20
> Thanks for the script!
>=20
> I=E2=80=99m trying to make it all pass now, and hitting a weird issue in =
the
> Kbuild case. The build prints "No rule to make target
> 'scripts/Makefile.ubsan.o'" and proceeds with an empty BPFTOOL_VERSION,
> which causes problems later on.

Does it only break with UBSAN enabled?

> I've found that this is caused by sub_make_done=3D1 environment variable,
> and unsetting it indeed fixes the problem, since the root Makefile no
> longer uses the implicit %.o rule.
>=20
> However, I wonder if that would be acceptable in the final version of
> the patch, and whether there is a cleaner way to achieve the same
> effect?

I'm not sure to be honest. Did you check how perf deals with that?

My goal was primarily to make sure we don't regress, so maybe if some
corner cases don't work that's not the end of the world. I think a good
rule of the thumb would be "if it works for perf it should work for
bpftool" ;) Perf gets a lot more build testing.
