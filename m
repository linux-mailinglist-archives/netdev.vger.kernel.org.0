Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B10551E8E
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfFXWtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:49:10 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:39919 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfFXWtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 18:49:10 -0400
Received: by mail-yb1-f193.google.com with SMTP id d14so4459785ybq.6
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 15:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2jIITlJAMqSwGSb8NcafsBTNtGUwQ247IZSbJFQyQxo=;
        b=kYIJStQMSdfm78D9teiDyBGKWXXwUu+yIk7ljjkCHKCRTrnI6k5GZdLh8QEwn3EWN1
         jSxMfWixmrasEN07kVSbuvIo7Uuky3Xf6p/5Yx95uWZOvhV4US0x1NWlEbNRgpJMg6v6
         svXvk94fFYbLjpDXI/+O/kgTa1Abqzj5GHuDKngEzI/yB5UHofuWbDhxPx5bNH4wkC56
         uqpQcwJ2X45kvIIslyRtlw+ZY1UpaQ2kPYY7EWBM1pPKQOGe2wkQVuq6dmXeh0W/tVC/
         zA3bzw37+UT+3u5rg1tqIkmMJNm0sezcYLCsT7BZ1CL4kP1juTLZpt05toxXYeDtnwPn
         EMng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2jIITlJAMqSwGSb8NcafsBTNtGUwQ247IZSbJFQyQxo=;
        b=UVlcX1WwMxFIf8jc9YHWhBeSItiirID9Zd+0H23E9UzRKyZ510Zr2VCCTqBwI4Yoy6
         4Xsn8EMyfK6flSV/xRe8AuiOEkVef7Ii3WCBcOX8EZB51FnKM9CJ/4qTITUqK7u1xgiZ
         P4p6LnLc/qNIp4ACERt1arfTYP5ACjiiD0JF78kqN364bKojxvqamGIOCniapFtwLu3b
         Cjac/JccvzdG8n/yuDluHLEBUI6en0HtKNC4Q7j6KuDAs2+oMps8tVNQvBujlvs2Lgjt
         74qeV57lN1mjNEPnwqCVhF2nqBEmSpqA9joKE8E4CuLJ5csp2s0CtQNZUK3myrqR5mnY
         EJ3Q==
X-Gm-Message-State: APjAAAWgznvJXq8gH11g7PSupkhL5LMs6mNnX4llfvydgV6T0ZNZnQbn
        FCQ6P+hLy4WZY5OQ1WdBtmZYBrVoUF0qba3ExQ==
X-Google-Smtp-Source: APXvYqygh/g1/MPKJI3iHfU7V4BMw+e0xgflGafBWcThVe44U4dwZX6OGdMoFnLp6lu7wh5XqbDvqTFgrbZ04hgDY+k=
X-Received: by 2002:a25:aba5:: with SMTP id v34mr2264188ybi.349.1561416549444;
 Mon, 24 Jun 2019 15:49:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190624112009.20048-1-danieltimlee@gmail.com> <871rzi4zax.fsf@toke.dk>
In-Reply-To: <871rzi4zax.fsf@toke.dk>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Tue, 25 Jun 2019 07:48:58 +0900
Message-ID: <CAEKGpzizbCb6Z3DN_p42LVsnBWwZpy3dPnsA2oRNEPP3p8BXRQ@mail.gmail.com>
Subject: Re: [PATCH] samples: bpf: make the use of xdp samples consistent
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will do right away! :)

On Tue, Jun 25, 2019 at 3:24 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> "Daniel T. Lee" <danieltimlee@gmail.com> writes:
>
> > Currently, each xdp samples are inconsistent in the use.
> > Most of the samples fetch the interface with it's name.
> > (ex. xdp1, xdp2skb, xdp_redirect, xdp_sample_pkts, etc.)
>
> The xdp_redirect and xdp_redirect_map also only accept ifindexes, not
> interface names. Care to fix those while you're at it? :)
>
> -Toke
