Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1A01BEC8E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 01:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgD2XPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 19:15:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:59412 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgD2XPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 19:15:33 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTvvM-0006vC-J2; Thu, 30 Apr 2020 01:15:28 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTvvM-0002IE-7A; Thu, 30 Apr 2020 01:15:28 +0200
Subject: Re: [PATCH] bpf: fix unused variable warning
To:     Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200429132217.1294289-1-arnd@arndb.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8fc6fb64-8858-bbda-8381-3341167cd004@iogearbox.net>
Date:   Thu, 30 Apr 2020 01:15:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200429132217.1294289-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25797/Wed Apr 29 14:06:14 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 3:21 PM, Arnd Bergmann wrote:
> Hiding the only using of bpf_link_type_strs[] in an #ifdef causes
> an unused-variable warning:
> 
> kernel/bpf/syscall.c:2280:20: error: 'bpf_link_type_strs' defined but not used [-Werror=unused-variable]
>   2280 | static const char *bpf_link_type_strs[] = {
> 
> Move the definition into the same #ifdef.
> 
> Fixes: f2e10bff16a0 ("bpf: Add support for BPF_OBJ_GET_INFO_BY_FD for bpf_link")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks!
