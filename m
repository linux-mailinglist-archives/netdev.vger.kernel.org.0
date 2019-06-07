Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8435397B2
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbfFGV0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:26:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:59826 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729125AbfFGV0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 17:26:36 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hZMNe-0002zE-1z; Fri, 07 Jun 2019 23:26:34 +0200
Received: from [178.197.248.32] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hZMNd-000L2M-RQ; Fri, 07 Jun 2019 23:26:33 +0200
Subject: Re: [PATCH v4 bpf-next 0/2] bpf: Add a new API
 libbpf_num_possible_cpus()
To:     Hechao Li <hechaol@fb.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, kernel-team@fb.com
References: <20190607163759.2211904-1-hechaol@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1ba65555-b7a5-3c8d-b5c8-3432dbb2770b@iogearbox.net>
Date:   Fri, 7 Jun 2019 23:26:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190607163759.2211904-1-hechaol@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25473/Fri Jun  7 10:00:31 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/07/2019 06:37 PM, Hechao Li wrote:
> Getting number of possible CPUs is commonly used for per-CPU BPF maps
> and perf_event_maps. Add a new API libbpf_num_possible_cpus() that
> helps user with per-CPU related operations and remove duplicate
> implementations in bpftool and selftests.
> 
> v4: Fixed error code when reading 0 bytes from possible CPU file
> 
> Hechao Li (2):
>   bpf: add a new API libbpf_num_possible_cpus()
>   bpf: use libbpf_num_possible_cpus in bpftool and selftests
> 
>  tools/bpf/bpftool/common.c             | 53 +++---------------------
>  tools/lib/bpf/libbpf.c                 | 57 ++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h                 | 16 ++++++++
>  tools/lib/bpf/libbpf.map               |  1 +
>  tools/testing/selftests/bpf/bpf_util.h | 37 +++--------------
>  5 files changed, 84 insertions(+), 80 deletions(-)

Series applied, thanks!

P.s.: Please retain full history (v1->v2->v3->v4) in cover letter next time as
that is typical convention and helps readers of git log to follow what has been
changed over time.
