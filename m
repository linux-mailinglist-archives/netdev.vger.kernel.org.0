Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019202140BD
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 23:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgGCVWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 17:22:54 -0400
Received: from www62.your-server.de ([213.133.104.62]:60170 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgGCVWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 17:22:53 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jrT8z-0007MC-V1; Fri, 03 Jul 2020 23:22:50 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jrT8z-000KUz-O9; Fri, 03 Jul 2020 23:22:49 +0200
Subject: Re: [bpf-next PATCH v2] bpf: fix bpftool without skeleton code
 enabled
To:     John Fastabend <john.fastabend@gmail.com>, yhs@fb.com,
        andriin@fb.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <159375071997.14984.17404504293832961401.stgit@john-XPS-13-9370>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <613cfcd0-a4e2-d193-6d23-883f27a35a4a@iogearbox.net>
Date:   Fri, 3 Jul 2020 23:22:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <159375071997.14984.17404504293832961401.stgit@john-XPS-13-9370>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25862/Fri Jul  3 15:56:19 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/3/20 6:31 AM, John Fastabend wrote:
> Fix segfault from bpftool by adding emit_obj_refs_plain when skeleton
> code is disabled.
> 
> Tested by deleting BUILD_BPF_SKELS in Makefile. We found this doing
> backports for Cilium when a testing image pulled in latest bpf-next
> bpftool, but kept using an older clang-7.
> 
> # ./bpftool prog show
> Error: bpftool built without PID iterator support
> 3: cgroup_skb  tag 7be49e3934a125ba  gpl
>          loaded_at 2020-07-01T08:01:29-0700  uid 0
> Segmentation fault
> 
> Reported-by: Joe Stringer <joe@wand.net.nz>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied, thanks!
