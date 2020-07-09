Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4906B21A9D9
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 23:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgGIVni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 17:43:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:33874 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgGIVnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 17:43:37 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jteKL-00029M-Gu; Thu, 09 Jul 2020 23:43:33 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jteKL-00085h-9X; Thu, 09 Jul 2020 23:43:33 +0200
Subject: Re: [PATCH bpf] selftests: bpf: fix detach from sockmap tests
To:     Lorenz Bauer <lmb@cloudflare.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, Martin KaFai Lau <kafai@fb.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200709115151.75829-1-lmb@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <98ec53fe-7766-2b0a-42f4-89ce9aad04dd@iogearbox.net>
Date:   Thu, 9 Jul 2020 23:43:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200709115151.75829-1-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25868/Thu Jul  9 15:58:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/9/20 1:51 PM, Lorenz Bauer wrote:
> Fix sockmap tests which rely on old bpf_prog_dispatch behaviour.
> In the first case, the tests check that detaching without giving
> a program succeeds. Since these are not the desired semantics,
> invert the condition. In the second case, the clean up code doesn't
> supply the necessary program fds.
> 
> Reported-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> Fixes: bb0de3131f4c ("bpf: sockmap: Require attach_bpf_fd when detaching a program")

Applied, thanks!
