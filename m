Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601B331F52E
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 07:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbhBSGiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 01:38:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229527AbhBSGiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 01:38:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613716610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p1RfEAeGKb9uq3M2z3rc/88HPaOSEdpp2SelzD3YUHE=;
        b=Y7GUf+UlRp/4aklTevUuChQlDjfbS2oDMVFAzLaGOwoQjd69JT8ARZGhWGm7VvtooB2AL3
        idHA6xCd7lsX094kDGfZ0iePrkMRAaueGuJiG1M9fcGOyWOwh5HYBRD1WrPOYA4vYbZA/I
        k8VfjV8zZ92q3jNqwPsh3v8X0dp3sqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-REyFH-bMNMmH6VcX0n3nuA-1; Fri, 19 Feb 2021 01:36:46 -0500
X-MC-Unique: REyFH-bMNMmH6VcX0n3nuA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D36C81E567;
        Fri, 19 Feb 2021 06:36:44 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42BB76F7E6;
        Fri, 19 Feb 2021 06:36:40 +0000 (UTC)
Date:   Fri, 19 Feb 2021 07:36:38 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next V2 0/2] bpf: Updates for BPF-helper
 bpf_check_mtu
Message-ID: <20210219073638.75b3d8f3@carbon>
In-Reply-To: <161364896576.1250213.8059418482723660876.stgit@firesoul>
References: <161364896576.1250213.8059418482723660876.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Feb 2021 12:49:53 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> The FIB lookup example[1] show how the IP-header field tot_len
> (iph->tot_len) is used as input to perform the MTU check. The recently
> added MTU check helper bpf_check_mtu() should also support this type
> of MTU check.
> 
> Lets add this feature before merge window, please. This is a followup
> to 34b2021cc616 ("bpf: Add BPF-helper for MTU checking").

Which git tree should I send this against bpf-next or bpf, to keep this
change together with 34b2021cc616 ("bpf: Add BPF-helper for MTU
checking") ?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

