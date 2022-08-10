Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5874A58E7D6
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 09:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiHJHZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 03:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiHJHZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 03:25:19 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAFF17A96
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 00:25:17 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id j8so26108658ejx.9
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 00:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=AvFHvhStEGcte1GswRD29xQS2qzDGouW34aT4oYXVtw=;
        b=gBT5HiIvUlJlvuRC+Gg2Tcvrz6p3n+HzgCEYiYCetQc1aA+kSjmqp140mdbPQ1TNaW
         MsM4gr8cYbhblzrQuTwpeWoBBTiFJFuPvcJDudCQzuwVpCk2dGtzqyxf8oPCCaWjSH6b
         Dq6/9UgA2IN/5mEfqKIbpajfc/oEgHgYJiX1KDLC6f0x0WAGLCRUknSrBE/T90iHv3+E
         /BYqJlTtikpqXb+oDgxU8odFkLCCyx5yT9xIcXylcG69q+yG5J0zKacPNGXlVyz21Ia5
         T8TC7czfoZbxF5E8bbDWSmP3eFTTH89T1VSPrnOP1Ow8Rg8dbwn7pugCTEQb+WVp7yk4
         DTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=AvFHvhStEGcte1GswRD29xQS2qzDGouW34aT4oYXVtw=;
        b=GZNW1SbvgNreVASBOs05cpAni7W6EPpT1Z9MACYGaVGTf6gs5VRWSyWrLFqis/u9yk
         PYM1plEyB0VDl21Wc32dL48xequDr6R8wbUTs7uNzKIX9xoZaynh4/SkJnK744udKF/D
         36C5pVk0v+Z0EAm+JehnTp1CvUL0gOgK+XMugMPh/fiILODQQMeXsmdyrIFfhfTvtctc
         pdDFZZjLZGA9qDhlQPbtfmhLC6T3803bkHR5qVCleX2NK0bH/tfEzxwqVrY9kC5l32BT
         W7aGS+rCEtX0mZQz/LHGqzpII+RgyymBpeNUq68PzXZ2F+NNRymWvTqsRuGjNDOkllIV
         MGSQ==
X-Gm-Message-State: ACgBeo3kvC0UylRx5DceqJCf1fKWXUO9pQFgDPieKAspxZt2728qU3a/
        hIJ5T+fpXybB3zNhg7PleFk=
X-Google-Smtp-Source: AA6agR58HUcfSElRo8naRwvvRLzmdJYflBRDhu4PDGK7jSdL2cU83KQYnDLqy+/524yvjSsQQmERBg==
X-Received: by 2002:a17:907:7243:b0:733:2c:14cf with SMTP id ds3-20020a170907724300b00733002c14cfmr2607521ejc.485.1660116315687;
        Wed, 10 Aug 2022 00:25:15 -0700 (PDT)
Received: from [192.168.2.114] (p5b3dd6ec.dip0.t-ipconnect.de. [91.61.214.236])
        by smtp.gmail.com with ESMTPSA id c16-20020aa7df10000000b0043cf2e0ce1csm7213181edy.48.2022.08.10.00.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 00:25:15 -0700 (PDT)
Message-ID: <48b9ecb8-5685-4ffe-b543-637f711be70e@gmail.com>
Date:   Wed, 10 Aug 2022 09:20:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: Question: Ethernet Phy issues on Colibri IMX8X (imx8qxp) - kernel
 5.19
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        netdev@vger.kernel.org, qiangqing.zhang@nxp.com,
        philipp.rossak@formulastudent.de
References: <90d979b7-7457-34b0-5142-fe288c4206d8@gmail.com>
 <YvMHp0K65a/L0pa4@lunn.ch>
From:   Philipp Rossak <embed3d@gmail.com>
In-Reply-To: <YvMHp0K65a/L0pa4@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10.08.22 03:19, Andrew Lunn wrote:
> On Wed, Aug 10, 2022 at 12:55:58AM +0200, Philipp Rossak wrote:
>> Hi,
>>
>> I currently have a project with a Toradex Colibri IMX8X SOM board whith an
>> onboard Micrel KSZ8041NL Ethernet PHY.
>>
>> The hardware is described in the devictree properly so I expected that the
>> onboard Ethernet with the phy is working.
>>
>> Currently I'm not able to get the link up.
>>
>> I already compared it to the BSP kernel, but I didn't found anything
>> helpful. The BSP kernel is working.
>>
>> Do you know if there is something in the kernel missing and got it running?
> 
> dmesg output might be useful.
> 
> Do you have the micrel driver either built in, or in your initramfs
> image?
> 
> 	Andrew

Hi Andrew,

the driver is built in.

In [1] you find the dmesg log from the 5.19 kernel. I also added the 
DEBUG built flag for the relevant phy and network drivers.

As reference the bsp kernel 5.4.129 kernel [3] works without issues as 
you can see in [2].

Thanks,
Philipp

[1] https://pastebin.com/g4XKw5yY
[2] https://pastebin.com/5t8iAAEu
[3] 
https://git.toradex.com/cgit/linux-toradex.git/tree/?h=toradex_5.4-2.3.x-imx
