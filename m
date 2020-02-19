Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4BA164B64
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 18:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgBSREL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 12:04:11 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22539 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726518AbgBSREK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 12:04:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582131849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=exWL05JayHn5BdhAYdfBEgnxXtLqq4p4qZiCB3GWVIs=;
        b=I4N+v3bFN5r/8eljF+QIf06T3/hI5ZMjS1toJ9ndDZIzx6ULo4ua203lDZwNwOVL6O39Xd
        6/ziSan/RAUmxc/kH126hXAxQgIZM8ag31AQofmmKL2eEXvs+ExV8au4oONKZL58G8EAc9
        OnKMoKJMaLGzeZwajPcHVN5V/WyPOwc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-mWSCxuclNjqLmW2Pn4jUWw-1; Wed, 19 Feb 2020 12:04:03 -0500
X-MC-Unique: mWSCxuclNjqLmW2Pn4jUWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC55C477;
        Wed, 19 Feb 2020 17:03:58 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7285F60BE1;
        Wed, 19 Feb 2020 17:03:50 +0000 (UTC)
Date:   Wed, 19 Feb 2020 18:03:48 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        brouer@redhat.com
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
Message-ID: <20200219180348.40393e28@carbon>
In-Reply-To: <CAADnVQKQRKtDz0Boy=-cudc4eKGXB-yParGZv6qvYcQR4uMUQQ@mail.gmail.com>
References: <20200219133012.7cb6ac9e@carbon>
        <CAADnVQKQRKtDz0Boy=-cudc4eKGXB-yParGZv6qvYcQR4uMUQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 08:41:27 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Wed, Feb 19, 2020 at 4:30 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > I'm willing to help out, such that we can do either version or feature
> > detection, to either skip compiling specific test programs or at least
> > give users a proper warning of they are using a too "old" LLVM version.  
> ...
> > progs/test_core_reloc_bitfields_probed.c:47:13: error: use of unknown builtin '__builtin_preserve_field_info' [-Wimplicit-function-declaration]
> >         out->ub1 = BPF_CORE_READ_BITFIELD_PROBED(in, ub1);  
> 
> imo this is proper warning message already.

This is an error, not a warning.  The build breaks as the make process stops.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

