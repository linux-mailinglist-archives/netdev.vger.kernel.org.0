Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4220D18D23A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgCTPAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:00:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:50728 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgCTPAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:00:25 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jFJ8I-0004OZ-Uc; Fri, 20 Mar 2020 16:00:23 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jFJ8I-000CmV-2M; Fri, 20 Mar 2020 16:00:22 +0100
Subject: Re: [PATCH v4 bpf-next 0/4] bpftool: Add struct_ops support
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        netdev@vger.kernel.org
References: <20200318171631.128566-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1dee7daa-a63c-ff2d-6a84-c4565e7932ac@iogearbox.net>
Date:   Fri, 20 Mar 2020 16:00:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200318171631.128566-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25757/Fri Mar 20 14:13:59 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/20 6:16 PM, Martin KaFai Lau wrote:
> This set adds "struct_ops" support to bpftool.
> 
> The first two patches improve the btf_dumper in bpftool.
> Patch 1: print the enum's name (if it is found) instead of the
>           enum's value.
> Patch 2: print a char[] as a string if all characters are printable.
> 
> "struct_ops" stores the prog_id in a func ptr.
> Instead of printing a prog_id,
> patch 3 adds an option to btf_dumper to allow a func ptr's value
> to be printed with the full func_proto info and the prog_name.
> 
> Patch 4 implements the "struct_ops" bpftool command.
> 
> v4:
> - Return -EINVAL in patch 1 (Andrii)
> 
> v3:
> - Check for "case 1:" in patch 1 (Andrii)
> 
> v2:
> - Typo fixes in comment and doc in patch 4 (Quentin)
> - Link to a few other man pages in doc in patch 4 (Quentin)
> - Alphabet ordering in include files in patch 4 (Quentin)
> - Use GET_ARG() in patch 4 (Quentin)
> 
> Martin KaFai Lau (4):
>    bpftool: Print the enum's name instead of value
>    bpftool: Print as a string for char array
>    bpftool: Translate prog_id to its bpf prog_name
>    bpftool: Add struct_ops support
> 
>   .../Documentation/bpftool-struct_ops.rst      | 116 ++++
>   tools/bpf/bpftool/bash-completion/bpftool     |  28 +
>   tools/bpf/bpftool/btf_dumper.c                | 199 +++++-
>   tools/bpf/bpftool/main.c                      |   3 +-
>   tools/bpf/bpftool/main.h                      |   2 +
>   tools/bpf/bpftool/struct_ops.c                | 596 ++++++++++++++++++
>   6 files changed, 927 insertions(+), 17 deletions(-)
>   create mode 100644 tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
>   create mode 100644 tools/bpf/bpftool/struct_ops.c
> 

Applied, thanks!
