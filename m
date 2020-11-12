Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8B02B0E08
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgKLT2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:28:03 -0500
Received: from www62.your-server.de ([213.133.104.62]:44266 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgKLT2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:28:03 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kdIGF-0004sC-Lc; Thu, 12 Nov 2020 20:27:59 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kdIGF-000X6g-GY; Thu, 12 Nov 2020 20:27:59 +0100
Subject: Re: [PATCH bpf] MAINTAINERS/bpf: Update Andrii's entry.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
References: <20201112180340.45265-1-alexei.starovoitov@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8d6d521d-9ed7-df03-0a9b-d31a0103938c@iogearbox.net>
Date:   Thu, 12 Nov 2020 20:27:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201112180340.45265-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25986/Thu Nov 12 14:18:25 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/20 7:03 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Andrii has been a de-facto maintainer for libbpf and other components.
> Update maintainers entry to acknowledge his work de-jure.
> 
> The folks with git write permissions will continue to follow the rule
> of not applying their own patches unless absolutely trivial.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Full ack, thanks for all the hard work, Andrii! Applied, thanks!
