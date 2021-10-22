Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFA4437FB8
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 22:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbhJVVAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 17:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234336AbhJVVAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 17:00:36 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E235AC061764;
        Fri, 22 Oct 2021 13:58:17 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id j21so11674674lfe.0;
        Fri, 22 Oct 2021 13:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to;
        bh=DvZRyK8W4taoJI0w6BsZtI1Rsk5Ek0pe9nbSOny/XQk=;
        b=ez4gPpN/IOR6H0XxlZCC1Rb4J+1SYLTTIYzHc3i8NDdOz+jcagq/G2sF1SkQ281m4y
         xeL9LKXQqZKeI99HmADhMqlRewoNQYwjo4qyB3xQIw3E5pkmmKop9/HrBW2+nZEAkZHp
         GO7R+Wo/DIpCJgAJdQMhxAtoPyJhipDRyEWIiERGFxn52pvPswhe+jVjGDai8N+fNzYU
         CAoPkwigyl13PukTRVuIbihfzdrromlY4ArIwmPvFscRioWlWkf5xmDpZ3lXk6ut8vGQ
         Dno9T1ftluLFnrt8Jls13D8VnK3nkNhYSiCrQa9BKL1ejNocJh8TIv2ZR+rKH9p2Q2yL
         qNkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to;
        bh=DvZRyK8W4taoJI0w6BsZtI1Rsk5Ek0pe9nbSOny/XQk=;
        b=25YlWE1ea3pjwseyAYqjk0fJB8V5EAJqPZZhnvqDSj2AbXpEKpqiUsJZRy/IEXMoCb
         TkwpfR0IlokVagdQ682FsIKmR0+ofKrzHZkFVf5VkMsLWeHeT9AlVTUUNgVMX2pqDvyZ
         VeKkGg4W8dgCTMMGqzPzo4EhqP6ODFOSoirY8PZz9Cbd1yAvT7jVJ3Zg1UnqgIm1INpk
         hCdeBqYVEagWJB2Le3QDJX14aUXUbEpdMhTMvhVpiQcvpFGK2Kh+f75HSuZ7anhPLozq
         HdwiVn2snVJEquTC/tqQpB3tjIzeEKo6i3g7ZimLJkjFogqoQLUnP2R/3WDQKgkR0D3Z
         v2Ig==
X-Gm-Message-State: AOAM5315QyRl31/kaRoVxABMqj3JqwjjFDssmeP+hqcvqr+/qqaiSM4m
        EPSVvLpimzV/GJoEW2j2mWo=
X-Google-Smtp-Source: ABdhPJy5N91FS9EFCKgLOEAgSnE0AQ+7LDZTXcIR7z3f2NjdZKLAt8iwZ4v7LYfBiY2a6Tjfzme4NQ==
X-Received: by 2002:a05:6512:3501:: with SMTP id h1mr1879903lfs.235.1634936296265;
        Fri, 22 Oct 2021 13:58:16 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.235.181])
        by smtp.gmail.com with ESMTPSA id l4sm995215ljc.133.2021.10.22.13.58.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 13:58:15 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------CvkaH0ihFkENdKmg5e7QlCGq"
Message-ID: <5e29e63c-d2b5-ae72-0e33-5a22e727be3c@gmail.com>
Date:   Fri, 22 Oct 2021 23:58:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] WARNING in batadv_nc_mesh_free
Content-Language: en-US
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com>,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
References: <000000000000c87fbd05cef6bcb0@google.com>
 <1639fcba-e543-e071-f17c-941b8c7a948f@gmail.com>
In-Reply-To: <1639fcba-e543-e071-f17c-941b8c7a948f@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------CvkaH0ihFkENdKmg5e7QlCGq
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/21 23:57, Pavel Skripkin wrote:
> On 10/22/21 23:20, syzbot wrote:
>> Hello,
>> 
>> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
>> general protection fault in batadv_nc_purge_paths
> 
> 
> Oh, ok. Next clean up call in batadv_nc_mesh_free() caused GPF, since
> fields are not initialized. Let's try to clean up one by one and do not
> break dependencies.
> 
> Quite ugly one, but idea is correct, I guess
> 
> Also, make each *_init() call clean up all allocated stuff to not call
> corresponding *_free() on error handling path, since it introduces
> problems, as syzbot reported
> 
> 
> 
> 

