Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660336C4F48
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjCVPTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjCVPTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:19:44 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B83591E0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/ngH4lRTOVSljehS281gVAjn9CyunphlgKx2v6Ny75Y=; b=s/Vkqlmse75edlgyRGeKLikCwZ
        dLn6SH2P5uSYPdTvqLIKprWHbEuq2MId8j9XbF/pCjnt8d+MoRtGqjI78J9i8NtFGO2WBOXpjikQW
        mfIp/N64tyyHax9LcOETlj6e6tktD1ynnA6+imRZ8mxSrAc5GNUmpfGherYuf/HV1mdU=;
Received: from [2a01:598:b1a6:ae43:fdb0:2ef2:7059:9fb7] (helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pf0FZ-005hs7-J5; Wed, 22 Mar 2023 16:19:41 +0100
Message-ID: <95878ada-e3ec-b563-3f64-b989241a87a4@nbd.name>
Date:   Wed, 22 Mar 2023 16:19:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 1/2] net: ethernet: mtk_eth_soc: add code for
 offloading flows from wlan devices
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org
References: <20230321133609.49591-1-nbd@nbd.name>
 <ZBsK46vmNtjxJZH6@corigine.com> <ZBsQwVODyLg+x96e@corigine.com>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <ZBsQwVODyLg+x96e@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.03.23 15:29, Simon Horman wrote:
> On Wed, Mar 22, 2023 at 03:04:19PM +0100, Simon Horman wrote:
>> On Tue, Mar 21, 2023 at 02:36:08PM +0100, Felix Fietkau wrote:
>> > WED version 2 (on MT7986 and later) can offload flows originating from wireless
>> > devices. In order to make that work, ndo_setup_tc needs to be implemented on
>> > the netdevs. This adds the required code to offload flows coming in from WED,
>> > while keeping track of the incoming wed index used for selecting the correct
>> > PPE device.
>> >
>> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> 
>> Hi Felix,
>> 
>> A few nits from my side.
>> 
>> First, please reformat the patch description to have a maximum of 75 characters
>> per line, as suggested by checkpatch.
>> 
>> ...
> 
> One more.
> 
> This seems to conflict with:
> 
>    [PATCH net 1/2] net: ethernet: mtk_eth_soc: fix flow block
> 
> So I guess this series needs to be rebased on that one one at some point.
I don't think this conflicts. My local rebase tests didn't show any 
issues either.

- Felix

