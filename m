Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73151F69D8
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 16:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgFKOYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 10:24:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:57332 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgFKOYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 10:24:11 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jjO7i-0007xP-3y; Thu, 11 Jun 2020 16:24:06 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jjO7h-0001jm-Su; Thu, 11 Jun 2020 16:24:05 +0200
Subject: Re: [PATCH] xdp: fix xsk_generic_xmit errno
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Li RongQing <lirongqing@baidu.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <1591852266-24017-1-git-send-email-lirongqing@baidu.com>
 <CAJ+HfNhq3yHOTH+v_UNTzarjCaftdw_v0WnebEphZ3niU8GEDQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2c2fb55d-d442-114a-f0d0-26be219eeeb1@iogearbox.net>
Date:   Thu, 11 Jun 2020 16:24:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNhq3yHOTH+v_UNTzarjCaftdw_v0WnebEphZ3niU8GEDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25840/Thu Jun 11 14:52:31 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/20 10:18 AM, Björn Töpel wrote:
> On Thu, 11 Jun 2020 at 07:11, Li RongQing <lirongqing@baidu.com> wrote:
>>
>> propagate sock_alloc_send_skb error code, not set it
>> to EAGAIN unconditionally, when fail to allocate skb,
>> which maybe causes that user space unnecessary loops
>>
>> Fixes: 35fcde7f8deb "(xsk: support for Tx)"
>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> 
> Thanks!
> Acked-by: Björn Töpel <bjorn.topel@intel.com>
> 
> Alexei/Daniel: This should go into "bpf".

Yep, applied, thanks!
