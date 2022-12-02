Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246AB640E6F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbiLBT2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiLBT2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:28:31 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AC9EC09D;
        Fri,  2 Dec 2022 11:28:30 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso9251411pjt.0;
        Fri, 02 Dec 2022 11:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hluiiQByw1+dCrRHvlH7aEddZogxA3+fW7rJrkxdfNA=;
        b=OE1iRk5WwHws5ggtSnqpBcrluG+ciS9Xcc+J85P7Y1SVk5Ofx4XlPfavWM8vaNKeqH
         pL1QzoSKkrarETQBiajAd+DB82N8RTY4ky4DaOYopNo6FHps+pwxUS5TlEsxX4v2W0nE
         qK21YEwz1MYEwB4joO0uF0F1zmFNn78SpFvqsmjxVtN8gDZtYdH2zdqxWSCKXuMAbAhh
         x5dzfli2jYX8wueAUJRXw9nDPFXrYByuqr1fuAuGK4mXqb1+bB6hrW57hkng7VOWHW0Z
         EVxlJKTyzCgeOn3+uZGScBaSjaA58QsskxeguKv3UU6jTs9+u3H3xRG9pGQpZ0tglLes
         h8Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hluiiQByw1+dCrRHvlH7aEddZogxA3+fW7rJrkxdfNA=;
        b=63iGtQCX9rNHt+oDn2sJBGlXkVfQMGuJB03qSAd0kLs5uj6uCQOrHqJcgohhhCsIYA
         K1R5Ex5tQvuOG0xnfJRT6UWMk6DyzDa9mfj+e9SxNdwpvVlvRvFqlOeMU8HbMV7nMKvz
         +a2i1c8hWdru+i+IaMxEfz8By9bCFE9/IHIs0Za2oRxK5j53lHXRQcZYGL+uWeRlOEjG
         VBtKlUkSBrQ6G30UFo57tii+blMeOxvFmqi2aaQHosPy2khHpWr/J+FnU9mRzjycpa6v
         VKQGfodsVvTJsAv2Iicj4OapyJ/LLD2wrq98+A4O+7opo8vtt6KO74BHY9CbKIVb7kRs
         XM2g==
X-Gm-Message-State: ANoB5pnmN3EdPsp04mQwJl0l70+spEJZyct7LmRKs66JndBF6stovfg4
        bRoA3jhDkVghbccnmh1vjow=
X-Google-Smtp-Source: AA0mqf76/vow2VuywgUBYm+ILceIV5wAajNQtYpRp/J7iHR1bLX+XRqAUkXtY4nPH959Sx3F45cLcg==
X-Received: by 2002:a17:902:ee55:b0:189:69cf:9ea0 with SMTP id 21-20020a170902ee5500b0018969cf9ea0mr36838193plo.37.1670009309917;
        Fri, 02 Dec 2022 11:28:29 -0800 (PST)
Received: from [192.168.178.136] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b00183c67844aesm5978028plg.22.2022.12.02.11.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 11:28:29 -0800 (PST)
Message-ID: <62566987-6bd2-eed3-7c2f-ec13c5d34d1b@gmail.com>
Date:   Fri, 2 Dec 2022 20:28:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
Content-Language: en-US
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kalle Valo <kvalo@kernel.org>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        Hector Martin <marcan@marcan.st>,
        "martin.botka@somainline.org" <martin.botka@somainline.org>,
        "angelogioacchino.delregno@somainline.org" 
        <angelogioacchino.delregno@somainline.org>,
        "marijn.suijten@somainline.org" <marijn.suijten@somainline.org>,
        "jamipkettunen@somainline.org" <jamipkettunen@somainline.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>,
        "Zhao, Jiaqing" <jiaqing.zhao@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
 <83b90478-3974-28e6-cf13-35fc4f62e0db@marcan.st>
 <13b8c67c-399c-d1a6-4929-61aea27aa57d@somainline.org>
 <0e65a8b2-0827-af1e-602c-76d9450e3d11@marcan.st>
 <7fd077c5-83f8-02e2-03c1-900a47f05dc1@somainline.org>
 <CACRpkda3uryD6TOEaTi3pPX5No40LBWoyHR4VcEuKw4iYT0dqA@mail.gmail.com>
 <20220922133056.eo26da4npkg6bpf2@bang-olufsen.dk> <87sfke32pc.fsf@kernel.org>
 <4592f87a-bb61-1c28-13f0-d041a6e7d3bf@linaro.org>
 <CACRpkdax-3VVDd29iH51mfumakqM7jyEc8Pbb=AQwAgp2WsqFQ@mail.gmail.com>
 <d03bd4d4-e4ef-681b-b4a5-02822e1eee75@linaro.org> <87fse76yig.fsf@kernel.org>
 <fc2812b1-db96-caa6-2ecb-c5bb2c33246a@linaro.org> <87bkov6x1q.fsf@kernel.org>
 <CACRpkdbpJ8fw0UsuHXGX43JRyPy6j8P41_5gesXOmitHvyoRwQ@mail.gmail.com>
 <28991d2d-d917-af47-4f5f-4e8183569bb1@linaro.org>
 <c83d7496-7547-2ab4-571a-60e16aa2aa3d@broadcom.com>
 <6e4f1795-08b5-7644-d1fa-102d6d6b47fb@linaro.org>
 <af489711-6849-6f87-8ea3-6c8216f0007b@broadcom.com>
