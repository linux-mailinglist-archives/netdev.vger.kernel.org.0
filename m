Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534BA2B8E50
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 10:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgKSI4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:56:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726182AbgKSI4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:56:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605776211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vq3O3HAFMM+KXB0NQbPEly52EXAERcRYAp8E1PAbV2c=;
        b=ZtPWrQPDAp1Ty4aGiEcr42vHpouvXD96oV9I5dW9PeIh8HDIbh5B2Txi8/OrKVqzS8stF5
        8uY5/cTzGhAY1O2MjHl4llYs06Qg12t3bramhM5sGNzsRHlJ0iQKc2C+HhCTDB+x02jCs1
        6f60WNl5Ita6cDKvAi8oXoB8RSPuga0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-J2SJ9_3bOYmgBdfywSdSKw-1; Thu, 19 Nov 2020 03:56:49 -0500
X-MC-Unique: J2SJ9_3bOYmgBdfywSdSKw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4A51107AFDD;
        Thu, 19 Nov 2020 08:56:47 +0000 (UTC)
Received: from localhost (unknown [10.40.194.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2152B60843;
        Thu, 19 Nov 2020 08:56:38 +0000 (UTC)
Date:   Thu, 19 Nov 2020 09:56:36 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        daniel@iogearbox.net, ast@fb.com, andrii@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, brouer@redhat.com,
        haliu@redhat.com, dsahern@gmail.com
Subject: Re: [PATCH bpf-next] libbpf: Add libbpf_version() function to get
 library version at runtime
Message-ID: <20201119095636.67c5b7ec@redhat.com>
In-Reply-To: <20201118174325.zjomd2gvybof6awa@ast-mbp>
References: <20201118170738.324226-1-toke@redhat.com>
        <20201118174325.zjomd2gvybof6awa@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 09:43:25 -0800, Alexei Starovoitov wrote:
> Just like the kernel doesn't add features for out-of-tree modules
> libbpf doesn't add features for projects where libbpf is optional.

A more fitting comparison would be the kernel refusing to add a new
uAPI call because some application refuses to bundle the kernel.
A libbpf equivalent of a kernel module would be some kind of libbpf
plugin (which does not exist), asking for an internal libbpf API to be
added.

Alexei, could you please start cooperating with others and actually
listening to others' needs? I know you started eBPF but you're not the
only user anymore and as much convinced you may be about your view,
people have reasons for what they're doing. It would help greatly if
you could listen to these reasons.

 Jiri

