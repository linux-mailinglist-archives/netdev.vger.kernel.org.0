Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3FD2A913D
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 09:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgKFI0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 03:26:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725616AbgKFI0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 03:26:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604651193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mkFQ/W1yb5r2YxANjqBFVzA9ucvkdKw8AkZKE33pGcA=;
        b=cCAREOE2WJdc5wkVdZKu4N6lp6FVKBVc9uxFT0anWbABYpZdWHdQRZq5dUhk3dg6NN74No
        42xEse3uFXzyg4FsAaMAHsoO3NvcXiwd6ClX0FQ3VDk6JwpWT90NFVvwGTM9b/9IgbS0SY
        asXkerzBRC08pv7C6rYcu0JMKBuLLWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-KJ3Iy4-YOzuNzc4KtbKgMQ-1; Fri, 06 Nov 2020 03:26:29 -0500
X-MC-Unique: KJ3Iy4-YOzuNzc4KtbKgMQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6E6A5F9D2;
        Fri,  6 Nov 2020 08:26:27 +0000 (UTC)
Received: from localhost (unknown [10.40.193.217])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 455A360BF3;
        Fri,  6 Nov 2020 08:26:26 +0000 (UTC)
Date:   Fri, 6 Nov 2020 09:26:24 +0100
From:   Jiri Benc <jbenc@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next] bpf: make verifier log more relevant by
 default
Message-ID: <20201106092624.5b0487e1@redhat.com>
In-Reply-To: <CAEf4Bzb7r-9TEAnQC3gwiwX52JJJuoRd_ZHrkGviiuFKvy8qJg@mail.gmail.com>
References: <20200423195850.1259827-1-andriin@fb.com>
        <20201105170202.5bb47fef@redhat.com>
        <CAEf4Bzb7r-9TEAnQC3gwiwX52JJJuoRd_ZHrkGviiuFKvy8qJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 13:22:12 -0800, Andrii Nakryiko wrote:
> test_progs is the only test runner that's run continuously on every
> patch. libbpf CI also runs test_maps and test_verifier. All the other
> test binaries/scripts rely on humans to not forget about them. Which
> works so-so, as you can see :)

Did not know that, thanks for the explanation.

Would be good to add full testing to some of the numerous CIs we have
(some taker? :-)).

 Jiri

