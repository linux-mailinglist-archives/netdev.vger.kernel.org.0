Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A8BCFDA6
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfJHP34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:29:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfJHP34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 11:29:56 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8499E7E426;
        Tue,  8 Oct 2019 15:29:56 +0000 (UTC)
Received: from localhost (ovpn-204-214.brq.redhat.com [10.40.204.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5821A62A7B;
        Tue,  8 Oct 2019 15:29:53 +0000 (UTC)
Date:   Tue, 8 Oct 2019 17:29:51 +0200
From:   Jiri Benc <jbenc@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move
 bpf_{helpers,endian,tracing}.h into libbpf
Message-ID: <20191008172951.468ecf33@redhat.com>
In-Reply-To: <20191004113026.4c23cd41@cakuba.hsd1.ca.comcast.net>
References: <20191003212856.1222735-1-andriin@fb.com>
        <20191003212856.1222735-6-andriin@fb.com>
        <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com>
        <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
        <4fcbe7bf-201a-727a-a6f1-2088aea82a33@gmail.com>
        <CAEf4BzZr9cxt=JrGYPUhDTRfbBocM18tFFaP+LiJSCF-g4hs2w@mail.gmail.com>
        <20191004113026.4c23cd41@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 08 Oct 2019 15:29:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Oct 2019 11:30:26 -0700, Jakub Kicinski wrote:
> Surely for distroes tho - they would have kernel headers matching the
> kernel release they ship. If parts of libbpf from GH only work with
> the latest kernel, distroes should ship libbpf from the kernel source,
> rather than GH.

I don't see a problem here for distros. Distros control both the kernel
and libbpf, there's no problem in keeping those in sync.

Packaging libbpf from the kernel source would not help anything -
updating libbpf would still require a new kernel. There's no difference
between updating libbpf from a github repo or from the kernel source,
as far as dependencies are concerned.

 Jiri
