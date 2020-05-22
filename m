Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B931DF314
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgEVXhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:37:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:54776 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731169AbgEVXhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:37:47 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcHET-0008KF-Su; Sat, 23 May 2020 01:37:41 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcHET-0004aZ-Gb; Sat, 23 May 2020 01:37:41 +0200
Subject: Re: [PATCH bpf 0/2] selftests/bpf: add missing CONFIG values to test
 config
To:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        andriin@fb.com
Cc:     kafai@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        shuah@kernel.org, sean@mess.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <1590147389-26482-1-git-send-email-alan.maguire@oracle.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2f1368e0-c74e-2fd3-430c-4692243e3d63@iogearbox.net>
Date:   Sat, 23 May 2020 01:37:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1590147389-26482-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25820/Fri May 22 14:21:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 1:36 PM, Alan Maguire wrote:
> Selftests "config" file is intended to represent the config required
> to run the tests; a few values are missing for the BPF selftests
> and these can result in test failures due to missing helpers etc.
> Add the missing values as they will help document the config needed
> for a clean BPF selftests run.
> 
> Alan Maguire (2):
>    selftests/bpf: CONFIG_IPV6_SEG6_BPF required for test_seg6_loop.o
>    selftests/bpf: CONFIG_LIRC required for test_lirc_mode2.sh
> 
>   tools/testing/selftests/bpf/config | 2 ++
>   1 file changed, 2 insertions(+)
> 

Applied to bpf-next, thanks!
