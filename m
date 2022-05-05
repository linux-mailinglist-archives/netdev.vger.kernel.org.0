Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B601251C4F8
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381826AbiEEQUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381266AbiEEQU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:20:28 -0400
Received: from smtp2.infineon.com (smtp2.infineon.com [IPv6:2a00:18f0:1e00:4::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34ACC5B8AB;
        Thu,  5 May 2022 09:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1651767408; x=1683303408;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=e4ygsikyJl0tMYtfWtwA8j3Qi+E39Mbf/ZG9ORl73wk=;
  b=LGu7GDoybbUgiB7+LbMIePQzOrWIaWWnEu9lzUYEwG3011bsjXHOW+Fc
   7K1b9qbi/NcXPtRILU+ZnbMxJlDSFpSf8MjJH9Jgk517zGrX6VuzruzAM
   IO8Bv8q7MTk8vQgNKeiW7nbbihP6nhJ/oBomklEFLin8pQTy9AIvrKJ6U
   E=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="176210663"
X-IronPort-AV: E=Sophos;i="5.91,201,1647298800"; 
   d="scan'208";a="176210663"
Received: from unknown (HELO mucxv002.muc.infineon.com) ([172.23.11.17])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 18:16:46 +0200
Received: from MUCSE812.infineon.com (MUCSE812.infineon.com [172.23.29.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv002.muc.infineon.com (Postfix) with ESMTPS;
        Thu,  5 May 2022 18:16:46 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 5 May 2022
 18:16:46 +0200
Received: from [10.160.221.24] (172.23.8.247) by MUCSE807.infineon.com
 (172.23.29.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 5 May 2022
 18:16:45 +0200
Message-ID: <d35fff90-ded7-2b1a-0e1a-f2db14cc4d07@infineon.com>
Date:   Thu, 5 May 2022 18:16:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/2] dt-bindings: net: broadcom-bluetooth: Add property
 for autobaud mode
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
References: <cover.1651647576.git.hakan.jansson@infineon.com>
 <64b59ca66cc22e6433a044e7bba2b3e97c810dc2.1651647576.git.hakan.jansson@infineon.com>
 <CACRpkdY3xPcyNcJfdGbSP5rdcUV6hr87yJNDVDGZdRCfN+MqLA@mail.gmail.com>
 <1e8cfbc6-8452-0e87-9713-536d235e5b51@infineon.com>
 <CACRpkda4ByrS8RGAunno_S59+Y2yado4eObzwsVkM2Q=n-B+CQ@mail.gmail.com>
From:   Hakan Jansson <hakan.jansson@infineon.com>
In-Reply-To: <CACRpkda4ByrS8RGAunno_S59+Y2yado4eObzwsVkM2Q=n-B+CQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE816.infineon.com (172.23.29.42) To
 MUCSE807.infineon.com (172.23.29.33)
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/2022 4:13 PM, Linus Walleij wrote:
> I suppose a general flag could be useful but to be honest I don't know
>> if any other devices besides the ones using the Broadcom driver has any
>> use for it. You would probably also still want to be able to use
>> current-speed to set the link speed and end up using both
>> current-speed=x and current-speed-auto at the same time, which might
>> look a little confusing?
> I do not think it is more confusing than being able to use
> current-speed and brcm,uses-autobaud-mode at the same time.
>
>> Please let me know if you'd still prefer "current-speed-auto" over
>> "brcm,uses-autobaud-mode" and I'll revise the patch and rename it!
> It actually depends a bit.
>
> This:
>
>>>> +      The controller should be started in autobaud mode by asserting
>>>> +      BT_UART_CTS_N (i.e. host RTS) during startup. Only HCI commands supported
>>>> +      in autobaud mode should be used until patch FW has been loaded.
> sounds a bit vague?

Yes, perhaps. I was thinking the details could be helpful but I can see 
how they might be perceived as vague and confusing. Maybe it would be 
better to just leave it at "The controller should be started in autobaud 
mode"?

>
> Does it mean that CTS is asserted, then you send a bit (CTS then goes low)
> and then CTS is asserted again when the device is ready to receieve more
> data? i.e is this some kind of one-bit mode, because it doesn't sound like
> it is using CTS as it was used in legacy modems.

CTS and RTS are actually used in the normal way during communication. 
The host will assert its RTS to indicate being ready to receive data 
from the controller. This flag just controls whether this happens before 
or after the controller is powered on. The controller will check the 
initial state of its BT_UART_CTS_N pin (connected to host's RTS) when 
starting up. It will enter autobaud mode if the signal is already asserted.

> Some more explanation of this mode is needed so we can understand if
> this is something generic or a BRCM-only thing.
>
> Yours,
> Linus Walleij

Thanks,
Håkan
