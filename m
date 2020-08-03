Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A59523A8C3
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgHCOpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:45:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:45332 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgHCOpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:45:14 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2biC-0000TA-7B; Mon, 03 Aug 2020 16:45:12 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k2biC-0007MS-1O; Mon, 03 Aug 2020 16:45:12 +0200
Subject: Re: [PATCH bpf-next 0/3] Add generic and raw BTF parsing APIs to
 libbpf
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200802013219.864880-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bc4f155d-afe0-9cda-b41b-282e948c15e9@iogearbox.net>
Date:   Mon, 3 Aug 2020 16:45:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200802013219.864880-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25892/Sun Aug  2 17:01:36 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/20 3:32 AM, Andrii Nakryiko wrote:
> It's pretty common for applications to want to parse raw (binary) BTF data
> from file, as opposed to parsing it from ELF sections. It's also pretty common
> for tools to not care whether given file is ELF or raw BTF format. This patch
> series exposes internal raw BTF parsing API and adds generic variant of BTF
> parsing, which will efficiently determine the format of a given fail and will
> parse BTF appropriately.
> 
> Patches #2 and #3 removes re-implementations of such APIs from bpftool and
> resolve_btfids tools.
> 
> Andrii Nakryiko (3):
>    libbpf: add btf__parse_raw() and generic btf__parse() APIs
>    tools/bpftool: use libbpf's btf__parse() API for parsing BTF from file
>    tools/resolve_btfids: use libbpf's btf__parse() API
> 
>   tools/bpf/bpftool/btf.c             |  54 +------------
>   tools/bpf/resolve_btfids/.gitignore |   4 +
>   tools/bpf/resolve_btfids/main.c     |  58 +-------------
>   tools/lib/bpf/btf.c                 | 114 +++++++++++++++++++---------
>   tools/lib/bpf/btf.h                 |   5 +-
>   tools/lib/bpf/libbpf.map            |   2 +
>   6 files changed, 89 insertions(+), 148 deletions(-)
>   create mode 100644 tools/bpf/resolve_btfids/.gitignore
> 

Applied, thanks!
