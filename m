Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B173181AFD
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 15:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbgCKOT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 10:19:28 -0400
Received: from www62.your-server.de ([213.133.104.62]:32990 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgCKOT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 10:19:28 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jC2Ck-00004t-NB; Wed, 11 Mar 2020 15:19:26 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jC2Cj-0003qC-Rw; Wed, 11 Mar 2020 15:19:26 +0100
Subject: Re: [PATCH bpf-next] tools/runqslower: add BPF_F_CURRENT_CPU for
 running selftest on older kernels
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200311043010.530620-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c622d372-f4a8-e080-3843-df22f926142f@iogearbox.net>
Date:   Wed, 11 Mar 2020 15:19:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200311043010.530620-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25748/Wed Mar 11 12:08:41 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/20 5:30 AM, Andrii Nakryiko wrote:
> Libbpf compiles and runs subset of selftests on each PR in its Github mirror
> repository. To allow still building up-to-date selftests against outdated
> kernel images, add back BPF_F_CURRENT_CPU definitions back.
> 
> N.B. BCC's runqslower version ([0]) doesn't need BPF_F_CURRENT_CPU due to use of
> locally checked in vmlinux.h, generated against kernel with 1aae4bdd7879 ("bpf:
> Switch BPF UAPI #define constants used from BPF program side to enums")
> applied.
> 
>    [0] https://github.com/iovisor/bcc/pull/2809
> 
> Fixes: 367d82f17eff (" tools/runqslower: Drop copy/pasted BPF_F_CURRENT_CPU definiton")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Too bad, applied, thanks!
