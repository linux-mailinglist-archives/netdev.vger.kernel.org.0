Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD81486F82
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 02:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344120AbiAGBNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 20:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239981AbiAGBNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 20:13:14 -0500
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47C5C061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 17:13:13 -0800 (PST)
Received: by mail-qv1-xf41.google.com with SMTP id fo11so4075447qvb.4
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 17:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=QAEdVKVuvHVd9j7iecOaSeXb2zUVUgiL+u5lq+ovFH8=;
        b=CRPuUbTggXNa5VjeLyMJy2rKTss5XA3TETo3YAk3JOolEqaS3nJFAu4GGIfgZeK8jZ
         uZXfReZH0tzy54D/nnReJmAiMwduC0VvwvfuoF4Ot0tmnvaaB3YT8U1L/A5jqGZszKdY
         Ia4ISxl8H//Kgd5AkTi62rO+NNpWf0TfhvGihQpNsVkZDemKQW6t/ms/VSRYlp9sUmqK
         VVfnYxLE/lkR7J4qYurQ7oUV9s0oAAD+PTDVvqz2qUobKQT9Zgdv1sMjhNO6iftcFyNa
         BtoBHy0TksRclHiFvMa30Qly/ugyGwEBzyCXrqA9Isz8PudhShwtviVC9aDudjMR/g20
         4hMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=QAEdVKVuvHVd9j7iecOaSeXb2zUVUgiL+u5lq+ovFH8=;
        b=oGJkC5pH7s+sbAw4pBb+uzlGamG1ELxWlc3VFC8BIC57ZvdMVFeHfeKeYN8tsgnTnG
         PErTrVGCDwif8RhsXK4zdAgQEBWa107wD/ze1pa/t1pupg5avHiYRknrjIo8ZrvgDYH8
         h0QEpss2q55SeUPCuEFbMH7fphlQQ+tv5IOBctch1I1YjOrMuNoytC69JR7pQuY9ACez
         oSQCsLZ+w4mQFrdLoTzSsS3xuxV8NR2QyNLpg5omUD2VhbE48QxPyJi+JzPjicuv/tpS
         j6syS1+xfaW8zIV0X+ARsx4Et4cyOA0xwU41ZuZEY9wfM9gaVqE5sJ0eQY2nUk6XSm8w
         7SVQ==
X-Gm-Message-State: AOAM530rHg6y6H2pymLjDdzZltX44dTKBAon2SttaQxAltHkRvLRBlpO
        Xzh3Pd+X2oB3zsbEkrA0Dke+OEkNiTbAxMSdOT4=
X-Google-Smtp-Source: ABdhPJw7JXY8ljQtFMHQ9XVRsMe2tNNK7gUOcNVcJ1rAdSKU/xqPXgPSSJOrNfEKFO0XgVH+wmSICVb2xSLSgtJa4yQ=
X-Received: by 2002:a05:6214:76a:: with SMTP id f10mr58066131qvz.4.1641517992641;
 Thu, 06 Jan 2022 17:13:12 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ad4:5bc7:0:0:0:0:0 with HTTP; Thu, 6 Jan 2022 17:13:11 -0800 (PST)
Reply-To: mr.luisfernando5050@gmail.com
From:   "Mr. Luis Fernando" <mrahmedmo04@gmail.com>
Date:   Thu, 6 Jan 2022 17:13:11 -0800
Message-ID: <CAC+b6+W+iJtuY9kgkHgy9=iXt75sXAQ0QjsgJgjkFVjisinSdg@mail.gmail.com>
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
Lmx1aXNmZXJuYW5kbzUwNTBAZ21haWwuY29tKSBNci5sdWlzIEZlcm5hbmRvDQoNCg0KDQoNCuaI
keaYr+i3r+aYk+aWr8K36LS55bCU5Y2X5aSa5YWI55SfDQoNCuWXqO+8jOaci+WPi++8jOaIkeWc
qOW4g+Wfuue6s+azlee0oueahOS4gOWutumdnua0sumTtuihjCAoQk9BKSDlt6XkvZwNCg0K5oiR
5oOz6YCa6L+HIEFUTSBWSVNBIENBUkQg5bCG5LiA56yU5bqf5byD55qEIDI3NTAg5LiH576O5YWD
6L2s57uZ5oKo77yMMC41MCUg5bCG5piv57uZ5oKo55qE44CCIOS4jea2ieWPiumjjumZqeOAgg0K
DQoNCuiuuOWkmumdnua0suaUv+WuouWIqeeUqCAoQk9BKSDpk7booYzlsIbotYTph5HvvIjmlL/l
rqLmjqDlpLrkuobotoXov4cgNTANCuS6v+e+juWFg++8iei9rOenu+WIsOS7luS7rOeahOWkluWb
vei0puaIt++8jOS7luS7rOS5n+aHkuW+l+efpemBk+i9rOenu+S6huWkmuWwke+8jOWboOS4uui/
meS6m+i1hOmHkeWxnuS6juKAnOWbveWutuKAnQ0K5Li65LuA5LmI5oiR6L+Y5Yaz5a6a5oqK546w
5Zyo6ZW/5pyf5L+d566h5Zyo5oiR5Lus6ZO26KGM55qEMjc1MOS4h+e+juWFg+WIhuW8gO+8gQ0K
DQogIOaIkeW/hemhu+e7meS9oOaJgOacieW/heimgeeahOaMh+WvvOaWuemSiO+8jOi/meagt+S9
oOWwseS4jeS8mueKr+S7u+S9lemUmeivr+OAgiDlpoLmnpzmgqjmnInog73lipvlpITnkIbkuqTm
mJPvvIzor7fogZTns7vmiJHkuobop6Pmm7TlpJror6bmg4XjgIIg6K+35Zue5aSN5oiR55qE5aSH
55So55S15a2Q6YKu5Lu25Zyw5Z2ADQoobXIubHVpc2Zlcm5hbmRvNTA1MEBnbWFpbC5jb20pIE1y
Lmx1aXMgRmVybmFuZG8NCg==
