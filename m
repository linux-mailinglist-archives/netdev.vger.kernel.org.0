Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 967F99011E
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 14:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfHPMKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 08:10:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56322 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbfHPMKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 08:10:16 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1964825CCB;
        Fri, 16 Aug 2019 12:10:16 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DA721001B28;
        Fri, 16 Aug 2019 12:10:03 +0000 (UTC)
Date:   Fri, 16 Aug 2019 14:10:01 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     brouer@redhat.com, <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Rostecki <mrostecki@opensuse.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sargun Dhillon <sargun@sargun.me>
Subject: Re: [PATCH bpf-next] libbpf: relicense bpf_helpers.h and
 bpf_endian.h
Message-ID: <20190816141001.4a879101@carbon>
In-Reply-To: <20190816054543.2215626-1-andriin@fb.com>
References: <20190816054543.2215626-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 16 Aug 2019 12:10:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Aug 2019 22:45:43 -0700
Andrii Nakryiko <andriin@fb.com> wrote:

> bpf_helpers.h and bpf_endian.h contain useful macros and BPF helper
> definitions essential to almost every BPF program. Which makes them
> useful not just for selftests. To be able to expose them as part of
> libbpf, though, we need them to be dual-licensed as LGPL-2.1 OR
> BSD-2-Clause. This patch updates licensing of those two files.

I've already ACKed this, and is fine with (LGPL-2.1 OR BSD-2-Clause).

I just want to understand, why "BSD-2-Clause" and not "Apache-2.0" ?

The original argument was that this needed to be compatible with
"Apache-2.0", then why not simply add this in the "OR" ?

> Acked-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Hechao Li <hechaol@fb.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Acked-by: Andrey Ignatov <rdna@fb.com>
> Acked-by: Yonghong Song <yhs@fb.com>
> Acked-by: Lawrence Brakmo <brakmo@fb.com>
> Acked-by: Adam Barth <arb@fb.com>
> Acked-by: Roman Gushchin <guro@fb.com>
> Acked-by: Josef Bacik <jbacik@fb.com>
> Acked-by: Joe Stringer <joe@wand.net.nz>
> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> Acked-by: David Ahern <dsahern@gmail.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Confirming I acked this.

> Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
> Acked-by: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: Adrian Ratiu <adrian.ratiu@collabora.com>
> Acked-by: Nikita V. Shirokov <tehnerd@tehnerd.com>
> Acked-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Petar Penkov <ppenkov@google.com>
> Acked-by: Teng Qin <palmtenor@gmail.com>
> Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Michal Rostecki <mrostecki@opensuse.org>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Sargun Dhillon <sargun@sargun.me>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/bpf_endian.h  | 2 +-
>  tools/testing/selftests/bpf/bpf_helpers.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/bpf_endian.h b/tools/testing/selftests/bpf/bpf_endian.h
> index 05f036df8a4c..ff3593b0ae03 100644
> --- a/tools/testing/selftests/bpf/bpf_endian.h
> +++ b/tools/testing/selftests/bpf/bpf_endian.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
>  #ifndef __BPF_ENDIAN__
>  #define __BPF_ENDIAN__
>  
> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> index 8b503ea142f0..6c4930bc6e2e 100644
> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> @@ -1,4 +1,4 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
>  #ifndef __BPF_HELPERS_H
>  #define __BPF_HELPERS_H
>  



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
