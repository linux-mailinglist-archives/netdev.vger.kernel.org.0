Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D4E3269C9
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 23:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhBZWBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 17:01:52 -0500
Received: from www62.your-server.de ([213.133.104.62]:32992 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhBZWBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 17:01:51 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lFlAT-000Bk4-Sb; Fri, 26 Feb 2021 23:01:01 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lFlAT-000ElV-NZ; Fri, 26 Feb 2021 23:01:01 +0100
Subject: Re: [PATCH 0/2] More strict error checking in bpf_asm (v3).
To:     Ian Denhardt <ian@zenhack.net>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
References: <cover.1614201868.git.ian@zenhack.net>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <251d8abe-04ff-a49e-d818-cc7b6ba5e647@iogearbox.net>
Date:   Fri, 26 Feb 2021 23:00:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <cover.1614201868.git.ian@zenhack.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26092/Fri Feb 26 13:12:59 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/21 10:24 PM, Ian Denhardt wrote:
> Gah, managed to typo my own name in the v2 patch >.<
> 
> This one should be good :/
> 
> Ian Denhardt (2):
>    tools, bpf_asm: Hard error on out of range jumps.
>    tools, bpf_asm: exit non-zero on errors.
> 
>   tools/bpf/bpf_exp.y | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)

Applied, thanks!
