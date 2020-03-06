Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D3D17B8B2
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 09:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgCFIwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 03:52:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37796 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726866AbgCFIwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 03:52:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583484728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wp2roWgLdqWzyepKSe0THPInKjX5W7pwk7INZWXYWgk=;
        b=eLYZ2+37MxtOmiAaGuOUt1pX6o7IagZ3iweWsr4RpJcr0yFt+j3qkXI031DyDqb2+QRKd8
        UnHdidA7weomqub6zH/6xz6bVD4nfxK5xdMZhxbIF7/pGujh9sgBwuCPROt9WRAHtkyowU
        WxZqe5HwOSNGo9bTOVfT58fK2EiebbM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-5v3qxgsVMTCiqaiV7xKwHQ-1; Fri, 06 Mar 2020 03:52:05 -0500
X-MC-Unique: 5v3qxgsVMTCiqaiV7xKwHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFAC8801E70;
        Fri,  6 Mar 2020 08:52:03 +0000 (UTC)
Received: from krava (ovpn-205-205.brq.redhat.com [10.40.205.205])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 965C590779;
        Fri,  6 Mar 2020 08:52:01 +0000 (UTC)
Date:   Fri, 6 Mar 2020 09:51:58 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "quentin@isovalent.com" <quentin@isovalent.com>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
Message-ID: <20200306085158.GC248782@krava>
References: <20200304180710.2677695-1-songliubraving@fb.com>
 <20200304190807.GA168640@krava>
 <20200304204158.GD168640@krava>
 <C7C4E8E1-9176-48DC-8089-D4AEDE86E720@fb.com>
 <20200304212931.GE168640@krava>
 <4C0824FE-37CB-4660-BAE0-0EAE8F6BF8A0@fb.com>
 <8855C490-F3E3-4FEB-B59E-C529667BDC30@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8855C490-F3E3-4FEB-B59E-C529667BDC30@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 08:03:53PM +0000, Song Liu wrote:

SNIP

> >> 	prog.c:1650:29: error: =E2=80=98struct profiler_bpf=E2=80=99 has no=
 member named =E2=80=98rodata=E2=80=99
> >> 	 1650 |  __u32 m, cpu, num_cpu =3D obj->rodata->num_cpu;
> >> 	      |                             ^~
> >> 	prog.c: In function =E2=80=98profile_open_perf_events=E2=80=99:
> >> 	prog.c:1810:19: error: =E2=80=98struct profiler_bpf=E2=80=99 has no=
 member named =E2=80=98rodata=E2=80=99
> >> 	 1810 |   sizeof(int), obj->rodata->num_cpu * obj->rodata->num_metr=
ic);
> >> 	      |                   ^~
> >> 	prog.c:1810:42: error: =E2=80=98struct profiler_bpf=E2=80=99 has no=
 member named =E2=80=98rodata=E2=80=99
> >> 	 1810 |   sizeof(int), obj->rodata->num_cpu * obj->rodata->num_metr=
ic);
> >> 	      |                                          ^~
> >> 	prog.c:1825:26: error: =E2=80=98struct profiler_bpf=E2=80=99 has no=
 member named =E2=80=98rodata=E2=80=99
> >> 	 1825 |   for (cpu =3D 0; cpu < obj->rodata->num_cpu; cpu++) {
> >> 	      |                          ^~
> >> 	prog.c: In function =E2=80=98do_profile=E2=80=99:
> >> 	prog.c:1904:13: error: =E2=80=98struct profiler_bpf=E2=80=99 has no=
 member named =E2=80=98rodata=E2=80=99
> >> 	 1904 |  profile_obj->rodata->num_cpu =3D num_cpu;
> >> 	      |             ^~
> >> 	prog.c:1905:13: error: =E2=80=98struct profiler_bpf=E2=80=99 has no=
 member named =E2=80=98rodata=E2=80=99
> >> 	 1905 |  profile_obj->rodata->num_metric =3D num_metric;
> >> 	      |             ^~
> >> 	make: *** [Makefile:129: prog.o] Error 1
> >=20
> > I guess you need a newer version of clang that supports global data i=
n BPF programs.=20
>=20
> Hi Jiri,
>=20
> Have you got chance to test this with latest clang?=20

yep, got it compiled with new clang

I was testing in on bpftrace programs and couldn't made it work,
because it relies on BTF info.. so I got stuck ;-)

  # bpftool prog profile id 241 duration 3 cycles instructions llc_misses
  Error: prog FD 3 doesn't have valid btf

nit.. ^^^ you could display ID instead of FD in here

I need to check if we can provide BTF info for bpftrace programs

jirka

