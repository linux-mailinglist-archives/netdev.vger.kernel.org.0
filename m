Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF91D1B1CD7
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgDUD3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgDUD3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 23:29:09 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D07C061A0E;
        Mon, 20 Apr 2020 20:29:08 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id u6so12432916ljl.6;
        Mon, 20 Apr 2020 20:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BMJTUlThbttHy1s8zUh/yLSGgtDbp++0rIV/2h/ppXc=;
        b=IOrDORJpETL24Q4qgjrdtATYPbplnCCaARvV4mTK2xNPrsPKma/RZf105SSk3pjbON
         HGAkpXiqwBzsmocWSaLCmmkd8WbS151+iq8eztxudkaeRBjnaDozYloik/+xSRKLDqi1
         f4M+XQhoew64tkF3TU67MpAZTMf7vds3uDZndxpzDKtzl1sy+vCeexYNWZ25s2aJIbq3
         4eenqUzgtrP+74IVktA2f9de0IcLFmTAkx8fxxSkd91Y9mFSPNJv352ECVF0QcLdm9bH
         3qD6uhmRSG2RQEv5WoUmwgKC770val/UE9F1ttXjSmm+Pomi698hAVqzA89v92KIuwS9
         iQ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BMJTUlThbttHy1s8zUh/yLSGgtDbp++0rIV/2h/ppXc=;
        b=jAHzw5H27VeisdEPQ6UUfPV51kU5bu3PYvLRBWkFOOJcadImLHPLtgZsx3m8HkgO1R
         UH39DDTnqHJRSXMzZd+YCcO9US09CiXDJcmCEfJniVuq2lSIvRl54E/gEuDOMOMShGcn
         eu34iHpKZjuQYSbbfnO7k9xJ7VStDsdIRfEcwRL+U3ZJFsxvV7nlxdvlDfRYD45GZeul
         ts1WSBl0nHFDHZfmDEtqtKy43zPKACf5IYEYiyD+ugTanR4QfnZNPzX6EykMLOQU5vPd
         wybMI6riCrzeUMqh7gjjnjfhUhQjHgyK97bMEiGeyqgMdcjXoefrLied3cjrUR1pHk/f
         EQAA==
X-Gm-Message-State: AGi0PuYXL/xW3cZ2Z98GWqDo9U1MP2tpmBp7nJru7+z8EPGbe6P3M98W
        O9QdKEDDfHuCFcBtp3ZTzU2ju+n1lH/DGKvp0AE=
X-Google-Smtp-Source: APiQypKCG5z3X8zmL26CpfcUXIEHpjh1hK9hE7uztfrp9w/P1N3NK5PCO8bHnVVhNO4IlT8umqToYEVAZjVTSaei/3w=
X-Received: by 2002:a2e:a169:: with SMTP id u9mr3804245ljl.144.1587439746689;
 Mon, 20 Apr 2020 20:29:06 -0700 (PDT)
MIME-Version: 1.0
References: <1587274757-14101-1-git-send-email-jagdsh.linux@gmail.com>
In-Reply-To: <1587274757-14101-1-git-send-email-jagdsh.linux@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 20 Apr 2020 20:28:55 -0700
Message-ID: <CAADnVQ+vFZpxvHryuofTou18LETweu4cPWX6b4skqZmU7_DDfA@mail.gmail.com>
Subject: Re: [PATCH] tools/bpf/bpftool: Remove duplicate headers
To:     jagdsh.linux@gmail.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Jiri Olsa <jolsa@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Paul Chaignon <paul.chaignon@orange.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 10:40 PM <jagdsh.linux@gmail.com> wrote:
>
> From: Jagadeesh Pagadala <jagdsh.linux@gmail.com>
>
> Code cleanup: Remove duplicate headers which are included twice.
>
> Signed-off-by: Jagadeesh Pagadala <jagdsh.linux@gmail.com>

Applied. Thanks
