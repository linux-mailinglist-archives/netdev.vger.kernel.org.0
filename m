Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335FA1E17DB
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389531AbgEYWUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:20:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:51978 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387629AbgEYWUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 18:20:11 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdLS5-0002Vr-JC; Tue, 26 May 2020 00:20:09 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdLS5-000BdC-Ci; Tue, 26 May 2020 00:20:09 +0200
Subject: Re: [PATCH bpf-next] tools: bpftool: clean subcommand help messages
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20200523010751.23465-1-quentin@isovalent.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1ce6f183-eee1-d4d3-7797-89e31e78cdb5@iogearbox.net>
Date:   Tue, 26 May 2020 00:20:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200523010751.23465-1-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25823/Mon May 25 14:23:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/20 3:07 AM, Quentin Monnet wrote:
> This is a clean-up for the formatting of the do_help functions for
> bpftool's subcommands. The following fixes are included:
> 
> - Do not use argv[-2] for "iter" help message, as the help is shown by
>    default if no "iter" action is selected, resulting in messages looking
>    like "./bpftool bpftool pin...".
> 
> - Do not print unused HELP_SPEC_PROGRAM in help message for "bpftool
>    link".
> 
> - Andrii used argument indexing to avoid having multiple occurrences of
>    bin_name and argv[-2] in the fprintf() for the help message, for
>    "bpftool gen" and "bpftool link". Let's reuse this for all other help
>    functions. We can remove up to thirty arguments for the "bpftool map"
>    help message.
> 
> - Harmonise all functions, e.g. use ending quotes-comma on a separate
>    line.
> 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>

Applied, thanks!
