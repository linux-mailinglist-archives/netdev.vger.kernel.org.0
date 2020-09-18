Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D0127091B
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 01:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgIRXQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 19:16:41 -0400
Received: from www62.your-server.de ([213.133.104.62]:49704 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgIRXQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 19:16:41 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 19:16:40 EDT
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kJPcN-0005nG-7C; Sat, 19 Sep 2020 01:16:39 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kJPcN-000KpJ-1d; Sat, 19 Sep 2020 01:16:39 +0200
Subject: Re: [PATCH bpf-next] bpf: Use hlist_add_head_rcu when linking to
 local_storage
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200916204453.2003915-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3f7a37d5-33cc-1ad5-15a0-10be42a8c8ea@iogearbox.net>
Date:   Sat, 19 Sep 2020 01:16:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200916204453.2003915-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25932/Fri Sep 18 15:48:08 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/20 10:44 PM, Martin KaFai Lau wrote:
> The local_storage->list will be traversed by rcu reader in parallel.
> Thus, hlist_add_head_rcu() is needed in bpf_selem_link_storage_nolock().
> This patch fixes it.
> 
> This part of the code has recently been refactored in bpf-next
> and this patch makes changes to the new file "bpf_local_storage.c".
> Instead of using the original offending commit in the Fixes tag,
> the commit that created the file "bpf_local_storage.c" is used.
> 
> A separate fix has been provided to the bpf tree.
> 
> Fixes: 450af8d0f6be ("bpf: Split bpf_local_storage to bpf_sk_storage")
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Applied, thanks!
