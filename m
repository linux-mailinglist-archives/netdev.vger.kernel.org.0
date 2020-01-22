Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67199145ABE
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgAVRYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:24:04 -0500
Received: from www62.your-server.de ([213.133.104.62]:50054 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVRYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 12:24:04 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuJjW-0004We-30; Wed, 22 Jan 2020 18:24:02 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuJjV-000RE1-PV; Wed, 22 Jan 2020 18:24:01 +0100
Subject: Re: [PATCH v2] bpf: btf: Always output invariant hit in pahole DWARF
 to BTF transform
To:     Chris Down <chris@chrisdown.name>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
References: <20200122000110.GA310073@chrisdown.name>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fcea8bd9-2bea-ddb2-449e-8640e772c487@iogearbox.net>
Date:   Wed, 22 Jan 2020 18:24:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200122000110.GA310073@chrisdown.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25703/Wed Jan 22 12:37:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/20 1:01 AM, Chris Down wrote:
> When trying to compile with CONFIG_DEBUG_INFO_BTF enabled, I got this
> error:
> 
>      % make -s
>      Failed to generate BTF for vmlinux
>      Try to disable CONFIG_DEBUG_INFO_BTF
>      make[3]: *** [vmlinux] Error 1
> 
> Compiling again without -s shows the true error (that pahole is
> missing), but since this is fatal, we should show the error
> unconditionally on stderr as well, not silence it using the `info`
> function. With this patch:
> 
>      % make -s
>      BTF: .tmp_vmlinux.btf: pahole (pahole) is not available
>      Failed to generate BTF for vmlinux
>      Try to disable CONFIG_DEBUG_INFO_BTF
>      make[3]: *** [vmlinux] Error 1
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Cc: kernel-team@fb.com

Applied, thanks!
