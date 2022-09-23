Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110575E8292
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 21:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbiIWT3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 15:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiIWT3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 15:29:42 -0400
Received: from mx12lb.world4you.com (mx12lb.world4you.com [81.19.149.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43101193DC;
        Fri, 23 Sep 2022 12:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rPCrmsnBQ58sl0n+Z35Km4yYNDsubjMeEJP3WkAxStc=; b=h47vz9x3/UsbhEc4g5W2KgUPil
        2P/wl8wNX3LmLLd7cucPfBYLBVxFimUgQQwrdJzCxRumufbHizySW1/1Qv5SOAd4CMDJLVhlJqENA
        0gMuEtMO3pTl2uwjqY1gYd/xSLUbSkQgTVqg3Z4+T3i3PzW0awLzZdNBYO00q/QCaDOE=;
Received: from [88.117.54.199] (helo=[10.0.0.160])
        by mx12lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oboMg-00026g-R3; Fri, 23 Sep 2022 21:29:34 +0200
Message-ID: <cb64b461-b0e4-8465-42c6-5d39ea373fc1@engleder-embedded.com>
Date:   Fri, 23 Sep 2022 21:29:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 5/7] tsnep: Add EtherType RX flow classification
 support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20220915203638.42917-1-gerhard@engleder-embedded.com>
 <20220915203638.42917-6-gerhard@engleder-embedded.com>
 <20220921175950.6d256ffa@kernel.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20220921175950.6d256ffa@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.09.22 02:59, Jakub Kicinski wrote:
> On Thu, 15 Sep 2022 22:36:35 +0200 Gerhard Engleder wrote:
>> +	if (!rule) {
>> +		mutex_unlock(&adapter->rxnfc_lock);
>> +
>> +		return -EINVAL;
> 
> nit: maybe -ENOENT in cases when rule was not found?

I will fix both locations.
