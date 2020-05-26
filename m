Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AD71E312E
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390002AbgEZV1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:27:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:46678 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388967AbgEZV1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:27:42 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdh6q-0001C1-Ez; Tue, 26 May 2020 23:27:40 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdh6q-0005q6-7s; Tue, 26 May 2020 23:27:40 +0200
Subject: Re: [iproute2 PATCH 0/2] Fix segfault in lib/bpf.c
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, jhs@mojatatu.com
References: <cover.1590508215.git.aclaudi@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0bd0af64-678f-0b71-821e-07044c9905dc@iogearbox.net>
Date:   Tue, 26 May 2020 23:27:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <cover.1590508215.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25824/Tue May 26 14:27:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 6:04 PM, Andrea Claudi wrote:
> Jamal reported a segfault in bpf_make_custom_path() when custom pinning is
> used. This is caused by commit c0325b06382cb ("bpf: replace snprintf with
> asprintf when dealing with long buffers").
> 
> As the only goal of that commit is to get rid of a truncation warning when
> compiling lib/bpf.c, revert it and fix the warning checking for snprintf
> return value
> 
> Andrea Claudi (2):
>    Revert "bpf: replace snprintf with asprintf when dealing with long
>      buffers"
>    bpf: Fixes a snprintf truncation warning
> 
>   lib/bpf.c | 155 +++++++++++++++---------------------------------------
>   1 file changed, 41 insertions(+), 114 deletions(-)
> 

Thanks for following up, Andrea! For the two:

Acked-by: Daniel Borkmann <daniel@iogearbox.net>
