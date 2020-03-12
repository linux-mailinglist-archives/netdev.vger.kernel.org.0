Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA13D183D2C
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgCLXQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:16:39 -0400
Received: from www62.your-server.de ([213.133.104.62]:40346 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgCLXQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:16:38 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCX48-0007bQ-J9; Fri, 13 Mar 2020 00:16:36 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCX48-0009WU-AO; Fri, 13 Mar 2020 00:16:36 +0100
Subject: Re: [PATCH bpf-next] libbpf: split BTF presence checks into libbpf-
 and kernel-specific parts
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Quentin Monnet <quentin@isovalent.com>
References: <20200312185033.736911-1-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f031cc95-de56-4701-7eb9-b3128b4722e5@iogearbox.net>
Date:   Fri, 13 Mar 2020 00:16:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200312185033.736911-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25749/Thu Mar 12 14:09:06 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/20 7:50 PM, Andrii Nakryiko wrote:
> Needs for application BTF being present differs between user-space libbpf needs and kernel
> needs. Currently, BTF is mandatory only in kernel only when BPF application is
> using STRUCT_OPS. While libbpf itself relies more heavily on presense of BTF:
>    - for BTF-defined maps;
>    - for Kconfig externs;
>    - for STRUCT_OPS as well.
> 
> Thus, checks for presence and validness of bpf_object's BPF needs to be
> performed separately, which is patch does.
> 
> Fixes: 5327644614a1 ("libbpf: Relax check whether BTF is mandatory")
> Reported-by: Michal Rostecki <mrostecki@opensuse.org>
> Cc: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied, thanks!
