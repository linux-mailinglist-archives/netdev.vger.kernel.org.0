Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C1D19FEDF
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 22:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgDFUND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 16:13:03 -0400
Received: from www62.your-server.de ([213.133.104.62]:50512 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFUND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 16:13:03 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jLY78-0000bM-7W; Mon, 06 Apr 2020 22:12:58 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jLY77-000Ref-Sy; Mon, 06 Apr 2020 22:12:57 +0200
Subject: Re: [PATCH] xsk: fix out of boundary write in __xsk_rcv_memcpy
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Li RongQing <lirongqing@baidu.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kevin Laatz <kevin.laatz@intel.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        magnus.karlsson@intel.com
References: <1585813930-19712-1-git-send-email-lirongqing@baidu.com>
 <6BB0E637-B5F8-4B50-9B70-8A30F4AF6CF5@gmail.com>
 <CAJ+HfNjTaWp+=na14mjMzpbRzM2Ea5wK_MNJddFNEJ59XDLPNw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7dbc67e0-aaca-9809-3cda-34f3d5791337@iogearbox.net>
Date:   Mon, 6 Apr 2020 22:12:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNjTaWp+=na14mjMzpbRzM2Ea5wK_MNJddFNEJ59XDLPNw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25774/Mon Apr  6 14:53:25 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/3/20 10:29 AM, Björn Töpel wrote:
> On Fri, 3 Apr 2020 at 00:22, Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>> On 2 Apr 2020, at 0:52, Li RongQing wrote:
>>
>>> first_len is remainder of first page, if write size is
>>> larger than it, out of page boundary write will happen
>>>
>>> Fixes: c05cd3645814 "(xsk: add support to allow unaligned chunk placement)"
>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>
>> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> Good catch!
> Acked-by: Björn Töpel <bjorn.topel@intel.com>

Applied, thanks!

Björn, Magnus, others, would be really valuable to have a proper kselftest suite
in BPF for covering everything xsk related, including such corner cases as Li fixed
here, wdyt? ;-)

Thanks,
Daniel
