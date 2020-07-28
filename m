Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90505230772
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 12:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgG1KQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 06:16:16 -0400
Received: from www62.your-server.de ([213.133.104.62]:43132 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728463AbgG1KQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 06:16:16 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0Meb-0000HO-TW; Tue, 28 Jul 2020 12:16:13 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k0Mea-000IrN-W9; Tue, 28 Jul 2020 12:16:13 +0200
Subject: Re: [PATCH bpf-next 0/2] tools: bpftool: update prog names list and
 fix segfault
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Paul Chaignon <paul@cilium.io>
References: <20200724090618.16378-1-quentin@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9623ce12-6a3f-77ad-7fae-40bb93761efc@iogearbox.net>
Date:   Tue, 28 Jul 2020 12:16:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200724090618.16378-1-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25886/Mon Jul 27 16:48:28 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/20 11:06 AM, Quentin Monnet wrote:
> Although probing features with bpftool works fine if bpftool's array of
> program and map type names lack the latest kernel additions, it can crash
> if there are some types missing _in the middle_ of the arrays. The case
> recently occurred with the addition of the "sk_lookup" name, which skipped
> the "lsm" in the list.
> 
> Let's update the list, and let's make sure it does not crash bpftool again
> if we omit other types again in the future.
> 
> Quentin Monnet (2):
>    tools: bpftool: skip type probe if name is not found
>    tools: bpftool: add LSM type to array of prog names
> 
>   tools/bpf/bpftool/feature.c | 8 ++++++++
>   tools/bpf/bpftool/prog.c    | 1 +
>   2 files changed, 9 insertions(+)
> 

Applied, thanks!
