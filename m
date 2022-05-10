Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CF052214D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347450AbiEJQhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244652AbiEJQhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:37:03 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFD52A3770;
        Tue, 10 May 2022 09:33:03 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 204so12581838pfx.3;
        Tue, 10 May 2022 09:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=GjChMeNIzLiRvrSn8OnMS9zcuWEpvcpYPPQEksMqNGI=;
        b=bcyxtS0zXZzZrIZG8OlMxLI+eozWOBw8yBXTHalpQHG0E5TazrSpDnh7D3rNFWzkzN
         wfjfnD/iVbRHWwRrA+RtTtdtZVlKxykzNIoqt6DFiUslxUzqHXK6SpoWv10lFpTQwIUY
         A//+noQiZq9IKZ6BJrQyP/cL5rtMBCjjJt7omr9HJcawrQX9xg2H8/cLr4nDxGI5Gz0F
         HpO4xC4X2pittWAFwTVNSaTgE+75pJoT8kuo5DqOnrRlJEOzQO1aajNlKTwfMz7O2Ism
         xYyZQqf2mth185epzKs2yRr6oDhJHY/KRdNWTnqO5KCDuIOM7FRPPTd77vGp8ejP1Yvc
         5lgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=GjChMeNIzLiRvrSn8OnMS9zcuWEpvcpYPPQEksMqNGI=;
        b=tkNECMNrjo4HutJqP3jCIOdX6fO3FYUPYMJYvR8o3PVOId0flp+GOewevA8XX+JALz
         Afe6M6V99DVZg27cs8zhOn2xhwHhxqt7S8oMsPZriY8ldKWH4lHOvS4zobdURkrAaUfa
         3nk+0H9MAe+g2SoTXYGPmiEB0dHNgDQTdfNc/xUo3lSWVNyF1+d9b0Vtk4Dk88F7MH1q
         CtT8Ws90Z5hj4t76MznbPV6+gaZGv3c2uLXjr7h5GhqM444z8jZHYuIE6H+G3OldiRMC
         kYFWB1Oji6mFRAf4cARGIMapnZSmK52Qdhs48Ad6hjAMIQGPSKuEp4BMoMonFnTlgZYM
         ZVDQ==
X-Gm-Message-State: AOAM531K7TQ6EdO3dQie/Z4IBqHs45KqPH2S48weUc6dZJlxVkf8fUed
        YqB61vDRkWn72584+Qr4IQU=
X-Google-Smtp-Source: ABdhPJz9k4askbfK9UmXvCcoQt2SxJ5gdVOhVd8QLLwCmfXZIYhwsJq/C690+7p+klwQYuQVaetEMQ==
X-Received: by 2002:a63:86c6:0:b0:3ab:2c2c:42e9 with SMTP id x189-20020a6386c6000000b003ab2c2c42e9mr17280836pgd.230.1652200383080;
        Tue, 10 May 2022 09:33:03 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o2-20020a63e342000000b003c14af5063esm10630940pgj.86.2022.05.10.09.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 09:33:02 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------9QHY3eIOD3o2Kvoq1xEXNc8i"
Message-ID: <e31809b6-6f57-111b-3e01-76bfa69f9796@gmail.com>
Date:   Tue, 10 May 2022 09:32:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v4 07/12] net: dsa: rzn1-a5psw: add statistics
 support
