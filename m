Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64871975FE
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgC3HvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:51:10 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:36108 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgC3HvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 03:51:09 -0400
Received: by mail-wm1-f47.google.com with SMTP id g62so20771756wme.1;
        Mon, 30 Mar 2020 00:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=D28hmkivPrtN/O6CqDfORJ7ebgvb0TsqZVcNv4tRkIs=;
        b=W2Ny2ePV9Ja2QJ6GQK6MC7elQP/kdG50R/KXXykuMXMC6oBEUJXKfUPdbw+FKNmsK2
         gmlDW0rcS3c7deM74ehER9TI/fsTbZsK9a5a1eKxiY3kOgWFsV3MiMcpeDGCDLI8b0Ev
         LHyuy8OKv9wO98Qea+8X62eeBUze02z/Tealt1d7BwjIAnoP7/fF8lQConZXFVPLqEtT
         ivydsvTVEAXqFBfhMuJzK8FsMfrEf55cqp9lAAQd3oWZvW7amINbqZyYiILfqDy1zXaY
         eI7Vp+g4Tc+nXCdQ8THKTKqXjBfWol4OHVKy1Xgf58EOK92iL02gdJaygnGcxAxX8gae
         dySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=D28hmkivPrtN/O6CqDfORJ7ebgvb0TsqZVcNv4tRkIs=;
        b=IHGrIDU8KDY5TN352QQwajsX99QIeHzlwnF+cilUvmo33Fp814tzfEFEq8erpO7PvY
         Y/DQYYxS3UyX6j49riohstXFkwJ/kH3WmeW7mzrCtvfJfs22gnJB3VJSTkklvPw8V9Cr
         kZagwG9sY6dbx3pMrJ9lJPTMl3qh9Ar640qS4IUdNfXZTokh7MBZkDd9dIbjAT45QNno
         9zKTB1jTtyQpXEF51ScJ0xV5WIJQZJZIbHfFjClhhqLqE0lFmRz+scr3eR09RqfzlMoo
         ioYOdGL3kkxH6fs/2vuLbousHbBZUHQWfaMzt98LVYpCAqfCqJYyXCXCek4iiqTErkuD
         LkBA==
X-Gm-Message-State: ANhLgQ0ITYDzvi0Ei28Rd0YNg1pGDUuIIH05QqN+HzDSqWOCET/nX/SO
        kfk4X17D9AVYvQ8yQyCBQ/fxWcFn05ztdGSLI0BVJ2y0
X-Google-Smtp-Source: ADFU+vu4YJXTYMM5co0HTqxQQgtJr05IoSoBeW7LatDa0J/GFsOarG1f1culHijFFh6+A4AtT5AENM/NmlQzfaE6t8w=
X-Received: by 2002:a1c:1bd2:: with SMTP id b201mr12376200wmb.181.1585554667212;
 Mon, 30 Mar 2020 00:51:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAM7-yPTUgdbEeVvpWgGfB_eb==m0HPj8FpM0P+P-E0aBr35mgw@mail.gmail.com>
In-Reply-To: <CAM7-yPTUgdbEeVvpWgGfB_eb==m0HPj8FpM0P+P-E0aBr35mgw@mail.gmail.com>
From:   Yun Levi <ppbuk5246@gmail.com>
Date:   Mon, 30 Mar 2020 16:50:56 +0900
Message-ID: <CAM7-yPSjawc1EhG--dOEJgEQ--qBuk6THGW1Qp4oHYTtDrjhSQ@mail.gmail.com>
Subject: Fwd: Some happening when using BIND mount with network namespace.
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000b6750905a20db61a"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b6750905a20db61a
Content-Type: text/plain; charset="UTF-8"

---------- Forwarded message ---------
From: Yun Levi <ppbuk5246@gmail.com>
Date: Mon, Mar 30, 2020 at 3:01 PM
Subject: Some happening when using BIND mount with network namespace.
To: Alexander Viro <viro@zeniv.linux.org.uk>, David S. Miller
<davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Guillaume
Nault <gnault@redhat.com>, Nicolas Dichtel
<nicolas.dichtel@6wind.com>, Eric Dumazet <edumazet@google.com>, David
Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
Li RongQing <lirongqing@baidu.com>, Johannes Berg
<johannes.berg@intel.com>, <linux-fsdevel@vger.kernel.org>,
<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>


Hello. I'm Levi who is the beginner of Linux kernel.

