Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42FC8C391
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 23:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfHMVWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 17:22:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:34458 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfHMVWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 17:22:43 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxeFd-0006JZ-3S; Tue, 13 Aug 2019 23:22:41 +0200
Received: from [178.193.45.231] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hxeFc-000PmK-UH; Tue, 13 Aug 2019 23:22:40 +0200
Subject: Re: [PATCH bpf-next 0/2] libbpf: make use of BTF through sysfs
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, acme@redhat.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20190813185443.437829-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <176f6ecc-dcd3-e646-f812-a2cb2a2b446b@iogearbox.net>
Date:   Tue, 13 Aug 2019 23:22:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190813185443.437829-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25540/Tue Aug 13 10:16:47 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/19 8:54 PM, Andrii Nakryiko wrote:
> Now that kernel's BTF is exposed through sysfs at well-known location, attempt
> to load it first as a target BTF for the purpose of BPF CO-RE relocations.
> 
> Patch #1 is a follow-up patch to rename /sys/kernel/btf/kernel into
> /sys/kernel/btf/vmlinux.
> Patch #2 adds ability to load raw BTF contents from sysfs and expands the list
> of locations libbpf attempts to load vmlinux BTF from.
> 
> Andrii Nakryiko (2):
>    btf: rename /sys/kernel/btf/kernel into /sys/kernel/btf/vmlinux
>    libbpf: attempt to load kernel BTF from sysfs first
> 
>   Documentation/ABI/testing/sysfs-kernel-btf |  2 +-
>   kernel/bpf/sysfs_btf.c                     | 30 +++++-----
>   scripts/link-vmlinux.sh                    | 18 +++---
>   tools/lib/bpf/libbpf.c                     | 64 +++++++++++++++++++---
>   4 files changed, 82 insertions(+), 32 deletions(-)
> 

LGTM, applied thanks!