Content-Language: en-US
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=c3=a8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <20220509131900.7840-1-clement.leger@bootlin.com>
 <20220509131900.7840-8-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220509131900.7840-8-clement.leger@bootlin.com>
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------9QHY3eIOD3o2Kvoq1xEXNc8i
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/9/22 06:18, Clément Léger wrote:
> Add statistics support to the rzn1-a5psw driver by implementing the
> following dsa_switch_ops callbacks:
> - get_sset_count()
> - get_strings()
> - get_ethtool_stats()
> - get_eth_mac_stats()
> - get_eth_ctrl_stats()
> - get_rmon_stats()
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>   drivers/net/dsa/rzn1_a5psw.c | 178 +++++++++++++++++++++++++++++++++++
>   drivers/net/dsa/rzn1_a5psw.h |  46 ++++++++-
>   2 files changed, 223 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> index 1e2fac80f3e0..46ba25672593 100644
> --- a/drivers/net/dsa/rzn1_a5psw.c
> +++ b/drivers/net/dsa/rzn1_a5psw.c
> @@ -17,6 +17,61 @@
>   
>   #include "rzn1_a5psw.h"
>   
> +struct a5psw_stats {
> +	u16 offset;
> +	const char name[ETH_GSTRING_LEN];
> +};
> +
> +#define STAT_DESC(_offset, _name) {.offset = _offset, .name = _name}

You can build a more compact representation as long as you keep the 
offset constant and the name in sync, the attached patch and leverage 
the __stringify() macro to construct the name field:

-#define STAT_DESC(_offset, _name) {.offset = _offset, .name = _name}
+#define STAT_DESC(_offset) {   \
+       .offset = A5PSW_##_offset,      \
+       .name = __stringify(_offset),   \
+}

