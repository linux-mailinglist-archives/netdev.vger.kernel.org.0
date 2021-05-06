Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4572F375D69
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 01:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhEFXbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 19:31:12 -0400
Received: from www62.your-server.de ([213.133.104.62]:33436 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbhEFXbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 19:31:08 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lenRO-0002hL-Ac; Fri, 07 May 2021 01:29:58 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lenRN-0008FD-GY; Fri, 07 May 2021 01:29:58 +0200
Subject: Re: [PATCH bpf] samples/bpf: consider frame size in tx_only of
 xdpsock sample
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, maciej.fijalkowski@intel.com
References: <20210506124349.6666-1-magnus.karlsson@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5d8ac9e9-1de7-116b-4e1a-8814cb01fc8b@iogearbox.net>
Date:   Fri, 7 May 2021 01:29:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210506124349.6666-1-magnus.karlsson@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26162/Thu May  6 13:11:07 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/21 2:43 PM, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Fix the tx_only micro-benchmark in xdpsock to take frame size into
> consideration. It was hardcoded to the default value of frame_size
> which is 4K. Changing this on the command line to 2K made half of the
> packets illegal as they were outside the umem and were therefore
> discarded by the kernel.
> 
> Fixes: 46738f73ea4f ("samples/bpf: add use of need_wakeup flag in xdpsock")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Applied, thanks!
