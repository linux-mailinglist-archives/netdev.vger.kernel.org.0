Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1858012091D
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbfLPO7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:59:31 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35764 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbfLPO7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:59:31 -0500
Received: by mail-lj1-f195.google.com with SMTP id j6so7170480lja.2;
        Mon, 16 Dec 2019 06:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AkMzpXI7ntO1rE/dfXOYRKPIeHQ3S3D+clN6+4ecy3s=;
        b=qOz7nFFM+iRZ8yh2pKfuwbG2D1QhH6FC7ssw95OLmeNO2C7orUWgwBcqD95s0HXEGr
         43CELEs/EKyXpfHh7u0E/ECf62MTxEdRchST5M0ujFMtxZtTe8IS3r+8U0KRuQcalZWW
         IcpbAQmtutVqYzi6bcnk82TPi8p3MO8iAcgr9oybYmiUISfMfDT8ffgS9GWqG4qMeV7u
         w0uAOvAaR/Kh9ZNerztI87Kj0NNEnaNmGd/MIlYl9M9JOxgnmSGSOftF3p9WNH6aQlm0
         RLCwFdW8fHHikUv/ZRlp8LMA70aCYsWrjrn7DWhVa34SNc7tA0dquLI21EEvN2FOimDi
         3vQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AkMzpXI7ntO1rE/dfXOYRKPIeHQ3S3D+clN6+4ecy3s=;
        b=MxChbk0ra0QayyyBHTXt96aXLrHZ8wtWhxlZjLplggWjL6/MZAFiof/uw82XpE4q9f
         8oV7Cf8is8uTQk5sUadDTjPzr5sI7KLD7CnfTwucAWtJtWL/Gxd0oHJszkuf/SlaAEdb
         F1gQi9LaxkH9fWIHmRF3KZKNZMUugg5XguUrOF7T6rgZ5ROJAaReeZfF17m8Hj1XGMOT
         9qS39mB1POc4931zO3mAt8/PI2U5GFBwF/ydoj+ioHYdJZpxDa+Z/X6zSgjqSyRXuZ1d
         OldK1MAswmfzMXHD49HDjQI3mwZc5IZjparO7XEUgZ526OEH3XBwc+w18LLSGw5mu11o
         uAfQ==
X-Gm-Message-State: APjAAAWVupzMfyWEIz+lCxiJhVEGf0SS6ibOvxgqQ/CZrfcK62nd2ptF
        YoWdq3emvnj07olLP2uGlEWZfbkId4Fd1IzlDiA=
X-Google-Smtp-Source: APXvYqz4WNLgCqiS/ExeZkpu0JuX1W4NIej14aOvyxIBzSlt+vZAkvtYrTkjpqq5CAsjnZEqU2oEiSR3BQEBhJ3wMu4=
X-Received: by 2002:a2e:8e8d:: with SMTP id z13mr19687074ljk.10.1576508369313;
 Mon, 16 Dec 2019 06:59:29 -0800 (PST)
MIME-Version: 1.0
References: <20191216102405.353834-1-toke@redhat.com> <CAJ+HfNjyx6ZLrcqW+voHsNH-PUuLKGCyvtdVXSz+kODhyxQYAA@mail.gmail.com>
In-Reply-To: <CAJ+HfNjyx6ZLrcqW+voHsNH-PUuLKGCyvtdVXSz+kODhyxQYAA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 16 Dec 2019 06:59:17 -0800
Message-ID: <CAADnVQJixv3g=WfcxEz3bqWPVG1DCfXoLgCLBBRtff3KmJeDaQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: Add missing -lz to TPROGS_LDLIBS
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 4:16 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> On Mon, 16 Dec 2019 at 11:24, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
> >
> > Since libbpf now links against zlib, this needs to be included in the
> > linker invocation for the userspace programs in samples/bpf that link
> > statically against libbpf.
> >
> > Fixes: 166750bc1dd2 ("libbpf: Support libbpf-provided extern variables"=
)
> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Thanks Toke!
>
> Tested-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Applied. Thanks
