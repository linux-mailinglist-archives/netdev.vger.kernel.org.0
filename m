Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C035C5D545
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 19:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfGBR36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 13:29:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbfGBR36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 13:29:58 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 00D44882F2;
        Tue,  2 Jul 2019 17:29:58 +0000 (UTC)
Received: from localhost (unknown [10.40.205.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EAD687C4;
        Tue,  2 Jul 2019 17:29:55 +0000 (UTC)
Date:   Tue, 2 Jul 2019 19:29:53 +0200
From:   Jiri Benc <jbenc@redhat.com>
To:     Y Song <ys114321@gmail.com>
Cc:     Song Liu <liu.song.a23@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: fix inlines in test_lwt_seg6local
Message-ID: <20190702192953.3fa9ccb5@redhat.com>
In-Reply-To: <CAH3MdRUbkswKAYiDSmhe9cdd-Jd=YmC0_PSLhzfY7vKv-zxCCA@mail.gmail.com>
References: <4fdda0547f90e96bd2ef5d5533ee286b02dd4ce2.1561819374.git.jbenc@redhat.com>
        <CAPhsuW4ncpfNCvbYHF36pb6ZEBJMX-iJP5sD0x3PbmAds+WGOQ@mail.gmail.com>
        <CAPhsuW4Ric_nMGxpKf3mEJw3JDBZYpbeAQwTW_Nrsz79T2zisw@mail.gmail.com>
        <CAH3MdRUbkswKAYiDSmhe9cdd-Jd=YmC0_PSLhzfY7vKv-zxCCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 02 Jul 2019 17:29:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Jul 2019 11:39:27 -0700, Y Song wrote:
> By default, we have
> # define __always_inline        inline __attribute__((always_inline))
> 
> So just use __always_inline should be less verbose in your patch.

I'll resubmit, converting everything to __always_inline, targeting
bpf-next.

> BTW, what compiler did you use have this behavior?

clang version 7.0.1 (tags/RELEASE_701/final)
LLVM version 7.0.1

> Did you have issues with `static __attribute__((always_inline))`?

That seems to work, too.

 Jiri