When I use system calls related to network namespace, I got a some
problem in below scenario.
That's why I want to distinguish it's prohibit case for using unshare
and setns system call.

    1. Forking the process.
    2. [PARENT] Waiting the Child till the end.
    3. [CHILD] unshare for creating new network namespace
    4. [CHILD] Bind mount /proc/self/ns/net to some mount point.
    5. [CHILD] Exit child.
    6. [PARENT] Try to setns with binded mount point

In my analysis I confirm step 4 to 6 makes problem.
When we try to bind network namespace, it doesn't increase reference
count of related network namespace which saved on inode->i_private.
That's why network namespace made by unshare system call will be free on Step 5.

But on bind mountpoint, it still has network namespace pointer that was freed.
This makes some memory corruption on kernel when someone require to
allocate memory and give the pointer which allocated to the network
namespace made by Step 3.
That's why I can see the some Kernel Panic when I kill the some process...

So I attach some patch file to fix this problem.
But I want to distinguish it abnormal usage or not and this patch
should be applied.

Thank you for reading.

HTH.
Levi.

--000000000000b6750905a20db61a
Content-Type: application/octet-stream; 
	name="fix_netns_dangling_inode2.patch"
Content-Disposition: attachment; filename="fix_netns_dangling_inode2.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k8e691tu0>
X-Attachment-Id: f_k8e691tu0

