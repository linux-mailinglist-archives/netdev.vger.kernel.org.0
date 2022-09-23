Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640D45E827D
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 21:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiIWTWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 15:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbiIWTWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 15:22:12 -0400
Received: from mx12lb.world4you.com (mx12lb.world4you.com [81.19.149.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C3E11BCF7;
        Fri, 23 Sep 2022 12:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CNVABCw0fWEIGTfXgX5AA5FL9U29u3KZGJLPyn0BDEo=; b=MdYLfJRhwmOlNcA8BXYK0orM40
        eYPgvHFpY58zqPaPebr7nIGX4tvpyZgn5bDx2WjJ50qkVadJmYFyXfbjULczpgIYT5TIjhV5Hc4Aa
        Q+MitAdRaTfnsugBRGEkc9CITOX2EKnw8uWjbob8WDKQe0TeWJV0olGb4E78a4y0MCPw=;
Received: from [88.117.54.199] (helo=[10.0.0.160])
        by mx12lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oboFQ-0000g5-Mc; Fri, 23 Sep 2022 21:22:04 +0200
Message-ID: <43c5df4d-3202-32d9-4895-80e95740c3e7@engleder-embedded.com>
Date:   Fri, 23 Sep 2022 21:22:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 2/7] dt-bindings: net: tsnep: Allow additional
 interrupts
Content-Language: en-US
To:     Krzysztof Kozlowski <krzk@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org
References: <20220915203638.42917-1-gerhard@engleder-embedded.com>
 <20220915203638.42917-3-gerhard@engleder-embedded.com>
 <5fffcfcd-6156-d3ba-0d92-39836830359e@kernel.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <5fffcfcd-6156-d3ba-0d92-39836830359e@kernel.org>
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

On 23.09.22 13:32, Krzysztof Kozlowski wrote:
> On 15/09/2022 22:36, Gerhard Engleder wrote:
>> Additional TX/RX queue pairs require dedicated interrupts. Extend
>> binding with additional interrupts.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> 
> Use scripts/get_maintainers.pl to CC all maintainers and relevant
> mailing lists.

Sorry I missed that. Will be done the next time.
