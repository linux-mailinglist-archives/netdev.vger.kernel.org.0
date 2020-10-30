Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E892A07FB
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 15:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgJ3Ofl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 10:35:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbgJ3Ofl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 10:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604068540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G/uUf4x5jmqoio45UotElBXDDV5Ef+L5uB7zqE76nAQ=;
        b=MB0XzSiBOcao3Sih8lkm5XbwS007u17qZwCLlEDIcuS9P4PFL9MxUBq2gzRoiWhTuo1hIm
        EB29BQ2y4xKnhwiT3+6t/keBkqvN6RdoCnJ0pBTCtGvnxGXCIDME/EBl9vI3H0MVaE8gFg
        4H3GilbMCbfVHzHSsPBLPjJRsu/kdno=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-EDFthimKOPGHh7oFb3zDAg-1; Fri, 30 Oct 2020 10:35:34 -0400
X-MC-Unique: EDFthimKOPGHh7oFb3zDAg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1F788F62C6;
        Fri, 30 Oct 2020 14:35:32 +0000 (UTC)
Received: from carbon (unknown [10.36.110.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E76921002C01;
        Fri, 30 Oct 2020 14:35:22 +0000 (UTC)
Date:   Fri, 30 Oct 2020 15:35:21 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kbuild@lists.01.org, bpf@vger.kernel.org, lkp@intel.com,
        kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next V4 2/5] bpf: bpf_fib_lookup return MTU value as
 output when looked up
Message-ID: <20201030153521.727bfb80@carbon>
In-Reply-To: <20201028124942.GE1042@kadam>
References: <160381601522.1435097.11103677488984953095.stgit@firesoul>
        <20201028124942.GE1042@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 15:49:42 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> New smatch warnings:
> net/core/filter.c:5395 bpf_ipv4_fib_lookup() error: uninitialized symbol 'mtu'.

I will fix and send V5.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

