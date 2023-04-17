Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E876E4428
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjDQJky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjDQJkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:40:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B476EBF;
        Mon, 17 Apr 2023 02:39:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 958C9620FB;
        Mon, 17 Apr 2023 09:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A95C433EF;
        Mon, 17 Apr 2023 09:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681724342;
        bh=1uorpTMHkFqpZA4T6bDoEtA6/LqIAMt2Atw6Gugzt6Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Um7WLR1eSeWGdLVC7KRWp0f6anMSnLgAlSy5AYL6et1S/R70k5QeQVMW9SlBUp2tF
         9BfmPQQGpvpj9FBx/sh+3y6wIQr3AEbhhXo/MpAi6gd41PvzqnnqPBGpHeJRNjEOe/
         Kkx2Ycow71drfrrQ5ZtBqbY+CtiwX9on/HfoL9ue5r2rLK3phtnno+NmZJhlSbuXSD
         ZWWggeIebyydOrqfi0v5M2BAnmxNykej9VVFApaRQ7SjqlveMEf5s1udAIjDOyZz5N
         mlqrQc/q5fmvN5B/FhEgbocZYgfsTlj1FnMVmVLRFxU91sQQOMU9PqiYrDoozOIoa6
         JipolWldjk/mA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez?= Rojas <noltari@gmail.com>,
        f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        toke@toke.dk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, chunkeey@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: net: wireless: ath9k: document endian check
References: <20230417053509.4808-1-noltari@gmail.com>
        <20230417053509.4808-2-noltari@gmail.com>
        <dd1525de-fa91-965f-148a-f7f517ae48f9@kernel.org>
Date:   Mon, 17 Apr 2023 12:38:54 +0300
In-Reply-To: <dd1525de-fa91-965f-148a-f7f517ae48f9@kernel.org> (Krzysztof
        Kozlowski's message of "Mon, 17 Apr 2023 09:19:58 +0200")
Message-ID: <87wn2ax2z5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzk@kernel.org> writes:

>> --- a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
>> +++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
>> @@ -44,6 +44,11 @@ properties:
>>  
>>    ieee80211-freq-limit: true
>>  
>> +  qca,endian-check:
>> +    $ref: /schemas/types.yaml#/definitions/flag
>> +    description:
>> +      Indicates that the EEPROM endianness should be checked
>
> Does not look like hardware property. Do not instruct what driver should
> or should not do. It's not the purpose of DT.

Also the documentation is vague and is not really telling anything new
what could be figured out from the property name, I would not be able to
understand just from this what value should be used.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
