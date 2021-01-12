Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2132F3628
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390701AbhALQu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:50:56 -0500
Received: from www62.your-server.de ([213.133.104.62]:45078 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733158AbhALQu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:50:56 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kzMs2-0002k2-BN; Tue, 12 Jan 2021 17:50:14 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kzMs2-0000jx-4W; Tue, 12 Jan 2021 17:50:14 +0100
Subject: Re: [PATCH bpf-next 0/2] add xdp_build_skb_from_frame utility routine
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, brouer@redhat.com, toshiaki.makita1@gmail.com
References: <cover.1608142960.git.lorenzo@kernel.org>
 <20210112160842.GC2555@lore-desk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <de334a62-c249-ea05-abec-2e1fe6c282ac@iogearbox.net>
Date:   Tue, 12 Jan 2021 17:50:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210112160842.GC2555@lore-desk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26047/Tue Jan 12 13:33:56 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/21 5:08 PM, Lorenzo Bianconi wrote:
>> Introduce __xdp_build_skb_from_frame and xdp_build_skb_from_frame routines to
>> build the skb from a xdp_frame. Respect to __xdp_build_skb_from_frame,
>> xdp_build_skb_from_frame will allocate the skb object.
>> Rely on __xdp_build_skb_from_frame/xdp_build_skb_from_frame in cpumap and veth
>> code.
> 
> since this series is marked as "archived" in patchwork, do I need to resubmit it?

Yes please do, afaik there was some minor feedback from Toshiaki which was not yet
addressed from your side.

Thanks,
Daniel
