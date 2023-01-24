Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5621B67A716
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 00:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbjAXXqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 18:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbjAXXqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 18:46:18 -0500
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8B7271B
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 15:45:56 -0800 (PST)
Received: from [192.168.0.18] (unknown [37.228.234.209])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id EBA245054FA;
        Wed, 25 Jan 2023 02:40:01 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru EBA245054FA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1674603603; bh=HbIQwFJkjm6kOOGIDDCllifyAAwPFQ41LhSvG7mi0CA=;
        h=Date:Subject:To:References:Cc:From:In-Reply-To:From;
        b=wLALWD+2fEPU4k9AR/59qDKOULE0qadjsw7Icg1CFn6HMrmTHRkk4sgO/yjiGwakQ
         AuLUEutfo7hoGsB09PsBq/ZpoIj6X2Brxu8AOrWuxxg1P65xrjWkmCrVei8Kz7Hbpf
         3EGexyUq8oPdtFD1sKfYgC704ozXwsVeGLXTMBII=
Message-ID: <d36c18ad-7fd0-beae-3147-574c4e3d01c5@novek.ru>
Date:   Tue, 24 Jan 2023 23:45:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: possible macvlan packet loss
To:     Aleksander Dutkowski <adutkowski@gmail.com>
References: <CABkKHSZV7OmkNnkZRi7dF=-_bJK9i4p_8XLdV_Zd0=Z_O8Jf6A@mail.gmail.com>
Content-Language: en-US
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <CABkKHSZV7OmkNnkZRi7dF=-_bJK9i4p_8XLdV_Zd0=Z_O8Jf6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.01.2023 15:14, Aleksander Dutkowski wrote:
> Hello,
> 
> we are experiencing something, that seems to be packet loss on macvlan
> interface.
> Input is ~350Mbps of multicasts, scattered over 120 docker containers,
> each having macvlan on top of the same mellanox 10G NIC. Each of
> macvlans have bcqueuelen set to INT_MAX.
> Streams recorded from phys interface have all packets, whereas streams
> recorded from macvlan have drops.
> 
Is it real packet loss or just reordering of the packets that is accounted by 
the software as a loss?

> I wonder what is the best way to test and measure the queue fulfillment?
> We can do simple printf when the queue is full, but maybe there are
> some tools or techniques I'm not aware of that we can use?
> 
> Thanks
> Alex

