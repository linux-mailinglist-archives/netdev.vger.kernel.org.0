Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D1B368592
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238271AbhDVRKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:10:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51742 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238427AbhDVRKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 13:10:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619111402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y5BqwVyFTuRUmMT95k385ZqmCV9Q+o4MykSmzv1VAmo=;
        b=grN1XYhD8DA1nW1gEz//0uJMcU/PNlYConzKv2VQFAhdFZdUKU4B7cqzujLncAw0sZL+93
        AND3HKUT7+e9evJr24NSDMtrc4HOQ7yamNSupAkrxeblyzSVd7JhXiwchFcvtOQDhSJfOb
        /DxkkFb3fDEdjFpiZ2H+BJIo6F3duKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-RJJhQvpENbetK7hBWkDKQw-1; Thu, 22 Apr 2021 13:09:58 -0400
X-MC-Unique: RJJhQvpENbetK7hBWkDKQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A4631922963;
        Thu, 22 Apr 2021 17:09:56 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B10D760938;
        Thu, 22 Apr 2021 17:09:49 +0000 (UTC)
Date:   Thu, 22 Apr 2021 19:09:48 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [PATCH bpf-next v3] bpf: Fix some invalid links in
 bpf_devel_QA.rst
Message-ID: <20210422190948.432c1cab@carbon>
In-Reply-To: <20210422111540.7e37c004@carbon>
References: <1619062560-30483-1-git-send-email-yangtiezhu@loongson.cn>
        <20210422111540.7e37c004@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 11:15:40 +0200
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> On Thu, 22 Apr 2021 11:36:00 +0800
> Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
> 
> > There exist some errors "404 Not Found" when I click the link
> > of "MAINTAINERS" [1], "samples/bpf/" [2] and "selftests" [3]
> > in the documentation "HOWTO interact with BPF subsystem" [4].  
> 
> The links work if you are browsing the document via GitHub:
>  https://github.com/torvalds/linux/blob/master/Documentation/bpf/bpf_devel_QA.rst
> 
> But I'm fine with removing those links as the official doc is here:
>  https://www.kernel.org/doc/html/latest/bpf/bpf_devel_QA.html

IMHO a V4 was not needed.  Let me make it clear by ACKing this patch.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

