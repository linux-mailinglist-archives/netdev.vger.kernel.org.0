Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A58B1642B7
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbgBSKym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:54:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45232 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbgBSKyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 05:54:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582109681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PauumciWQeMsaVAq7AsvZUadieEbxMADpQ3r9+NupQ8=;
        b=UKfsxQlKKEGxB14GkBx5+K6LhxYAT0lrkQ0q5uDypKCESdbnVhsZArKZP9BpXxFVPyxTyD
        1ijANRyKPfX/PO5OhRtJlQSr74p9CofbwTXYp1v1djobpy064UNotuhoXAib857FKSzRfD
        +T5iRT4CaVqA7XI1aPb3QceUYtwcsTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-vXBSodOxM72P_Chen0DNHQ-1; Wed, 19 Feb 2020 05:54:39 -0500
X-MC-Unique: vXBSodOxM72P_Chen0DNHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BC7E1336562;
        Wed, 19 Feb 2020 10:54:37 +0000 (UTC)
Received: from [10.36.116.231] (ovpn-116-231.ams2.redhat.com [10.36.116.231])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 647E589F3B;
        Wed, 19 Feb 2020 10:54:32 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, "Song Liu" <songliubraving@fb.com>,
        "Yonghong Song" <yhs@fb.com>, "Andrii Nakryiko" <andriin@fb.com>,
        "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Subject: Re: [PATCH bpf-next v4 3/3] selftests/bpf: update xdp_bpf2bpf test to
 use new set_attach_target API
Date:   Wed, 19 Feb 2020 11:54:30 +0100
Message-ID: <C9BBE2C5-E7ED-465C-98B5-1476B9B475A9@redhat.com>
In-Reply-To: <CAEf4BzYx2ZccrAu8JC=UxeHamk4dHKVa2jH4P=Hr7VzMwUphJQ@mail.gmail.com>
References: <158194337246.104074.6407151818088717541.stgit@xdp-tutorial>
 <158194342478.104074.6851588870108514192.stgit@xdp-tutorial>
 <CAEf4BzYx2ZccrAu8JC=UxeHamk4dHKVa2jH4P=Hr7VzMwUphJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18 Feb 2020, at 22:21, Andrii Nakryiko wrote:

> On Mon, Feb 17, 2020 at 5:03 AM Eelco Chaudron <echaudro@redhat.com> wr=
ote:
>>
>> Use the new bpf_program__set_attach_target() API in the xdp_bpf2bpf
>> selftest so it can be referenced as an example on how to use it.
>>
>>
>
> nit: extra empty line?

ACK <SNIP>
>> +       prog =3D *ftrace_skel->skeleton->progs[0].prog;
>
> it took me a while to understand what's going on here... :) You are
> not supposed to peek into ftrace_skel->skeleton, it's an "internal"
> object that's passed into libbpf.
>
> It's better to write it as a nice and short:
>
> prog =3D ftrace_skel->progs.trace_on_entry;
>

Will change in next rev=E2=80=A6

