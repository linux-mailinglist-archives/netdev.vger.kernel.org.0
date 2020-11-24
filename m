Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3F72C33FE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387985AbgKXWZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:25:14 -0500
Received: from www62.your-server.de ([213.133.104.62]:40314 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727868AbgKXWZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 17:25:14 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1khgkK-0001hd-HW; Tue, 24 Nov 2020 23:25:12 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1khgkK-0005fd-AV; Tue, 24 Nov 2020 23:25:12 +0100
Subject: Re: [PATCH net-next 0/3] mvneta: access skb_shared_info only on last
 frag
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, brouer@redhat.com, echaudro@redhat.com,
        john.fastabend@gmail.com, alexei.starovoitov@gmail.com
References: <cover.1605889258.git.lorenzo@kernel.org>
 <20201124122639.6fa91460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201124221854.GA64351@lore-desk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <09034687-75d5-7102-8f9a-7dde69d04a63@iogearbox.net>
Date:   Tue, 24 Nov 2020 23:25:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201124221854.GA64351@lore-desk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25998/Tue Nov 24 14:16:50 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/24/20 11:18 PM, Lorenzo Bianconi wrote:
>> On Fri, 20 Nov 2020 18:05:41 +0100 Lorenzo Bianconi wrote:
>>> Build skb_shared_info on mvneta_rx_swbm stack and sync it to xdp_buff
>>> skb_shared_info area only on the last fragment.
>>> Avoid avoid unnecessary xdp_buff initialization in mvneta_rx_swbm routine.
>>> This a preliminary series to complete xdp multi-buff in mvneta driver.
>>
>> Looks fine, but since you need this for XDP multi-buff it should
>> probably go via bpf-next, right?
>>
>> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> 
> Hi Jakub,
> 
> thx for the review. Since the series changes networking-only bits I sent it for
> net-next, but I agree bpf-next is better.
> 
> @Alexei, Daniel: is it fine to merge the series in bpf-next?

Yeah totally fine, will take it into bpf-next in a bit.

Thanks,
Daniel