From:   Arend Van Spriel <aspriel@gmail.com>
In-Reply-To: <af489711-6849-6f87-8ea3-6c8216f0007b@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2022 4:26 PM, Arend van Spriel wrote:
> On 12/2/2022 11:33 AM, Konrad Dybcio wrote:
>>
>>
>> On 1.12.2022 12:31, Arend van Spriel wrote:
>>> On 11/28/2022 3:40 PM, Konrad Dybcio wrote:
>>>>
>>>>
>>>> On 26.11.2022 22:45, Linus Walleij wrote:
>>>>> On Fri, Nov 25, 2022 at 1:25 PM Kalle Valo <kvalo@kernel.org> wrote:
>>>>>> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
>>>>>>
>>>>>>> On 25.11.2022 12:53, Kalle Valo wrote:
>>>>>>>> Konrad Dybcio <konrad.dybcio@linaro.org> writes:
>>>>>>>>
>>>>>>>>> On 21.11.2022 14:56, Linus Walleij wrote:
>>>>>>>>>> On Fri, Nov 18, 2022 at 5:47 PM Konrad Dybcio 
>>>>>>>>>> <konrad.dybcio@linaro.org> wrote:
>>>>>>>>>>
>>>>>>>>>>> I can think of a couple of hacky ways to force use of 43596 
>>>>>>>>>>> fw, but I
>>>>>>>>>>> don't think any would be really upstreamable..
>>>>>>>>>>
>>>>>>>>>> If it is only known to affect the Sony Xperias mentioned then
>>>>>>>>>> a thing such as:
>>>>>>>>>>
>>>>>>>>>> if (of_machine_is_compatible("sony,xyz") ||
>>>>>>>>>>       of_machine_is_compatible("sony,zzz")... ) {
>>>>>>>>>>      // Enforce FW version
>>>>>>>>>> }
>>>>>>>>>>
>>>>>>>>>> would be completely acceptable in my book. It hammers the
>>>>>>>>>> problem from the top instead of trying to figure out itsy witsy
>>>>>>>>>> details about firmware revisions.
>>>>>>>>>>
>>>>>>>>>> Yours,
>>>>>>>>>> Linus Walleij
>>>>>>>>>
>>>>>>>>> Actually, I think I came up with a better approach by pulling a 
>>>>>>>>> page
>>>>>>>>> out of Asahi folks' book - please take a look and tell me what you
>>>>>>>>> think about this:
>>>>>>>>>
>>>>>>>>> [1]
>>>>>>>>> https://github.com/SoMainline/linux/commit/4b6fccc995cd79109b0dae4e4ab2e48db97695e7
>>>>>>>>> [2]
>>>>>>>>> https://github.com/SoMainline/linux/commit/e3ea1dc739634f734104f37fdbed046873921af7
>>>>>
>>>>> Something in this direction works too.
>>>>>
>>>>> The upside is that it tells all operating systems how to deal
>>>>> with the firmware for this hardware.
>>>>>
>>>>>>>> Instead of a directory path ("brcm/brcmfmac43596-pcie") why not 
>>>>>>>> provide
>>>>>>>> just the chipset name ("brcmfmac43596-pcie")? IMHO it's 
>>>>>>>> unnecessary to
>>>>>>>> have directory names in Device Tree.
>>>>>>>
>>>>>>> I think it's common practice to include a full 
>>>>>>> $FIRMWARE_DIR-relative
>>>>>>> path when specifying firmware in DT, though here I left out the 
>>>>>>> board
>>>>>>> name bit as that's assigned dynamically anyway. That said, if you 
>>>>>>> don't
>>>>>>> like it, I can change it.
>>>>>>
>>>>>> It's just that I have understood that Device Tree is supposed to
>>>>>> describe hardware and to me a firmware directory "brcm/" is a 
>>>>>> software
>>>>>> property, not a hardware property. But this is really for the Device
>>>>>> Tree maintainers to decide, they know this best :)
>>>>>
>>>>> I would personally just minimize the amount of information
>>>>> put into the device tree to be exactly what is needed to find
>>>>> the right firmware.
>>>>>
>>>>> brcm,firmware-compatible = "43596";
>>>>>
>>>>> since the code already knows how to conjure the rest of the string.
>>>>>
>>>>> But check with Rob/Krzysztof.
>>>>>
>>>>> Yours,
>>>>> Linus Walleij
>>>>
>>>> Krzysztof, Rob [added to CC] - can I have your opinions?
>>>
>>> I tried catching up on this thread. Reading it I am not sure what the 
>>> issue is, but I am happy to dive in. If you can provide a boot log 
>>> with brcmfmac loaded with module parameter 'debug=0x1416' I can try 
>>> and make sense of the chipid/devid confusion.
>>
>> Hope this helps, thanks! https://hastebin.com/xidagekuge.yaml
> 
> It does to some extent. It is basically a 4359 revision 9:
> 
> [   25.898782] brcmfmac: brcmf_chip_recognition found AXI chip: BCM4359/9
> 
> The 4359 entry in pcie.c is applicable for revision 0 and higher 
> (doubtful but that is in the code):
> 
>      BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
> 
> We need to change the mask above to 0x000001FF and add a new entry with 
> mask 0xFFFFFE00. All we need is come up with a reasonable firmware 
> filename. So can you run the strings command on the firmware you use:
> 
> $ strings fw.bin | tail -1
> 
> and let me know the output.

