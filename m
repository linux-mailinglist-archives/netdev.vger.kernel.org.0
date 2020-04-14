Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E031A8B5B
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505180AbgDNTpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:45:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:51340 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505166AbgDNTpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:45:20 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jORUj-0002UK-N9; Tue, 14 Apr 2020 21:45:17 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jORUi-0008vT-Si; Tue, 14 Apr 2020 21:45:17 +0200
Subject: Re: [PATCH bpf] xdp: Reset prog in dev_change_xdp_fd when fd is
 negative
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, ast@kernel.org
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
References: <20200412133204.43847-1-dsahern@kernel.org>
 <87imi2pmcz.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b49e845e-8841-f906-31fa-08871a4f4159@iogearbox.net>
Date:   Tue, 14 Apr 2020 21:45:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87imi2pmcz.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25782/Tue Apr 14 13:57:42 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/20 9:17 AM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@kernel.org> writes:
> 
>> From: David Ahern <dsahern@gmail.com>
>>
>> The commit mentioned in the Fixes tag reuses the local prog variable
>> when looking up an expected_fd. The variable is not reset when fd < 0
>> causing a detach with the expected_fd set to actually call
>> dev_xdp_install for the existing program. The end result is that the
>> detach does not happen.
>>
>> Fixes: 92234c8f15c8 ("xdp: Support specifying expected existing program when attaching XDP")
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Cc: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> Ugh, my bad (obviously!). Thanks for the fix! I'll send an update to the
> selftest to catch errors like this...

+1

> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied, thanks!
