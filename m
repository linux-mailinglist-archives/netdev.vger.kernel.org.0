Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A33814CE5A
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 17:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgA2QYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 11:24:37 -0500
Received: from www62.your-server.de ([213.133.104.62]:46164 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgA2QYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 11:24:37 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iwq8n-0005t7-Ih; Wed, 29 Jan 2020 17:24:33 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iwq8n-000LxS-AT; Wed, 29 Jan 2020 17:24:33 +0100
Subject: Re: [PATCH bpf] bpf: Reuse log from btf_prase_vmlinux() in
 btf_struct_ops_init()
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200127175145.1154438-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <50acd550-4451-b40d-e50f-a3b2f894fcfa@iogearbox.net>
Date:   Wed, 29 Jan 2020 17:24:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200127175145.1154438-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25710/Wed Jan 29 12:38:38 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/20 6:51 PM, Martin KaFai Lau wrote:
> Instead of using a locally defined "struct bpf_verifier_log log = {}",
> btf_struct_ops_init() should reuse the "log" from its calling
> function "btf_parse_vmlinux()".  It should also resolve the
> frame-size too large compiler warning in some ARCH.
> 
> Fixes: 27ae7997a661 ("bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied, thanks!
