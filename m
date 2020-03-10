Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3BCF180574
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgCJRuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:50:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56191 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726283AbgCJRuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583862613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fLv6D1QjBvxFfuGZu92WqllciGihMVguSN11W75RFVw=;
        b=VKLXMt6k11lJXUiooraf2l/m6K0KjIWtEoOHEGEG9ShA2dGgUhv5KQZU8Q6Cs4iAVTKe6f
        FyQny9iiATyXwONObBlFchrkguppv/Rbu9xR772Lyz/yKN3AARkqgIrBmab5dMuvbqO9y8
        XYQmjJavWrRFwzKWU6+7uoNk4SKWrTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-yA0Ibyq2OwSgjkuMcUcAvg-1; Tue, 10 Mar 2020 13:50:09 -0400
X-MC-Unique: yA0Ibyq2OwSgjkuMcUcAvg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7BC08010E3;
        Tue, 10 Mar 2020 17:50:07 +0000 (UTC)
Received: from krava (ovpn-204-223.brq.redhat.com [10.40.204.223])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 079848D56A;
        Tue, 10 Mar 2020 17:49:52 +0000 (UTC)
Date:   Tue, 10 Mar 2020 18:49:38 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Julia Kartseva <hex@fb.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "md@linux.it" <md@linux.it>, Cestmir Kalina <ckalina@redhat.com>
Subject: Re: libbpf distro packaging
Message-ID: <20200310174938.GC167617@krava>
References: <040A8497-C388-4B65-9562-6DB95D72BE0F@fb.com>
 <20191008073958.GA10009@krava>
 <AAB8D5C3-807A-4EE3-B57C-C7D53F7E057D@fb.com>
 <20191016100145.GA15580@krava>
 <824912a1-048e-9e95-f6be-fd2b481a8cfc@fb.com>
 <20191220135811.GF17348@krava>
 <c1b6a5b1-bbc8-2186-edcf-4c4780c6f836@fb.com>
 <20200305141812.GH168640@krava>
 <20200310145717.GB167617@krava>
 <8552eef5-5bb8-5298-d0ab-f3c05c73c448@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8552eef5-5bb8-5298-d0ab-f3c05c73c448@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 10:18:12AM -0700, Julia Kartseva wrote:
>=20
>=20
> On 3/10/20 7:57 AM, Jiri Olsa wrote:
> > On Thu, Mar 05, 2020 at 03:18:12PM +0100, Jiri Olsa wrote:
> >=20
> > so I did some more checking and libbpf is automatically pulled into
> > centos 8, it's just at the moment there's some bug preventing that..=20
> > it is going to be fixed shortly ;-)
> >=20
> > as for centos 7, what is the target user there? which version of libb=
pf
> > would you need in there?
> >=20
> > jirka
> >
> Hi, that's great news!
> Nothing prevents us from having the latest v0.0.7 [1] in CentOS 7 :)

that's just half true.. while libbpf is ok, libbpf-devel needs uapi
headers to define all the stuff that's used in libbpf's headers

  Example:
	$ echo "#include <bpf/xsk.h>" | gcc -x c -=20
	In file included from <stdin>:1:
	/usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__needs_wakeup=
=E2=80=99:
	/usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WAKEUP=E2=80=
=99 undeclared (first use in this function)
	   82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
	      |                     ^~~~~~~~~~~~~~~~~~~~
	/usr/include/bpf/xsk.h:82:21: note: each undeclared identifier is report=
ed only once for each function it appears in
	/usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_addr=E2=80=
=99:
	/usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNALIGNED_BUF_ADDR_MA=
SK=E2=80=99 undeclared (first use in this function)
	  173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
	      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
	/usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem__extract_offset=E2=
=80=99:
	/usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNALIGNED_BUF_OFFSET_=
SHIFT=E2=80=99 undeclared (first use in this function)
	  178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT;
	      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I'll need to check the state of rhel7 kernel headers, but that was
very early backport and I think headers are far behind

jirka

> Can updates for CentOS 7 and 8 be synced so the have the same libbpf ve=
rsion?
>=20
> [1] https://github.com/libbpf/libbpf/releases/tag/v0.0.7
>=20

