Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C9458CE90
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 21:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243599AbiHHTaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 15:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbiHHTaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 15:30:07 -0400
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F375B1A04B
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 12:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nEwe2orNhVWd3+5KS6QtSz21jPviUJY7IfsVXugJJhs=; b=uIvGmK2DkAVEIURs3nuQD7/3aG
        tZh7CtSnlo1jo09rWBaRVFRByRtDzP6RYsiiDEIf0hVAYLyogF0ANNKxHh+QRtYgnn4zqaoT9iX4g
        6oIODnEgESsN/CXlZ8ucU9KVLulRxEyk6Mor7T0BSG8s+x9IvKpPnMGbUftTGpvx8bBU=;
Received: from [88.117.52.3] (helo=[10.0.0.160])
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oL8Rv-0001CE-Bf; Mon, 08 Aug 2022 21:30:03 +0200
Message-ID: <44114097-15bc-77ff-51f5-bfc0b5e02b70@engleder-embedded.com>
Date:   Mon, 8 Aug 2022 21:30:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 2/2] tsnep: Fix tsnep_tx_unmap() error path usage
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20220804183935.73763-1-gerhard@engleder-embedded.com>
 <20220804183935.73763-3-gerhard@engleder-embedded.com>
 <20220808122319.4164b5c6@kernel.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20220808122319.4164b5c6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08.08.22 21:23, Jakub Kicinski wrote:
> On Thu,  4 Aug 2022 20:39:35 +0200 Gerhard Engleder wrote:
>> If tsnep_tx_map() fails, then tsnep_tx_unmap() shall start at the write
>> index like tsnep_tx_map(). This is different to the normal operation.
>> Thus, add an additional parameter to tsnep_tx_unmap() to enable start at
>> different positions for successful TX and failed TX.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> Is this correct:
>
> Fixes: 403f69bbdbad ("tsnep: Add TSN endpoint Ethernet MAC driver")
>
> ?
Yes, that's correct. Sorry I forget to add it. Shall I add it and resend?