ZGlmZiAtLWdpdCBhL2ZzL25hbWVzcGFjZS5jIGIvZnMvbmFtZXNwYWNlLmMKaW5kZXggODViNWY3
YmVhODJlLi44OGViZGUzOTk1OWYgMTAwNjQ0Ci0tLSBhL2ZzL25hbWVzcGFjZS5jCisrKyBiL2Zz
L25hbWVzcGFjZS5jCkBAIC0zMSw2ICszMSwxMCBAQAogI2luY2x1ZGUgPGxpbnV4L2ZzX2NvbnRl
eHQuaD4KICNpbmNsdWRlIDxsaW51eC9zaG1lbV9mcy5oPgoKKyNpZmRlZiBDT05GSUdfTkVUX05T
CisjaW5jbHVkZSA8bmV0L25ldF9uYW1lc3BhY2UuaD4KKyNlbmRpZgorCiAjaW5jbHVkZSAicG5v
ZGUuaCIKICNpbmNsdWRlICJpbnRlcm5hbC5oIgoKQEAgLTEwMTMsMTIgKzEwMTcsMjUgQEAgdmZz
X3N1Ym1vdW50KGNvbnN0IHN0cnVjdCBkZW50cnkgKm1vdW50cG9pbnQsIHN0cnVjdCBmaWxlX3N5
c3RlbV90eXBlICp0eXBlLAogfQogRVhQT1JUX1NZTUJPTF9HUEwodmZzX3N1Ym1vdW50KTsKCisj
aWZkZWYgQ09ORklHX05FVF9OUworc3RhdGljIGJvb2wgaXNfbmV0X25zX2ZpbGUoc3RydWN0IGRl
bnRyeSAqZGVudHJ5KQoreworCS8qIElzIHRoaXMgYSBwcm94eSBmb3IgYSBtb3VudCBuYW1lc3Bh
Y2U/ICovCisJcmV0dXJuIGRlbnRyeS0+ZF9vcCA9PSAmbnNfZGVudHJ5X29wZXJhdGlvbnMgJiYK
KwkgICAgICAgZGVudHJ5LT5kX2ZzZGF0YSA9PSAmbmV0bnNfb3BlcmF0aW9uczsKK30KKyNlbmRp
ZgorCiBzdGF0aWMgc3RydWN0IG1vdW50ICpjbG9uZV9tbnQoc3RydWN0IG1vdW50ICpvbGQsIHN0
cnVjdCBkZW50cnkgKnJvb3QsCiAJCQkJCWludCBmbGFnKQogewogCXN0cnVjdCBzdXBlcl9ibG9j
ayAqc2IgPSBvbGQtPm1udC5tbnRfc2I7CiAJc3RydWN0IG1vdW50ICptbnQ7CiAJaW50IGVycjsK
KyNpZmRlZiBDT05GSUdfTkVUX05TCisJc3RydWN0IG5zX2NvbW1vbiAqbnMgPSBOVUxMOworCXN0
cnVjdCBuZXQgKm5ldCA9IE5VTEw7CisjZW5kaWYKCiAJbW50ID0gYWxsb2NfdmZzbW50KG9sZC0+
bW50X2Rldm5hbWUpOwogCWlmICghbW50KQpAQCAtMTAzNSw2ICsxMDUyLDIwIEBAIHN0YXRpYyBz
dHJ1Y3QgbW91bnQgKmNsb25lX21udChzdHJ1Y3QgbW91bnQgKm9sZCwgc3RydWN0IGRlbnRyeSAq
cm9vdCwKIAkJCWdvdG8gb3V0X2ZyZWU7CiAJfQoKKyNpZmRlZiBDT05GSUdfTkVUX05TCisJaWYg
KCEoZmxhZyAmIENMX0NPUFlfTU5UX05TX0ZJTEUpICYmIGlzX25ldF9uc19maWxlKHJvb3QpKSB7
CisJCW5zID0gZ2V0X3Byb2NfbnMoZF9pbm9kZShyb290KSk7CisJCWlmIChucyA9PSBOVUxMIHx8
IG5zLT5vcHMtPnR5cGUgIT0gQ0xPTkVfTkVXTkVUKSB7CisJCQllcnIgPSAtRUlOVkFMOworCisJ
CQlnb3RvIG91dF9mcmVlOworCQl9CisKKwkJbmV0ID0gdG9fbmV0X25zKG5zKTsKKwkJbmV0ID0g
Z2V0X25ldChuZXQpOworCX0KKyNlbmRpZgorCiAJbW50LT5tbnQubW50X2ZsYWdzID0gb2xkLT5t
bnQubW50X2ZsYWdzOwogCW1udC0+bW50Lm1udF9mbGFncyAmPSB+KE1OVF9XUklURV9IT0xEfE1O
VF9NQVJLRUR8TU5UX0lOVEVSTkFMKTsKCmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9uZXRfbmFt
ZXNwYWNlLmggYi9pbmNsdWRlL25ldC9uZXRfbmFtZXNwYWNlLmgKaW5kZXggODU0ZDM5ZWYxY2Ez
Li5kZjNmYjA2NmEwMDIgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0L25ldF9uYW1lc3BhY2UuaAor
KysgYi9pbmNsdWRlL25ldC9uZXRfbmFtZXNwYWNlLmgKQEAgLTQ2OSw0ICs0NjksMTEgQEAgc3Rh
dGljIGlubGluZSB2b2lkIGZuaGVfZ2VuaWRfYnVtcChzdHJ1Y3QgbmV0ICpuZXQpCiAJYXRvbWlj
X2luYygmbmV0LT5mbmhlX2dlbmlkKTsKIH0KCisjaWZkZWYgQ09ORklHX05FVF9OUworc3RhdGlj
IGlubGluZSBzdHJ1Y3QgbmV0ICp0b19uZXRfbnMoc3RydWN0IG5zX2NvbW1vbiAqbnMpCit7CisJ
cmV0dXJuIGNvbnRhaW5lcl9vZihucywgc3RydWN0IG5ldCwgbnMpOworfQorI2VuZGlmCisKICNl
bmRpZiAvKiBfX05FVF9ORVRfTkFNRVNQQUNFX0ggKi8KZGlmZiAtLWdpdCBhL25ldC9jb3JlL25l
dF9uYW1lc3BhY2UuYyBiL25ldC9jb3JlL25ldF9uYW1lc3BhY2UuYwppbmRleCA3NTdjYzFkMDg0
ZTcuLmI2NzcxYzIwMTgwNSAxMDA2NDQKLS0tIGEvbmV0L2NvcmUvbmV0X25hbWVzcGFjZS5jCisr
KyBiL25ldC9jb3JlL25ldF9uYW1lc3BhY2UuYwpAQCAtMTMyOCwxMSArMTMyOCw2IEBAIHN0YXRp
YyBzdHJ1Y3QgbnNfY29tbW9uICpuZXRuc19nZXQoc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrKQog
CXJldHVybiBuZXQgPyAmbmV0LT5ucyA6IE5VTEw7CiB9Cgotc3RhdGljIGlubGluZSBzdHJ1Y3Qg
bmV0ICp0b19uZXRfbnMoc3RydWN0IG5zX2NvbW1vbiAqbnMpCi17Ci0JcmV0dXJuIGNvbnRhaW5l
cl9vZihucywgc3RydWN0IG5ldCwgbnMpOwotfQotCiBzdGF0aWMgdm9pZCBuZXRuc19wdXQoc3Ry
dWN0IG5zX2NvbW1vbiAqbnMpCiB7CiAJcHV0X25ldCh0b19uZXRfbnMobnMpKTsK
--000000000000b6750905a20db61a--
