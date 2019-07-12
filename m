Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3318B67063
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 15:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbfGLNoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 09:44:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:57056 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727271AbfGLNoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 09:44:12 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvqJ-00011k-76; Fri, 12 Jul 2019 15:44:07 +0200
Received: from [2a02:1205:5069:fce0:c5f9:cd68:79d4:446d] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hlvqJ-000Ia2-0Z; Fri, 12 Jul 2019 15:44:07 +0200
Subject: Re: [PATCH v4 bpf-next 0/4] selftests/bpf: fix compiling
 loop{1,2,3}.c on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Y Song <ys114321@gmail.com>, davem@davemloft.net,
        ast@kernel.org
References: <20190711142930.68809-1-iii@linux.ibm.com>
 <20190711203508.GC16709@mini-arch>
 <994CF53F-3E84-4CE8-92C5-B2983AD50EB8@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2e6eabde-b584-5241-5368-d2ba58cb482f@iogearbox.net>
Date:   Fri, 12 Jul 2019 15:44:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <994CF53F-3E84-4CE8-92C5-B2983AD50EB8@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25508/Fri Jul 12 10:10:04 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/12/2019 10:55 AM, Ilya Leoshkevich wrote:
>> Am 11.07.2019 um 22:35 schrieb Stanislav Fomichev <sdf@fomichev.me>:
>>
>> On 07/11, Ilya Leoshkevich wrote:
>>> Use PT_REGS_RC(ctx) instead of ctx->rax, which is not present on s390.
>>>
>>> This patch series consists of three preparatory commits, which make it
>>> possible to use PT_REGS_RC in BPF selftests, followed by the actual fix.
>>>
>> Still looks good to me, thanks!
>>
>> Reviewed-by: Stanislav Fomichev <sdf@google.com>
>>
>> Again, should probably go via bpf to fix the existing tests, not bpf-next
>> (but I see bpf tree is not synced with net tree yet).
> 
> Sorry, I missed your comment the last time. You are right - that’s the
> reason I’ve been sending this to bpf-next so far — loop*.c don’t even
> exist in the bpf tree.

Applied to bpf tree (and also added Stanislav's Tested-by to the last
one), thanks!
