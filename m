Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3446425F91
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 23:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241547AbhJGV63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 17:58:29 -0400
Received: from www62.your-server.de ([213.133.104.62]:41334 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbhJGV62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 17:58:28 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mYbNN-000GEi-7x; Thu, 07 Oct 2021 23:56:29 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mYbNN-0000uR-1E; Thu, 07 Oct 2021 23:56:29 +0200
Subject: Re: linux-next: Fixes tag needs some work in the bpf-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20211008083118.43f6d79f@canb.auug.org.au>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <002d3d66-9081-b117-ec93-4235450d6036@iogearbox.net>
Date:   Thu, 7 Oct 2021 23:56:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211008083118.43f6d79f@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26315/Thu Oct  7 11:09:01 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/21 11:31 PM, Stephen Rothwell wrote:
> Hi all,
> 
> In commit
> 
>    065485ac5e86 ("mips, bpf: Fix Makefile that referenced a removed file")
> 
> Fixes tag
> 
>    Fixes: 06b339fe5450 ("mips, bpf: Remove old BPF JIT implementations")
> 
> has these problem(s):
> 
>    - Target SHA1 does not exist
> 
> Maybe you meant
> 
> Fixes: ebcbacfa50ec ("mips, bpf: Remove old BPF JIT implementations")

Yeah, Fixes tag was incorrect. Fixed up now, thanks for the heads up!
