Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D83039B15E
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 06:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhFDE0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 00:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhFDE0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 00:26:47 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00970C06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 21:24:50 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id m23so4548530uao.12
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 21:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=1p6Vhy2bTbozEOWPiJDqnwlyFOp9kKQyHPsFai3s6Lg=;
        b=qW/uR5O3rDg5dd8IHvrPzQ8HOQZR/KHzNqZvgtBQ+7I+Yb3/BtkaekaLeicOwW5gVZ
         atj914uqm++8JsQ5OgDaFt9nwX9ZHLDuCbZFGH6Neh0QccefSAT7n1GjXAP9wTNxh6MB
         qbIZ6u4OUJpTD0mMEXoqPzcGhLnatW6Ua39jNOej98wonvionSOQ9XWG0iX5jJjomjRx
         lTt1ALFs5Gkwe6EHl5Rx4gWdPnjLvHfIswcmwUgdjaq+AKopgL9S+f8Xjgq9WTItGfw7
         fJofcoCyb0eQkiF/YX52npfEpxiyhgMEWTxaNi4L1owEqx1P8lGVrkIlXXoRUsGL8pWB
         r/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=1p6Vhy2bTbozEOWPiJDqnwlyFOp9kKQyHPsFai3s6Lg=;
        b=APnAsahT0oe2zBy5CgE0EOvRC0IJNDlteYrBqDS18kMLtD2VWstUm35edgU3Z78OGy
         4e9Le0nOWOoSYtl3I7tNMdknPsFOrsOnUbcyzexbNxybL55C95WAD8EiudE1ghS9lnvE
         igqFRb8I86JkeF8CxPLbkCLYIVx1eqm7YqBbcUkKQy5cVQODvmFsNyUh+k8fZWQycVmi
         02dbdC7EfE1RDAY5mHSzMRYgKC0ZVWGto81Aw6dwzrwBoXnKx+rPqdz8jGo+LGjnS8z2
         OJATPSQG9Spwoy7uuA39Huk3hL+aLuzxfyEYEPCbqgyGXvOLG3ph6Qdy0Mwhv7uk7bpz
         I6ZQ==
X-Gm-Message-State: AOAM5322Bcd0R5nzRMUj/bYqT4sRFy+aF4WdLty1NalJ1TdKSba7Zcvm
        kCdsXv15axKkTkZbtRfN+XFFsKMTGpM1OsZ2yyFVL2CAvW7z0A==
X-Google-Smtp-Source: ABdhPJyRTuuz3T3aW5Rc1C6FnhYB75GgNtmjXeAPBppNp/eFmOx8/IY3RfGkQQm0Gvj7BbvvQU774kwtJEUNyrEEEHU=
X-Received: by 2002:ab0:185a:: with SMTP id j26mr1938928uag.33.1622780690000;
 Thu, 03 Jun 2021 21:24:50 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
        <socketpair@gmail.com>
Date:   Fri, 4 Jun 2021 09:24:39 +0500
Message-ID: <CAEmTpZHK7OoWxpGXKc0_=yYhW0YxQVZUYU3_Gkpf2VeA9xBMXw@mail.gmail.com>
Subject: [PATCH] ip link get dev if%u" now works
To:     netdev@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000093b7d105c3e912cf"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000093b7d105c3e912cf
Content-Type: text/plain; charset="UTF-8"

The same:
https://github.com/shemminger/iproute2/pull/43

I give any rights on this code, please merge.

-- 
Segmentation fault

--00000000000093b7d105c3e912cf
Content-Type: text/x-patch; charset="UTF-8"; name="ifu.patch"
Content-Disposition: attachment; filename="ifu.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kphtppc20>
X-Attachment-Id: f_kphtppc20

