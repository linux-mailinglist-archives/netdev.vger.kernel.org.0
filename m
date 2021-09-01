Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B073FE3EC
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 22:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345150AbhIAUW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 16:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344607AbhIAUWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 16:22:17 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A21C0617A8;
        Wed,  1 Sep 2021 13:21:03 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j4so1559052lfg.9;
        Wed, 01 Sep 2021 13:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to;
        bh=pJPyEbgDyxweejpYMD0yQbh+6nlqZ4ZcT25PJQyPPOk=;
        b=pmj0972aM1frEH65nbRcoB7jrY8gTCr7sumnzbQp5BgL/Dmc9vL4c5KZUFMpPAcccC
         Li+YdWnRsQ4VABSzrLxnLwHKwYqxv8AAndz8wLdiHOj4eKkvmZRzms73sljrszxXvqji
         DPbCjbu92vI7yCMh0GjX1FngiayfstVEowP8QkKIIfVrLSvJ85NvE5KgPDsLLatBlj5K
         cQipi3UD5wig3j09mM1AUR7/qOaOxp8XKZYxPTBw65HfLw7+uaL4jGm55u9B4kHH9KXC
         mB7JKG3UQVFTQYKWZAdW1jKN/668PZkFWR+NO2ddEapUlbA6LIU8k0/+cMjNPItl667u
         PMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to;
        bh=pJPyEbgDyxweejpYMD0yQbh+6nlqZ4ZcT25PJQyPPOk=;
        b=NTIvCduWCgXyzjM2E1r2gnjuUrrYMFIrRy4OmlVXa+5D0Uivc6chagnuECSuaOp+IT
         VkGsKNXGw/1crE3WNQX6uw/Rz7bPRa0WgMtIDzJDgbPkHJD9fDNxT1iIW7WDi+3zC8TW
         5X+nqiymmTo3hUGCBbzoSy43rbdouWdiPtab0+i4mRNFN2CQAn+2MVxzeSSY8rFEguEF
         G/XGKmTDFDfJ4Tm0nlHw+Rf0qIf/JYhYNYq4BatSx8c/5Q0WrdkM3sSfmNOAXZMPARIx
         ELhimMefUpwTXkeMnUzEHHCE3+jb6cJQXSfoxcPowJ3wpssMectxVmkZbeOhgLF/hWDi
         u0EQ==
X-Gm-Message-State: AOAM530dt3wohcspKOamMItyAd2sQ7tGBZJDa4jvtrg60RYQLQVrFsad
        BkPSuYyPqcEm7BYcsJzqCO4=
X-Google-Smtp-Source: ABdhPJx3WkDXZWFAcAsSQ2LvjNhW6y9+inRcy8YF161mA7fjHvamtzs7D/xQjJ2r0wx+PH24K+epWw==
X-Received: by 2002:a05:6512:2148:: with SMTP id s8mr900047lfr.317.1630527661817;
        Wed, 01 Sep 2021 13:21:01 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.229.213])
        by smtp.gmail.com with UTF8SMTPSA id j1sm71761lji.124.2021.09.01.13.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 13:21:01 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------dKn190a6SKK3cd0KsH6Gjlpw"
Message-ID: <983049ea-3023-8dbe-cbb4-51fb5661d2cb@gmail.com>
Date:   Wed, 1 Sep 2021 23:21:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in xfrm_get_default
Content-Language: en-US
To:     syzbot <syzbot+b2be9dd8ca6f6c73ee2d@syzkaller.appspotmail.com>,
        antony.antony@secunet.com, christian.langrock@secunet.com,
        davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
References: <0000000000005a8dc805caf4b92e@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <0000000000005a8dc805caf4b92e@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------dKn190a6SKK3cd0KsH6Gjlpw
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/21 23:15, syzbot wrote:
> Hello,
> 
> syzbot tried to test the proposed patch but the build/boot failed:
> 
> arch/x86/kernel/setup.c:916:6: error: implicit declaration of function 'acpi_mps_check' [-Werror=implicit-function-declaration]
> arch/x86/kernel/setup.c:1110:2: error: implicit declaration of function 'acpi_table_upgrade' [-Werror=implicit-function-declaration]
> arch/x86/kernel/setup.c:1112:2: error: implicit declaration of function 'acpi_boot_table_init' [-Werror=implicit-function-declaration]
> arch/x86/kernel/setup.c:1120:2: error: implicit declaration of function 'early_acpi_boot_init'; did you mean 'early_cpu_init'? [-Werror=implicit-function-declaration]
> arch/x86/kernel/setup.c:1162:2: error: implicit declaration of function 'acpi_boot_init' [-Werror=implicit-function-declaration]
> 
> 
> Tested on:
> 
> commit:         9e9fb765 Merge tag 'net-next-5.15' of git://git.kernel..
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git master
> dashboard link: https://syzkaller.appspot.com/bug?extid=b2be9dd8ca6f6c73ee2d
> compiler:
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=14a2a34d300000
> 

