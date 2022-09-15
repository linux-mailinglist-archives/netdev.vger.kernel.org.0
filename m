Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301EB5BA19D
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 21:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiIOTxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 15:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIOTw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 15:52:59 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A628895E4;
        Thu, 15 Sep 2022 12:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1663271565;
        bh=ibEywUFeGjMC1iHdJne53rTsiI2aVS6FyLrY0lHBEPM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=dzHhNHvjJG4m8g+GALiIw4IIx5X1XoXjZD9jiqWHbJHIUokepFdyu8x0f0iMOr+b7
         tvfoTIoS/3WoT8vel8iFrjvP+WL+YrvOfjHiHVjvPHF9/rTu+GnyB30TCYSGIpG2Q6
         Nljve7Z6QeySDcictGdjL5SR66cR9IqY853EQ/Ow=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.fritz.box ([62.216.209.163]) by mail.gmx.net
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MEm2D-1oVx3931sx-00GM0K; Thu, 15 Sep 2022 21:52:44 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] wifi: mac80211: minstrel_ht: remove unused has_mrr member from struct minstrel_priv
Date:   Thu, 15 Sep 2022 21:52:43 +0200
Message-Id: <20220915195243.17142-1-ps.report@gmx.net>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:mqjVT6CYjUqic2ZPH1el64YRyCMQ7w1WOQx458k6wCLCibkvvIH
 oVoRL+soDNfiBz4HpXdE2zE6NUlVviZVrTtDsu9RS3IXE3mMKqCzOUj6ZYg7sr9pj9nfaQk
 7CLQhHXkxdBuI9RjbGGqEYnMiEaFwyXYnIUe5eCp7g+dVO1iIRLwH9oRO+mcB9zMes4nPHd
 5Kne2wbJavMTnkLoDA2NA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:I2geNFE7cy8=:Dj5dZMM58zLi6Nb9Ein4vB
 o2hW3RtlAc/07XUNJ01rkxCMp4Ox4GXsDpF5HrPRfIUAT4TS7wZK1bObimqw4cLOi5NrI0xlQ
 bCun07LozjeY5jNTLxLBwI3/T0KKSKfL2T7yL2Npmte0HKoorS/FrEi/9l9TUg5tS1x0+c3v2
 FL1V2gnILAj+nm+RAjTqSxply7YO1FIXSmpCudv3o9LWEhCxggpYLUFVHYnl3gipHrf3Jf3Qx
 DZiNl3sTkTVSSvoy28u2Pn3NvKmXatMXjZx8zRPH84mGnTsd1oGnvzqtDRIiLmipoAVnLiFUZ
 q3eX/dtHCQAnIIPfsAnEuvKLnjyYRWRa2/lSIIaejASj7OtUy9ENToNu/qs2uIRuU/JC24ina
 rh3KcPWzvSziSc6qT8KEJhTG73djr1Ztzjt2XoPKQ/rC2JG1lQBcECpuvHOpYuVDgz9Xyr0v8
 LOY92AbjEdSo/UDSeANxbyzWjjJsM5PEvE75lP8YTCFSTZhvSEDHBgJ0KMdCvuZb3dQqiz67f
 Whlr11Jy28QVg83p952D3wMBunHEgrEReG5O6WLegHXDQBPykasxtz4VJtOIJN9ilKyfoYKjw
 alZobCkfs0pr2wLBwTRjDvDJO9/nP/ZU014iALrKn7jJtpVzSRnhhynzI1Z9xfgoT+U0sicNY
 VpNoe8y3hFvgpc4vKeqIgkMDrkfXCdJ94G2gaT9Vep2wmdCc0Cn2a5rvVmMyb06kx6TST4nJ/
 4Wwm6OagstHLZjaYUMx08eaJsx61HdPj+yQsxVXfILncR/AhcDAeBVuJKBaggNHWyIVqCQOK+
 FrtyEi36JzrDaKfAJjga8iHKb+mOBdRCkCCPkyJhYE2SLJxVRcZ9P8w6UyVEAAOU/Wi9EfIPW
 1McDJqzpOr0A3qkdB6SiHm04lJXqAJ09HnJ5yM3djqcBWaKe5ob/gCboEpT/e9aSlagI1pWub
 5L1mYvpAeRWZHOlbE/Vcorp0ms8SxWq+XCiYPgnIqZz5Y1x6knmq0nnqD/JU8RMzrF8F96GxE
 9CncWTvOuF/sascLky9OlwyiiOZn7aucavVZcmkL3BAZdCFg4JW2jTunKJIsZmyXtcQ4zdEZW
 dudHbwxBn3CoG8xQC3896RaUCWYiHw9fm2FVyniO7v6rnxCqR48jQXRznxpJni+gxX2JA/2X1
 bB5mi6d4VrChIzg+syrmZ2noct
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MIME_BASE64_TEXT,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmVtb3ZlIHVudXNlZCBoYXNfbXJyIChoYXMgbXVsdGktcmF0ZSByZXRyeSBjYXBhYmlsaXRpZXMp
IG1lbWJlcgpmcm9tIHN0cnVjdCBtaW5zdHJlbF9wcml2IChvbmx5IHNldCBvbmNlIGluIG1pbnN0
cmVsX2h0X2FsbG9jLCBuZXZlcgp1c2VkIGFnYWluKS4KClNpZ25lZC1vZmYtYnk6IFBldGVyIFNl
aWRlcmVyIDxwcy5yZXBvcnRAZ214Lm5ldD4KLS0tCiBuZXQvbWFjODAyMTEvcmM4MDIxMV9taW5z
dHJlbF9odC5jIHwgMyAtLS0KIG5ldC9tYWM4MDIxMS9yYzgwMjExX21pbnN0cmVsX2h0LmggfCAx
IC0KIDIgZmlsZXMgY2hhbmdlZCwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9uZXQvbWFj
ODAyMTEvcmM4MDIxMV9taW5zdHJlbF9odC5jIGIvbmV0L21hYzgwMjExL3JjODAyMTFfbWluc3Ry
ZWxfaHQuYwppbmRleCAyNGMzYzA1NWRiNmQuLmQyNjJhNjE5OWRkNSAxMDA2NDQKLS0tIGEvbmV0
L21hYzgwMjExL3JjODAyMTFfbWluc3RyZWxfaHQuYworKysgYi9uZXQvbWFjODAyMTEvcmM4MDIx
MV9taW5zdHJlbF9odC5jCkBAIC0xOTYxLDkgKzE5NjEsNiBAQCBtaW5zdHJlbF9odF9hbGxvYyhz
dHJ1Y3QgaWVlZTgwMjExX2h3ICpodykKIAkJLyogc2FmZSBkZWZhdWx0LCBkb2VzIG5vdCBuZWNl
c3NhcmlseSBoYXZlIHRvIG1hdGNoIGh3IHByb3BlcnRpZXMgKi8KIAkJbXAtPm1heF9yZXRyeSA9
IDc7CiAKLQlpZiAoaHctPm1heF9yYXRlcyA+PSA0KQotCQltcC0+aGFzX21yciA9IHRydWU7Ci0K
IAltcC0+aHcgPSBodzsKIAltcC0+dXBkYXRlX2ludGVydmFsID0gSFogLyAyMDsKIApkaWZmIC0t
Z2l0IGEvbmV0L21hYzgwMjExL3JjODAyMTFfbWluc3RyZWxfaHQuaCBiL25ldC9tYWM4MDIxMS9y
YzgwMjExX21pbnN0cmVsX2h0LmgKaW5kZXggMTc2NmZmMGM3OGQzLi40YmUwNDAxZjc3MjEgMTAw
NjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS9yYzgwMjExX21pbnN0cmVsX2h0LmgKKysrIGIvbmV0L21h
YzgwMjExL3JjODAyMTFfbWluc3RyZWxfaHQuaApAQCAtNzQsNyArNzQsNiBAQAogCiBzdHJ1Y3Qg
bWluc3RyZWxfcHJpdiB7CiAJc3RydWN0IGllZWU4MDIxMV9odyAqaHc7Ci0JYm9vbCBoYXNfbXJy
OwogCXVuc2lnbmVkIGludCBjd19taW47CiAJdW5zaWduZWQgaW50IGN3X21heDsKIAl1bnNpZ25l
ZCBpbnQgbWF4X3JldHJ5OwotLSAKMi4zNy4zCgo=
