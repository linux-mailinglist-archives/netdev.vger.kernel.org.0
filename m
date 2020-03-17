Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDECA188D80
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 19:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgCQS45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 14:56:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:59752 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgCQS45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 14:56:57 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEHOZ-0001vg-SC; Tue, 17 Mar 2020 19:56:55 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jEHOZ-0008LS-K6; Tue, 17 Mar 2020 19:56:55 +0100
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: fix nanosleep for real this
 time
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200314002743.3782677-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <621281d6-8eb6-79f2-7672-4647e875019e@iogearbox.net>
Date:   Tue, 17 Mar 2020 19:56:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200314002743.3782677-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25754/Tue Mar 17 14:09:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/20 1:27 AM, Andrii Nakryiko wrote:
> Amazingly, some libc implementations don't call __NR_nanosleep syscall from
> their nanosleep() APIs. Hammer it down with explicit syscall() call and never
> get back to it again. Also simplify code for timespec initialization.
> 
> I verified that nanosleep is called w/ printk and in exactly same Linux image
> that is used in Travis CI. So it should both sleep and call correct syscall.
> 
> v1->v2:
>    - math is too hard, fix usec -> nsec convertion (Martin);
>    - test_vmlinux has explicit nanosleep() call, convert that one as well.
> 
> Fixes: 4e1fd25d19e8 ("selftests/bpf: Fix usleep() implementation")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
