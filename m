Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA739E6C8
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhFGSo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:44:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230322AbhFGSoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 14:44:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623091351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DtLeDx9IxGvg3tiYe5/5l5JBVFtcLEyFoylGCJoC6BU=;
        b=Bo21uWiMyuO1xcCXcBSnK6c+szJgIvhzaovhWJ7HROQgcn4V0wgLdxL+lM5NkU59ZhdqM2
        duK3PsdQZsXr25hjXbZ+ebG0asXVREWbXTi2GO3glYx8TG0C4PwQYZs/fezR8W7gugL2T7
        Tgy/0JsuObQTwTMIN8cYfSC+Z+yHQD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-PlG4BwxZNoSK9QLgdnGk9A-1; Mon, 07 Jun 2021 14:42:27 -0400
X-MC-Unique: PlG4BwxZNoSK9QLgdnGk9A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B147102CB86;
        Mon,  7 Jun 2021 18:42:25 +0000 (UTC)
Received: from krava (unknown [10.40.192.167])
        by smtp.corp.redhat.com (Postfix) with SMTP id D74015C1D1;
        Mon,  7 Jun 2021 18:42:22 +0000 (UTC)
Date:   Mon, 7 Jun 2021 20:42:21 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 16/19] selftests/bpf: Add fentry multi func test
Message-ID: <YL5ojaBnlhLIPXIz@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-17-jolsa@kernel.org>
 <1f3946e8-24eb-6804-e06f-8c97f5145fb7@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f3946e8-24eb-6804-e06f-8c97f5145fb7@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 06, 2021 at 11:06:14PM -0700, Yonghong Song wrote:
> 
> 
> On 6/5/21 4:10 AM, Jiri Olsa wrote:
> > Adding selftest for fentry multi func test that attaches
> > to bpf_fentry_test* functions and checks argument values
> > based on the processed function.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   tools/testing/selftests/bpf/multi_check.h     | 52 +++++++++++++++++++
> 
> Should we put this file under selftests/bpf/progs directory?
> It is included only by bpf programs.

ok

jirka

