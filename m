Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3053486F8B
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 02:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344051AbiAGBQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 20:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345141AbiAGBQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 20:16:03 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E0FC061212
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 17:16:03 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id w20so8076792wra.9
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 17:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=+dkiLt9yMO6x46qZW333QEXi70FYxlft58uImyv90V8=;
        b=WZ8kAJ/A+Jh6LzR+UC5PWkn88AzR1nvEhCM4pff2BPdaP3YgxlpOMZI9Gbhjc6lNSW
         NZA9o0lTjznelEB3IZc5llQA8LdT1XiPijCwjFFkovmdQnXHXlQQG4kLcSoenbNlQRnq
         lsTmp+hnh2VHv/XE6RHAySv8bWaa2JAj5AKOAIfdUVYbTUi/ADsNPAiOhYNflCtMeUO3
         2APuZ7E8wqx8+9tmG5EoQdDw31/iHrxnksd8ua8+MwU6D5YfIpDev9Hp7FQ6lti8RoqE
         M3sDulU2iteiWu3KH5Pq2otZIISX0/ZvyGlGgjsDgQUvTyc7JfX1BArnEqWTSE5U5uJ0
         L4ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=+dkiLt9yMO6x46qZW333QEXi70FYxlft58uImyv90V8=;
        b=d8JnpR7z3e8m7hYjrAORGNCUtcbqmEzWYmptuFYQWjQtkz0sI190uo1gXsaYV8yTBW
         c+52Lg1rw4avbPN3U3LCNqXy88RYRIMKBciaVdd/aui59W1CBCfKYybDW3s4U3X2VRdy
         wCTnsPzurzBn+2fu9iAqcm29gfYHp04QWgfF3Bo3NO8zHjJ0IDCQFQtGi/SPzcxZg2DT
         EiCwA+5L7heqCAEitqfk9XFQjkuROYQDeLnmhVA0Vhs0L5i2/DIeO47UkG+hdDF1Ez8F
         GTuXbeLglBLpbGP4GGF2d3Op1Vp9VKpTDkaA+xRH6IONS27PGZT1seL6DGNIwnNHJs9w
         Kb8w==
X-Gm-Message-State: AOAM532hLs2deBRXZ4DThAvEOvDs44IhlEKWbAQVST1o77EBF6P+078E
        MUroTgtDvkoZ7U/s4QfVOYhV4zP0m2SuFnGTOZQ=
X-Google-Smtp-Source: ABdhPJwraLF27rUehlGolQ00d+pn5MVfPzumRwY6Q7I+AU4GmEOO9n5SVCBAFN8N1rwjr6Jqvrc0v+/ikj3oo061WPw=
X-Received: by 2002:a5d:6c6c:: with SMTP id r12mr53228414wrz.532.1641518161805;
 Thu, 06 Jan 2022 17:16:01 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6000:110c:0:0:0:0 with HTTP; Thu, 6 Jan 2022 17:16:01
 -0800 (PST)
