Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B58904A9
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 17:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfHPP3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 11:29:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:38210 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbfHPP3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 11:29:45 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hyeAS-0000J3-L6; Fri, 16 Aug 2019 17:29:28 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hyeAS-000SI0-EK; Fri, 16 Aug 2019 17:29:28 +0200
Subject: Re: [PATCH bpf-next] libbpf: relicense bpf_helpers.h and bpf_endian.h
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Rostecki <mrostecki@opensuse.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sargun Dhillon <sargun@sargun.me>
References: <20190816054543.2215626-1-andriin@fb.com>
 <20190816141001.4a879101@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <23a87525-acf5-7a7e-b7b6-3c47b9760eeb@iogearbox.net>
Date:   Fri, 16 Aug 2019 17:29:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190816141001.4a879101@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25543/Fri Aug 16 10:23:13 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/19 2:10 PM, Jesper Dangaard Brouer wrote:
> On Thu, 15 Aug 2019 22:45:43 -0700
> Andrii Nakryiko <andriin@fb.com> wrote:
> 
>> bpf_helpers.h and bpf_endian.h contain useful macros and BPF helper
>> definitions essential to almost every BPF program. Which makes them
>> useful not just for selftests. To be able to expose them as part of
>> libbpf, though, we need them to be dual-licensed as LGPL-2.1 OR
>> BSD-2-Clause. This patch updates licensing of those two files.
> 
> I've already ACKed this, and is fine with (LGPL-2.1 OR BSD-2-Clause).
> 
> I just want to understand, why "BSD-2-Clause" and not "Apache-2.0" ?
> 
> The original argument was that this needed to be compatible with
> "Apache-2.0", then why not simply add this in the "OR" ?

It's use is discouraged in the kernel tree, see also LICENSES/dual/Apache-2.0 (below) and
statement wrt compatibility from https://www.apache.org/licenses/GPL-compatibility.html:

   Valid-License-Identifier: Apache-2.0
   SPDX-URL: https://spdx.org/licenses/Apache-2.0.html
   Usage-Guide:
     Do NOT use. The Apache-2.0 is not GPL2 compatible. [...]

>> Acked-by: Alexei Starovoitov <ast@kernel.org>
>> Acked-by: Hechao Li <hechaol@fb.com>
>> Acked-by: Martin KaFai Lau <kafai@fb.com>
>> Acked-by: Andrey Ignatov <rdna@fb.com>
>> Acked-by: Yonghong Song <yhs@fb.com>
>> Acked-by: Lawrence Brakmo <brakmo@fb.com>
>> Acked-by: Adam Barth <arb@fb.com>
>> Acked-by: Roman Gushchin <guro@fb.com>
>> Acked-by: Josef Bacik <jbacik@fb.com>
>> Acked-by: Joe Stringer <joe@wand.net.nz>
>> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
>> Acked-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>> Acked-by: David Ahern <dsahern@gmail.com>
>> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> Confirming I acked this.
> 
>> Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
>> Acked-by: Lorenz Bauer <lmb@cloudflare.com>
>> Acked-by: Adrian Ratiu <adrian.ratiu@collabora.com>
>> Acked-by: Nikita V. Shirokov <tehnerd@tehnerd.com>
>> Acked-by: Willem de Bruijn <willemb@google.com>
>> Acked-by: Petar Penkov <ppenkov@google.com>
>> Acked-by: Teng Qin <palmtenor@gmail.com>
>> Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
>> Cc: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Michal Rostecki <mrostecki@opensuse.org>
>> Cc: John Fastabend <john.fastabend@gmail.com>
>> Cc: Sargun Dhillon <sargun@sargun.me>
>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> ---
>>   tools/testing/selftests/bpf/bpf_endian.h  | 2 +-
>>   tools/testing/selftests/bpf/bpf_helpers.h | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/bpf_endian.h b/tools/testing/selftests/bpf/bpf_endian.h
>> index 05f036df8a4c..ff3593b0ae03 100644
>> --- a/tools/testing/selftests/bpf/bpf_endian.h
>> +++ b/tools/testing/selftests/bpf/bpf_endian.h
>> @@ -1,4 +1,4 @@
>> -/* SPDX-License-Identifier: GPL-2.0 */
>> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
>>   #ifndef __BPF_ENDIAN__
>>   #define __BPF_ENDIAN__
>>   
>> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
>> index 8b503ea142f0..6c4930bc6e2e 100644
>> --- a/tools/testing/selftests/bpf/bpf_helpers.h
>> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
>> @@ -1,4 +1,4 @@
>> -/* SPDX-License-Identifier: GPL-2.0 */
>> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
>>   #ifndef __BPF_HELPERS_H
>>   #define __BPF_HELPERS_H
>>   
> 
> 
> 

