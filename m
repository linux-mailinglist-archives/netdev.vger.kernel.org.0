Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4803929261
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389325AbfEXIFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:05:21 -0400
Received: from www62.your-server.de ([213.133.104.62]:58360 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388959AbfEXIFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:05:21 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hU5CU-0007EH-Fq; Fri, 24 May 2019 10:05:14 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hU5CU-0005lH-8C; Fri, 24 May 2019 10:05:14 +0200
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: optimize explored_states
To:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20190522031707.2834254-1-ast@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7182029c-f789-5856-551e-e991d13a129c@iogearbox.net>
Date:   Fri, 24 May 2019 10:05:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190522031707.2834254-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25458/Thu May 23 09:58:32 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/22/2019 05:17 AM, Alexei Starovoitov wrote:
> Convert explored_states array into hash table and use simple hash to
> reduce verifier peak memory consumption for programs with bpf2bpf calls.
> More details in patch 3.
> 
> v1->v2: fixed Jakub's small nit in patch 1
> 
> Alexei Starovoitov (3):
>   bpf: cleanup explored_states
>   bpf: split explored_states
>   bpf: convert explored_states to hash table
> 
>  include/linux/bpf_verifier.h |  2 +
>  kernel/bpf/verifier.c        | 77 ++++++++++++++++++++++--------------
>  2 files changed, 50 insertions(+), 29 deletions(-)
> 

Applied, thanks!