Reply-To: mr.luisfernando5050@gmail.com
From:   "Mr. Luis Fernando" <kasimmohamed0099@gmail.com>
Date:   Thu, 6 Jan 2022 17:16:01 -0800
Message-ID: <CANUogzV=sNCOvSUZPFnTdOw0iSaJopOhDtoLDW9dScToL84bZw@mail.gmail.com>
Subject: GOOD DAY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0gDQpJIGFtIE1yLmx1aXMgZmVybmFuZG8NCg0KSGkgRnJpZW5kIEkgd29yayBpbiBhIEJhbmsg
Zm9yIEFmcmljYSAoQk9BKSBoZXJlIGluIEJVUktJTkEgRkFTTw0KDQpJIHdhbnRzIHRvIHRyYW5z
ZmVyIGFuIGFiYW5kb25lZCBzdW0gb2YgMjcuNSBtaWxsaW9ucyBVU0QgdG8geW91DQp0aHJvdWdo
IEFUTSBWSVNBIENBUkQgLjUwJSB3aWxsIGJlIGZvciB5b3UuIE5vIHJpc2sgaW52b2x2ZWQuDQoN
Cg0KVGhlIChCT0EpIGJhbmsgd2FzIGJlaW5nIHVzZWQgYnkgbWFueSBBZnJpY2FuIFBvbGl0aWNp
YW5zIHRvIGRpdmVydA0KZnVuZHMgKHRoZSBQb2xpdGljaWFucyBsb290ZWQgb3ZlcjViaWxsaW9u
IFVuaXRlZCBTdGF0ZXMgZG9sbGFycykgdG8NCnRoZWlyIGZvcmVpZ24gYWNjb3VudHMgYW5kIHRo
ZXkgZGlkIE5vdCBib3RoZXIgdG8ga25vdyBob3cgbXVjaCB3YXMNCnRyYW5zZmVycmVkIGJlY2F1
c2UgdGhlIGZ1bmRzIGJlbG9uZ2VkIHRvIHRoZSAnU3RhdGUnIHRoYXQgaXMgd2h5IEkNCmFsc28g
ZGVjaWRlZCB0byBwdXQgYXBhcnQgdGhlIHN1bSBvZiAgJDI3LjVtaWxsaW9uIERvbGxhcnMgd2hp
Y2ggaXMNCnN0aWxsIGluIG91ciBiYW5rIHVuZGVyIG15IGN1c3RvZHkgZm9yIGEgbG9uZyBwZXJp
b2Qgbm93IQ0KDQpJIGhhdmUgdG8gZ2l2ZSB5b3UgYWxsIHRoZSByZXF1aXJlZCBndWlkZWxpbmVz
IHNvIHRoYXQgeW91IGRvIG5vdA0KbWFrZSBhbnkgbWlzdGFrZS4gSWYgeW91IGFyZSBjYXBhYmxl
IHRvIGhhbmRsZSB0aGUgdHJhbnNhY3Rpb24gQ29udGFjdA0KbWUgZm9yIG1vcmUgZGV0YWlscy4g
S2luZGx5IHJlcGx5IG1lIGJhY2sgdG8gbXkgYWx0ZXJuYXRpdmUgZW1haWwNCmFkZHJlc3MgKG1y
Lmx1aXNmZXJuYW5kbzUwNTBAZ21haWwuY29tKSBNci5sdWlzIEZlcm5hbmRvDQoNCg0KDQoNCg0K
DQrmiJHmmK/ot6/mmJPmlq/Ct+i0ueWwlOWNl+WkmuWFiOeUnw0KDQrll6jvvIzmnIvlj4vvvIzm
iJHlnKjluIPln7rnurPms5XntKLnmoTkuIDlrrbpnZ7mtLLpk7booYwgKEJPQSkg5bel5L2cDQoN
CuaIkeaDs+mAmui/hyBBVE0gVklTQSBDQVJEIOWwhuS4gOeslOW6n+W8g+eahCAyNzUwIOS4h+e+
juWFg+i9rOe7meaCqO+8jDAuNTAlIOWwhuaYr+e7meaCqOeahOOAgiDkuI3mtonlj4rpo47pmanj
gIINCg0KDQrorrjlpJrpnZ7mtLLmlL/lrqLliKnnlKggKEJPQSkg6ZO26KGM5bCG6LWE6YeR77yI
5pS/5a6i5o6g5aS65LqG6LaF6L+HIDUwDQrkur/nvo7lhYPvvInovaznp7vliLDku5bku6znmoTl
pJblm73otKbmiLfvvIzku5bku6zkuZ/mh5Llvpfnn6XpgZPovaznp7vkuoblpJrlsJHvvIzlm6Dk
uLrov5nkupvotYTph5HlsZ7kuo7igJzlm73lrrbigJ0NCuS4uuS7gOS5iOaIkei/mOWGs+WumuaK
iueOsOWcqOmVv+acn+S/neeuoeWcqOaIkeS7rOmTtuihjOeahDI3NTDkuIfnvo7lhYPliIblvIDv
vIENCg0KICDmiJHlv4Xpobvnu5nkvaDmiYDmnInlv4XopoHnmoTmjIflr7zmlrnpkojvvIzov5nm
oLfkvaDlsLHkuI3kvJrniq/ku7vkvZXplJnor6/jgIIg5aaC5p6c5oKo5pyJ6IO95Yqb5aSE55CG
5Lqk5piT77yM6K+36IGU57O75oiR5LqG6Kej5pu05aSa6K+m5oOF44CCIOivt+WbnuWkjeaIkeea
hOWkh+eUqOeUteWtkOmCruS7tuWcsOWdgA0KKG1yLmx1aXNmZXJuYW5kbzUwNTBAZ21haWwuY29t
KSBNci5sdWlzIEZlcm5hbmRvDQo=
