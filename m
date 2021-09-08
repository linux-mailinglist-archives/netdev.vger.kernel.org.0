Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F76840329E
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 04:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347440AbhIHC1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 22:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347386AbhIHC1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 22:27:04 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD92EC061757;
        Tue,  7 Sep 2021 19:25:57 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id k24so920276pgh.8;
        Tue, 07 Sep 2021 19:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=KpE+tSoXtIOrVuWjkXbb+qiN54PPmFaUs54WUhu4gqg=;
        b=BkHHn77LAqXdcGy4v409R8lRlvO+MrZf1qVHKrfWSys1JSsFPjZ8pRBJ3iRtsEmg6I
         YzNch8dK74TpOJPHiCeXWlinHlcu5vHhnOfbhcfjzW0GToY8mDmYwHWR97ZJyb9A77NY
         ZhVV3yaRKB0WKy7NCsLwv0mZGqXTkScBn5NXhsa8DyFuePK20jUSBKj9TzSACPSTY3/g
         7JtnnMqoWWTOME2+eXBp5lfB1H7tc3PAKPhUF2AQVgcmAyusye5ejOn88YS2iXTNOTb/
         qrIrcut4KRh0dWxEJCCyvM0h+JbkoMHvoAeC1MMdBH68qO2I8ufb6GxpTIbrrNmEdzyD
         Knrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=KpE+tSoXtIOrVuWjkXbb+qiN54PPmFaUs54WUhu4gqg=;
        b=BP3MVETE5opO/SnokBVgQHgkhi3xjDWRSopoknkHaZ/aXjFEKN8PBlgvoIABCWTb2F
         9nvEl43VpOK+D2XEcUXYB0y2mQGkAQ+WqWPXmz0TPWUCRHlpyLx0t4azZjJ+1nc5BgLs
         HoiioNBdffCn/PPEqgmqJjGgZTLOaUUdSXQJgKN+7i+Rfn1naLbt3gX5sf0c1Nchp+Cw
         sap+lTi4zg65VLXe//M7OQBGinEOx6tIOuigoz/aJy/fivVSmS/Lz8bhST6tNySZZxyP
         otA8ztIibdNhApRX5DIuEbPMZA/pBxgLDNmRp87dk4xmwHKBacXZMef0BGb8CVChZiy5
         BK1w==
X-Gm-Message-State: AOAM53032x2U7rSXirsoioa5zWcd3zbjCT+8h07QMu/x4gzn5w1j3prB
        taildJGTaeQnRnRVp635hZL4tjGh6rfWtHdAVXQ=
X-Google-Smtp-Source: ABdhPJyzofjTb0czO2LIyAQi5gy0gAyChpYPgCp191UZsxkU6yXnFTt0PWUITu0Wm2quIn/pm6ka92QFPg7vTZAHSss=
X-Received: by 2002:a65:63d0:: with SMTP id n16mr1404509pgv.432.1631067957289;
 Tue, 07 Sep 2021 19:25:57 -0700 (PDT)
MIME-Version: 1.0
From:   Ujjal Roy <royujjal@gmail.com>
Date:   Wed, 8 Sep 2021 07:55:45 +0530
Message-ID: <CAE2MWknAvL01A9V44PaODencJpGFHuOzH36h4ry=pbgOf4B9jw@mail.gmail.com>
Subject: ip6mr: Indentation not proper in ip6mr_cache_report()
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc:     Kernel <linux-kernel@vger.kernel.org>,
        Kernel <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000339ba105cb729a62"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000339ba105cb729a62
Content-Type: text/plain; charset="UTF-8"

Hi All,

Before sending the patch, I am writing this email to get your
attention please. As per my knowledge I can see ip6mr_cache_report()
has some indentation issues. Please have a look at the line 1085.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv6/ip6mr.c#n1085

Sharing a patch based on the latest stable Linux.

Thanks,
UjjaL Roy

--000000000000339ba105cb729a62
Content-Type: application/octet-stream; 
	name="ip6mr-ip6mr_cache_report-indent-fix.patch"
Content-Disposition: attachment; 
	filename="ip6mr-ip6mr_cache_report-indent-fix.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ktavq4ka0>
X-Attachment-Id: f_ktavq4ka0

