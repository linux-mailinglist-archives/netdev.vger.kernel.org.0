Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3EFE145ED
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 10:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfEFITw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 04:19:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:52550 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfEFITv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 04:19:51 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNYqi-00021T-PC; Mon, 06 May 2019 10:19:48 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNYqi-000RYB-Id; Mon, 06 May 2019 10:19:48 +0200
Subject: Re: [PATCH bpf] kbuild: tolerate missing pahole when generating BTF
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, yhs@fb.com,
        kernel-team@fb.com
Cc:     Alexei Starovoitov <ast@fb.com>
References: <20190506001033.2765060-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <aed4c5ed-32fc-4ce7-6490-42aa51d41888@iogearbox.net>
Date:   Mon, 6 May 2019 10:19:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190506001033.2765060-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25440/Sun May  5 10:04:31 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/06/2019 02:10 AM, Andrii Nakryiko wrote:
> When BTF generation is enabled through CONFIG_DEBUG_INFO_BTF,
> scripts/link-vmlinux.sh detects if pahole version is too old and
> gracefully continues build process, skipping BTF generation build step.
> But if pahole is not available, build will still fail. This patch adds
> check for whether pahole exists at all and bails out gracefully, if not.
> 
> Cc: Alexei Starovoitov <ast@fb.com>
> Reported-by: Yonghong Song <yhs@fb.com>
> Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
