Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 034876ADE3
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 19:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388252AbfGPRtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 13:49:25 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36592 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728137AbfGPRtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 13:49:24 -0400
Received: by mail-lf1-f65.google.com with SMTP id q26so14388663lfc.3;
        Tue, 16 Jul 2019 10:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HTL9IQf99IT+ysRDGfc105FrkGObZJ5xlWUc03CT67A=;
        b=MBWIOKYd73z261xyZfJqCIdmXDe9Pocl9WT2CcEf1w3dPMgJPVxh28Do2ELwdEAzs5
         EaioLhrwnkDiNm61y/4g8pk1kB4TcPv9y4lKCoGP1h1RHimui8KvjI4luwgEeW6Op8HH
         fI4oS3WOJwczEAt9pZ4JQ5GuH8wEXCkY8jo5jXlt3RJe6u4i1NxIcYeScgN5CGo1ddeJ
         WK27xJyF8akSFC6gJghJhFvGuFV/Cb84B6uTQzewXcmvvlgZS1oLjQOVG/mZYAJbgYi8
         vhmQCT2FN7rCi2ZNbJ8LVuAiuRCjsjwfAXGhVhGPeVecyTMMyV+CGVrQ6o1QIh6N41sI
         yLDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HTL9IQf99IT+ysRDGfc105FrkGObZJ5xlWUc03CT67A=;
        b=YNRMyE4xmyKiEayM1lyN7IKV2432bDZCQrDxRJQka4yCDNGbNo6nHpjm8hyWbYQ1pW
         +GFq0935wKocLD/WJPtJGQRtRVQuDZbFN7H+Eh/3z/EA7beGMLW6sTIKGGJq5lDShQ5J
         wDILseUjZjNZM5hmsXSgoGkTNk1EEa9f6nAIPTLlWs881uBqqMhfA3GKl/5Qa2tkc/OE
         qEtxH6I/GBiScdhoehPLigjWBHBm0kbome09BIywZyi1vfrEkN7RkdiP5ZNZTKYZp+yd
         kr7gxqF3cf9HSLEa5N3SZGsAl/3pCA2g5uGtt+vbkKvyvSfk4bO4e0TETSIVuN2Jl/ky
         MBZA==
X-Gm-Message-State: APjAAAVAFjAZwfPMuYIL7qoHyyXjuNFT1W7P4LnFY12Xm6eT1dNe/Ug7
        DYXYYXenAdiS1Jd+qBiVSu8owJiSXAJFpG5EF0Q=
X-Google-Smtp-Source: APXvYqwnhSb7lqgvZennS0RsEDutmX54GDy2a/XHdaib2hCFOcwADkk5+ZMrBHsBtRasuRKaI8MIhOgA/i5qkEfnvag=
X-Received: by 2002:a19:6e4d:: with SMTP id q13mr15563860lfk.6.1563299362722;
 Tue, 16 Jul 2019 10:49:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190712135631.91398-1-iii@linux.ibm.com> <a3823fec-3816-9c38-bb2d-a8391766e64d@iogearbox.net>
In-Reply-To: <a3823fec-3816-9c38-bb2d-a8391766e64d@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 16 Jul 2019 10:49:10 -0700
Message-ID: <CAADnVQKzZQ_mbaMHEU6HA-JEy=1jXvBWULg8yKQY_2zwSmU86g@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: make directory prerequisites order-only
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        gor@linux.ibm.com, Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 3:22 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/12/19 3:56 PM, Ilya Leoshkevich wrote:
> > When directories are used as prerequisites in Makefiles, they can cause
> > a lot of unnecessary rebuilds, because a directory is considered changed
> > whenever a file in this directory is added, removed or modified.
> >
> > If the only thing a target is interested in is the existence of the
> > directory it depends on, which is the case for selftests/bpf, this
> > directory should be specified as an order-only prerequisite: it would
> > still be created in case it does not exist, but it would not trigger a
> > rebuild of a target in case it's considered changed.
> >
> > Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
>
> Applied, thanks!

Hi Ilya,

this commit breaks map_tests.
To reproduce:
rm map_tests/tests.h
make
tests.h will not be regenerated.
Please provide a fix asap.
We cannot ship bpf tree with such failure.
