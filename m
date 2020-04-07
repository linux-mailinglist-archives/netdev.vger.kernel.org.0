Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E00C1A0994
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 10:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgDGIxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 04:53:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20703 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725817AbgDGIxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 04:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586249614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ipYCcCqa2Muib314Zq2hTUsli6+sqi8KPyaPUSKEjE0=;
        b=UOx0R0CKgDUfiYsaqY2Rn1J7kgXOg9pPkOIByZKug47WElfM8fZ8cTur+5hbju94PC1Xxj
        L3xTybi3OR1p7Ojal/tkzIiIaBepf7qeeLt1V6GmcjHZPkAh6nVq9Dy3ocmR9cqb4CUQZJ
        eqWeLK2SazBKZkGRXN8GV09WpTkz+mM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-B5wDdJ3JPQS3VfS56BFJuQ-1; Tue, 07 Apr 2020 04:53:29 -0400
X-MC-Unique: B5wDdJ3JPQS3VfS56BFJuQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 340C88017CE;
        Tue,  7 Apr 2020 08:53:27 +0000 (UTC)
Received: from krava (unknown [10.40.192.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABC2550C01;
        Tue,  7 Apr 2020 08:53:23 +0000 (UTC)
Date:   Tue, 7 Apr 2020 10:53:21 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>, bgregg@netflix.com
Subject: Re: [RFC 0/3] bpf: Add d_path helper
Message-ID: <20200407085321.GA3144092@krava>
References: <20200401110907.2669564-1-jolsa@kernel.org>
 <20200402142106.GF23230@ZenIV.linux.org.uk>
 <20200403090828.GF2784502@krava>
 <20200406031602.GR23230@ZenIV.linux.org.uk>
 <20200406090918.GA3035739@krava>
 <20200407011052.khtujfdamjtwvpdp@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407011052.khtujfdamjtwvpdp@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 06, 2020 at 06:10:52PM -0700, Alexei Starovoitov wrote:
> On Mon, Apr 06, 2020 at 11:09:18AM +0200, Jiri Olsa wrote:
> > 
> > is there any way we could have d_path functionality (even
> > reduced and not working for all cases) that could be used
> > or called like that?
> 
> I agree with Al. This helper cannot be enabled for all of bpf tracing.
> We have to white list its usage for specific callsites only.
> May be all of lsm hooks are safe. I don't know yet. This has to be
> analyzed carefully. Every hook. One by one.
> in_task() isn't really a solution.

ok, I thought of white list and it seemed too much to me,
but there's probably no other way

jirka

> 
> At the same time I agree that such helper is badly needed.
> Folks have been requesting it for long time.
> 

