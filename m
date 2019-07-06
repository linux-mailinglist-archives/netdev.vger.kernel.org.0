Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76337612C1
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 21:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfGFTAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 15:00:36 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35912 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726743AbfGFTAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 15:00:35 -0400
Received: by mail-io1-f65.google.com with SMTP id o9so10443039iom.3
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 12:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=t4g0Ot5nO3b0oZ80HFYhNovlAUiDmHNptUC+ENhO6x8=;
        b=vKlVHlGgPV904jUiGHdoizM7x06qpGL7BAoSjUfLjoa4IppMDL2GEdAxFIYPD7291+
         c62tPslyTcGjMx+SEgQKG6xwF8e569lLdY3hCVaN9NhVKArmvwsns5UABA5CxJ2E31ET
         uJERVikGKVoLEh0xKJ6bh6yQKyKIXj23Vq+1PK0GPAYT/YJu6tBjWAUGiUnuLIHmy1jy
         Qx+Nf9RJFNL2KIsQp6bvBYTFzdPbQ7o3LTWTigeSSF2R9Q8jw5eaRWyx7gZD1vbK02q6
         A1A/diPZHJFvPFME5126TKFoweM2gv9qKfU7fvbBjYbMJlCs/NwQKatkdRXZ1nkMU8Q9
         VfOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t4g0Ot5nO3b0oZ80HFYhNovlAUiDmHNptUC+ENhO6x8=;
        b=ERc0KQRRcLHh0OKn5ZRsn2gHRS4RyC38fWcEttLx41HzCTi2nOCS/ukeLouF4e4eU4
         o+R1E6UsIN++54dB9mwq7bKVspF/OqY/uxREoAVPIuC1wCGREgntPxAwztNSpnbfM/jN
         saTBnR4argC6NPZTfUtTz8ucqdQ9Jacgr9LX5EAiwbJiOkBBlicIe1LYrwHdwDdHO0yl
         s0R0sDJIw0o+plHQxZclFscH9MCgOwI+LGNRqbg95ANBiaED23D5EUKkr3gvXb8zMxF4
         z2U1dm5rg0b33yPHCh9skXGq26ChmTkcrF2NbBLsZb/X606elaBmdkOcI1L1Q3uz5CvJ
         mgPw==
X-Gm-Message-State: APjAAAUbO//QL7eIJIMDLKSWsKwa/ENf1FLBM/q2t+cTAV3E1u6AavJL
        kYUTTPt5KsfTcrnNai/QO7U/2mr0wf4aVEPl4co=
X-Google-Smtp-Source: APXvYqxwR3RMfxbuij2WUbc5eBVDSnJtCRGbGy+pqdLM+NokNehGvUjN29BW1NBa6BlAwxdA+UtuMetqoAAQrjWUPZo=
X-Received: by 2002:a6b:bf01:: with SMTP id p1mr10180536iof.181.1562439634934;
 Sat, 06 Jul 2019 12:00:34 -0700 (PDT)
MIME-Version: 1.0
References: <156240283550.10171.1727292671613975908.stgit@alrua-x1> <156240283571.10171.11997723639222073086.stgit@alrua-x1>
In-Reply-To: <156240283571.10171.11997723639222073086.stgit@alrua-x1>
From:   Y Song <ys114321@gmail.com>
Date:   Sat, 6 Jul 2019 11:59:59 -0700
Message-ID: <CAH3MdRX8ED3rb_sJQ5XKV+0Z0ihs7sj4-cL3upEJkGd6G2r+ow@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/6] include/bpf.h: Remove map_insert_ctx() stubs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 6, 2019 at 1:47 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> When we changed the device and CPU maps to use linked lists instead of
> bitmaps, we also removed the need for the map_insert_ctx() helpers to kee=
p
> track of the bitmaps inside each map. However, it seems I forgot to remov=
e
> the function definitions stubs, so remove those here.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
