Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC3B23C9F4
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 12:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgHEKf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 06:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbgHEK2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 06:28:32 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DD8C061757;
        Wed,  5 Aug 2020 03:26:52 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f10so66658plj.8;
        Wed, 05 Aug 2020 03:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PcNxBp780rBLK15Q4o9jnC5g02E0z+AA30xIc41WoMg=;
        b=UTGOcJNvle6iiiZKaXZ10pKqPljw3PxLnUWqxXE7C0FvPzxXUaYaBtu1O88729wCJ4
         4Oj5MYJJPf2mn4RM/vsF5PKBqk17LnLTUbXH2ZlGYhMUnfk65c3iNB0HSZBcY7izfWhh
         gOq7NShmkNhYaYkdzzo318C/QN96De/K7a1Ngc9G+512ZUol8tzx/04lMV/qnnXOuVXc
         HnEnMwze47Qaw8NmRAQPbqcXvqNQ5sP2LZtoAh7vz4YYC7QSRzkY3lpI6xkLYIMw9ZRG
         Vd94Trz5dN7/xx/kr8oR376BIIMH28eFgMc9p09icN7q4dr5R/0tIanTI0KslvJCBLGN
         tWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=PcNxBp780rBLK15Q4o9jnC5g02E0z+AA30xIc41WoMg=;
        b=r1nhuqtNSVc66KSgeM0RKKQ+InEquiBkDsVy0h2fO+ow+JJwPe1E8bVGCJtU/RW33p
         MxK6puItbSS9d+bUGShmgxVXilNZZwLv8K3VTcMv41MD62f3YFX3V/rBQRlkechhhoo6
         49QF1K9SmyJdrUUMUUjyTDuUcuwyorC/khQrhu4fmn2McCU4+NNw72idSciLlPvS4B8m
         +CutL2vSoNeR7lDNikYAycRI69jffNjNzFYqnErnu75reS3/vdOVMZ18MhVylcpR3N0n
         wU2LGi14X2gMcRtNwkadUS0f9siSlba9ZsIN9p2KPATG0yA4GaraLr4lecDbiayusz4Z
         kLcQ==
X-Gm-Message-State: AOAM531RFKMAmcsyzeuo0hXiwLs/qSqGFpzrhlUuxyuSMgpZ3D+meR0Y
        p1thYc7qcscj3WJ1Y5qMEa4=
X-Google-Smtp-Source: ABdhPJwW1Ru/I9BiBuKNfXKu41agua8GbaNFmQ7aCVFEfpATwnvFVPHv6sFBeLSrJl6IbM45LagDzg==
X-Received: by 2002:a17:902:7c03:: with SMTP id x3mr2388475pll.178.1596623212033;
        Wed, 05 Aug 2020 03:26:52 -0700 (PDT)
Received: from [192.168.97.34] (p7925058-ipngn38401marunouchi.tokyo.ocn.ne.jp. [122.16.223.58])
        by smtp.gmail.com with ESMTPSA id w64sm3180379pfw.18.2020.08.05.03.26.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2020 03:26:51 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.15\))
Subject: Re: [RFC PATCH bpf-next 0/3] Add a new bpf helper for FDB lookup
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
In-Reply-To: <5f2492aedba05_54fa2b1d9fe285b42d@john-XPS-13-9370.notmuch>
Date:   Wed, 5 Aug 2020 19:26:45 +0900
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
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, bpf@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E2A7CC68-9235-4E97-9532-66D61A6B8965@gmail.com>
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
 <5f2492aedba05_54fa2b1d9fe285b42d@john-XPS-13-9370.notmuch>
To:     John Fastabend <john.fastabend@gmail.com>
X-Mailer: Apple Mail (2.3445.104.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for giving me a lot of comments! Find my response below, please.

> 2020/08/01 6:52=E3=80=81John Fastabend =
<john.fastabend@gmail.com>=E3=81=AE=E3=83=A1=E3=83=BC=E3=83=AB:
>=20
> Yoshiki Komachi wrote:
>> This series adds a new bpf helper for doing FDB lookup in the kernel
>> tables from XDP programs. This helps users to accelerate Linux bridge
>> with XDP.
>>=20
>> In the past, XDP generally required users to reimplement their own
>> networking functionalities with specific manners of BPF programming
>> by themselves, hindering its potential uses. IMO, bpf helpers to
>> access networking stacks in kernel help to mitigate the programming
>> costs because users reuse mature Linux networking feature more =
easily.
>>=20
>> The previous commit 87f5fc7e48dd ("bpf: Provide helper to do =
forwarding
>> lookups in kernel FIB table") have already added a bpf helper for =
access
>> FIB in the kernel tables from XDP programs. As a next step, this =
series
>> introduces the API for FDB lookup. In the future, other bpf helpers =
for
>> learning and VLAN filtering will also be required in order to realize
>> fast XDP-based bridge although these are not included in this series.
>=20
> Just to clarify for myself. I expect that with just the helpers here
> we should only expect static configurations to work, e.g. any learning
> and/or aging is not likely to work if we do redirects in the XDP path.

As you described above, learning and aging don=E2=80=99t work at this =
point.=20

IMO, another helper for learning will be required to fill the =
requirements.
I guess that the helper will enable us to use the aging feature as well
because the aging is the functionality of bridge fdb.

> Then next to get a learning/filtering/aging we would need to have a
> set of bridge helpers to get that functionality as well? I believe
> I'm just repeating what you are saying above, but wanted to check.

As for the vlan filtering, I think it doesn't necessarily have to be =
like that.
I have the following ideas to achieve it for now:

1. Monitoring vlan events in bridges by a userspace daemon and it
   notifies XDP programs of the events through BPF maps
2. Another bpf helper to retrieve bridge vlan information

The additional helper will be required only if the 2nd one is accepted. =
I
would like to discuss which is better because there are pros and cons.


On the other hand, the helper for the learning feature should be added,
IMO. But, I guess that the learning feature is just sufficient to get =
the aging
feature because bridges with learning have capability for aging as well.

> Then my next question is can we see some performance numbers? These
> things are always trade-off between performance and ease of
> use, but would be good to know roughly what we are looking at vs
> a native XDP bridge functionality.

Sorry, I have not measured the performance numbers yet, so I will try it =
later.

> Do you have a use case for a static bridge setup? Nothing wrong to
> stage things IMO if the 'real' use case needs learning and filtering.

For example, it is useful in libvirt with macTableManager. This feature
makes it possible for static bridges to process packets faster than =
other
ones with learning. However, it doesn't work properly if the vlan =
filtering is
not enabled.

> I guess to get STP working you would minimally need learning and
> aging?

I guess that STP seems not to be related to learning and aging, but =
there
may be the following requirements if it is added in the future:

1. BPDU frames are transferred to normal bridges by the XDP_PASS action
2. closing targeted ports based on the STP configurations

To meet the 2nd one, another bpf helper may be required. There is a =
possibility
that bpf maps help to achieve this as another approach.


Thanks & Best regards,

> Thanks,
> John

=E2=80=94
Yoshiki Komachi
komachi.yoshiki@gmail.com

