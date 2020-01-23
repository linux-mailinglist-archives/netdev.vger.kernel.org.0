Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9F8147081
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 19:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgAWSLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 13:11:49 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43218 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbgAWSLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 13:11:49 -0500
Received: by mail-ed1-f68.google.com with SMTP id dc19so4245673edb.10
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 10:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=74fRWVRhPL8V6KYaBVHwjmwxdW4Na08LTeKfxvnXL4w=;
        b=sw0m9saTHUc5d7iXQ7KYbhQn0x6X96E6lsrvGXgzYtqt4vkqVMQH/xHqUyf1y8LcVm
         IF/JFQIja2Ib0+hcIIXDBdov+f/s6/UH4g/2aNYqhXJUByw+8JcL9wGEacDjKiluph9a
         aX5jAMnNAj4SiFk39/uA9MnpYJW2qsBs1zCucsJZUBUaO1qs5mcU1TIrWZODeDwOeEpz
         c6xxbT2qlgyFAamnpepBtq5lpDsGwGRWqRHw5dFcWHVAcICDwmRJBXtH1sBJ1ftVJalQ
         1VS1ABHZNqhhlIY1EAJGKh7QUNOvmJic/7D+ocsGdekitr+3JOX6sZiDj8w+zkO5fL5q
         SyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=74fRWVRhPL8V6KYaBVHwjmwxdW4Na08LTeKfxvnXL4w=;
        b=CzeAFOTXHKsBPAYpDq6lxQoSFdq3WpU4B9Xekpks6tyJ/a3kd/ctu6aYfPr3r3qKsj
         qevrZ3UzDCR6Uu2jvt4J24SgtBf4/kN8M8WpP+E+Yf1NFN9lSI4b8XPvuQpU0Flox74M
         l/PSidIQmsWTBBOBpivUgezVsN9sz3ugs0l+4hYB71T62W5VStThoMYYk1UcQt0nzf1T
         itr5KJnyXP+3UOKdvVe40CByAlXK6MoJq0Y0vCto8HrOUYp6c0wKV8ptuxboydk6JDzQ
         7NXcU3O2PGIi6D7AA04ThNgU8Q+V4cdoIqpT1nTPe1WKYFCsNkh1IfEQIcg3EoNQMffZ
         L7gA==
X-Gm-Message-State: APjAAAW+nDq+xJoGIjVpECo7zXbPOZdQ7By3F8jf84VjnkNXWR05N8r0
        Xdo/jKT90Ag2OnRTA/RWuzWRP81i7HAHJNliH7s/czCU
X-Google-Smtp-Source: APXvYqztLm45eAt3vq2lFH1hBtia1GCspBwSJBGHcx4osA7H/mPek2+MfA2xME7mFWnoInUegQV4QTpDoPEbNOQBykk=
X-Received: by 2002:a17:906:3601:: with SMTP id q1mr8131133ejb.276.1579803107275;
 Thu, 23 Jan 2020 10:11:47 -0800 (PST)
MIME-Version: 1.0
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk>
 <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net> <CAMOZA0K-0LOGMXdFecRUHmyoOmOUabsgvzwA35jB-T=5tzV_TA@mail.gmail.com>
 <878slyhx39.fsf@toke.dk>
In-Reply-To: <878slyhx39.fsf@toke.dk>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Thu, 23 Jan 2020 10:11:35 -0800
Message-ID: <CAMOZA0KL1p8ojK2t9hk3RDD35nN+ZuQfAOkodabZ=07p+Z8ucA@mail.gmail.com>
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 10:00 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Luigi Rizzo <lrizzo@google.com> writes:
>
> > On Thu, Jan 23, 2020 at 7:48 AM Daniel Borkmann <daniel@iogearbox.net> =
wrote:
...
> > There was some discussion on multi-segment xdp
> > https://www.spinics.net/lists/netdev/msg620140.html
> > https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-m=
ulti-buffer01-design.org
> >
> > with no clear decision as far as I can tell.
> >
> > I wanted to point out that linearization might be an issue for native
> > xdp as well (specifically with NICs that do header split, LRO,
> > scatter-gather, MTU pagesize ...) and having to unconditionally pay
> > the linearization cost (or disable the above features) by just loading
> > an xdp program may be a big performance hit.
>
> Right, sure, but then I'd rather fix it for all of XDP instead of
> introduce (more) differences between native and generic mode...

FWIW I think the discussion was heading towards 'only pass the first segmen=
t
to the bpf code' with some other mechanism TBD to at least reliably know th=
at
there is more (right now bpf can look at the protocol headers, but of
course they can lie).

Whatever the fix is, it will probably require extending xdp_buff with
extra fields.
I am not sure whether this is considered a stable ABI or one in flux...

cheers
luigi
>
> -Toke
>
