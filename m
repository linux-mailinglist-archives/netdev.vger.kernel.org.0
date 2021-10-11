Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291004291D2
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237130AbhJKOcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:32:18 -0400
Received: from www62.your-server.de ([213.133.104.62]:59424 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236716AbhJKOcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:32:12 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mZwJY-000Cmb-Vp; Mon, 11 Oct 2021 16:30:05 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mZwJY-000MJx-M5; Mon, 11 Oct 2021 16:30:04 +0200
Subject: Re: [PATCH] selftests: bpf: Remove dumplicated include in
 cgroup_helpers
To:     Wan Jiabing <wanjiabing@vivo.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
References: <20211011111948.19301-1-wanjiabing@vivo.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0b1f31ec-68e4-92e1-f4a6-b97fcb3ba6a8@iogearbox.net>
Date:   Mon, 11 Oct 2021 16:30:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211011111948.19301-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26319/Mon Oct 11 10:18:47 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/21 1:19 PM, Wan Jiabing wrote:
> Fix following checkincludes.pl warning:
> ./tools/testing/selftests/bpf/cgroup_helpers.c
> 12	#include <unistd.h>
>      14	#include <unistd.h>

What does the 12 vs 14 mean here? Please provide a proper commit description, e.g. if
you used checkincludes.pl, maybe include the full command invocation and the relevant
output, so that this is more obvious and in a better shape. Thanks!

> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>   tools/testing/selftests/bpf/cgroup_helpers.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
> index 8fcd44841bb2..9d59c3990ca8 100644
> --- a/tools/testing/selftests/bpf/cgroup_helpers.c
> +++ b/tools/testing/selftests/bpf/cgroup_helpers.c
> @@ -11,7 +11,6 @@
>   #include <fcntl.h>
>   #include <unistd.h>
>   #include <ftw.h>
> -#include <unistd.h>
>   
>   #include "cgroup_helpers.h"
>   
> 

