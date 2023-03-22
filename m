Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7158B6C4F09
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjCVPJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjCVPJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:09:37 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10AB3BC4E
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DtjCD3LaM1y33vx17RrnD3ZiPZzTzQEesVBUjBrQ89o=; b=FaSA/1adA2yfSaNGH/SCdzz1zA
        6p0IP16kXbn/RVlnmX5JU/XziN0qWT/YPY5bmS0eEPsex0q7pqPgunHfeUH2wkmgzk9lXUMxAbMTJ
        x+zIhFc1EfZwItRAzcZLg6Fnz5D3LVoTZjKv1/UuW6bcIb/lphe4HWZoHKSZ8L2/gFS0=;
Received: from [2a01:598:b1a6:ae43:fdb0:2ef2:7059:9fb7] (helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pf05k-005hlh-GF; Wed, 22 Mar 2023 16:09:32 +0100
Message-ID: <c6c52acc-0203-f4e5-a368-850d9f459b08@nbd.name>
Date:   Wed, 22 Mar 2023 16:09:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 2/2] net: ethernet: mediatek: mtk_ppe: prefer
 newly added l2 flows over existing ones
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org
References: <20230321133609.49591-1-nbd@nbd.name>
 <20230321133609.49591-2-nbd@nbd.name> <ZBsKF4r7bARMFNp0@corigine.com>
Content-Language: en-US
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <ZBsKF4r7bARMFNp0@corigine.com>
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

On 22.03.23 15:00, Simon Horman wrote:
> On Tue, Mar 21, 2023 at 02:36:09PM +0100, Felix Fietkau wrote:
>> When a device is roaming between interfaces and a new flow entry is created,
>> we should assume that its output device is more up to date than whatever
>> entry existed already.
> 
> As per patch 1/2. checkpatch complains that the patch description
> has lines more than 75 characters long.
Will do.

> That aside, this change looks good to me.
> But I'm wondering if it is fixing a bug.
> Or just improving something suboptimal (form a user experience POV).
In my opinion, this is just an improvement, not a bugfix.

Thanks,

- Felix

