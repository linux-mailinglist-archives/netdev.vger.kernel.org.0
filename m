Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FA81CE5A1
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgEKUer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:34:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:46038 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729517AbgEKUer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:34:47 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYF8N-0007g7-GC; Mon, 11 May 2020 22:34:43 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYF8N-000BCK-9D; Mon, 11 May 2020 22:34:43 +0200
Subject: Re: [PATCH bpf-next v2 0/4] bpf: clean up bpftool, bpftool doc,
 bpf-helpers doc
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20200511161536.29853-1-quentin@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3f767262-11dc-d11e-abcd-33481720239d@iogearbox.net>
Date:   Mon, 11 May 2020 22:34:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200511161536.29853-1-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25809/Mon May 11 14:16:55 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/20 6:15 PM, Quentin Monnet wrote:
> This set focuses on cleaning-up the documentation for bpftool and BPF
> helpers.
> 
> The first patch is actually a clean-up for bpftool itself: it replaces
> kernel integer types by the ones that should be used in user space, and
> poisons kernel types to avoid reintroducing them by mistake in the future.
> 
> Then come the documentation fixes: bpftool, and BPF helpers, with the usual
> sync up for the BPF header under tools/. Please refer to individual commit
> logs for details.
> 
> Quentin Monnet (4):
>    tools: bpftool: poison and replace kernel integer typedefs
>    tools: bpftool: minor fixes for documentation
>    bpf: minor fixes to BPF helpers documentation
>    tools: bpf: synchronise BPF UAPI header with tools

Applied, thanks!
