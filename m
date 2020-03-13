Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF07D184F7A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 20:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgCMTtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 15:49:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:43112 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgCMTtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 15:49:07 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCqIr-0005FL-2P; Fri, 13 Mar 2020 20:49:05 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jCqIq-000FUP-NU; Fri, 13 Mar 2020 20:49:04 +0100
Subject: Re: [PATCH 1/8] bpf: Add missing annotations for __bpf_prog_enter()
 and __bpf_prog_exit()
To:     Jules Irenge <jbi.octave@gmail.com>, boqun.feng@gmail.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <0/8> <20200311010908.42366-1-jbi.octave@gmail.com>
 <20200311010908.42366-2-jbi.octave@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f0d5133d-91af-19fd-19c5-aa0b879c1db8@iogearbox.net>
Date:   Fri, 13 Mar 2020 20:49:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200311010908.42366-2-jbi.octave@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25750/Fri Mar 13 14:03:09 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/20 2:09 AM, Jules Irenge wrote:
> Sparse reports a warning at __bpf_prog_enter() and __bpf_prog_exit()
> 
> warning: context imbalance in __bpf_prog_enter() - wrong count at exit
> warning: context imbalance in __bpf_prog_exit() - unexpected unlock
> 
> The root cause is the missing annotation at __bpf_prog_enter()
> and __bpf_prog_exit()
> 
> Add the missing __acquires(RCU) annotation
> Add the missing __releases(RCU) annotation
> 
> Signed-off-by: Jules Irenge <jbi.octave@gmail.com>

Applied this one to bpf-next, thanks!
