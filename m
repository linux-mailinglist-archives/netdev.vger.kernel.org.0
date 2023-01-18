Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE303671A22
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjARLMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjARLLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:11:31 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48953EFC9
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:19:35 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id j34-20020a05600c1c2200b003da1b054057so1032133wms.5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJ1awvcfaGRtaHnfZ6TkrEWuY8TagX/QkFEsPOIHowA=;
        b=8tEfukgmiTeDv9XDeZeeBpXNR7pLQ+l59YB9nM3ejSUXV67XsD/aP5JswNcKI2Ewqa
         oEJQVMON4PN/2rdgX1WJzE/XfLB7cB2x1QLcMoJXCRejkBWBP1RucdPqOV0M+wNQSyLg
         I7j4W802At53EpA56rlZffcdJ2KkWN7jHPMTcMBz6quKxeLckij5bOd4nwwtrV0eVsOr
         Dqcv2W66pD4reTw18FtmUIL7PeJb/aM2fGw3j1J2OBMmue9uUpBKpbzFwMZMWXi1mtwC
         V9O+sUt+kmnL08KN1L9+Sdx0DCNB8nOJU72CcXVHi8xIp5h287Ct2Or/5oYpcuyahbIi
         5p9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dJ1awvcfaGRtaHnfZ6TkrEWuY8TagX/QkFEsPOIHowA=;
        b=gmiXWYahCB9KPUeucH3G8nccp/xuKd+HEfAzTLHuo9cCNCTyoXZ2qKxjzT+bwEaLJ7
         iXDfE2ASqtOiusyLyO+oxo97NNASEdpA8Da3DsCWJnS8GUdhsQOodghbLlC+laNX+aIP
         IlVoNyJZZ1JcyjLpqwvac52482+zuNDsVSwiGv9vpEox+kfFLwEVzcKzEK8R8d1ccXk0
         7J+/PLFPZDZXNAE53YFIo68VXdgectj9GfMm1qSMiQYSE7txTPbaQ7EuXTaHC6z3rtbF
         IX0eTO5nqE3q6X3k27UPPoPRqif7NXuqFe/beEQixSmaKJOHbo5kUrsC8Chj23B/hMwJ
         gAMw==
X-Gm-Message-State: AFqh2kpI7xHkboTa4zUcsZFwLaYS8JPVyxfvIHuKD5JTMXhVuMS/TQIt
        xFn9CXH8ACXcP7x7/ZOrBA/rKg==
X-Google-Smtp-Source: AMrXdXuwSfubE2IhdBuWXPXH820jB4CwDNtVF6hslEQ+i+dbALczHp/eLkVQGKQkXwcUmxC7GuHgxQ==
X-Received: by 2002:a05:600c:540d:b0:3d9:fb59:c16b with SMTP id he13-20020a05600c540d00b003d9fb59c16bmr2044686wmb.36.1674037174185;
        Wed, 18 Jan 2023 02:19:34 -0800 (PST)
Received: from ?IPV6:2a02:578:8593:1200:8e14:5bfc:959c:41cd? ([2a02:578:8593:1200:8e14:5bfc:959c:41cd])
        by smtp.gmail.com with ESMTPSA id l11-20020a1c790b000000b003cf6a55d8e8sm1505516wme.7.2023.01.18.02.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 02:19:33 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------gioF0AstFB80b0DoaUTY8oEt"
Message-ID: <79e46152-8043-a512-79d9-c3b905462774@tessares.net>
Date:   Wed, 18 Jan 2023 11:19:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net] net: ipa: disable ipa interrupt during suspend:
 manual merge
Content-Language: en-GB
To:     Caleb Connolly <caleb.connolly@linaro.org>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alex Elder <elder@linaro.org>, netdev@vger.kernel.org
References: <20230115175925.465918-1-caleb.connolly@linaro.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230115175925.465918-1-caleb.connolly@linaro.org>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------gioF0AstFB80b0DoaUTY8oEt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 15/01/2023 18:59, Caleb Connolly wrote:
> The IPA interrupt can fire when pm_runtime is disabled due to it racing
> with the PM suspend/resume code. This causes a splat in the interrupt
> handler when it tries to call pm_runtime_get().
> 
> Explicitly disable the interrupt in our ->suspend callback, and
> re-enable it in ->resume to avoid this. If there is an interrupt pending
> it will be handled after resuming. The interrupt is a wake_irq, as a
> result even when disabled if it fires it will cause the system to wake
> from suspend as well as cancel any suspend transition that may be in
> progress. If there is an interrupt pending, the ipa_isr_thread handler
> will be called after resuming.
> 
> Fixes: 1aac309d3207 ("net: ipa: use autosuspend")
> Signed-off-by: Caleb Connolly <caleb.connolly@linaro.org>