The attached patch does the conversion if you want to fixup into your 
commit.
-- 
Florian
--------------9QHY3eIOD3o2Kvoq1xEXNc8i
Content-Type: text/x-patch; charset=UTF-8; name="rzn1_a5psw.c.diff"
Content-Disposition: attachment; filename="rzn1_a5psw.c.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9yem4xX2E1cHN3LmMgYi9kcml2ZXJzL25l
dC9kc2EvcnpuMV9hNXBzdy5jCmluZGV4IGVmOWQ4ZWY5NjFiNS4uNGU1Mjg5ODE4N2E1IDEw
MDY0NAotLS0gYS9kcml2ZXJzL25ldC9kc2EvcnpuMV9hNXBzdy5jCisrKyBiL2RyaXZlcnMv
bmV0L2RzYS9yem4xX2E1cHN3LmMKQEAgLTIyLDU0ICsyMiw1MCBAQCBzdHJ1Y3QgYTVwc3df
c3RhdHMgewogCWNvbnN0IGNoYXIgbmFtZVtFVEhfR1NUUklOR19MRU5dOwogfTsKIAotI2Rl
ZmluZSBTVEFUX0RFU0MoX29mZnNldCwgX25hbWUpIHsub2Zmc2V0ID0gX29mZnNldCwgLm5h
bWUgPSBfbmFtZX0KKyNkZWZpbmUgU1RBVF9ERVNDKF9vZmZzZXQpIHsJXAorCS5vZmZzZXQg
PSBBNVBTV18jI19vZmZzZXQsIAlcCisJLm5hbWUgPSBfX3N0cmluZ2lmeShfb2Zmc2V0KSwJ
XAorfQogCiBzdGF0aWMgY29uc3Qgc3RydWN0IGE1cHN3X3N0YXRzIGE1cHN3X3N0YXRzW10g
PSB7Ci0JU1RBVF9ERVNDKEE1UFNXX2FGcmFtZXNUcmFuc21pdHRlZE9LLCAiYUZyYW1lVHJh
bnNtaXR0ZWRPSyIpLAotCVNUQVRfREVTQyhBNVBTV19hRnJhbWVzUmVjZWl2ZWRPSywgImFG
cmFtZVJlY2VpdmVkT0siKSwKLQlTVEFUX0RFU0MoQTVQU1dfYUZyYW1lQ2hlY2tTZXF1ZW5j
ZUVycm9ycywgImFGcmFtZUNoZWNrU2VxdWVuY2VFcnJvcnMiKSwKLQlTVEFUX0RFU0MoQTVQ
U1dfYUFsaWdubWVudEVycm9ycywgImFBbGlnbm1lbnRFcnJvcnMiKSwKLQlTVEFUX0RFU0Mo
QTVQU1dfYU9jdGV0c1RyYW5zbWl0dGVkT0ssICJhT2N0ZXRzVHJhbnNtaXR0ZWRPSyIpLAot
CVNUQVRfREVTQyhBNVBTV19hT2N0ZXRzUmVjZWl2ZWRPSywgImFPY3RldHNSZWNlaXZlZE9L
IiksCi0JU1RBVF9ERVNDKEE1UFNXX2FUeFBBVVNFTUFDQ3RybEZyYW1lcywgImFUeFBBVVNF
TUFDQ3RybEZyYW1lcyIpLAotCVNUQVRfREVTQyhBNVBTV19hUnhQQVVTRU1BQ0N0cmxGcmFt
ZXMsICJhUnhQQVVTRU1BQ0N0cmxGcmFtZXMiKSwKLQlTVEFUX0RFU0MoQTVQU1dfaWZJbkVy
cm9ycywgImlmSW5FcnJvcnMiKSwKLQlTVEFUX0RFU0MoQTVQU1dfaWZPdXRFcnJvcnMsICJp
Zk91dEVycm9ycyIpLAotCVNUQVRfREVTQyhBNVBTV19pZkluVWNhc3RQa3RzLCAiaWZJblVj
YXN0UGt0cyIpLAotCVNUQVRfREVTQyhBNVBTV19pZkluTXVsdGljYXN0UGt0cywgImlmSW5N
dWx0aWNhc3RQa3RzIiksCi0JU1RBVF9ERVNDKEE1UFNXX2lmSW5Ccm9hZGNhc3RQa3RzLCAi
aWZJbkJyb2FkY2FzdFBrdHMiKSwKLQlTVEFUX0RFU0MoQTVQU1dfaWZPdXREaXNjYXJkcywg
ImlmT3V0RGlzY2FyZHMiKSwKLQlTVEFUX0RFU0MoQTVQU1dfaWZPdXRVY2FzdFBrdHMsICJp
Zk91dFVjYXN0UGt0cyIpLAotCVNUQVRfREVTQyhBNVBTV19pZk91dE11bHRpY2FzdFBrdHMs
ICJpZk91dE11bHRpY2FzdFBrdHMiKSwKLQlTVEFUX0RFU0MoQTVQU1dfaWZPdXRCcm9hZGNh
c3RQa3RzLCAiaWZPdXRCcm9hZGNhc3RQa3RzIiksCi0JU1RBVF9ERVNDKEE1UFNXX2V0aGVy
U3RhdHNEcm9wRXZlbnRzLCAiZXRoZXJTdGF0c0Ryb3BFdmVudHMiKSwKLQlTVEFUX0RFU0Mo
QTVQU1dfZXRoZXJTdGF0c09jdGV0cywgImV0aGVyU3RhdHNPY3RldHMiKSwKLQlTVEFUX0RF
U0MoQTVQU1dfZXRoZXJTdGF0c1BrdHMsICJldGhlclN0YXRzUGt0cyIpLAotCVNUQVRfREVT
QyhBNVBTV19ldGhlclN0YXRzVW5kZXJzaXplUGt0cywgImV0aGVyU3RhdHNVbmRlcnNpemVQ
a3RzIiksCi0JU1RBVF9ERVNDKEE1UFNXX2V0aGVyU3RhdHNPdmVyc2l6ZVBrdHMsICJldGhl
clN0YXRzT3ZlcnNpemVQa3RzIiksCi0JU1RBVF9ERVNDKEE1UFNXX2V0aGVyU3RhdHNQa3Rz
NjRPY3RldHMsICJldGhlclN0YXRzUGt0czY0T2N0ZXRzIiksCi0JU1RBVF9ERVNDKEE1UFNX
X2V0aGVyU3RhdHNQa3RzNjV0bzEyN09jdGV0cywKLQkJICAiZXRoZXJTdGF0c1BrdHM2NXRv
MTI3T2N0ZXRzIiksCi0JU1RBVF9ERVNDKEE1UFNXX2V0aGVyU3RhdHNQa3RzMTI4dG8yNTVP
Y3RldHMsCi0JCSAgImV0aGVyU3RhdHNQa3RzMTI4dG8yNTVPY3RldHMiKSwKLQlTVEFUX0RF
U0MoQTVQU1dfZXRoZXJTdGF0c1BrdHMyNTZ0bzUxMU9jdGV0cywKLQkJICAiZXRoZXJTdGF0
c1BrdHMyNTZ0bzUxMU9jdGV0cyIpLAotCVNUQVRfREVTQyhBNVBTV19ldGhlclN0YXRzUGt0
czUxMnRvMTAyM09jdGV0cywKLQkJICAiZXRoZXJTdGF0c1BrdHM1MTJ0bzEwMjNPY3RldHMi
KSwKLQlTVEFUX0RFU0MoQTVQU1dfZXRoZXJTdGF0c1BrdHMxMDI0dG8xNTE4T2N0ZXRzLAot
CQkgICJldGhlclN0YXRzUGt0czEwMjR0bzE1MThPY3RldHMiKSwKLQlTVEFUX0RFU0MoQTVQ
U1dfZXRoZXJTdGF0c1BrdHMxNTE5dG9YT2N0ZXRzLAotCQkgICJldGhlclN0YXRzUGt0czE1
MTl0b1hPY3RldHMiKSwKLQlTVEFUX0RFU0MoQTVQU1dfZXRoZXJTdGF0c0phYmJlcnMsICJl
dGhlclN0YXRzSmFiYmVycyIpLAotCVNUQVRfREVTQyhBNVBTV19ldGhlclN0YXRzRnJhZ21l
bnRzLCAiZXRoZXJTdGF0c0ZyYWdtZW50cyIpLAotCVNUQVRfREVTQyhBNVBTV19WTEFOUmVj
ZWl2ZWQsICJWTEFOUmVjZWl2ZWQiKSwKLQlTVEFUX0RFU0MoQTVQU1dfVkxBTlRyYW5zbWl0
dGVkLCAiVkxBTlRyYW5zbWl0dGVkIiksCi0JU1RBVF9ERVNDKEE1UFNXX2FEZWZlcnJlZCwg
ImFEZWZlcnJlZCIpLAotCVNUQVRfREVTQyhBNVBTV19hTXVsdGlwbGVDb2xsaXNpb25zLCAi
YU11bHRpcGxlQ29sbGlzaW9ucyIpLAotCVNUQVRfREVTQyhBNVBTV19hU2luZ2xlQ29sbGlz
aW9ucywgImFTaW5nbGVDb2xsaXNpb25zIiksCi0JU1RBVF9ERVNDKEE1UFNXX2FMYXRlQ29s
bGlzaW9ucywgImFMYXRlQ29sbGlzaW9ucyIpLAotCVNUQVRfREVTQyhBNVBTV19hRXhjZXNz
aXZlQ29sbGlzaW9ucywgImFFeGNlc3NpdmVDb2xsaXNpb25zIiksCi0JU1RBVF9ERVNDKEE1
UFNXX2FDYXJyaWVyU2Vuc2VFcnJvcnMsICJhQ2FycmllclNlbnNlRXJyb3JzIiksCisJU1RB
VF9ERVNDKGFGcmFtZXNUcmFuc21pdHRlZE9LKSwKKwlTVEFUX0RFU0MoYUZyYW1lc1JlY2Vp
dmVkT0spLAorCVNUQVRfREVTQyhhRnJhbWVDaGVja1NlcXVlbmNlRXJyb3JzKSwKKwlTVEFU
X0RFU0MoYUFsaWdubWVudEVycm9ycyksCisJU1RBVF9ERVNDKGFPY3RldHNUcmFuc21pdHRl
ZE9LKSwKKwlTVEFUX0RFU0MoYU9jdGV0c1JlY2VpdmVkT0spLAorCVNUQVRfREVTQyhhVHhQ
QVVTRU1BQ0N0cmxGcmFtZXMpLAorCVNUQVRfREVTQyhhUnhQQVVTRU1BQ0N0cmxGcmFtZXMp
LAorCVNUQVRfREVTQyhpZkluRXJyb3JzKSwKKwlTVEFUX0RFU0MoaWZPdXRFcnJvcnMpLAor
CVNUQVRfREVTQyhpZkluVWNhc3RQa3RzKSwKKwlTVEFUX0RFU0MoaWZJbk11bHRpY2FzdFBr
dHMpLAorCVNUQVRfREVTQyhpZkluQnJvYWRjYXN0UGt0cyksCisJU1RBVF9ERVNDKGlmT3V0
RGlzY2FyZHMpLAorCVNUQVRfREVTQyhpZk91dFVjYXN0UGt0cyksCisJU1RBVF9ERVNDKGlm
T3V0TXVsdGljYXN0UGt0cyksCisJU1RBVF9ERVNDKGlmT3V0QnJvYWRjYXN0UGt0cyksCisJ
U1RBVF9ERVNDKGV0aGVyU3RhdHNEcm9wRXZlbnRzKSwKKwlTVEFUX0RFU0MoZXRoZXJTdGF0
c09jdGV0cyksCisJU1RBVF9ERVNDKGV0aGVyU3RhdHNQa3RzKSwKKwlTVEFUX0RFU0MoZXRo
ZXJTdGF0c1VuZGVyc2l6ZVBrdHMpLAorCVNUQVRfREVTQyhldGhlclN0YXRzT3ZlcnNpemVQ
a3RzKSwKKwlTVEFUX0RFU0MoZXRoZXJTdGF0c1BrdHM2NE9jdGV0cyksCisJU1RBVF9ERVND
KGV0aGVyU3RhdHNQa3RzNjV0bzEyN09jdGV0cyksCisJU1RBVF9ERVNDKGV0aGVyU3RhdHNQ
a3RzMTI4dG8yNTVPY3RldHMpLAorCVNUQVRfREVTQyhldGhlclN0YXRzUGt0czI1NnRvNTEx
T2N0ZXRzKSwKKwlTVEFUX0RFU0MoZXRoZXJTdGF0c1BrdHMxMDI0dG8xNTE4T2N0ZXRzKSwK
KwlTVEFUX0RFU0MoZXRoZXJTdGF0c1BrdHMxNTE5dG9YT2N0ZXRzKSwKKwlTVEFUX0RFU0Mo
ZXRoZXJTdGF0c0phYmJlcnMpLAorCVNUQVRfREVTQyhldGhlclN0YXRzRnJhZ21lbnRzKSwK
KwlTVEFUX0RFU0MoVkxBTlJlY2VpdmVkKSwKKwlTVEFUX0RFU0MoVkxBTlRyYW5zbWl0dGVk
KSwKKwlTVEFUX0RFU0MoYURlZmVycmVkKSwKKwlTVEFUX0RFU0MoYU11bHRpcGxlQ29sbGlz
aW9ucyksCisJU1RBVF9ERVNDKGFTaW5nbGVDb2xsaXNpb25zKSwKKwlTVEFUX0RFU0MoYUxh
dGVDb2xsaXNpb25zKSwKKwlTVEFUX0RFU0MoYUV4Y2Vzc2l2ZUNvbGxpc2lvbnMpLAorCVNU
QVRfREVTQyhhQ2FycmllclNlbnNlRXJyb3JzKSwKIH07CiAKIHN0YXRpYyB2b2lkIGE1cHN3
X3JlZ193cml0ZWwoc3RydWN0IGE1cHN3ICphNXBzdywgaW50IG9mZnNldCwgdTMyIHZhbHVl
KQo=

--------------9QHY3eIOD3o2Kvoq1xEXNc8i--
