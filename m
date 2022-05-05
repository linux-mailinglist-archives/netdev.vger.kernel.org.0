Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F8C51BB67
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 11:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236699AbiEEJKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 05:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbiEEJKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 05:10:33 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607584B41B;
        Thu,  5 May 2022 02:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1651741573;
        bh=PE49ljxOaJbEZXi8zE0UMbSilxTIkum0Hyl9KtNCWhk=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=VUzb45/7jJ0QvY1LxJ8fGd5PIAHk5tdZv7WCsWGN7HfaLTECfsZkWen2XvyKS2Gcj
         8kH0TsJ3fjICqkzk+WMAkUiLt9Bn1doMlT+h/XRlLyxtX+9DYHnXTl42I6LxeNibw+
         Z5m/D4xAVI5EUTEwdTqGLboOd5OI7EtfGKKkEX84=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([217.61.145.208]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MO9z7-1nSWYG34kz-00OWh0; Thu, 05
 May 2022 11:06:13 +0200
Date:   Thu, 05 May 2022 11:06:05 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <313a5b2e-c571-a13f-3447-b1cd7200f4c9@linaro.org>
References: <20220430130347.15190-1-linux@fw-web.de> <20220430130347.15190-5-linux@fw-web.de> <20220504152450.cs2afa4hwkqp5b5m@skbuf> <trinity-9f557027-8e00-4a4a-bc19-bc576e163f7b-1651678399970@3c-app-gmx-bs42> <20220504154720.62cwrz7frjkjbb7u@skbuf> <313a5b2e-c571-a13f-3447-b1cd7200f4c9@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC v2 4/4] arm64: dts: rockchip: Add mt7531 dsa node to BPI-R2-Pro board
Reply-to: frank-w@public-files.de
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <D201CE50-280C-4089-BB9F-053FEA28FE9A@public-files.de>
X-Provags-ID: V03:K1:fswHZVyF/lRZd8JVwCdyHBJTeHXeAmwGzgMDMSGIdz0hDXO4adf
 6DNQ7Hdu1vjFnafdsMjLokD96/xSHtW4P+JlwGF2ydVvccgeJQBGyVtf7/ZDzMAqCho34s6
 sqGM3PaZ3PFndCo6VMXLcocAJLEHxA55eeaTeLXVgZvDzQ8Eq5RrHCw/S+odtiUpd+qjGwv
 hU0vAPDjw5yIm6bXegJYA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:j9Ro5GzlgnE=:y3PubMXQ+/zpI4KYSQDupN
 oJQ4JRWONcKWVYZCKX5H33jQSFgLL0YuSvZjmf5jpfD9ZjxI1yRt3sXo5C6rRn34aoaYXcKP5
 /4H0dcXerNyfkv11BLsVwX2VgZQOxaQjNLpXLl3aGa3zNBYwqcSzz/EdExVhA9cuEf8sEgCfn
 0wnFgq+SwuViwDNEq/HpuRQQaFDuxy1QDlx+o2nvYr3Hz788H0tqJwVfEMaWelJU+mtfwaBe6
 NzkUsrZ2U2B9dvCi+VSuW/GkhIMUw1KQlWZ4UKCNFtJAZmcwrMSIxIFOvJPEwDUaXgtE10z50
 7Fiv/v8B6y2qiSGvW/ReSyVbVgmgZhe1YtU8E2XzI5TXrt7rFOQw87hJkp/crzLFShocXerQ7
 zm4WJks0YVv+1oltOdPUFIspJjubkzbv6XYiF6BdA+1CMEaKHrstBYrKXswB30nDsqcWhzjrw
 /kfzpB34G2xm9xqFsI5fuR9s77kfUsVeA4d6UFGAhBhHRaclbOsFaHtbFhSIhSHIwg9bwKVIh
 92vmwoTI+2PqW/yiSDF3TKfSwd/vsdlZzF0+C3hwSi8Ko6/PFLXSWUVCWgA6nexfzcs1aVEqx
 0I4/Z32mTAh00UsfdTLvjzeqkIgzoNRB74Sjxg+mFyaD/zrL38u74bF3LB109QcvBTTxYlG9y
 NKZZ0Zue4kRVXXJ6jMvnCicYjwWrdHSKgW4nTT6d0Q9LhQb0mHnA0HN/m+BJRQLa7q2oQQHKz
 0lwS8B3plWBqraGPjKNqjhvTh/56cN9zvWWnXKNGA62Iayo5NAHKrVcuLPVUF1JFtbX4RVL3+
 rYbffYZn8AWErO/QSmfeoOWLPRiCSw5iQs214Qy7h2QgFe2mQb+BXSiZxLW1fQag1q+c3QUwT
 JRy7cyct7nh15eyCpady/PJZVyrV2v1SdKAZz2u5iF4aPZfy1qvV5C/lyUwqqEz/Q3Uael2IP
 M5nkUJKzCP6lIJUeLYU0LtyfFwZAAF/cyKyNAcZ3UvmQ8Rh1OFJadwYuyxLyRXiP3Wi6XDTAT
 gia7QCQap4UUaPAopLvQFtwWb0Gm66A9uYYycp2oQfnUWkuMSVGRNbufUVlKGNuB9pIvr8uQE
 88aNqbN5kytPzg=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 5=2E Mai 2022 10:46:55 MESZ schrieb Krzysztof Kozlowski <krzysztof=2Ekoz=
lowski@linaro=2Eorg>:
>On 04/05/2022 17:47, Vladimir Oltean wrote:
>>>
>>> current device-tree nodes using "switch" and "ports"
>>>
>>> see discussioon here about make it fixed to "ports" property instead
>of PatternProperties including optional "ethernet-"
>>>
>>>
>https://patchwork=2Ekernel=2Eorg/project/linux-mediatek/patch/20220502153=
238=2E85090-1-linux@fw-web=2Ede/#24843155
>>=20
>> Hmm, I don't get why Krzysztof said to just keep what is used in
>> existing device trees=2E The schema validator should describe what is
>> valid,=20
>
>These were talks about bindings which describe hardware=2E The node name,
>except Devicetree spec asking for generic names, does not matter here
>actually=2E
>
>> and since the mt7530 driver does not care one way or another
>> (some drivers do explicitly parse the "ports"/"ethernet-ports" node),
>> then whatever is valid for the DSA core is also valid for the mt7530
>> bindings=2E And "ethernet-ports" is valid too, so I think it should be
>> accepted by mediatek=2Eyaml=2E=2E=2E
>
>You can make it "(ethernet-)?ports" as well=2E My comment was purely to
>make it simpler, for bindings (goes into properties, not
>patternProperties) and for us=2E If you prefer to keep it like DSA core,
>also fine=2E

Ok, i'm also thinking, the dsa-definition will be the right way (pattern-p=
roperties with optional "ethernet-") in binding=2E

Should i use "ethernet-ports" instead of "ports" here? Current dts with mt=
7530/mt7531 switches using "ports" so i would use it here too=2E If dsa pre=
fer ethernet-ports now it should be changed in other files too=2E

>Best regards,
>Krzysztof

Hi,
regards Frank
