Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D45105B3B
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKUUjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:39:02 -0500
Received: from www62.your-server.de ([213.133.104.62]:56238 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfKUUjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:39:02 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXtE2-0006yr-3K; Thu, 21 Nov 2019 21:38:50 +0100
Received: from [178.197.248.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iXtE1-0003lB-K1; Thu, 21 Nov 2019 21:38:49 +0100
Subject: Re: [PATCH net-next] audit: Move audit_log_task declaration under
 CONFIG_AUDITSYSCALL
To:     Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        Steve Grubb <sgrubb@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
References: <20191121155853.3750-1-jolsa@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a39cbda4-a1e4-ddc8-6ecf-046ccfb3d584@iogearbox.net>
Date:   Thu, 21 Nov 2019 21:38:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191121155853.3750-1-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25640/Thu Nov 21 11:08:44 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 4:58 PM, Jiri Olsa wrote:
> The 0-DAY found that audit_log_task is not declared under
> CONFIG_AUDITSYSCALL which causes compilation error when
> it is not defined:
> 
>      kernel/bpf/syscall.o: In function `bpf_audit_prog.isra.30':
>   >> syscall.c:(.text+0x860): undefined reference to `audit_log_task'
> 
> Adding the audit_log_task declaration and stub within
> CONFIG_AUDITSYSCALL ifdef.
> 
> Fixes: 91e6015b082b ("bpf: Emit audit messages upon successful prog load and unload")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Daniel Borkmann <daniel@iogearbox.net>
