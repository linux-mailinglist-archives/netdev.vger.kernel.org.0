Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC881D909E
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 09:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgESHBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 03:01:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42024 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726881AbgESHBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 03:01:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589871697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yf2My6h6KwN48RRp5ClQBSdmf3dz99WGO2io9IXtB38=;
        b=QgxDGdUNzquX8vP5SjPnRenAuOyrZKAxDw1LCvwxutlVeJ974CWOnKvoC+UCVjIzcCAjrJ
        GgvaaO17N3paY3JplMgwWaVrR2M1N5Nqji0btJTWJa3SVgnrjmWgbUp5bP7v+iKAVwPjE/
        HVfnwksYz+mXDXWUVD8Gq8GPH63Jx/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-zRwkP1ITMhOccJptVVvoTg-1; Tue, 19 May 2020 03:01:34 -0400
X-MC-Unique: zRwkP1ITMhOccJptVVvoTg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB91DEC1A4;
        Tue, 19 May 2020 07:01:32 +0000 (UTC)
Received: from carbon (unknown [10.40.208.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 268905C1BB;
        Tue, 19 May 2020 07:01:26 +0000 (UTC)
Date:   Tue, 19 May 2020 09:01:25 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next] selftest/bpf: make bpf_iter selftest
 compilable against old vmlinux.h
Message-ID: <20200519090125.2612b00c@carbon>
In-Reply-To: <6633a04c-aab4-5182-2bed-28b235436932@fb.com>
References: <20200518234516.3915052-1-andriin@fb.com>
        <6633a04c-aab4-5182-2bed-28b235436932@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 May 2020 18:42:24 -0700
Yonghong Song <yhs@fb.com> wrote:

> On 5/18/20 4:45 PM, Andrii Nakryiko wrote:
> > It's good to be able to compile bpf_iter selftest even on systems that don't
> > have the very latest vmlinux.h, e.g., for libbpf tests against older kernels in
> > Travis CI. To that extent, re-define bpf_iter_meta and corresponding bpf_iter
> > context structs in each selftest. To avoid type clashes with vmlinux.h, rename
> > vmlinux.h's definitions to get them out of the way.
> > 
> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>  
> 
> Acked-by: Yonghong Song <yhs@fb.com>

Thanks for looking into this Andrii :-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