Ok, net-next is also broken....

#syz test:
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git master




With regards,
Pavel Skripkin
--------------dKn190a6SKK3cd0KsH6Gjlpw
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-net-xfrm-fix-shift-out-of-bounds-in-xfrm_get_default.patch"
Content-Disposition: attachment;
 filename*0="0001-net-xfrm-fix-shift-out-of-bounds-in-xfrm_get_default.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAxNzJjMzUxODY5ZTU5MjA2MzBmMjdkMjA5NzZiMDc5ZmNhMzA2NTBjIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBQYXZlbCBTa3JpcGtpbiA8cGFza3JpcGtpbkBnbWFp
bC5jb20+CkRhdGU6IFdlZCwgMSBTZXAgMjAyMSAyMTo1NToyNSArMDMwMApTdWJqZWN0OiBb
UEFUQ0hdIG5ldDogeGZybTogZml4IHNoaWZ0LW91dC1vZi1ib3VuZHMgaW4geGZybV9nZXRf
ZGVmYXVsdAoKLyogLi4uICovCgpTaWduZWQtb2ZmLWJ5OiBQYXZlbCBTa3JpcGtpbiA8cGFz
a3JpcGtpbkBnbWFpbC5jb20+Ci0tLQogYXJjaC94ODYva2VybmVsL3NldHVwLmMgfCAxICsK
IG5ldC94ZnJtL3hmcm1fdXNlci5jICAgIHwgMyArKysKIDIgZmlsZXMgY2hhbmdlZCwgNCBp
bnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL3NldHVwLmMgYi9h
cmNoL3g4Ni9rZXJuZWwvc2V0dXAuYwppbmRleCBkYTBhNGI2NDg4MGYuLmM5ZTNhMTdiOTRm
OSAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2VybmVsL3NldHVwLmMKKysrIGIvYXJjaC94ODYv
a2VybmVsL3NldHVwLmMKQEAgLTIzLDYgKzIzLDcgQEAKICNpbmNsdWRlIDxsaW51eC91c2Iv
eGhjaS1kYmdwLmg+CiAjaW5jbHVkZSA8bGludXgvc3RhdGljX2NhbGwuaD4KICNpbmNsdWRl
IDxsaW51eC9zd2lvdGxiLmg+CisjaW5jbHVkZSA8bGludXgvYWNwaS5oPgogCiAjaW5jbHVk
ZSA8dWFwaS9saW51eC9tb3VudC5oPgogCmRpZmYgLS1naXQgYS9uZXQveGZybS94ZnJtX3Vz
ZXIuYyBiL25ldC94ZnJtL3hmcm1fdXNlci5jCmluZGV4IGI3Yjk4NjUyMGRjNy4uYTFkZDM4
NTI1OTU3IDEwMDY0NAotLS0gYS9uZXQveGZybS94ZnJtX3VzZXIuYworKysgYi9uZXQveGZy
bS94ZnJtX3VzZXIuYwpAQCAtMjAwNyw2ICsyMDA3LDkgQEAgc3RhdGljIGludCB4ZnJtX2dl
dF9kZWZhdWx0KHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBubG1zZ2hkciAqbmxoLAog
CiAJcl91cCA9IG5sbXNnX2RhdGEocl9ubGgpOwogCisJaWYgKHVwLT5kaXJtYXNrID49IFhG
Uk1fVVNFUlBPTElDWV9ESVJNQVNLX01BWCkKKwkJcmV0dXJuIC1FSU5WQUw7CisKIAlyX3Vw
LT5hY3Rpb24gPSAoKG5ldC0+eGZybS5wb2xpY3lfZGVmYXVsdCAmICgxIDw8IHVwLT5kaXJt
YXNrKSkgPj4gdXAtPmRpcm1hc2spOwogCXJfdXAtPmRpcm1hc2sgPSB1cC0+ZGlybWFzazsK
IAlubG1zZ19lbmQocl9za2IsIHJfbmxoKTsKLS0gCjIuMzMuMAoK
--------------dKn190a6SKK3cd0KsH6Gjlpw--

