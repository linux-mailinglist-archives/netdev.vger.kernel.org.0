Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E9D6B37E8
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCJH47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCJH45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:56:57 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A52DDF35
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 23:56:53 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id u9so17069900edd.2
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 23:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678435011;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Na4vhlLIT8h87R1c4saJtnoc0rpStTN6SAaJv5Ui0DU=;
        b=f/cdum7O6TN5gJ9ROGgx6QjE0oljMSgdfelOxJDv/A44aZ7Mm1unTj43LMrAl8qXD3
         sHI50PXnWoUWOCaGf+Lw7NcDVU4NiPijijYupEKrMb/i7yVzAFSIs2Sdxro3W9NWDoHv
         l0FZKC3iXGb6IU9h1xEP+L1xj0TStwEsdmZgH7BeJN1yxjzdFSB6oJFobXTUS45dVs0M
         ULQH07khMas1d0aBIt/OjZLOHVTDe9lhbsnUreYNdh+WszcP/mDLVMMeWmaL4KFGK0LG
         +5HnCCB4hC8JohJPmZdM8SSKIi+lKSrrSUXogyHzjsDGs1U97Mara0hXF/7LevUFdWY9
         OvCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678435011;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Na4vhlLIT8h87R1c4saJtnoc0rpStTN6SAaJv5Ui0DU=;
        b=ALBLL6FBJ2qUAhPKB589dV7Vb3Q7NbsW7q9FccKNOx1Mjay2uDmE9xc8wpDM4XQgxZ
         iOU7gv0quA/2Ne/iGkTe+vfR2pOKgPpzgqVHZrpfp+S+qzgZ/tk3Wz8U1BNWKfh2hicQ
         Y30hs36XQMOG/G/vFV0fR+RI3H/no0QZU8TgwyfpWd6AuYmHUE9PfvmZkbxhptzvRjau
         UK0NJb9SpGAhA41PxUy1Jizk5P8d6IZwPcpad4yphzmUECusBpWfP2Xp4j1LaLVvBGrZ
         6jhVEbuzhjDZgw5ZkcG8jCxb7MblPsCeW6b+POmeCuk2jAyU+ZUuOZ/K0+O1/UAuMeW2
         w8MA==
X-Gm-Message-State: AO0yUKV7FmKiGsE3hfbsHeRugdl7AZpdnJow95AIh1pBmLQoneqYL4zr
        Ag0JNGQbFPwpmAHYBSu/V98jgQ==
X-Google-Smtp-Source: AK7set83ouw7MBm0jqo5iH57IkMFwoOVUzIry7zQggJ4hxcJBeN03UC69xrHLWNGpiqGw+nvqtrohA==
X-Received: by 2002:a17:906:eecc:b0:90b:167e:3050 with SMTP id wu12-20020a170906eecc00b0090b167e3050mr30865633ejb.36.1678435011591;
        Thu, 09 Mar 2023 23:56:51 -0800 (PST)
Received: from [192.168.1.195] ([5.133.47.210])
        by smtp.googlemail.com with ESMTPSA id ox11-20020a170907100b00b008cf6f8798e1sm641097ejb.54.2023.03.09.23.56.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 23:56:50 -0800 (PST)
Message-ID: <6108c68b-e38b-3060-f6fa-53be79a795d7@linaro.org>
Date:   Fri, 10 Mar 2023 07:56:49 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v1 01/15] dt-bindings: add pwrseq device tree bindings
Content-Language: en-US
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Herring <robh@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Abel Vesa <abel.vesa@linaro.org>
References: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
 <20211006035407.1147909-2-dmitry.baryshkov@linaro.org>
 <YXf6TbV2IpPbB/0Y@robh.at.kernel.org>
 <37b26090-945f-1e17-f6ab-52552a4b6d89@linaro.org>
 <CAL_JsqLAnJqZ95_bf6_fFmPJFMjuy43UfP2UxzEmFMNnG_t-Ug@mail.gmail.com>
 <31792ef1-20b0-b801-23b7-29f303b91def@linaro.org>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <31792ef1-20b0-b801-23b7-29f303b91def@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/11/2021 15:26, Dmitry Baryshkov wrote:
> On 28/10/2021 00:53, Rob Herring wrote:
>> On Tue, Oct 26, 2021 at 9:42 AM Dmitry Baryshkov
>> <dmitry.baryshkov@linaro.org> wrote:
>>>
>>> On 26/10/2021 15:53, Rob Herring wrote:
>>>> On Wed, Oct 06, 2021 at 06:53:53AM +0300, Dmitry Baryshkov wrote:
>>>>> Add device tree bindings for the new power sequencer subsystem.
>>>>> Consumers would reference pwrseq nodes using "foo-pwrseq" properties.
>>>>> Providers would use '#pwrseq-cells' property to declare the amount of
>>>>> cells in the pwrseq specifier.
>>>>
>>>> Please use get_maintainers.pl.
>>>>
>>>> This is not a pattern I want to encourage, so NAK on a common binding.
>>>
>>>
>>> Could you please spend a few more words, describing what is not
>>> encouraged? The whole foo-subsys/#subsys-cells structure?
>>
>> No, that's generally how common provider/consumer style bindings work.
>>
>>> Or just specifying the common binding?
>>
>> If we could do it again, I would not have mmc pwrseq binding. The
>> properties belong in the device's node. So don't generalize the mmc
>> pwrseq binding.
>>
>> It's a kernel problem if the firmware says there's a device on a
>> 'discoverable' bus and the kernel can't discover it. I know you have
>> the added complication of a device with 2 interfaces, but please,
>> let's solve one problem at a time.

Just to keep this topic updated with some pointers [1] to changes done 
to solve same problem in USB Hub. These patches 
(drivers/usb/misc/onboard_usb_hub*) have been merged since last year July.

It looks like we can take some inspiration from this to address PCIE Bus 
issue aswell.

Thanks to Neil to point this.

[1] 
https://lore.kernel.org/lkml/20220630193530.2608178-1-mka@chromium.org/T/


--srini
> 
> The PCI bus handling is a separate topic for now (as you have seen from 
> the clearly WIP patches targeting just testing of qca6390's wifi part).
> 
> For me there are three parts of the device:
> - power regulator / device embedded power domain.
> - WiFi
> - Bluetooth
> 
> With the power regulator being a complex and a bit nasty beast. It has 
> several regulators beneath, which have to be powered up in a proper way.
> Next platforms might bring additional requirements common to both WiFi 
> and BT parts (like having additional clocks, etc). It is externally 
> controlled (after providing power to it you have to tell, which part of 
> the chip is required by pulling up the WiFi and/or BT enable GPIOs.
> 
> Having to duplicate this information in BT and WiFi cases results in 
> non-aligned bindings (with WiFi and BT parts using different set of 
> properties and different property names) and non-algined drivers (so the 
> result of the powerup would depend on the order of drivers probing).
> 
> So far I still suppose that having a single separate entity controlling 
> the powerup of such chips is the right thing to do.
> 
> I'd prefer to use the power-domain bindings (as the idea seems to be 
> aligned here), but as the power-domain is used for the in-chip power 
> domains, we had to invent the pwrseq name.
> 
