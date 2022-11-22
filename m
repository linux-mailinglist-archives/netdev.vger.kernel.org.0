Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5F46342C2
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 18:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiKVRou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 12:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbiKVRos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 12:44:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB6365F0;
        Tue, 22 Nov 2022 09:44:48 -0800 (PST)
Message-ID: <20221122173648.153480304@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669139086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=vPQpsKvWnASzU3gSCvd8QTllKFezKGed3DBwTOx2RsY=;
        b=N1JdlAq02OGh1ZaHD7YrDTYMYpCfJwds7yiy47sSsKrsscCku9ZeyGkFcuMMTvaOkg0mBh
        9PIu/EEfwcpUmektmw8eBXUbRIeL8LPKNifLEOwbUcHavwajnrvmDsMNnGbo3IQyUdXZE3
        fXSH56BsDR1kv3YQrZAOlJRGNJ8q8jTay1HWJcrtsqOAE21A2bq86Iwokid1/4lew92134
        cPNG9iXt8FQIj+hPM3lAHZJwoMAl9wuPm0nhRlWwL8b6x5KNFx2wPUBvAez7rHjN+P+FEL
        y8gVeqCjwX8cKpL7sKtpszLaLpzT+tBYMn517QbefeK8K20Im7s8sN1ptBT8+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669139086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=vPQpsKvWnASzU3gSCvd8QTllKFezKGed3DBwTOx2RsY=;
        b=y93AMtrwboI4mg48ccrd69AeqcjYHNWmCsBPWMVYSOFh86bGLdI5qNWUx/E7AoaUQNIPQI
        9P/jYXxtnLlR8WAA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [patch V2 01/17] Documentation: Remove bogus claim about del_timer_sync()
References: <20221122171312.191765396@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Date:   Tue, 22 Nov 2022 18:44:45 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ZGVsX3RpbWVyX3N5bmMoKSBkb2VzIG5vdCByZXR1cm4gdGhlIG51bWJlciBvZiB0aW1lcyBpdCB0
cmllZCB0byBkZWxldGUgdGhlCnRpbWVyIHdoaWNoIHJlYXJtcyBpdHNlbGYuIEl0J3MgY2xlYXJs
eSBkb2N1bWVudGVkOgoKIFRoZSBmdW5jdGlvbiByZXR1cm5zIHdoZXRoZXIgaXQgaGFzIGRlYWN0
aXZhdGVkIGEgcGVuZGluZyB0aW1lciBvciBub3QuCgpUaGlzIHBhcnQgb2YgdGhlIGRvY3VtZW50
YXRpb24gaXMgZnJvbSAyMDAzIHdoZXJlIGRlbF90aW1lcl9zeW5jKCkgcmVhbGx5CnJldHVybmVk
IHRoZSBudW1iZXIgb2YgZGVsZXRpb24gYXR0ZW1wdHMgZm9yIHVua25vd24gcmVhc29ucy4gVGhp
cyBjb2RlCndhcyByZXdyaXR0ZW4gaW4gMjAwNSwgYnV0IHRoZSBkb2N1bWVudGF0aW9uIHdhcyBu
b3QgdXBkYXRlZC4KClNpZ25lZC1vZmYtYnk6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJv
bml4LmRlPgotLS0KIERvY3VtZW50YXRpb24va2VybmVsLWhhY2tpbmcvbG9ja2luZy5yc3QgICAg
ICAgICAgICAgICAgICAgIHwgICAgMyArLS0KIERvY3VtZW50YXRpb24vdHJhbnNsYXRpb25zL2l0
X0lUL2tlcm5lbC1oYWNraW5nL2xvY2tpbmcucnN0IHwgICAgNCArLS0tCiAyIGZpbGVzIGNoYW5n
ZWQsIDIgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCi0tLSBhL0RvY3VtZW50YXRpb24v
a2VybmVsLWhhY2tpbmcvbG9ja2luZy5yc3QKKysrIGIvRG9jdW1lbnRhdGlvbi9rZXJuZWwtaGFj
a2luZy9sb2NraW5nLnJzdApAQCAtMTAwNiw4ICsxMDA2LDcgQEAgQW5vdGhlciBjb21tb24gcHJv
YmxlbSBpcyBkZWxldGluZyB0aW1lcgogY2FsbGluZyBhZGRfdGltZXIoKSBhdCB0aGUgZW5kIG9m
IHRoZWlyIHRpbWVyIGZ1bmN0aW9uKS4KIEJlY2F1c2UgdGhpcyBpcyBhIGZhaXJseSBjb21tb24g
Y2FzZSB3aGljaCBpcyBwcm9uZSB0byByYWNlcywgeW91IHNob3VsZAogdXNlIGRlbF90aW1lcl9z
eW5jKCkgKGBgaW5jbHVkZS9saW51eC90aW1lci5oYGApIHRvCi1oYW5kbGUgdGhpcyBjYXNlLiBJ
dCByZXR1cm5zIHRoZSBudW1iZXIgb2YgdGltZXMgdGhlIHRpbWVyIGhhZCB0byBiZQotZGVsZXRl
ZCBiZWZvcmUgd2UgZmluYWxseSBzdG9wcGVkIGl0IGZyb20gYWRkaW5nIGl0c2VsZiBiYWNrIGlu
LgoraGFuZGxlIHRoaXMgY2FzZS4KIAogTG9ja2luZyBTcGVlZAogPT09PT09PT09PT09PQotLS0g
YS9Eb2N1bWVudGF0aW9uL3RyYW5zbGF0aW9ucy9pdF9JVC9rZXJuZWwtaGFja2luZy9sb2NraW5n
LnJzdAorKysgYi9Eb2N1bWVudGF0aW9uL3RyYW5zbGF0aW9ucy9pdF9JVC9rZXJuZWwtaGFja2lu
Zy9sb2NraW5nLnJzdApAQCAtMTAyNyw5ICsxMDI3LDcgQEAgVW4gYWx0cm8gcHJvYmxlbWEgw6gg
bCdlbGltaW5hemlvbmUgZGVpCiBkYSBzb2xpIChjaGlhbWFuZG8gYWRkX3RpbWVyKCkgYWxsYSBm
aW5lIGRlbGxhIGxvcm8gZXNlY3V6aW9uZSkuCiBEYXRvIGNoZSBxdWVzdG8gw6ggdW4gcHJvYmxl
bWEgYWJiYXN0YW56YSBjb211bmUgY29uIHVuYSBwcm9wZW5zaW9uZQogYWxsZSBjb3JzZSBjcml0
aWNoZSwgZG92cmVzdGUgdXNhcmUgZGVsX3RpbWVyX3N5bmMoKQotKGBgaW5jbHVkZS9saW51eC90
aW1lci5oYGApIHBlciBnZXN0aXJlIHF1ZXN0byBjYXNvLiBRdWVzdGEgcml0b3JuYSBpbAotbnVt
ZXJvIGRpIHZvbHRlIGNoZSBpbCB0ZW1wb3JpenphdG9yZSDDqCBzdGF0byBpbnRlcnJvdHRvIHBy
aW1hIGNoZQotZm9zc2UgaW4gZ3JhZG8gZGkgZmVybWFybG8gc2VuemEgY2hlIHNpIHJpYXZ2aWFz
c2UuCisoYGBpbmNsdWRlL2xpbnV4L3RpbWVyLmhgYCkgcGVyIGdlc3RpcmUgcXVlc3RvIGNhc28u
CiAKIFZlbG9jaXTDoCBkZWxsYSBzaW5jcm9uaXp6YXppb25lCiA9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09Cgo=
