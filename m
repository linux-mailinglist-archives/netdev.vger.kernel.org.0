Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26539368580
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238067AbhDVRIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:08:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236058AbhDVRIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 13:08:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619111283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6iyRCQCEGRHHV6y2IaFBtD9oS6jvBRER/Lqe7zRME5s=;
        b=B1yUmck2TA1dXqKJZSr38kU7bP+UzneSZfvOYBPzUUnJVsR92wrHpFXak3U3/mRl9mpX3x
        Ir4IOAzQqIubha0rLcEE8dXXwBITKPR84Bd0Qqi7RAjmxkg4lHF1z4yFeysBJ88DptuHP4
        6sXHe7IswAN2beKpyDHyiupCCPb+Ujo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-2ey14UIJOzuK4QqUFlPTBw-1; Thu, 22 Apr 2021 13:08:01 -0400
X-MC-Unique: 2ey14UIJOzuK4QqUFlPTBw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBB80A40C1;
        Thu, 22 Apr 2021 17:07:58 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE4F25C27C;
        Thu, 22 Apr 2021 17:07:51 +0000 (UTC)
Date:   Thu, 22 Apr 2021 19:07:50 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xuefeng Li <lixuefeng@loongson.cn>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next v4] bpf: Fix some invalid links in
 bpf_devel_QA.rst
Message-ID: <20210422190750.7273292c@carbon>
In-Reply-To: <87pmymcofa.fsf@meer.lwn.net>
References: <1619089790-6252-1-git-send-email-yangtiezhu@loongson.cn>
        <87pmymcofa.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 09:46:33 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> Tiezhu Yang <yangtiezhu@loongson.cn> writes:
> 
> > There exist some errors "404 Not Found" when I click the link
> > of "MAINTAINERS" [1], "samples/bpf/" [2] and "selftests" [3]
> > in the documentation "HOWTO interact with BPF subsystem" [4].
> >
> > As Jesper Dangaard Brouer said, the links work if you are browsing
> > the document via GitHub [5], so I think maybe it is better to use
> > the corresponding GitHub links to fix the issues in the kernel.org
> > official document [4], this change has no influence on GitHub and
> > looks like more clear.  
> 
> No, we really don't want to link to GitHub, that's what we have
> kernel.org for.

I fully agree.
I actually liked V3 better.

Back when I wrote the documentation with these links, the BPF doc was
not well integrated with the kernels doc-system.  It is today, so it
makes sense to remove the links (that happens to work on GitHub) as you
did in V3.

Today BPF documentation is nicely organized via this link:
 https://www.kernel.org/doc/html/latest/bpf/index.html

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

