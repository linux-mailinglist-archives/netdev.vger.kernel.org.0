Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 908541842AE
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 09:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgCMIcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 04:32:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51727 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726310AbgCMIcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 04:32:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584088324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KIQbNGiFmwMgwORtPcHBOl+vGwafENPhGJxxDNhVz7k=;
        b=DEc3ixN6h14jXH1cRUGune2Ute5B85kWLfPM3S3RAAXDokHtTn0dMk9lEPyEJyvz5NUyIU
        IkzJ4R0yqDMN172lXZz11ZjSGXT1uGZ7gDXhjMj9jDn9aWVZrtRKbGbLLRVp93dTn+fVe6
        YApYa8fHXPR7S8dmurXPn5jSTV4vtNU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-pzRmYGXuNLSH8-MGYXpB0Q-1; Fri, 13 Mar 2020 04:32:00 -0400
X-MC-Unique: pzRmYGXuNLSH8-MGYXpB0Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3BB8100550E;
        Fri, 13 Mar 2020 08:31:57 +0000 (UTC)
Received: from krava (ovpn-205-229.brq.redhat.com [10.40.205.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ECE631001B09;
        Fri, 13 Mar 2020 08:31:53 +0000 (UTC)
Date:   Fri, 13 Mar 2020 09:31:51 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCHv5 00/15] bpf: Add trampoline and dispatcher to
 /proc/kallsyms
Message-ID: <20200313083151.GA386262@krava>
References: <20200312195610.346362-1-jolsa@kernel.org>
 <20200313023927.ejv6aubwzjht55cf@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313023927.ejv6aubwzjht55cf@ast-mbp>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 07:39:27PM -0700, Alexei Starovoitov wrote:
> On Thu, Mar 12, 2020 at 08:55:55PM +0100, Jiri Olsa wrote:
> > hi,
> > this patchset adds trampoline and dispatcher objects
> > to be visible in /proc/kallsyms. The last patch also
> > adds sorting for all bpf objects in /proc/kallsyms.
> 
> I removed second sentence from the cover letter and
> applied the first 12 patches.
> Thanks a lot!
> 
> > For perf tool to properly display trampoline/dispatcher you need
> > also Arnaldo's perf/urgent branch changes. I merged everything
> > into following branch:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git bpf/kallsyms
> 
> It sounds that you folks want to land the last three patches via Arnaldo's tree
> to avoid conflicts?
> Right?

right, thanks

jirka