Actually realized you already provided a URL to the repo containing the 
firmware you used. So I had a look and it shows:

43596a0-roml/pcie-ag-apcs-pktctx-proptxstatus-ampduhostreorder-lpc-die3-olpc-pspretend-mfp-ltecx-clm_43xx_somc_mimo-phyflags-txpwrctrls-dpo 
Version: 9.75.119.15 (r691661) CRC: a6cf427b Date: Fri 2017-03-24 
13:24:25 KST Ucode Ver: 1060.20542 FWID: 01-e4abc35c

However, from firmware perspective this is equivalent to 4359c0 so I 
would suggest the change below.

Let me know if that works.

Regards,
Arend
---
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c 
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index cf564adc612a..b59cf0f2939c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -55,6 +55,7 @@ BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-pcie");
  BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
  BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
  BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
+BCRMF_FW_DEF(4359C, "brcmfmac4359c-pcie");
  BRCMF_FW_DEF(4364, "brcmfmac4364-pcie");
  BRCMF_FW_DEF(4365B, "brcmfmac4365b-pcie");
  BRCMF_FW_DEF(4365C, "brcmfmac4365c-pcie");
@@ -83,7 +84,8 @@ static const struct brcmf_firmware_mapping 
brcmf_pcie_fwnames[] = {
  	BRCMF_FW_ENTRY(BRCM_CC_43569_CHIP_ID, 0xFFFFFFFF, 43570),
  	BRCMF_FW_ENTRY(BRCM_CC_43570_CHIP_ID, 0xFFFFFFFF, 43570),
  	BRCMF_FW_ENTRY(BRCM_CC_4358_CHIP_ID, 0xFFFFFFFF, 4358),
-	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
+	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0x000001FF, 4359),
+	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFE00, 4359C),
  	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0xFFFFFFFF, 4364),
  	BRCMF_FW_ENTRY(BRCM_CC_4365_CHIP_ID, 0x0000000F, 4365B),
  	BRCMF_FW_ENTRY(BRCM_CC_4365_CHIP_ID, 0xFFFFFFF0, 4365C),

