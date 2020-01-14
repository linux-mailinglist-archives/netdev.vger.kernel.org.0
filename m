Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4B4913B247
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 19:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgANSml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 13:42:41 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48246 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726491AbgANSml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 13:42:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579027360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e8VOWN53+8eVp/ukk8x+fivpg8/VfPu0j809WuoSnQQ=;
        b=iMFejeAHX/jWZSqndQVVlrv56BXZ7+Yn7qgl22Qw9cyZdbGEFC8gHBf8mogRcYZEjl3Fhf
        V2YyBRkCC+if0UESOvTBxtAMI0WxSpmGhc0fYsc8qKCJUCWCS1JeSofyNnXTmSKF1aUnQC
        FuFPmlLFjf6oNHqqo9OVrW/h9CXR+Ok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-dPR6MkefOo6kGNvC0J2U_w-1; Tue, 14 Jan 2020 13:42:37 -0500
X-MC-Unique: dPR6MkefOo6kGNvC0J2U_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B6AC1800D78;
        Tue, 14 Jan 2020 18:42:35 +0000 (UTC)
Received: from krava (ovpn-204-61.brq.redhat.com [10.40.204.61])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FF1160BE2;
        Tue, 14 Jan 2020 18:42:33 +0000 (UTC)
Date:   Tue, 14 Jan 2020 19:42:30 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 5/6] tools/bpf: add runqslower tool to
 tools/bpf
Message-ID: <20200114184230.GA204154@krava>
References: <20200113073143.1779940-1-andriin@fb.com>
 <20200113073143.1779940-6-andriin@fb.com>
 <20200114132208.GC170376@krava>
 <d13fff52-e262-aadf-25cb-7166cb334be5@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d13fff52-e262-aadf-25cb-7166cb334be5@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 05:25:42PM +0000, Alexei Starovoitov wrote:
> On 1/14/20 5:22 AM, Jiri Olsa wrote:
> > On Sun, Jan 12, 2020 at 11:31:42PM -0800, Andrii Nakryiko wrote:
> > 
> > SNIP
> > 
> >> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
> >> new file mode 100644
> >> index 000000000000..f1363ae8e473
> >> --- /dev/null
> >> +++ b/tools/bpf/runqslower/Makefile
> >> @@ -0,0 +1,80 @@
> >> +# SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> >> +OUTPUT := .output
> >> +CLANG := clang
> >> +LLC := llc
> >> +LLVM_STRIP := llvm-strip
> >> +DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
> >> +BPFTOOL ?= $(DEFAULT_BPFTOOL)
> >> +LIBBPF_SRC := $(abspath ../../lib/bpf)
> >> +CFLAGS := -g -Wall
> >> +
> >> +# Try to detect best kernel BTF source
> >> +KERNEL_REL := $(shell uname -r)
> >> +ifneq ("$(wildcard /sys/kenerl/btf/vmlinux)","")
> > 
> > s/kenerl/kernel/
> 
> eagle eye!
> I fixed up in the tree. Thanks!

nah my eyes are screwed.. compilation failed for me ;-)

jirka

