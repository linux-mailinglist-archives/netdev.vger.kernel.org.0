Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4232D1270AF
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfLSW3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:29:52 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42356 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfLSW3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 17:29:51 -0500
Received: by mail-qk1-f195.google.com with SMTP id z14so4766976qkg.9
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 14:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XsmZBNUHHCXNS0fS7nTCTITHP4EPFsvNRDCD9lzBi+w=;
        b=Eif7wPUhZhBXMbOxcCVIswCva/mJdhNlrsuySiCKIsGVgAwqU2+iXh8mFqr1Ly77XZ
         3zrlNnVfxN8cmFagAZzCQxkFZc5muSCRZIWQP8lohsbiOw0LOiLeHiWMKr6iEGSNusnk
         nmGYzxrqB8oInl31JkeAFmM1Y/DZedeZOVuyI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XsmZBNUHHCXNS0fS7nTCTITHP4EPFsvNRDCD9lzBi+w=;
        b=XVZvMk/zyVPByvl1mBRIbwQXQxM//y0V/KQTMDyeb2DoLqMcw86QO2J85Q1tTD4Cmx
         Uu12srULSryn7UQ1Hjv/M/YZHxtaXNKQXdz+oCp3j7OrK05WxwwWJLiqqlPLALu0pZM/
         Du8840tTp7xveDksNfKy+OZRkXYz31AxA7ntsdBTFwGymYmNHCJ2EIVrpFWeJ3NB1N8y
         YD0i/BYNC4gCxNdoTmgOh2Tynbn7VCvFvc+SUv+ycBTDyBQ3DZCVqJpPrlo6bDcxZ8/g
         7eapbUy5R+sls8IRL7jIU4yu5GKOuj31FaQr2lNuuKK0hHHUVjjYYqrR8pobrPNb6oNh
         MftA==
X-Gm-Message-State: APjAAAViJtXs3hmkdY+P4NxDD6IwGI8Evohq//+KSVFhSNDmoTrq8Vdf
        VuHciFkxCKFZ6/chZIgdwL/yJggOPp6rvv7NukLfXQ==
X-Google-Smtp-Source: APXvYqxtFJZffZC3OR8xTVwXjUOlIiGd63DxAjijFLC1qabFOPp4JBCYMvJ6UkYGbSpHsGZPZsp2ah9pH2Cx2WhdDsc=
X-Received: by 2002:a05:620a:102c:: with SMTP id a12mr10051027qkk.95.1576794590648;
 Thu, 19 Dec 2019 14:29:50 -0800 (PST)
MIME-Version: 1.0
References: <20191219201601.7378-1-aforster@cloudflare.com> <CAADnVQLrsgGzVcBea68gf+yZ2R-iYzCJupE6jzaqR5ctbCKxNw@mail.gmail.com>
In-Reply-To: <CAADnVQLrsgGzVcBea68gf+yZ2R-iYzCJupE6jzaqR5ctbCKxNw@mail.gmail.com>
From:   Alex Forster <aforster@cloudflare.com>
Date:   Thu, 19 Dec 2019 16:29:39 -0600
Message-ID: <CAKxSbF19OsyE8B9mM+nB6676R6oA0duXSLn6_GGr1A+tCKhY9w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix AF_XDP helper program to support
 kernels without the JMP32 eBPF instruction class
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I though af_xdp landed after jmp32 ?

They were indeed pretty close together, but AF_XDP became usable in
late 2018 with either 4.18 or 4.19. JMP32 landed in early 2019 with
5.1.

Alex Forster
