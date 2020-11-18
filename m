Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D1F2B80AB
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 16:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgKRPh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:37:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbgKRPh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 10:37:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605713845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d8sRYGEzSwBuvAF+H53zPFqrxK3fJ+m2Pfzo+FY4+Kw=;
        b=BFWjd9mnkqoLYhcOh1yzaKv5eEFXKnl4IU6QnmiNcKa931nI6vCnklL5uBNufWyoKp4KAS
        hDibrKKLUY4GepPJLqgec34iB9CEXeHRkV4qWvuSFjzqh06Y9zuVgNr0ykbaMaVCCCPawb
        OTDq68AOdxHbBDxlzfkJIVoQifQWNhI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-518-Yt0VGFVoMPSF14_iFirexw-1; Wed, 18 Nov 2020 10:37:21 -0500
X-MC-Unique: Yt0VGFVoMPSF14_iFirexw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F31E219251BB;
        Wed, 18 Nov 2020 15:37:18 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F336E60843;
        Wed, 18 Nov 2020 15:37:11 +0000 (UTC)
Date:   Wed, 18 Nov 2020 16:37:10 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V6 0/7] Series short description
Message-ID: <20201118163710.201853da@carbon>
In-Reply-To: <160571329106.2801162.7380460134461487044.stgit@firesoul>
References: <160571329106.2801162.7380460134461487044.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Sorry, please ignore this email.

(Wrong invocation of stg mail from command line)
--Jesper


On Wed, 18 Nov 2020 16:28:21 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> The following series implements...
> 
> ---
> 
> Jesper Dangaard Brouer (7):
>       bpf: Remove MTU check in __bpf_skb_max_len
>       bpf: fix bpf_fib_lookup helper MTU check for SKB ctx
>       bpf: bpf_fib_lookup return MTU value as output when looked up
>       bpf: add BPF-helper for MTU checking
>       bpf: drop MTU check when doing TC-BPF redirect to ingress
>       bpf: make it possible to identify BPF redirected SKBs
>       selftests/bpf: use bpf_check_mtu in selftest test_cls_redirect
> 
> 
>  .../selftests/bpf/progs/test_cls_redirect.c        |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> --
> Signature

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