Y29tbWl0IGM3MWExNjRmYjNhYmJjZTE3N2NiMjY5MmUyNWViYzU0ZTAxNTZkNWEgKHJlZnMvcmVt
b3Rlcy9vcmlnaW4vZ2V0aW5kZXgpCkF1dGhvcjog0JrQvtGA0LXQvdCx0LXRgNCzIOKYou+4jyAg
0JzQsNGA0LogPG1hcmtAaWRlY28ucnU+CkRhdGU6ICAgVGh1IE1heSAxMyAxNTo0MzoxNCAyMDIx
ICswNTAwCgogICAgaXA6ICJpcCBsaW5rIGdldCBkZXYgaWYldSIgbm93IHdvcmtzCgpkaWZmIC0t
Z2l0IGEvaXAvaXBfY29tbW9uLmggYi9pcC9pcF9jb21tb24uaAppbmRleCA5YTMxZTgzNy4uMWVi
NDBhMWUgMTAwNjQ0Ci0tLSBhL2lwL2lwX2NvbW1vbi5oCisrKyBiL2lwL2lwX2NvbW1vbi5oCkBA
IC04OSw3ICs4OSw3IEBAIGludCBkb19zZWc2KGludCBhcmdjLCBjaGFyICoqYXJndik7CiBpbnQg
ZG9faXBuaChpbnQgYXJnYywgY2hhciAqKmFyZ3YpOwogaW50IGRvX21wdGNwKGludCBhcmdjLCBj
aGFyICoqYXJndik7CiAKLWludCBpcGxpbmtfZ2V0KGNoYXIgKm5hbWUsIF9fdTMyIGZpbHRfbWFz
ayk7CitpbnQgaXBsaW5rX2dldCh1bnNpZ25lZCBpZmluZGV4LCBfX3UzMiBmaWx0X21hc2spOwog
aW50IGlwbGlua19pZmxhX3hzdGF0cyhpbnQgYXJnYywgY2hhciAqKmFyZ3YpOwogCiBpbnQgaXBf
bGlua19saXN0KHJlcV9maWx0ZXJfZm5fdCBmaWx0ZXJfZm4sIHN0cnVjdCBubG1zZ19jaGFpbiAq
bGluZm8pOwpkaWZmIC0tZ2l0IGEvaXAvaXBhZGRyZXNzLmMgYi9pcC9pcGFkZHJlc3MuYwppbmRl
eCAwYmJjZWUyYi4uOWJlNmVhNGQgMTAwNjQ0Ci0tLSBhL2lwL2lwYWRkcmVzcy5jCisrKyBiL2lw
L2lwYWRkcmVzcy5jCkBAIC0xMCw2ICsxMCw3IEBACiAgKgogICovCiAKKyNpbmNsdWRlIDxhc3Nl
cnQuaD4KICNpbmNsdWRlIDxzdGRpby5oPgogI2luY2x1ZGUgPHN0ZGxpYi5oPgogI2luY2x1ZGUg
PHVuaXN0ZC5oPgpAQCAtMjExMSw3ICsyMTEyLDggQEAgc3RhdGljIGludCBpcGFkZHJfbGlzdF9m
bHVzaF9vcl9zYXZlKGludCBhcmdjLCBjaGFyICoqYXJndiwgaW50IGFjdGlvbikKIAkgKiB0aGUg
bGluayBkZXZpY2UKIAkgKi8KIAlpZiAoZmlsdGVyX2RldiAmJiBmaWx0ZXIuZ3JvdXAgPT0gLTEg
JiYgZG9fbGluayA9PSAxKSB7Ci0JCWlmIChpcGxpbmtfZ2V0KGZpbHRlcl9kZXYsIFJURVhUX0ZJ
TFRFUl9WRikgPCAwKSB7CisJCWFzc2VydChmaWx0ZXIuaWZpbmRleCk7CisJCWlmIChpcGxpbmtf
Z2V0KGZpbHRlci5pZmluZGV4LCBSVEVYVF9GSUxURVJfVkYpIDwgMCkgewogCQkJcGVycm9yKCJD
YW5ub3Qgc2VuZCBsaW5rIGdldCByZXF1ZXN0Iik7CiAJCQlkZWxldGVfanNvbl9vYmooKTsKIAkJ
CWV4aXQoMSk7CmRpZmYgLS1naXQgYS9pcC9pcGxpbmsuYyBiL2lwL2lwbGluay5jCmluZGV4IDI3
YzliZTQ0Li40MzI3MmM2YiAxMDA2NDQKLS0tIGEvaXAvaXBsaW5rLmMKKysrIGIvaXAvaXBsaW5r
LmMKQEAgLTExMDEsMjEgKzExMDEsMTcgQEAgc3RhdGljIGludCBpcGxpbmtfbW9kaWZ5KGludCBj
bWQsIHVuc2lnbmVkIGludCBmbGFncywgaW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCXJldHVybiAw
OwogfQogCi1pbnQgaXBsaW5rX2dldChjaGFyICpuYW1lLCBfX3UzMiBmaWx0X21hc2spCitpbnQg
aXBsaW5rX2dldCh1bnNpZ25lZCBpZmluZGV4LCBfX3UzMiBmaWx0X21hc2spCiB7CiAJc3RydWN0
IGlwbGlua19yZXEgcmVxID0gewogCQkubi5ubG1zZ19sZW4gPSBOTE1TR19MRU5HVEgoc2l6ZW9m
KHN0cnVjdCBpZmluZm9tc2cpKSwKIAkJLm4ubmxtc2dfZmxhZ3MgPSBOTE1fRl9SRVFVRVNULAog
CQkubi5ubG1zZ190eXBlID0gUlRNX0dFVExJTkssCiAJCS5pLmlmaV9mYW1pbHkgPSBwcmVmZXJy
ZWRfZmFtaWx5LAorCQkuaS5pZmlfaW5kZXggPSBpZmluZGV4LAogCX07CiAJc3RydWN0IG5sbXNn
aGRyICphbnN3ZXI7CiAKLQlpZiAobmFtZSkgewotCQlhZGRhdHRyX2woJnJlcS5uLCBzaXplb2Yo
cmVxKSwKLQkJCSAgIWNoZWNrX2lmbmFtZShuYW1lKSA/IElGTEFfSUZOQU1FIDogSUZMQV9BTFRf
SUZOQU1FLAotCQkJICBuYW1lLCBzdHJsZW4obmFtZSkgKyAxKTsKLQl9CiAJYWRkYXR0cjMyKCZy
ZXEubiwgc2l6ZW9mKHJlcSksIElGTEFfRVhUX01BU0ssIGZpbHRfbWFzayk7CiAKIAlpZiAocnRu
bF90YWxrKCZydGgsICZyZXEubiwgJmFuc3dlcikgPCAwKQo=
--00000000000093b7d105c3e912cf--
