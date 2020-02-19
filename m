Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3783164F11
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgBSTkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:40:55 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54311 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726648AbgBSTkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 14:40:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582141254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B2NE/NbXNx0huOaDg+XnsSaVKEiOIkqXx5nv2J9kK4E=;
        b=Cwa3lLhGO3BnjJKganUIC+IxD6fHYAl6SQe/xqKya+zl14oa68JTI8a/PwZtn70RLsWKD2
        b+Nvq6h9h+hdzdtLJl889kaESxmtruFtt0D0xBZpn2b2qKvjO+ygtaAbcsrApM6uLwinmf
        IvOpwNQvrjWRXcpg5mtYRHlZ/q5H2us=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-Ap-53oU3O-CVBm3QmAVMkA-1; Wed, 19 Feb 2020 14:40:51 -0500
X-MC-Unique: Ap-53oU3O-CVBm3QmAVMkA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 684878017CC;
        Wed, 19 Feb 2020 19:40:49 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC73B5DA76;
        Wed, 19 Feb 2020 19:40:40 +0000 (UTC)
Date:   Wed, 19 Feb 2020 20:40:39 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4?= =?UTF-8?B?cmdlbnNlbg==?= 
        <toke@redhat.com>, brouer@redhat.com
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
Message-ID: <20200219204039.121f10d2@carbon>
In-Reply-To: <20200219181250.GA2852230@kroah.com>
References: <20200219133012.7cb6ac9e@carbon>
        <20200219132856.GA2836367@kroah.com>
        <20200219144254.36c3921b@carbon>
        <20200219181250.GA2852230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 19:12:50 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Wed, Feb 19, 2020 at 02:42:54PM +0100, Jesper Dangaard Brouer wrote:
> > On Wed, 19 Feb 2020 14:28:56 +0100
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >   
> > > On Wed, Feb 19, 2020 at 01:30:12PM +0100, Jesper Dangaard Brouer wrote:  
> > > > Hi Andrii,
> > > > 
> > > > Downloaded tarball for kernel release 5.5.4, and I cannot compile
> > > > tools/testing/selftests/bpf/ with latest LLVM release version 9.    
> > > 
[...]
> > > And has llvm 9 always worked here?  
> > 
> > Yes, llvm-9 used to work for tools/testing/selftests/bpf/.  
> 
> As of when?

Kernel v5.4 works when compiling BPF-selftests with LLVM 9.0.1.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

