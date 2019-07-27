Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80BA0775F5
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 04:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfG0C03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 22:26:29 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34836 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbfG0C03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 22:26:29 -0400
Received: by mail-lj1-f194.google.com with SMTP id x25so53307154ljh.2
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 19:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XYP54evcAQPtaPZ45o4xXH5uEXuIUHWPLF4WP7inYdY=;
        b=S1G6Cz0SNGWpusdp/lB3FKY3XpLK/3VOja4VIOHq7xV8q7bIh52J8beBojezVf2UDe
         DxMy3eYom842NMxKbSfC8XhLtZF3grxW+/5H24nQFTLE8w3rNWDFKecPECEstYEvPRX8
         4m1hpSiSqHKj5lxE2NvhNLOn3NLa6fYTEi3Ld9LXSQ0Ep9KE2gVg35uYSV3ZHih2MLxl
         LISUlA3DwGKXxnZOriS4GEe6D9E6j3hnn3m7ZlYiiGM5cNkjo8FegS1cuYtOwdoQfNHl
         BgoscRnhlIHXTJp+f/cRrvqoi2la22YPQibAZiGfLOZu2BzNrKgbZJX10gfS7ctTf/Ly
         5bDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XYP54evcAQPtaPZ45o4xXH5uEXuIUHWPLF4WP7inYdY=;
        b=H8g0n/CLSDt1Ir2tISwBISFk2M3gplWGMjeuPwIBNMBU1ezixv2Lhb+7r2v5pxdc4J
         NxBCnRtUe2pDi+nEPsULDEYrHzTohv5oJlMdy+PHJL0rzDr4TELar49K+TZfj16ssBcw
         DNWQnbuHxuzQJnETwAsw6xSXiZSzlY+k/Ht7VJmX2AMbxcpB4vHjfPBP6aqSFcUG+jQ6
         6elT4g/vt/96VLJqNex4hhybD4OTo9s5o0GeWrOAcQBFro0C3Iv9uaNeQpCQPQul7dVY
         ozsZg6LwrvEHC3ERUC9IY9k4kR5qHrnnpGd7dsqGyXztddGSSMIpwSIVtrBhKz7SW56L
         fu+g==
X-Gm-Message-State: APjAAAWJikg8aE6IX9UC+TbWW4QHo5ldBzg+e0PifPwlDByT5MsqfoP+
        NG/pv3jQe/NAfb+0j+YbqN/v0kPQKf+moNWVuus=
X-Google-Smtp-Source: APXvYqxzA+FviKKCBfQg0+vkB8f+JvXBn8S4Hqv55fPfjhohnwu1olbZEs2NmFWGNbN3mMncglvpRFNLkmkretRqYPc=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr23871196ljc.210.1564194387779;
 Fri, 26 Jul 2019 19:26:27 -0700 (PDT)
MIME-Version: 1.0
References: <156415721066.13581.737309854787645225.stgit@alrua-x1>
In-Reply-To: <156415721066.13581.737309854787645225.stgit@alrua-x1>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 26 Jul 2019 19:26:16 -0700
Message-ID: <CAADnVQJpYeQ68V5BE2r3BhbraBh7G8dSd8zknFUJxtW4GwNkuA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/6] xdp: Add devmap_hash map type
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> This series adds a new map type, devmap_hash, that works like the existin=
g
> devmap type, but using a hash-based indexing scheme. This is useful for t=
he use
> case where a devmap is indexed by ifindex (for instance for use with the =
routing
> table lookup helper). For this use case, the regular devmap needs to be s=
ized
> after the maximum ifindex number, not the number of devices in it. A hash=
-based
> indexing scheme makes it possible to size the map after the number of dev=
ices it
> should contain instead.
>
> This was previously part of my patch series that also turned the regular
> bpf_redirect() helper into a map-based one; for this series I just pulled=
 out
> the patches that introduced the new map type.
>
> Changelog:
>
> v5:
>
> - Dynamically set the number of hash buckets by rounding up max_entries t=
o the
>   nearest power of two (mirroring the regular hashmap), as suggested by J=
esper.

fyi I'm waiting for Jesper to review this new version.
