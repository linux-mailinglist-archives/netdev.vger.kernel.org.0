Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A2B1C3512
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgEDI5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:57:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36907 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728165AbgEDI5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:57:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588582638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2pT6P62tfr+l7qGJkPdDkRAwCMWh+RIvavExV9R+IBM=;
        b=cvnt3iodoiw5intJyxiZXYAHtM0DHnMXVCnJONeTXcdpkv2XYcTS9duAUzUZslYhj5lueL
        6QSO6qsyy0O8HVTPevtKCfuxvIpQdkj2KfHw6bdoVm2Px0CHiqbWXKvgZAM5dyq26txzmj
        WRfzchN6J5RaVnGfNB7xhvA/iXTj3VU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-pYvvuqa5PaKmDXmyOedVhA-1; Mon, 04 May 2020 04:57:15 -0400
X-MC-Unique: pYvvuqa5PaKmDXmyOedVhA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16B6E800687;
        Mon,  4 May 2020 08:57:13 +0000 (UTC)
Received: from [10.36.113.160] (ovpn-113-160.ams2.redhat.com [10.36.113.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DCA360CCC;
        Mon,  4 May 2020 08:57:08 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, "Song Liu" <songliubraving@fb.com>,
        "Yonghong Song" <yhs@fb.com>, "Andrii Nakryiko" <andriin@fb.com>,
        "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Subject: Re: [PATCH bpf-next] libbpf: fix probe code to return EPERM if
 encountered
Date:   Mon, 04 May 2020 10:57:06 +0200
Message-ID: <6E5513F5-0ACC-42C1-B6B2-0F73D3675859@redhat.com>
In-Reply-To: <CAEf4BzZScS-vRtiy2H6KgOHiq_xbhrNYVMtsD2Tn7Q4y1ssg4w@mail.gmail.com>
References: <158824221003.2338.9700507405752328930.stgit@ebuild>
 <CAEf4BzYeJxGuPC8rbsY5yvED8KNaq=7NULFPnwPdeEs==Srd1w@mail.gmail.com>
 <5E1C3675-7D77-4A58-B2FD-CE92806DA363@redhat.com>
 <CAEf4BzZScS-vRtiy2H6KgOHiq_xbhrNYVMtsD2Tn7Q4y1ssg4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1 May 2020, at 21:16, Andrii Nakryiko wrote:

> On Fri, May 1, 2020 at 2:56 AM Eelco Chaudron <echaudro@redhat.com> wro=
te:
<SNIP>
>>
>> Let me know, and I sent out a v2.
>
> Yes, that's the split I had in mind, but I'd move
> bpf_object__probe_loading() call directly into bpf_object__load() to
> be the first thing to check. probe_caps() should still be non-failing
> if any feature is missing. Does it make sense?

I think I got it :) I=E2=80=99ll send out a v2 soon=E2=80=A6

//Eelco