ZGlmZiAtLWdpdCBhL25ldC9pcHY2L2lwNm1yLmMgYi9uZXQvaXB2Ni9pcDZtci5jCmluZGV4IDM2
ZWQ5ZWZiODgyNS4uYWE1Yjg4NGE4MTllIDEwMDY0NAotLS0gYS9uZXQvaXB2Ni9pcDZtci5jCisr
KyBiL25ldC9pcHY2L2lwNm1yLmMKQEAgLTEwODIsMzAgKzEwODIsMjYgQEAgc3RhdGljIGludCBp
cDZtcl9jYWNoZV9yZXBvcnQoc3RydWN0IG1yX3RhYmxlICptcnQsIHN0cnVjdCBza19idWZmICpw
a3QsCiAJfSBlbHNlCiAjZW5kaWYKIAl7Ci0JLyoKLQkgKglDb3B5IHRoZSBJUCBoZWFkZXIKLQkg
Ki8KKwkJLyogQ29weSB0aGUgSVAgaGVhZGVyICovCisJCXNrYl9wdXQoc2tiLCBzaXplb2Yoc3Ry
dWN0IGlwdjZoZHIpKTsKKwkJc2tiX3Jlc2V0X25ldHdvcmtfaGVhZGVyKHNrYik7CisJCXNrYl9j
b3B5X3RvX2xpbmVhcl9kYXRhKHNrYiwgaXB2Nl9oZHIocGt0KSwKKwkJCQkJc2l6ZW9mKHN0cnVj
dCBpcHY2aGRyKSk7CisKKwkJLyogQWRkIG91ciBoZWFkZXIgKi8KKwkJc2tiX3B1dChza2IsIHNp
emVvZigqbXNnKSk7CisJCXNrYl9yZXNldF90cmFuc3BvcnRfaGVhZGVyKHNrYik7CisJCW1zZyA9
IChzdHJ1Y3QgbXJ0Nm1zZyAqKXNrYl90cmFuc3BvcnRfaGVhZGVyKHNrYik7CiAKLQlza2JfcHV0
KHNrYiwgc2l6ZW9mKHN0cnVjdCBpcHY2aGRyKSk7Ci0Jc2tiX3Jlc2V0X25ldHdvcmtfaGVhZGVy
KHNrYik7Ci0Jc2tiX2NvcHlfdG9fbGluZWFyX2RhdGEoc2tiLCBpcHY2X2hkcihwa3QpLCBzaXpl
b2Yoc3RydWN0IGlwdjZoZHIpKTsKKwkJbXNnLT5pbTZfbWJ6ID0gMDsKKwkJbXNnLT5pbTZfbXNn
dHlwZSA9IGFzc2VydDsKKwkJbXNnLT5pbTZfbWlmID0gbWlmaTsKKwkJbXNnLT5pbTZfcGFkID0g
MDsKKwkJbXNnLT5pbTZfc3JjID0gaXB2Nl9oZHIocGt0KS0+c2FkZHI7CisJCW1zZy0+aW02X2Rz
dCA9IGlwdjZfaGRyKHBrdCktPmRhZGRyOwogCi0JLyoKLQkgKglBZGQgb3VyIGhlYWRlcgotCSAq
LwotCXNrYl9wdXQoc2tiLCBzaXplb2YoKm1zZykpOwotCXNrYl9yZXNldF90cmFuc3BvcnRfaGVh
ZGVyKHNrYik7Ci0JbXNnID0gKHN0cnVjdCBtcnQ2bXNnICopc2tiX3RyYW5zcG9ydF9oZWFkZXIo
c2tiKTsKLQotCW1zZy0+aW02X21ieiA9IDA7Ci0JbXNnLT5pbTZfbXNndHlwZSA9IGFzc2VydDsK
LQltc2ctPmltNl9taWYgPSBtaWZpOwotCW1zZy0+aW02X3BhZCA9IDA7Ci0JbXNnLT5pbTZfc3Jj
ID0gaXB2Nl9oZHIocGt0KS0+c2FkZHI7Ci0JbXNnLT5pbTZfZHN0ID0gaXB2Nl9oZHIocGt0KS0+
ZGFkZHI7Ci0KLQlza2JfZHN0X3NldChza2IsIGRzdF9jbG9uZShza2JfZHN0KHBrdCkpKTsKLQlz
a2ItPmlwX3N1bW1lZCA9IENIRUNLU1VNX1VOTkVDRVNTQVJZOworCQlza2JfZHN0X3NldChza2Is
IGRzdF9jbG9uZShza2JfZHN0KHBrdCkpKTsKKwkJc2tiLT5pcF9zdW1tZWQgPSBDSEVDS1NVTV9V
Tk5FQ0VTU0FSWTsKIAl9CiAKIAlyY3VfcmVhZF9sb2NrKCk7Cg==
--000000000000339ba105cb729a62--
