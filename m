Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717C2CFDBC
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfJHPhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfJHPhO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 11:37:14 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E09F63082E72;
        Tue,  8 Oct 2019 15:37:13 +0000 (UTC)
Received: from localhost (ovpn-204-214.brq.redhat.com [10.40.204.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BDE419C69;
        Tue,  8 Oct 2019 15:37:11 +0000 (UTC)
Date:   Tue, 8 Oct 2019 17:37:09 +0200
From:   Jiri Benc <jbenc@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move
 bpf_{helpers,endian,tracing}.h into libbpf
Message-ID: <20191008173709.07da56ef@redhat.com>
In-Reply-To: <62b1bc6b-8c8a-b766-6bfc-2fb16017d591@fb.com>
References: <20191003212856.1222735-1-andriin@fb.com>
        <20191003212856.1222735-6-andriin@fb.com>
        <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com>
        <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
        <4fcbe7bf-201a-727a-a6f1-2088aea82a33@gmail.com>
        <CAEf4BzZr9cxt=JrGYPUhDTRfbBocM18tFFaP+LiJSCF-g4hs2w@mail.gmail.com>
        <20191004113026.4c23cd41@cakuba.hsd1.ca.comcast.net>
        <62b1bc6b-8c8a-b766-6bfc-2fb16017d591@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 08 Oct 2019 15:37:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Oct 2019 18:37:44 +0000, Yonghong Song wrote:
> distro can package bpf/btf uapi headers into libbpf package.
> Users linking with libbpf.a/libbpf.so can use bpf/btf.h with include
> path pointing to libbpf dev package include directory.
> Could this work?

I don't think it would. Distros have often a policy against bundling
files that are available from one package (in this case, kernel-headers
or similar) in a different package (libbpf).

The correct way is making the libbpf package depend on a particular
version of kernel-headers (or newer). As I said, I don't see a problem
here. It's not a special situation, it's just usual dependencies.

 Jiri
