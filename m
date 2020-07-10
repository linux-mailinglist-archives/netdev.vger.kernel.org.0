Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD97E21C0CC
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 01:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgGJXea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 19:34:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:50860 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgGJXea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 19:34:30 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ju2XE-0007vI-Cj; Sat, 11 Jul 2020 01:34:28 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ju2XE-000XkG-2T; Sat, 11 Jul 2020 01:34:28 +0200
Subject: Re: [PATCH bpf] selftests/bpf: Fix cgroup sockopt verifier test
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, sdf@google.com
References: <20200710150439.126627-1-jean-philippe@linaro.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <85d9b268-2960-79a2-102e-2fcc6e7d2462@iogearbox.net>
Date:   Sat, 11 Jul 2020 01:34:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200710150439.126627-1-jean-philippe@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25869/Fri Jul 10 16:01:45 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 5:04 PM, Jean-Philippe Brucker wrote:
> Since the BPF_PROG_TYPE_CGROUP_SOCKOPT verifier test does not set an
> attach type, bpf_prog_load_check_attach() disallows loading the program
> and the test is always skipped:
> 
>   #434/p perfevent for cgroup sockopt SKIP (unsupported program type 25)
> 
> Fix the issue by setting a valid attach type.
> 
> Fixes: 0456ea170cd6 ("bpf: Enable more helpers for BPF_PROG_TYPE_CGROUP_{DEVICE,SYSCTL,SOCKOPT}")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

Applied, thanks!
