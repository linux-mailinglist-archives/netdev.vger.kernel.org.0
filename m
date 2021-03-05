Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1BB332EFBB
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 17:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhCEQKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 11:10:06 -0500
Received: from www62.your-server.de ([213.133.104.62]:42836 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhCEQJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 11:09:33 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lID15-000Cs5-Hn; Fri, 05 Mar 2021 17:09:27 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lID15-000UYN-BL; Fri, 05 Mar 2021 17:09:27 +0100
Subject: Re: [PATCH bpf-next] selftests_bpf: extend test_tc_tunnel test with
 vxlan
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Xuesen Huang <hxseverything@gmail.com>
Cc:     David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Xuesen Huang <huangxuesen@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>
References: <20210305123347.15311-1-hxseverything@gmail.com>
 <CA+FuTSc_RDHb8dmMzfwatt89pXsX2AA1--X98pEGkmmfpVs-Vg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dfde1c9f-cd2d-6e7d-ea3e-58b486a1388b@iogearbox.net>
Date:   Fri, 5 Mar 2021 17:09:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTSc_RDHb8dmMzfwatt89pXsX2AA1--X98pEGkmmfpVs-Vg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26099/Fri Mar  5 13:02:51 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/5/21 4:08 PM, Willem de Bruijn wrote:
> On Fri, Mar 5, 2021 at 7:34 AM Xuesen Huang <hxseverything@gmail.com> wrote:
>>
>> From: Xuesen Huang <huangxuesen@kuaishou.com>
>>
>> Add BPF_F_ADJ_ROOM_ENCAP_L2_ETH flag to the existing tests which
>> encapsulates the ethernet as the inner l2 header.
>>
>> Update a vxlan encapsulation test case.
>>
>> Signed-off-by: Xuesen Huang <huangxuesen@kuaishou.com>
>> Signed-off-by: Li Wang <wangli09@kuaishou.com>
>> Signed-off-by: Willem de Bruijn <willemb@google.com>
> 
> Please don't add my signed off by without asking.

Agree, I can remove it if you prefer while applying and only keep the
ack instead.

> That said,
> 
> Acked-by: Willem de Bruijn <willemb@google.com>
