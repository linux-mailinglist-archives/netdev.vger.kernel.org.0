Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50613324548
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 21:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhBXUfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 15:35:20 -0500
Received: from www62.your-server.de ([213.133.104.62]:43026 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhBXUfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 15:35:19 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lF0rg-000BWE-Tx; Wed, 24 Feb 2021 21:34:32 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lF0rg-0005O5-Pr; Wed, 24 Feb 2021 21:34:32 +0100
Subject: Re: [PATCH 0/2] More strict error checking in bpf_asm.
To:     Ian Denhardt <ian@zenhack.net>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
References: <cover.1614134213.git.ian@zenhack.net>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ef747c45-a68c-2a87-202c-5fd9faf70392@iogearbox.net>
Date:   Wed, 24 Feb 2021 21:34:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <cover.1614134213.git.ian@zenhack.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26090/Wed Feb 24 13:09:42 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ian,

On 2/24/21 3:36 AM, Ian Denhardt wrote:
> Hi,
> 
> Enclosed are two patches related to my earlier message, which make the
> error checking in the bpf_asm tool more strict, the first by upgrading a
> warning to an error, the second by using non-zero exit codes when
> aborting.
> 
> These could be conceptually separated, but it seemed sensible to submit
> them together.
> 
> -Ian
> 
> Ian Denhardt (2):
>    tools, bpf_asm: Hard error on out of range jumps.
>    tools, bpf_asm: exit non-zero on errors.

Both of the patches need to have your Signed-off-by [0] in order to be able
to apply them, for example see [1]. Please resubmit with them & feel free to
carry Ilya's ACK forward for the v2. Thanks!

   [0] https://www.kernel.org/doc/html/latest/process/submitting-patches.html
   [1] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=557c223b643a35effec9654958d8edc62fd2603a

>   tools/bpf/bpf_exp.y | 14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)
> 
> --
> 2.30.1
> 

