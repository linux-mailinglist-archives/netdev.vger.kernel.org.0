Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63E135C45C
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239674AbhDLKt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:49:56 -0400
Received: from relay07.th.seeweb.it ([5.144.164.168]:46079 "EHLO
        relay07.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239190AbhDLKty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 06:49:54 -0400
Received: from IcarusMOD.eternityproject.eu (unknown [2.237.20.237])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by m-r2.th.seeweb.it (Postfix) with ESMTPSA id DC0313ED8B;
        Mon, 12 Apr 2021 12:39:37 +0200 (CEST)
Subject: Re: [PATCH] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        phone-devel@vger.kernel.org
Cc:     ~postmarketos/upstreaming@lists.sr.ht, martin.botka@somainline.org,
        marijn.suijten@somainline.org,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210307113550.7720-1-konrad.dybcio@somainline.org>
 <5e7b575a-7820-3d10-8617-36911d49f4a9@broadcom.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>
Message-ID: <754923af-407e-05f8-148e-4c2a3faf42ab@somainline.org>
Date:   Mon, 12 Apr 2021 12:39:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <5e7b575a-7820-3d10-8617-36911d49f4a9@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 12/04/21 10:36, Arend van Spriel ha scritto:
> On 07-03-2021 12:35, Konrad Dybcio wrote:
>> Add support for BCM43596 dual-band AC chip, found in
>> SONY Xperia X Performance, XZ and XZs smartphones (and
>> *possibly* other devices from other manufacturers).
>> The chip doesn't require any special handling and seems to work
>> just fine OOTB.
>>
>> PCIe IDs taken from: 
>> https://github.com/sonyxperiadev/kernel/commit/9e43fefbac8e43c3d7792e73ca52a052dd86d7e3.patch 
>>
> 
> I don't see 4359 firmware in linux-firmware repo so what are you using?
> 
> Regards,
> Arend

Hi Arend,

we are using firmwares that come with our specific Sony devices, as we 
couldn't find any generic one.
Pushing firmwares around is something that we tend to be careful about 
because, as you know, they are usually covered with proprietary licenses 
and such.

If anyone from Broadcom can help us by pushing "generic" firmwares for 
this chip on linux-firmware, we would largely appreciate that.

Yours,
- Angelo
