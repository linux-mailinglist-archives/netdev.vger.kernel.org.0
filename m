Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD8309134E
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfHQVat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:30:49 -0400
Received: from www62.your-server.de ([213.133.104.62]:57066 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfHQVat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:30:49 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hz6He-0001hG-NL; Sat, 17 Aug 2019 23:30:46 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hz6He-000UF7-Ge; Sat, 17 Aug 2019 23:30:46 +0200
Subject: Re: [PATCH bpf-next] libbpf: relicense bpf_helpers.h and bpf_endian.h
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Rostecki <mrostecki@opensuse.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sargun Dhillon <sargun@sargun.me>
References: <20190816054543.2215626-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5f60df0f-9aa2-28b3-700c-6b436a9f996c@iogearbox.net>
Date:   Sat, 17 Aug 2019 23:30:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190816054543.2215626-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25544/Sat Aug 17 10:24:01 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/19 7:45 AM, Andrii Nakryiko wrote:
> bpf_helpers.h and bpf_endian.h contain useful macros and BPF helper
> definitions essential to almost every BPF program. Which makes them
> useful not just for selftests. To be able to expose them as part of
> libbpf, though, we need them to be dual-licensed as LGPL-2.1 OR
> BSD-2-Clause. This patch updates licensing of those two files.
> 
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

Applied, thanks!
