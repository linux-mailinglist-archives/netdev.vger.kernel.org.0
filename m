Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5382A51C04E
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378845AbiEENPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376871AbiEENPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:15:00 -0400
Received: from smtp14.infineon.com (smtp14.infineon.com [IPv6:2a00:18f0:1e00:4::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9AC27B2C;
        Thu,  5 May 2022 06:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1651756277; x=1683292277;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xsOMw0gRr0SLaJWZpts/Mm92RAFuNPJLPsaz21uD8Ww=;
  b=FBTSHmIlIdE832JlYBLV7yOCvXGSjOOwpLTBWKHtzOzjmCfjmz9rzAKT
   0BurVxBjCa9jduMfm3+7mZHyRjYUAjriT8gY/3ybC5xmgdipJWU2AsiEa
   NX3XcawdsVI08o9UUxR4Dv6ixanp/bGT2Wb3Fs5tjNkHWFaZ4JkqBtHWF
   Y=;
X-SBRS: None
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="119355111"
X-IronPort-AV: E=Sophos;i="5.91,201,1647298800"; 
   d="scan'208";a="119355111"
Received: from unknown (HELO mucxv001.muc.infineon.com) ([172.23.11.16])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 15:11:12 +0200
Received: from MUCSE812.infineon.com (MUCSE812.infineon.com [172.23.29.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mucxv001.muc.infineon.com (Postfix) with ESMTPS;
        Thu,  5 May 2022 15:11:12 +0200 (CEST)
Received: from MUCSE807.infineon.com (172.23.29.33) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 5 May 2022
 15:11:12 +0200
Received: from [10.160.221.24] (172.23.8.247) by MUCSE807.infineon.com
 (172.23.29.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 5 May 2022
 15:11:11 +0200
Message-ID: <1e8cfbc6-8452-0e87-9713-536d235e5b51@infineon.com>
Date:   Thu, 5 May 2022 15:11:09 +0200
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
From:   Hakan Jansson <hakan.jansson@infineon.com>
In-Reply-To: <CACRpkdY3xPcyNcJfdGbSP5rdcUV6hr87yJNDVDGZdRCfN+MqLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.23.8.247]
X-ClientProxiedBy: MUCSE805.infineon.com (172.23.29.31) To
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

Hi Linus,

Thanks for responding.

On 5/5/2022 12:15 AM, Linus Walleij wrote:
> On Wed, May 4, 2022 at 11:04 AM Hakan Jansson
> <hakan.jansson@infineon.com> wrote:
>
>> +  brcm,uses-autobaud-mode:
>> +    type: boolean
>> +    description: >
>> +      The controller should be started in autobaud mode by asserting
>> +      BT_UART_CTS_N (i.e. host RTS) during startup. Only HCI commands supported
>> +      in autobaud mode should be used until patch FW has been loaded.
> Things like gnss uses the current-speed attribute to set a serial link speed,
> maybe also Bluetooth?
As far as I can tell, not many Bluetooth drivers use the current-speed 
attribute yet but perhaps it would be a good idea to start using it more 
broadly in the future to set the initial serial link speed.

>
> Would it make sense to use
>
> current-speed-auto;
>
> As a flag for these things in general?
I suppose a general flag could be useful but to be honest I don't know 
if any other devices besides the ones using the Broadcom driver has any 
use for it. You would probably also still want to be able to use 
current-speed to set the link speed and end up using both 
current-speed=x and current-speed-auto at the same time, which might 
look a little confusing?

Please let me know if you'd still prefer "current-speed-auto" over 
"brcm,uses-autobaud-mode" and I'll revise the patch and rename it!

>
> Yours,
> Linus Walleij

Thanks,
Håkan
