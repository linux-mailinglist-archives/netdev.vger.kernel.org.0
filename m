Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50644519883
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345425AbiEDHtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345582AbiEDHsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:48:55 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2754310F6;
        Wed,  4 May 2022 00:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1651650277;
        bh=pfo7l2+6NRg3JzR+9KrIDePEDrqA7zKF11o5LYtwEJg=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=d3TNyVHaZZCMyyfKbsrQUNviX4v3RF5SfOoweE6vmaR2/JyBWFRWypYDyjp06Z1DB
         FuBE+0+Udaa3ARZCq5fBT3AykSejo8IhgMbgVSW2VZXyu3xEoIliwkzLa7TWBSMoM2
         GCDzaQVtRipER38qIXCwauuhna5OWspUz/EXvDDY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([80.245.79.168]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MRmfo-1nNQj902p8-00T9ld; Wed, 04
 May 2022 09:44:37 +0200
Date:   Wed, 04 May 2022 09:44:29 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <95aea078-3e85-79c3-79c0-430bd7c0fbae@linaro.org>
References: <20220502153238.85090-1-linux@fw-web.de> <d29637f8-87ff-b5f0-9604-89b51a2ba7c1@linaro.org> <trinity-cda3b94f-8556-4b83-bc34-d2c215f93bcd-1651587032669@3c-app-gmx-bap25> <10770ff5-c9b1-7364-4276-05fa0c393d3b@linaro.org> <trinity-213ab6b1-ccff-4429-b76c-623c529f6f73-1651590197578@3c-app-gmx-bap25> <95aea078-3e85-79c3-79c0-430bd7c0fbae@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: Aw: Re: Re: [RFC v1] dt-bindings: net: dsa: convert binding for mediatek switches
Reply-to: frank-w@public-files.de
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
CC:     Greg Ungerer <gerg@kernel.org>,
        =?ISO-8859-1?Q?Ren=E9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Frank Wunderlich <linux@fw-web.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <69290DD3-0179-49C2-8E7D-9F8DBDEBC96F@public-files.de>
X-Provags-ID: V03:K1:Xi3146xQ+5Emm7jErYnUntzfAYprQLIZghBegsBA0oc7IJk6WZ7
 EN1yKUXY8pzFBl73tvSapxS4fIHqWMvVrkpzm1Iu+ZHscY3V5cEJqpj7clPSPxeAHNTLZLq
 kAhiRrTtFdRmz5z1ZElLYt/qGdFj91Z7CWXWfazFNmqpRklgMAB+8wY9CzSuw3JLP2a3Onz
 ockS0Idi7ssPgd4G6pOAQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SvD6m1ZZk2w=:nHsMDGmebHyxCWsbOOhqYD
 tJ0PHMZ3fVxKUH8cbqp2Lpy7oGvya/82ozlXh7WfaupZ7Bf9hftCqF0yN2Yz7/DfIiWhSDQsR
 xobZopSNltQQHTvmrfFEzYureaXSTUUdS7EgXDzK5tJNCbUaTd7Q7LX/Wup1Mhn6DVJNJpeJZ
 SAV31HJXlN8WqcveBMYJl1gE1aHv0D1wMOUOzsz2+gDUVdTaumYSHF1mp1BbJR6tr781+Lofa
 zCPzk+lJiy3MqbuS89FaeKStJPf+f3VC+lYd3N6PUZJ47Hg4Ok2XMCWsRLM6QME43dxuH6Y4+
 8NCI5g6u1UbYQOpm+Hp6381ErHpWOJwUcVK3wzSBK/PdYx15STdq6swxGeCXazsniOAbIIK0F
 4NmuGLcuDrrtuuX8qPa3L3p+PXmJ7yy8OF5gpcDmIOVORUrHhXrGOJg+99893evc88fcHV7Ia
 7Tnp/0iuzRifFFr/kyKVqY+NDsEQnXGplKHXqDfru1luPdpM2BkiflGVhKoayUNX5+5yXCUKR
 T0rHlxVtu4XT58dMrDjTa2EhdYNNq3AXHjIck/XLkZHYujX1PiEZvF2gRTL/8fL+8GB61sOH8
 s6d2bCw44Y9AzarEyYbPsSqOoH4t/DCPnszAUTsn8HWyfNbXKRCPy4FtKbWHVpnTxOAJKykH0
 Yw2BaXd8qqhkDCtNLT1lc2FzOeAt2PgKdD051V71706+pcCMFZ/iQCR4ujdlsFIJoKJRQKnjr
 Mza88SlwQr5Q9C7knbcvq+sVSpsg1vUDy1Jyv08jjD4LdDmAtgFiGQKxOFOv7hCT/XTia9UnH
 /gQhZyzMmxiVOdlY9eGfc/aMITeIMWheznW6Lyq2FJ3hLpaGI/9e/NNyCbquv8Sk2aisnaAe4
 ZDR76Yxs0Y8Z1quc8rQ6EnGzVeo5HJkw13gCK37XxHeAnOwuSZl3+ZD1z2jmGFnN1PFX/23a+
 Es9UuweDvyE23bhOQc/5nbuT0+YnvsBTfNKuHQqkUOJdy3YVLjnpuGf++pTcmQaWmr32bLkTn
 hMELGm5Dl56aogpxH2xJlgEKll2vhPUIBQanJnZT3L+moBr6fz7fMGHLHqrBcKmdbsdtOQCAp
 6GSaSEtX1hNx+g=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

m 4=2E Mai 2022 08:51:41 MESZ schrieb Krzysztof Kozlowski <krzysztof=2Ekozl=
owski@linaro=2Eorg>:
>On 03/05/2022 17:03, Frank Wunderlich wrote:
>>=20
>> have not posted this version as it was failing in dtbs_check, this
>was how i tried:
>>=20
>>
>https://github=2Ecom/frank-w/BPI-R2-4=2E14/blob/8f2033eb6fcae273580263c3f=
0b31f0d48821740/Documentation/devicetree/bindings/net/dsa/mediatek=2Eyaml#L=
177
>
>You have mixed up indentation of the second if (and missing -)=2E

The "compatible if" should be a child of the "if" above,because phy-mode p=
roperty only exists for cpu-port=2E I can try with additional "-" (but i gu=
ess this is only needed for allOf)

Rob told me that i cannot check compatible in subnode and this check will =
be always true=2E=2E=2Ejust like my experience=2E
I can only make the compatible check at top-level and then need to define =
substructure based on this (so define structure twice)=2E He suggested me a=
dding this to description for now=2E

Imho this can be added later if really needed=2E=2E=2Edid not found any ex=
ample checking for compatible in a subnode=2E All were in top level=2E Afai=
r these properties are handled by dsa-core/phylink and driver only compares=
 constants set there=2E

>(=2E=2E=2E)
>
>>>>
>>>> basicly this "ports"-property should be required too, right?
>>>
>>> Previous binding did not enforce it, I think, but it is reasonable
>to
>>> require ports=2E
>>=20
>> basicly it is required in dsa=2Eyaml, so it will be redundant here
>>=20
>>
>https://elixir=2Ebootlin=2Ecom/linux/v5=2E18-rc5/source/Documentation/dev=
icetree/bindings/net/dsa/dsa=2Eyaml#L55
>>=20
>> this defines it as pattern "^(ethernet-)?ports$" and should be
>processed by dsa-core=2E so maybe changing it to same pattern instead of
>moving up as normal property?
>
>Just keep what is already used in existing DTS=2E

Currently only "ports" is used=2E=2E=2Eso i will change it to "normal" pro=
perty=2E

>>>> for 33 there seem no constant=2E=2Eall other references to pio node a=
re
>with numbers too and there seem no binding
>>>> header defining the gpio pins (only functions in
>include/dt-bindings/pinctrl/mt7623-pinfunc=2Eh)
>>>
>>> ok, then my comment
>>=20
>> you mean adding a comment to the example that GPIO-flags/constants
>should be used instead of magic numbers?
>
>I think something was cut from my reply=2E I wanted to say:
>"ok, then my comment can be skipped"

Ok

>But I think your check was not correct=2E I looked at bpi-r2 DTS
>(mt7623n)
>and pio controller uses GPIO flags=2E

I see only same as in the example

https://elixir=2Ebootlin=2Ecom/linux/latest/source/arch/arm/boot/dts/mt762=
3n-bananapi-bpi-r2=2Edts#L196

>Best regards,
>Krzysztof
regards Frank
