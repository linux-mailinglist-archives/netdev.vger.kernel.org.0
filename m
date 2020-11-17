Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE562B699D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbgKQQNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:13:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727519AbgKQQNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 11:13:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605629588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BVsfR8T15xda2UvQfXxognwTfJY/c2OoSf9W43fPmOU=;
        b=P9a4WBS6D+nbmoLi82bbyVUKwAhN1YZuwshnCGGF1Il221trkpxUV4hdmwm4KuqGLoNrSW
        qDpCgE9pkM5tTp1scVg2DrEI0eLLo/baFOCZeNy1PwOTUaZ32WWU4ppaROkC4zHATvC4hf
        9MtqzpunEUBQxfIQKR1C8xJMEoABEmM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-I2h5SXcZMLSFM8fbYaGRAQ-1; Tue, 17 Nov 2020 11:13:04 -0500
X-MC-Unique: I2h5SXcZMLSFM8fbYaGRAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 644825F9DE;
        Tue, 17 Nov 2020 16:13:01 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A69A85C1D0;
        Tue, 17 Nov 2020 16:12:49 +0000 (UTC)
Date:   Tue, 17 Nov 2020 17:12:48 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Xdp <xdp-newbies@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next 9/9] samples: bpf: remove bpf_load loader
 completely
Message-ID: <20201117171248.465494b7@carbon>
In-Reply-To: <20201117145644.1166255-10-danieltimlee@gmail.com>
References: <20201117145644.1166255-1-danieltimlee@gmail.com>
        <20201117145644.1166255-10-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 14:56:44 +0000
"Daniel T. Lee" <danieltimlee@gmail.com> wrote:

> Numerous refactoring that rewrites BPF programs written with bpf_load
> to use the libbpf loader was finally completed, resulting in BPF
> programs using bpf_load within the kernel being completely no longer
> present.
> 
> This commit removes bpf_load, an outdated bpf loader that is difficult
> to keep up with the latest kernel BPF and causes confusion.
> 
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/bpf_load.c          | 667 --------------------------------
>  samples/bpf/bpf_load.h          |  57 ---
>  samples/bpf/xdp2skb_meta_kern.c |   2 +-
>  3 files changed, 1 insertion(+), 725 deletions(-)
>  delete mode 100644 samples/bpf/bpf_load.c
>  delete mode 100644 samples/bpf/bpf_load.h

I've very happy that we can finally remove this ELF-BPF loader :-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

