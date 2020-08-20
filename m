Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE5D24C077
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgHTOUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:20:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:52188 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgHTOTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:19:52 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k8lPt-0003p3-8Q; Thu, 20 Aug 2020 16:19:45 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k8lPt-000Ntj-1z; Thu, 20 Aug 2020 16:19:45 +0200
Subject: Re: [PATCH v6 bpf-next 0/4] bpf: Populate bpffs with map and prog
 iterators
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20200819042759.51280-1-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <75e37df4-77c4-bd39-f23d-5a1733864698@iogearbox.net>
Date:   Thu, 20 Aug 2020 16:19:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200819042759.51280-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25905/Thu Aug 20 15:09:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/19/20 6:27 AM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> v5->v6:
> - refactored Makefiles with Andrii's help
>    - switched to explicit $(MAKE) style
>    - switched to userldlibs instead of userldflags
>    - fixed build issue with libbpf Makefile due to invocation from kbuild
> - fixed menuconfig order as spotted by Daniel
> - introduced CONFIG_USERMODE_DRIVER bool that is selected by bpfilter and bpf_preload

Applied, thanks!
