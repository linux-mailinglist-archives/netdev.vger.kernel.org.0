Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E331413798
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 18:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhIUQdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 12:33:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42133 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229448AbhIUQde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 12:33:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632241925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4FzVI0NgAL+4GbDA10ag57a7YP2ulK19sMtingEyh9g=;
        b=Nm+58HzWrrRMyaQJSAwlJpxBhF77xOUHLzaH7Citw9kiF/6fv9bCR/jOOomJlWYrymDa+g
        e492q5u9w5YCi4XUmkUzer/Lu3rkFmH+5RzyIk9jViuTOaNJMX10l2qd+amw6ajiXhkzhN
        yU+S8fiRWlAMGfq56b1wWNNFxKl9R28=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-DStJG2FmOzm3kPvqT-wuMg-1; Tue, 21 Sep 2021 12:32:04 -0400
X-MC-Unique: DStJG2FmOzm3kPvqT-wuMg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CED9A9126F;
        Tue, 21 Sep 2021 16:32:02 +0000 (UTC)
Received: from localhost (unknown [10.40.194.136])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C16A6D985;
        Tue, 21 Sep 2021 16:32:01 +0000 (UTC)
Date:   Tue, 21 Sep 2021 18:31:59 +0200
From:   Jiri Benc <jbenc@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        William Tu <u9012063@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next] seltests: bpf: test_tunnel: use ip neigh
Message-ID: <20210921183159.596a2662@redhat.com>
In-Reply-To: <2f9554d2-c9c7-5c37-7df0-d011d80d7460@gmail.com>
References: <40f24b9d3f0f53b5c44471b452f9a11f4d13b7af.1632236133.git.jbenc@redhat.com>
        <2f9554d2-c9c7-5c37-7df0-d011d80d7460@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Sep 2021 09:23:06 -0600, David Ahern wrote:
> I realize you are just following suit with this change, but ip can
> change namespaces internally:
> 
> ip -netns at_ns0 neigh add 10.1.1.200 lladdr 52:54:00:d9:02:00 dev $DEV_NS
> 
> All of the 'ip netns exec ... ip ...' commands can be simplified.

I know and I don't like the superfluous exec, either. But that's
something for a different patch. As you said, I'm just following what's
already there. There's ton of different stuff that can be cleaned up in
this and other selftests, unfortunately.

 Jiri

