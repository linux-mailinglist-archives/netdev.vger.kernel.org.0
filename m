Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1172123E8E9
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 10:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgHGIaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 04:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgHGIaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 04:30:24 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36F8C061574;
        Fri,  7 Aug 2020 01:30:24 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id i92so5918135pje.0;
        Fri, 07 Aug 2020 01:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=EVtHDL3zK/M7ogfJLTnbqUj/+R1pnCu3LmpkYrXn7WI=;
        b=Us1H8RGxl87Uo//uGLeMoVDoUUO7W76DnC/ipQAIIFV8i6WnVTplLysjyIoSaotcVm
         BinZfOIVf1SRbwpyuGfHnCC2LizudABFRJX3N/GbgqBZtjeXnKFzd9bp1NUfEkfmSDD3
         484fJybh/iCN6DzYi3W3P6RgJTGDrpTair67iLqu6WU6aZOG3llDGadYM2ik0OS9xXTg
         o2ro+Txb4QQutHAp564nZWJId0a8eq35hIKo6/bilITKuDiWYMpcA8xN7ccHTPJgzbYV
         omIq5Wbf2uOdQsV5oqHHgzPYhYsYKJnUZNZuYBxIOGMpNGMbHXTP+Z5H3B64Sj3Eofdk
         benw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=EVtHDL3zK/M7ogfJLTnbqUj/+R1pnCu3LmpkYrXn7WI=;
        b=qUzdQDngPUU7epxDd07zFoyof+rPhPaYLclKpuCwh2W9il+0plNWpOTIG3M36xGDJX
         UQfcvFrZXXp0CWGUJFCDr3E3S9vclBmLqVmrN8GKve7LjfuzibhBAiIMbkl/kTxLMziV
         hlCZrFhmOpq8qQzBHYWRoPeQXRyBX/s8qLsUm9PoruegJyZElCdSmOdMjyarWGAIq3kY
         9p2q2+hnUJCXchV+HvyobleIiO/8z0Nnsmk0sIotbVzYHUn44z6Jfv4TEjoofCOBUjDO
         leo/PHi0M64tlC4X5E6YBfw3X+UWjLH23gTBVqwf/Qt3aIOT9xQ5h8n9DmqI/egpOfeo
         HfHw==
X-Gm-Message-State: AOAM5303kYHKOWcRHGxNh5ScxJT+GhsFcBUBvYgT1Nj0Zms/xToxJ3nl
        Yw+TKTy7HLfQxfOupIMd4Jg=
X-Google-Smtp-Source: ABdhPJz5ThbGz5vV2hquuWQrvlmTQ+agJ5HdSfWVCMQTldu98q9WqTSO342EMngzNRtjvHt46p9kXQ==
X-Received: by 2002:a17:902:8b85:: with SMTP id ay5mr10806177plb.162.1596789024095;
        Fri, 07 Aug 2020 01:30:24 -0700 (PDT)
Received: from [192.168.97.34] (p7925058-ipngn38401marunouchi.tokyo.ocn.ne.jp. [122.16.223.58])
        by smtp.gmail.com with ESMTPSA id x66sm10585855pgb.12.2020.08.07.01.30.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Aug 2020 01:30:23 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.15\))
Subject: Re: [RFC PATCH bpf-next 0/3] Add a new bpf helper for FDB lookup
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
In-Reply-To: <8eda2f23-f526-bd56-b6ac-0d7ae82444b5@gmail.com>
Date:   Fri, 7 Aug 2020 17:30:16 +0900
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org, bpf <bpf@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <901DF60C-F4DD-4125-80D6-128C1764424F@gmail.com>
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
 <5f2492aedba05_54fa2b1d9fe285b42d@john-XPS-13-9370.notmuch>
 <E2A7CC68-9235-4E97-9532-66D61A6B8965@gmail.com>
 <8eda2f23-f526-bd56-b6ac-0d7ae82444b5@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
X-Mailer: Apple Mail (2.3445.104.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 2020/08/06 1:36=E3=80=81David Ahern <dsahern@gmail.com>=E3=81=AE=E3=83=A1=
=E3=83=BC=E3=83=AB:
>=20
> On 8/5/20 4:26 AM, Yoshiki Komachi wrote:
>>>=20
>>> Just to clarify for myself. I expect that with just the helpers here
>>> we should only expect static configurations to work, e.g. any =
learning
>>> and/or aging is not likely to work if we do redirects in the XDP =
path.
>>=20
>> As you described above, learning and aging don=E2=80=99t work at this =
point.=20
>>=20
>> IMO, another helper for learning will be required to fill the =
requirements.
>> I guess that the helper will enable us to use the aging feature as =
well
>> because the aging is the functionality of bridge fdb.
>=20
> One option is to have a flag that bumps the ageing on successful =
lookup
> and do that in 1 call. You will already have access to the fdb entry.

It seems like a good idea to me! I guess that the flags in my suggested =
bpf
helper for the FDB lookup will be useful for such a case.

Thanks & Best regards,

=E2=80=94
Yoshiki Komachi
komachi.yoshiki@gmail.com