Whooops.... Forgot to ask syzbot to test the patch

#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master




With regards,
Pavel Skripkin
--------------CvkaH0ihFkENdKmg5e7QlCGq
Content-Type: text/plain; charset=UTF-8; name="ph"
Content-Disposition: attachment; filename="ph"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL25ldC9iYXRtYW4tYWR2L2JyaWRnZV9sb29wX2F2b2lkYW5jZS5jIGIv
bmV0L2JhdG1hbi1hZHYvYnJpZGdlX2xvb3BfYXZvaWRhbmNlLmMKaW5kZXggMTY2OTc0NDMw
NGM1Li4xNzY4Nzg0OGRhZWMgMTAwNjQ0Ci0tLSBhL25ldC9iYXRtYW4tYWR2L2JyaWRnZV9s
b29wX2F2b2lkYW5jZS5jCisrKyBiL25ldC9iYXRtYW4tYWR2L2JyaWRnZV9sb29wX2F2b2lk
YW5jZS5jCkBAIC0xNTYwLDEwICsxNTYwLDE0IEBAIGludCBiYXRhZHZfYmxhX2luaXQoc3Ry
dWN0IGJhdGFkdl9wcml2ICpiYXRfcHJpdikKIAkJcmV0dXJuIDA7CiAKIAliYXRfcHJpdi0+
YmxhLmNsYWltX2hhc2ggPSBiYXRhZHZfaGFzaF9uZXcoMTI4KTsKLQliYXRfcHJpdi0+Ymxh
LmJhY2tib25lX2hhc2ggPSBiYXRhZHZfaGFzaF9uZXcoMzIpOworCWlmICghYmF0X3ByaXYt
PmJsYS5jbGFpbV9oYXNoKQorCQlyZXR1cm4gLUVOT01FTTsKIAotCWlmICghYmF0X3ByaXYt
PmJsYS5jbGFpbV9oYXNoIHx8ICFiYXRfcHJpdi0+YmxhLmJhY2tib25lX2hhc2gpCisJYmF0
X3ByaXYtPmJsYS5iYWNrYm9uZV9oYXNoID0gYmF0YWR2X2hhc2hfbmV3KDMyKTsKKwlpZiAo
IWJhdF9wcml2LT5ibGEuYmFja2JvbmVfaGFzaCkgeworCQliYXRhZHZfaGFzaF9kZXN0cm95
KGJhdF9wcml2LT5ibGEuY2xhaW1faGFzaCk7CiAJCXJldHVybiAtRU5PTUVNOworCX0KIAog
CWJhdGFkdl9oYXNoX3NldF9sb2NrX2NsYXNzKGJhdF9wcml2LT5ibGEuY2xhaW1faGFzaCwK
IAkJCQkgICAmYmF0YWR2X2NsYWltX2hhc2hfbG9ja19jbGFzc19rZXkpOwpkaWZmIC0tZ2l0
IGEvbmV0L2JhdG1hbi1hZHYvbWFpbi5jIGIvbmV0L2JhdG1hbi1hZHYvbWFpbi5jCmluZGV4
IDNkZGQ2NmU0YzI5ZS4uOTA1MTJlZDMyMzQ4IDEwMDY0NAotLS0gYS9uZXQvYmF0bWFuLWFk
di9tYWluLmMKKysrIGIvbmV0L2JhdG1hbi1hZHYvbWFpbi5jCkBAIC0xOTAsMjkgKzE5MCw0
MSBAQCBpbnQgYmF0YWR2X21lc2hfaW5pdChzdHJ1Y3QgbmV0X2RldmljZSAqc29mdF9pZmFj
ZSkKIAogCWJhdF9wcml2LT5ndy5nZW5lcmF0aW9uID0gMDsKIAotCXJldCA9IGJhdGFkdl92
X21lc2hfaW5pdChiYXRfcHJpdik7Ci0JaWYgKHJldCA8IDApCi0JCWdvdG8gZXJyOwotCiAJ
cmV0ID0gYmF0YWR2X29yaWdpbmF0b3JfaW5pdChiYXRfcHJpdik7Ci0JaWYgKHJldCA8IDAp
Ci0JCWdvdG8gZXJyOworCWlmIChyZXQgPCAwKSB7CisJCWF0b21pY19zZXQoJmJhdF9wcml2
LT5tZXNoX3N0YXRlLCBCQVRBRFZfTUVTSF9ERUFDVElWQVRJTkcpOworCQlnb3RvIGVycl9v
cmlnOworCX0KIAogCXJldCA9IGJhdGFkdl90dF9pbml0KGJhdF9wcml2KTsKLQlpZiAocmV0
IDwgMCkKLQkJZ290byBlcnI7CisJaWYgKHJldCA8IDApIHsKKwkJYXRvbWljX3NldCgmYmF0
X3ByaXYtPm1lc2hfc3RhdGUsIEJBVEFEVl9NRVNIX0RFQUNUSVZBVElORyk7CisJCWdvdG8g
ZXJyX3R0OworCX0KKworCXJldCA9IGJhdGFkdl92X21lc2hfaW5pdChiYXRfcHJpdik7CisJ
aWYgKHJldCA8IDApIHsKKwkJYXRvbWljX3NldCgmYmF0X3ByaXYtPm1lc2hfc3RhdGUsIEJB
VEFEVl9NRVNIX0RFQUNUSVZBVElORyk7CisJCWdvdG8gZXJyX3Y7CisJfQogCiAJcmV0ID0g
YmF0YWR2X2JsYV9pbml0KGJhdF9wcml2KTsKLQlpZiAocmV0IDwgMCkKLQkJZ290byBlcnI7
CisJaWYgKHJldCA8IDApIHsKKwkJYXRvbWljX3NldCgmYmF0X3ByaXYtPm1lc2hfc3RhdGUs
IEJBVEFEVl9NRVNIX0RFQUNUSVZBVElORyk7CisJCWdvdG8gZXJyX2JsYTsKKwl9CiAKIAly
ZXQgPSBiYXRhZHZfZGF0X2luaXQoYmF0X3ByaXYpOwotCWlmIChyZXQgPCAwKQotCQlnb3Rv
IGVycjsKKwlpZiAocmV0IDwgMCkgeworCQlhdG9taWNfc2V0KCZiYXRfcHJpdi0+bWVzaF9z
dGF0ZSwgQkFUQURWX01FU0hfREVBQ1RJVkFUSU5HKTsKKwkJZ290byBlcnJfZGF0OworCX0K
IAogCXJldCA9IGJhdGFkdl9uY19tZXNoX2luaXQoYmF0X3ByaXYpOwotCWlmIChyZXQgPCAw
KQotCQlnb3RvIGVycjsKKwlpZiAocmV0IDwgMCl7CisJCWF0b21pY19zZXQoJmJhdF9wcml2
LT5tZXNoX3N0YXRlLCBCQVRBRFZfTUVTSF9ERUFDVElWQVRJTkcpOworCQlnb3RvIGVycl9u
YzsKKwl9CiAKIAliYXRhZHZfZ3dfaW5pdChiYXRfcHJpdik7CiAJYmF0YWR2X21jYXN0X2lu
aXQoYmF0X3ByaXYpOwpAQCAtMjIyLDggKzIzNCwyMCBAQCBpbnQgYmF0YWR2X21lc2hfaW5p
dChzdHJ1Y3QgbmV0X2RldmljZSAqc29mdF9pZmFjZSkKIAogCXJldHVybiAwOwogCi1lcnI6
Ci0JYmF0YWR2X21lc2hfZnJlZShzb2Z0X2lmYWNlKTsKK2Vycl9uYzoKKwliYXRhZHZfZGF0
X2ZyZWUoYmF0X3ByaXYpOworZXJyX2RhdDoKKwliYXRhZHZfYmxhX2ZyZWUoYmF0X3ByaXYp
OworZXJyX2JsYToKKwliYXRhZHZfdl9tZXNoX2ZyZWUoYmF0X3ByaXYpOworZXJyX3Y6CisJ
YmF0YWR2X3R0X2ZyZWUoYmF0X3ByaXYpOworZXJyX3R0OgorCWJhdGFkdl9vcmlnaW5hdG9y
X2ZyZWUoYmF0X3ByaXYpOworZXJyX29yaWc6CisJYmF0YWR2X3B1cmdlX291dHN0YW5kaW5n
X3BhY2tldHMoYmF0X3ByaXYsIE5VTEwpOworCWF0b21pY19zZXQoJmJhdF9wcml2LT5tZXNo
X3N0YXRlLCBCQVRBRFZfTUVTSF9JTkFDVElWRSk7CisKIAlyZXR1cm4gcmV0OwogfQogCmRp
ZmYgLS1naXQgYS9uZXQvYmF0bWFuLWFkdi9uZXR3b3JrLWNvZGluZy5jIGIvbmV0L2JhdG1h
bi1hZHYvbmV0d29yay1jb2RpbmcuYwppbmRleCA5ZjA2MTMyZTAwN2QuLjBhN2YxZDM2YTZh
OCAxMDA2NDQKLS0tIGEvbmV0L2JhdG1hbi1hZHYvbmV0d29yay1jb2RpbmcuYworKysgYi9u
ZXQvYmF0bWFuLWFkdi9uZXR3b3JrLWNvZGluZy5jCkBAIC0xNTIsOCArMTUyLDEwIEBAIGlu
dCBiYXRhZHZfbmNfbWVzaF9pbml0KHN0cnVjdCBiYXRhZHZfcHJpdiAqYmF0X3ByaXYpCiAJ
CQkJICAgJmJhdGFkdl9uY19jb2RpbmdfaGFzaF9sb2NrX2NsYXNzX2tleSk7CiAKIAliYXRf
cHJpdi0+bmMuZGVjb2RpbmdfaGFzaCA9IGJhdGFkdl9oYXNoX25ldygxMjgpOwotCWlmICgh
YmF0X3ByaXYtPm5jLmRlY29kaW5nX2hhc2gpCisJaWYgKCFiYXRfcHJpdi0+bmMuZGVjb2Rp
bmdfaGFzaCkgeworCQliYXRhZHZfaGFzaF9kZXN0cm95KGJhdF9wcml2LT5uYy5jb2Rpbmdf
aGFzaCk7CiAJCWdvdG8gZXJyOworCX0KIAogCWJhdGFkdl9oYXNoX3NldF9sb2NrX2NsYXNz
KGJhdF9wcml2LT5uYy5kZWNvZGluZ19oYXNoLAogCQkJCSAgICZiYXRhZHZfbmNfZGVjb2Rp
bmdfaGFzaF9sb2NrX2NsYXNzX2tleSk7CmRpZmYgLS1naXQgYS9uZXQvYmF0bWFuLWFkdi90
cmFuc2xhdGlvbi10YWJsZS5jIGIvbmV0L2JhdG1hbi1hZHYvdHJhbnNsYXRpb24tdGFibGUu
YwppbmRleCBlMGIzZGFjZTIwMjAuLjJjMzhkOWNiNGNjNCAxMDA2NDQKLS0tIGEvbmV0L2Jh
dG1hbi1hZHYvdHJhbnNsYXRpb24tdGFibGUuYworKysgYi9uZXQvYmF0bWFuLWFkdi90cmFu
c2xhdGlvbi10YWJsZS5jCkBAIC00MTYyLDggKzQxNjIsMTAgQEAgaW50IGJhdGFkdl90dF9p
bml0KHN0cnVjdCBiYXRhZHZfcHJpdiAqYmF0X3ByaXYpCiAJCXJldHVybiByZXQ7CiAKIAly
ZXQgPSBiYXRhZHZfdHRfZ2xvYmFsX2luaXQoYmF0X3ByaXYpOwotCWlmIChyZXQgPCAwKQor
CWlmIChyZXQgPCAwKSB7CisJCWJhdGFkdl90dF9nbG9iYWxfdGFibGVfZnJlZShiYXRfcHJp
dik7CiAJCXJldHVybiByZXQ7CisJfQogCiAJYmF0YWR2X3R2bHZfaGFuZGxlcl9yZWdpc3Rl
cihiYXRfcHJpdiwgYmF0YWR2X3R0X3R2bHZfb2dtX2hhbmRsZXJfdjEsCiAJCQkJICAgICBi
YXRhZHZfdHRfdHZsdl91bmljYXN0X2hhbmRsZXJfdjEsCg==
--------------CvkaH0ihFkENdKmg5e7QlCGq--

