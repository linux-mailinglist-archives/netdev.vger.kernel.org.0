Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CE16455D8
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiLGI5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiLGI5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:57:22 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DEAD77
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 00:57:19 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id a16so23913206edb.9
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 00:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFUuCOOiYpWargj2Hxx4wMeTG9+2i0xp4Xulr1tAh5I=;
        b=w+PrcUPZV5sQabnMiIjAHQDYVNHUfAPdie62LtsU7xJVmWCqBHqmOGKPerEgg+vvNz
         mLFwsVRbBZ5gwsYkcq2TYQU7k2mNOdwJ9DkxT1Cs3DSlF4s9xTENQ9r4S5qFlPHChMjZ
         0WIHZpgVFkK16I1RvSRdIbPYeef37f6IoXnvz20e8wYuojNZBXNApPZMHf0Ap912GY4L
         0umkAAwOSC9Pr3VEBXC4COkjJNDxSYs9qtWbKFuPdf48Ow52XVLbdD+o++GqUz0DZRMv
         xTH24BUAzw7D7biqvLbG7ffVAN5QCKfYrtFaDWY52vPor4OVlbud/TgfSOgRAqaY1S4x
         TiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aFUuCOOiYpWargj2Hxx4wMeTG9+2i0xp4Xulr1tAh5I=;
        b=pI2RiO3Tb/UOCk2u7OX0njIC9PmpdIHrcrww8kKVacD+F9u+PApsx8/GxdnevA+09E
         RMGQuUCKTfCxZpRsG18MsH0pibi6ZKat9XRBRCWEx18qOHopch+EqhnF3mRcqUhF7PVk
         TJhipV7FchW66ei6meGMQw3jW/UpVXDYAs31LaWDW09AK6m8Cwzxa+S8dw6L/1m/VY0m
         W4J9orbO9xyet6SMvCvHD+RXSvFyDk20md1Ua86rCRcGHcHe2X4zmVF9DKTDTtcktRtW
         d6BmEg90n2Q9FFRjhmF+PHwEVcLf7+3CKHNwcMvlEfAcusZZgCn31KSmWRKpWUPI3dqf
         0kCQ==
X-Gm-Message-State: ANoB5pno3Ir1k0Ct1OckZkFjRh66WtTDYzspwTzvhO+YLG14dZ7Iqz/H
        B+I335AWDqK7orSq0blUGYxU4w==
X-Google-Smtp-Source: AA0mqf5WMrbilNVw4TizQyBbN02+ie9mlbjBtzYdH/RCctyU33On5vtBjilGIpk2xE+JkGW6CsVFqA==
X-Received: by 2002:a05:6402:e9c:b0:458:d064:a8c2 with SMTP id h28-20020a0564020e9c00b00458d064a8c2mr8428952eda.346.1670403437959;
        Wed, 07 Dec 2022 00:57:17 -0800 (PST)
Received: from [192.168.31.208] ([194.29.137.22])
        by smtp.gmail.com with ESMTPSA id 2-20020a170906218200b007be886f0db5sm8175707eju.209.2022.12.07.00.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 00:57:17 -0800 (PST)
Message-ID: <0a340c21-7794-dd50-0e5c-90abb37423f2@linaro.org>
Date:   Wed, 7 Dec 2022 09:57:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH v2] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
To:     Linus Walleij <linus.walleij@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend Van Spriel <aspriel@gmail.com>
Cc:     Kalle Valo <kvalo@kernel.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
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
        Rob Herring <robh+dt@kernel.org>, phone-devel@vger.kernel.org
References: <20220921001630.56765-1-konrad.dybcio@somainline.org>
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
 <62566987-6bd2-eed3-7c2f-ec13c5d34d1b@gmail.com>
 <21fc5c0e-f880-7a14-7007-2d28d5e66c7d@linaro.org>
 <CACRpkdbNssF5c7oJnm-EbjAJnD25kv2V7wp+TCKQZnVHJsni-g@mail.gmail.com>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <CACRpkdbNssF5c7oJnm-EbjAJnD25kv2V7wp+TCKQZnVHJsni-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07/12/2022 00:37, Linus Walleij wrote:
> On Tue, Dec 6, 2022 at 10:59 AM Konrad Dybcio <konrad.dybcio@linaro.org> wrote:
> 
>> Yes, it does seem to work just fine! The kernel now looks for
>> brcm/brcmfmac4359c-pcie.sony,kagura-row.bin as we would expect.
> 
> So the Sony kagura needs a special brcmfmac firmware like so many
> other mobile phones. There are a few Samsungs with custom firmware
> as well.
FWIW, Sony did a great job and agreed to license calibration files under 
CC0-1.0 [1] and the firmwares itself [2] have a Broadcom license 
attached to it.

Konrad

[1] 
https://github.com/sonyxperiadev/device-sony-kagura/commit/1f633325a3890864503b5e19f581d1b6a538996c
[2] 
https://github.com/sonyxperiadev/vendor-broadcom-wlan/tree/master/bcmdhd/firmware
> 
> Arend: what is the legal situation with these custom firmwares?
> 
> I was under the impression that Broadcom actually made these,
> so they could in theory be given permission for redistribution in
> linux-firmware?
> 
> Some that I have are newer versions than what is in Linux-firmware,
> e.g this from linux-firmware:
> 
> brcm/brcmfmac4330-sdio.bin
> 4330b2-roml/sdio-ag-pool-ccx-btamp-p2p-idsup-idauth-proptxstatus-pno-aoe-toe-pktfilter-keepalive
> Version: 5.90.125.104 CRC: 2570e6a3 Date: Tue 2011-10-25 19:34:26 PDT
> 
> There is this found in Samsung Codina GT-I8160:
> 4330b2-roml/sdio-g-p2p-aoe-pktfilter-keepalive-pno-ccx-wepso Version:
> 5.99.10.0 CRC: 4f7fccf Date: Wed 2012-12-05 01:02:50 PST FWID
> 01-52653ba9
> 
> Or:
> brcmfmac4334-sdio.bin
> 4334b1min-roml/sdio-ag-pno-p2p-ccx-extsup-proptxstatus-dmatxrc-rxov-pktfilter-keepalive-aoe-vsdb-wapi-wl11d
> Version: 6.10.0.0 CRC: 31410dd4 Date: Tue 2012-06-26 11:33:07 PDT FWID
> 01-8ee3be86
> 
> There is this found in Samsung Golden GT-I8190N:
> 4334b1-roml/sdio-ag-p2p-extsup-aoe-pktfilter-keepalive-pno-dmatxrc-rxov-proptxstatus-vsdb-mchan-okc-rcc-fmc-wepso-txpwr-autoabn-sr
> Version: 6.10.58.99 CRC: 828f9174 Date: Mon 2013-08-26 02:13:44 PDT
> FWID 01-e39d4d77
> 
> So in some cases more than a year newer firmware versions
> compared to linux-firmware, I guess also customized for the
> phones, but I can't really tell because we don't have anything
> of similar date in linux-firmware.
> 
> Yours,
> Linus Walleij
