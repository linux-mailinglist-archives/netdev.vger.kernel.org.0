Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4881DF312
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387445AbgEVXhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:37:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:54646 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387436AbgEVXhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:37:10 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcHDq-0008IE-T6; Sat, 23 May 2020 01:37:02 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcHDq-0002cR-G7; Sat, 23 May 2020 01:37:02 +0200
Subject: Re: [PATCH] selftests/bpf: add general instructions for test
 execution
To:     Alan Maguire <alan.maguire@oracle.com>, corbet@lwn.net,
        ast@kernel.org, andriin@fb.com
Cc:     kafai@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        shuah@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <1590146674-25485-1-git-send-email-alan.maguire@oracle.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5618d86a-ced6-b564-0eab-abcebdd08d12@iogearbox.net>
Date:   Sat, 23 May 2020 01:37:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1590146674-25485-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25820/Fri May 22 14:21:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 1:24 PM, Alan Maguire wrote:
> Getting a clean BPF selftests run involves ensuring latest trunk LLVM/clang
> are used, pahole is recent (>=1.16) and config matches the specified
> config file as closely as possible.  Add to bpf_devel_QA.rst and point
> tools/testing/selftests/bpf/README.rst to it.
> 
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