FYI, we got some small conflicts when merging -net in net-next in the
MPTCP tree due to this patch applied in -net:

  9ec9b2a30853 ("net: ipa: disable ipa interrupt during suspend")

and these one from net-next:

  8e461e1f092b ("net: ipa: introduce ipa_interrupt_enable()")
  d50ed3558719 ("net: ipa: enable IPA interrupt handlers separate from
registration")

These conflicts have been resolved on our side[1] and the resolution we
suggest is attached to this email: I simply took both part (new
functions) and changed the order to have the functions from -net first.

Cheers,
Matt

[1] https://github.com/multipath-tcp/mptcp_net-next/commit/00697360079c
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
--------------gioF0AstFB80b0DoaUTY8oEt
Content-Type: text/x-patch; charset=UTF-8;
 name="00697360079c3cff038eefe6561a1761ffe7e333.patch"
Content-Disposition: attachment;
 filename="00697360079c3cff038eefe6561a1761ffe7e333.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWNjIGRyaXZlcnMvbmV0L2lwYS9pcGFfaW50ZXJydXB0LmMKaW5kZXggZmQ5ODJj
ZWM4MDY4LGMxYjM5NzdlMWFlNC4uY2FlOGM3YTJiZGE2Ci0tLSBhL2RyaXZlcnMvbmV0L2lw
YS9pcGFfaW50ZXJydXB0LmMKKysrIGIvZHJpdmVycy9uZXQvaXBhL2lwYV9pbnRlcnJ1cHQu
YwpAQEAgLTEyOSwyOSAtMTI3LDE2ICsxMjksMzkgQEBAIG91dF9wb3dlcl9wdXQKICAJcmV0
dXJuIElSUV9IQU5ETEVEOwogIH0KICAKKyB2b2lkIGlwYV9pbnRlcnJ1cHRfaXJxX2Rpc2Fi
bGUoc3RydWN0IGlwYSAqaXBhKQorIHsKKyAJZGlzYWJsZV9pcnEoaXBhLT5pbnRlcnJ1cHQt
PmlycSk7CisgfQorIAorIHZvaWQgaXBhX2ludGVycnVwdF9pcnFfZW5hYmxlKHN0cnVjdCBp
cGEgKmlwYSkKKyB7CisgCWVuYWJsZV9pcnEoaXBhLT5pbnRlcnJ1cHQtPmlycSk7CisgfQor
IAogK3N0YXRpYyB2b2lkIGlwYV9pbnRlcnJ1cHRfZW5hYmxlZF91cGRhdGUoc3RydWN0IGlw
YSAqaXBhKQogK3sKICsJY29uc3Qgc3RydWN0IGlwYV9yZWcgKnJlZyA9IGlwYV9yZWcoaXBh
LCBJUEFfSVJRX0VOKTsKICsKICsJaW93cml0ZTMyKGlwYS0+aW50ZXJydXB0LT5lbmFibGVk
LCBpcGEtPnJlZ192aXJ0ICsgaXBhX3JlZ19vZmZzZXQocmVnKSk7CiArfQogKwogKy8qIEVu
YWJsZSBhbiBJUEEgaW50ZXJydXB0IHR5cGUgKi8KICt2b2lkIGlwYV9pbnRlcnJ1cHRfZW5h
YmxlKHN0cnVjdCBpcGEgKmlwYSwgZW51bSBpcGFfaXJxX2lkIGlwYV9pcnEpCiArewogKwkv
KiBVcGRhdGUgdGhlIElQQSBpbnRlcnJ1cHQgbWFzayB0byBlbmFibGUgaXQgKi8KICsJaXBh
LT5pbnRlcnJ1cHQtPmVuYWJsZWQgfD0gQklUKGlwYV9pcnEpOwogKwlpcGFfaW50ZXJydXB0
X2VuYWJsZWRfdXBkYXRlKGlwYSk7CiArfQogKwogKy8qIERpc2FibGUgYW4gSVBBIGludGVy
cnVwdCB0eXBlICovCiArdm9pZCBpcGFfaW50ZXJydXB0X2Rpc2FibGUoc3RydWN0IGlwYSAq
aXBhLCBlbnVtIGlwYV9pcnFfaWQgaXBhX2lycSkKICt7CiArCS8qIFVwZGF0ZSB0aGUgSVBB
IGludGVycnVwdCBtYXNrIHRvIGRpc2FibGUgaXQgKi8KICsJaXBhLT5pbnRlcnJ1cHQtPmVu
YWJsZWQgJj0gfkJJVChpcGFfaXJxKTsKICsJaXBhX2ludGVycnVwdF9lbmFibGVkX3VwZGF0
ZShpcGEpOwogK30KICsKICAvKiBDb21tb24gZnVuY3Rpb24gdXNlZCB0byBlbmFibGUvZGlz
YWJsZSBUWF9TVVNQRU5EIGZvciBhbiBlbmRwb2ludCAqLwogIHN0YXRpYyB2b2lkIGlwYV9p
bnRlcnJ1cHRfc3VzcGVuZF9jb250cm9sKHN0cnVjdCBpcGFfaW50ZXJydXB0ICppbnRlcnJ1
cHQsCiAgCQkJCQkgIHUzMiBlbmRwb2ludF9pZCwgYm9vbCBlbmFibGUpCmRpZmYgLS1jYyBk
cml2ZXJzL25ldC9pcGEvaXBhX2ludGVycnVwdC5oCmluZGV4IDc2NGE2NWU2YjUwMyw4YTFi
ZDViODkzOTMuLmQ2ZDg0NzUxZjAyOQotLS0gYS9kcml2ZXJzL25ldC9pcGEvaXBhX2ludGVy
cnVwdC5oCisrKyBiL2RyaXZlcnMvbmV0L2lwYS9pcGFfaW50ZXJydXB0LmgKQEBAIC01Mywy
MCAtODUsMjIgKzUzLDM2IEBAQCB2b2lkIGlwYV9pbnRlcnJ1cHRfc3VzcGVuZF9jbGVhcl9h
bGwoc3QKICAgKi8KICB2b2lkIGlwYV9pbnRlcnJ1cHRfc2ltdWxhdGVfc3VzcGVuZChzdHJ1
Y3QgaXBhX2ludGVycnVwdCAqaW50ZXJydXB0KTsKICAKKyAvKioKKyAgKiBpcGFfaW50ZXJy
dXB0X2lycV9lbmFibGUoKSAtIEVuYWJsZSBJUEEgaW50ZXJydXB0cworICAqIEBpcGE6CUlQ
QSBwb2ludGVyCisgICoKKyAgKiBUaGlzIGVuYWJsZXMgdGhlIElQQSBpbnRlcnJ1cHQgbGlu
ZQorICAqLworIHZvaWQgaXBhX2ludGVycnVwdF9pcnFfZW5hYmxlKHN0cnVjdCBpcGEgKmlw
YSk7CisgCisgLyoqCisgICogaXBhX2ludGVycnVwdF9pcnFfZGlzYWJsZSgpIC0gRGlzYWJs
ZSBJUEEgaW50ZXJydXB0cworICAqIEBpcGE6CUlQQSBwb2ludGVyCisgICoKKyAgKiBUaGlz
IGRpc2FibGVzIHRoZSBJUEEgaW50ZXJydXB0IGxpbmUKKyAgKi8KKyB2b2lkIGlwYV9pbnRl
cnJ1cHRfaXJxX2Rpc2FibGUoc3RydWN0IGlwYSAqaXBhKTsKKyAKICsvKioKICsgKiBpcGFf
aW50ZXJydXB0X2VuYWJsZSgpIC0gRW5hYmxlIGFuIElQQSBpbnRlcnJ1cHQgdHlwZQogKyAq
IEBpcGE6CUlQQSBwb2ludGVyCiArICogQGlwYV9pcnE6CUlQQSBpbnRlcnJ1cHQgSUQKICsg
Ki8KICt2b2lkIGlwYV9pbnRlcnJ1cHRfZW5hYmxlKHN0cnVjdCBpcGEgKmlwYSwgZW51bSBp
cGFfaXJxX2lkIGlwYV9pcnEpOwogKwogKy8qKgogKyAqIGlwYV9pbnRlcnJ1cHRfZGlzYWJs
ZSgpIC0gRGlzYWJsZSBhbiBJUEEgaW50ZXJydXB0IHR5cGUKICsgKiBAaXBhOglJUEEgcG9p
bnRlcgogKyAqIEBpcGFfaXJxOglJUEEgaW50ZXJydXB0IElECiArICovCiArdm9pZCBpcGFf
aW50ZXJydXB0X2Rpc2FibGUoc3RydWN0IGlwYSAqaXBhLCBlbnVtIGlwYV9pcnFfaWQgaXBh
X2lycSk7CiArCiAgLyoqCiAgICogaXBhX2ludGVycnVwdF9jb25maWcoKSAtIENvbmZpZ3Vy
ZSB0aGUgSVBBIGludGVycnVwdCBmcmFtZXdvcmsKICAgKiBAaXBhOglJUEEgcG9pbnRlcgo=


--------------gioF0AstFB80b0DoaUTY8oEt--
