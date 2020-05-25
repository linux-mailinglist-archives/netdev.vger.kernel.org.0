Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126AD1E17E3
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 00:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389505AbgEYWXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 18:23:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:52266 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgEYWXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 18:23:14 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdLUz-0002ho-34; Tue, 26 May 2020 00:23:09 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jdLUy-000Jyd-MG; Tue, 26 May 2020 00:23:08 +0200
Subject: Re: [PATCH] MAINTAINERS: adjust entry in XDP SOCKETS to actual file
 name
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        maciej.fijalkowski@intel.com, Alexei Starovoitov <ast@kernel.org>,
        bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200525141553.7035-1-lukas.bulwahn@gmail.com>
 <9d930e0e-5c77-11b8-6a8b-982fac711f6d@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <22339b06-2cf1-0a3a-5813-86651ecd8d03@iogearbox.net>
Date:   Tue, 26 May 2020 00:23:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <9d930e0e-5c77-11b8-6a8b-982fac711f6d@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25823/Mon May 25 14:23:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/25/20 4:42 PM, Björn Töpel wrote:
> On 2020-05-25 16:15, Lukas Bulwahn wrote:
>> Commit 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API") added a
>> new header file include/net/xsk_buff_pool.h, but commit 28bee21dc04b
>> ("MAINTAINERS, xsk: Update AF_XDP section after moves/adds") added a file
>> entry referring to include/net/xsk_buffer_pool.h.
>>
>> Hence, ./scripts/get_maintainer.pl --self-test=patterns complains:
>>
>>    warning: no file matches  F:  include/net/xsk_buffer_pool.h
>>
>> Adjust the entry in XDP SOCKETS to the actual file name.
>>
>> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
>> ---
>> Björn, please pick this minor non-urgent patch.
>>
>> applies to next-20200525 on top of the commits mentioned above
>>
> 
> Thanks Lukas!
> 
> Daniel/Alexei, this should go to the bpf-next tree.

Yep, applied, thanks!
