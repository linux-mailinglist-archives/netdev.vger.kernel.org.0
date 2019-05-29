Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294D02E956
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 01:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfE2X0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 19:26:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:39754 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfE2X0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 19:26:39 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hW7xs-0000BG-7J; Thu, 30 May 2019 01:26:36 +0200
Received: from [178.197.249.12] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hW7xs-000Bbt-02; Thu, 30 May 2019 01:26:36 +0200
Subject: Re: [PATCH v2 bpf-next 0/9] libbpf random fixes
To:     Andrii Nakryiko <andriin@fb.com>, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ast@fb.com,
        kernel-team@fb.com
References: <20190529173611.4012579-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8718da15-efdc-cc14-d70d-4ffa3d200cc1@iogearbox.net>
Date:   Thu, 30 May 2019 01:26:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190529173611.4012579-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25464/Wed May 29 09:59:09 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/29/2019 07:36 PM, Andrii Nakryiko wrote:
> This patch set is a collection of unrelated fixes for libbpf.
> 
> Patch #1 fixes detection of corrupted BPF section w/ instructions.
> Patch #2 fixes possible errno clobbering.
> Patch #3 simplifies endianness check and brings it in line with few other
> similar checks in libbpf.
> Patch #4 adds check for failed map name retrieval from ELF symbol name.
> Patch #5 fixes return error code to be negative.
> Patch #6 fixes using valid fd (0) as a marker of missing associated BTF.
> Patch #7 removes redundant logic in two places.
> Patch #8 fixes typos in comments and debug output, and fixes formatting.
> Patch #9 unwraps a bunch of multi-line statements and comments.
> 
> v1->v2:
>   - patch #1 simplifications (Song);
> 
> 
> Andrii Nakryiko (9):
>   libbpf: fix detection of corrupted BPF instructions section
>   libbpf: preserve errno before calling into user callback
>   libbpf: simplify endianness check
>   libbpf: check map name retrieved from ELF
>   libbpf: fix error code returned on corrupted ELF
>   libbpf: use negative fd to specify missing BTF
>   libbpf: simplify two pieces of logic
>   libbpf: typo and formatting fixes
>   libbpf: reduce unnecessary line wrapping
> 
>  tools/lib/bpf/libbpf.c | 148 +++++++++++++++++------------------------
>  1 file changed, 60 insertions(+), 88 deletions(-)
> 

Applied, thanks!
