Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBB12B8073
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 16:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgKRP2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:28:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20122 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbgKRP2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 10:28:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605713313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=q3a4BtFcx5O8RJ6/ReVxaOLvpbyGa2oBL+Tx0jBvhz4=;
        b=TFiklLAIF0P1SDGUGQ0HvrRhL8xIgDCGp65WrH0yLaXf1RBesjtVz9cyERGtWzBlMvuKJh
        ENHBhWfGEYR9zyf018mIbhdGrtaQCl7Jx6N5IK227E/HA5LiqgIpYi7HTMYD8GbN7hnSTB
        DDKIWVrSyZ2fvr2+tMZwTdgfN1CCDHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-JfbrFiriMXqf_qWMYit05A-1; Wed, 18 Nov 2020 10:28:29 -0500
X-MC-Unique: JfbrFiriMXqf_qWMYit05A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC42110866AD;
        Wed, 18 Nov 2020 15:28:26 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 249A960843;
        Wed, 18 Nov 2020 15:28:23 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id C694932138454;
        Wed, 18 Nov 2020 16:28:21 +0100 (CET)
Subject: [PATCH bpf-next V6 0/7] Series short description
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Date:   Wed, 18 Nov 2020 16:28:21 +0100
Message-ID: <160571329106.2801162.7380460134461487044.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following series implements...

---

Jesper Dangaard Brouer (7):
      bpf: Remove MTU check in __bpf_skb_max_len
      bpf: fix bpf_fib_lookup helper MTU check for SKB ctx
      bpf: bpf_fib_lookup return MTU value as output when looked up
      bpf: add BPF-helper for MTU checking
      bpf: drop MTU check when doing TC-BPF redirect to ingress
      bpf: make it possible to identify BPF redirected SKBs
      selftests/bpf: use bpf_check_mtu in selftest test_cls_redirect


 .../selftests/bpf/progs/test_cls_redirect.c        |    7 +++++++
 1 file changed, 7 insertions(+)

--
Signature

