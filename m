Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB3A5958C8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbiHPKqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbiHPKpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:45:09 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A838852DCB;
        Tue, 16 Aug 2022 02:54:39 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oNtHL-0008sY-GS; Tue, 16 Aug 2022 11:54:31 +0200
Received: from [85.1.206.226] (helo=linux-4.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oNtHL-000Bt7-6s; Tue, 16 Aug 2022 11:54:31 +0200
Subject: Re: [PATCH bpf-next] xdp: report rx queue index in xdp_frame
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, hawk@kernel.org,
        john.fastabend@gmail.com
References: <181f994e13c816116fa69a1e92c2f69e6330f749.1658746417.git.lorenzo@kernel.org>
 <YvtnOloObaUxpR1O@lore-desk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4e717cbe-17a2-dbae-d557-0b29eaa28dae@iogearbox.net>
Date:   Tue, 16 Aug 2022 11:54:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YvtnOloObaUxpR1O@lore-desk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26629/Tue Aug 16 09:51:41 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/22 11:45 AM, Lorenzo Bianconi wrote:
>> Report rx queue index in xdp_frame according to the xdp_buff xdp_rxq_info
>> pointer. xdp_frame queue_index is currently used in cpumap code to covert
>> the xdp_frame into a xdp_buff.
>> xdp_frame size is not increased adding queue_index since an alignment padding
>> in the structure is used to insert queue_index field.
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> ---
>>   include/net/xdp.h   | 2 ++
>>   kernel/bpf/cpumap.c | 2 +-
>>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> 
> Hi Alexei and Daniel,
> 
> this patch is marked as 'new, archived' in patchwork.
> Do I need to rebase and repost it?

Yes, please rebase and resend. Perhaps also improve the commit description
a bit in terms of what it fixes, it's a bit terse to the reader above on
what effect it has.

Thanks,
Daniel
