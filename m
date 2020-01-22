Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A2A145ABC
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAVRX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:23:29 -0500
Received: from www62.your-server.de ([213.133.104.62]:49958 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVRX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 12:23:29 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuJiu-0004Uq-PA; Wed, 22 Jan 2020 18:23:24 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuJiu-000NiI-DM; Wed, 22 Jan 2020 18:23:24 +0100
Subject: Re: [PATCH 3/3] selftests/bpf: Build urandom_read with LDFLAGS and
 LDLIBS
To:     =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>,
        shuah@kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20200117165330.17015-1-daniel.diaz@linaro.org>
 <20200117165330.17015-3-daniel.diaz@linaro.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f2d533bc-8b6d-ecb5-2052-34c6876f2249@iogearbox.net>
Date:   Wed, 22 Jan 2020 18:23:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200117165330.17015-3-daniel.diaz@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25703/Wed Jan 22 12:37:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/17/20 5:53 PM, Daniel Díaz wrote:
> During cross-compilation, it was discovered that LDFLAGS and
> LDLIBS were not being used while building binaries, leading
> to defaults which were not necessarily correct.
> 
> OpenEmbedded reported this kind of problem:
>    ERROR: QA Issue: No GNU_HASH in the ELF binary [...], didn't pass LDFLAGS?
> 
> Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>

Applied, thanks!
