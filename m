Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484E23E152C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241544AbhHEM5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbhHEM5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 08:57:32 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86698C061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 05:57:18 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id t7-20020a17090a5d87b029017807007f23so11334849pji.5
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 05:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=CUJAPxl/NPUJn40+0/B+dDcum5FvMyz50MbPQFWF6HU=;
        b=kSbrYQiRaYGFrCOTv470twLUCd30Zw4RwxpUWIHXF7EuiDGl+tdnhWMLgP6Udtu/l6
         Ojpts803+AsYFc3mnoCFnAwp5ERFRxBDIi6+uOrz+8mpzeMXsB/MHEGJPYQnTln8CJml
         qn5UWfusy+irJLgjOvYvujdVybPCCdl3LEwhs/BTtNkOMBmYjr6kcQaEtQ12kM50I71s
         V6rlTc/OptBdeejRzo6zSpXuLnVdYgC3kQwvn8HrY6MosrnVoibQJhyaq9FqvcHTRTZm
         Gi4E1WP9CkMS7hPI1ubDtFa1XClf5Ezxv663/fnPY2T1SXCkPxqLRLdLabGiSyinEGjZ
         MEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=CUJAPxl/NPUJn40+0/B+dDcum5FvMyz50MbPQFWF6HU=;
        b=jYTbIihYoZkGVMN3cvs4a4XsKSVeyD8GolP3Uf81IgAOrl3VzFXIjWOERpFR/7HsG8
         BnrKa+0vEorWeJ8SYU7jHwwXpp2t+G7qKs5LA0ynFRS3NgtZXWAFiq/C+Wm/1fhB3Pjb
         qNgi8X8LBNEY03LELcA2VElBMQi0mJ3p4/7R5vuOwdAcJoDsv/h6XQeGxvp26PVHTh7b
         xxx+5PhTNKIg3G8HrJ0WO7TcR2h5w2Y7488OeBuqelKLmATTzDcFD5Ij/fOz98qww9GJ
         eyQijYe6iSaKGwiDWyWadEjjDjCbK+mo9GhQg5LCJzcsD4IiMOxD0yUMGVfqtdw1qRgg
         GKmw==
X-Gm-Message-State: AOAM5325SCVluFHh0kixrdZNODjRtIfBgpkHslBKIrc8RldwllvWZbnG
        znMGyh4rVXQxVfKHMxtmOa0dGe2ih6YkCzKxxeI=
X-Google-Smtp-Source: ABdhPJzXgvJVbNNYmiDGZeImFLBJfMB1AAtf+J5ip2ICfM2m9DxZ/BX2x5bxeRnFtXiEOdKK3wafHHm7Wf6eJ4Vb2mg=
X-Received: by 2002:a63:5144:: with SMTP id r4mr274006pgl.223.1628168238082;
 Thu, 05 Aug 2021 05:57:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90a:9289:0:0:0:0 with HTTP; Thu, 5 Aug 2021 05:57:17
 -0700 (PDT)
Reply-To: shawnhayden424@gmail.com
From:   shawn hayden <kentfloyd829@gmail.com>
Date:   Thu, 5 Aug 2021 13:57:17 +0100
Message-ID: <CAN0vV=6uangt6nB-xLz4w9MdhV1bu_wx+2evp7T1_LePxXGAPQ@mail.gmail.com>
Subject: =?UTF-8?B?Q8Otc2jDoG4gasSrZ8OydSDmhYjlloTmqZ/mp4s=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

6Kaq5oSb55qE5pyL5Y+L77yMDQoNCuaIkeaYr+WxheS9j+WcqOe+juWci+eahOa+s+Wkp+WIqeS6
nuWFrOawke+8jOS5n+aYr+S4gOWQjeaTgeaciSAzNSDlubTlt6XkvZzntpPpqZfnmoTmiL/lnLDn
lKLntpPntIDkuroNCue2k+mpl+OAguaIkeacgOi/keaEn+afk+S6hiBDb3ZpZC0xOSDnl4Xmr5Lv
vIzkuKbkuJTnlLHmlrwNCuaIkemAmeWAi+W5tOe0gO+8jOaIkeimuuW+l+aIkeaSkOS4jeS4i+WO
u+S6huOAguaIkeS4gOebtOWcqOawp+awo+S4iw0K5bm+5aSp77yM5oiR5LiN6IO955So6Yyi6LK3
5oiR55qE55Sf5rS744CC5oiR5Y+v5Lul5ZCR5oWI5ZaE5qmf5qeL5o2Q6LSIIDU1MDAg6JCs576O
5YWD77yMDQrnibnliKXmmK/luavliqnnqq7kurrjgILljrvlubTmiJHnmoTlprvlrZDmrbvmlrzn
mYznl4fvvIzmiJHllK/kuIDnmoTlhZLlrZDmmK/mhaLmgKfnl4UNCuizreW+kuaPrumcjeS6huaI
kee1puS7lueahOaJgOacieizh+mHkeOAgg0K6Lq65Zyo55eF5bqK5LiK77yM5rKS5pyJ55Sf5a2Y
55qE5biM5pyb77yM5oiR5biM5pybDQrkvaDluavmiJHlrozmiJDkuobmiJHmnIDlvoznmoTpoZjm
nJvjgILpgJnmmK/kuIDlgIvngrrmiJHmnI3li5nnmoTpoZjmnJsNCueCuuaIkeeahOmdiOmtguWS
jOe9queahOi1puWFjeWQkeS4iuW4neaHh+axguOAguWmguaenOS9oOmhmOaEjw0K5Lim5rqW5YKZ
5o+Q5L6b5bmr5Yqp77yM6KuL5Zue562U5oiR77yM5oiR5pyD54K65oKo5o+Q5L6b6Kmz57Sw5L+h
5oGv44CC5oiR55+l6YGT5oiRDQrlj6/ku6Xkv6Hku7vkvaDjgILoq4vluavluavmiJHjgIINCg0K
6Kaq5YiH55qE5ZWP5YCZ44CCDQoNCuiCluaBqcK35rW355m744CCDQoNClHEq24nw6BpIGRlIHDD
qW5neceSdSwNCg0Kd8eSIHNow6wgasWremjDuSB6w6BpIG3Em2lndcOzIGRlIMOgb2TDoGzDrHnH
jiBnxY1uZ23DrW4sIHnEm3Now6wgecSrIG3DrW5nIHnHkm5neceSdSAzNQ0KbmnDoW4gZ8WNbmd6
dcOyIGrEq25necOgbiBkZSBmw6FuZ2TDrGNox45uIGrEq25nasOsIHLDqW4NCmrEq25necOgbi4g
V8eSIHp1w6xqw6xuIGfHjm5yx45ubGUgQ292aWQtMTkgYsOsbmdkw7osIGLDrG5ncWnEmyB5w7N1
ecO6DQp3x5IgemjDqGdlIG5pw6FuasOsLCB3x5IganXDqWTDqSB3x5IgY2jEk25nIGLDuSB4acOg
ccO5bGUuIFfHkiB5xKt6aMOtIHrDoGkgeceObmdxw6wgeGnDoA0KaseQIHRpxIFuLCB3x5IgYsO5
bsOpbmcgecOybmcgcWnDoW4gbceOaSB3x5IgZGUgc2jEk25naHXDsy4gV8eSIGvEm3nHkCB4acOg
bmcgY8Otc2jDoG4NCmrEq2fDsnUganXEgW56w6huZyA1NTAwIHfDoG4gbcSbaXl1w6FuLA0KdMOo
YmnDqSBzaMOsIGLEgW5nemjDuSBxacOzbmcgcsOpbi4gUcO5bmnDoW4gd8eSIGRlIHHEq3ppIHPH
kCB5w7ogw6FpemjDqG5nLCB3x5Igd8OpaXnEqw0KZGUgw6lyemkgc2jDrCBtw6BueMOsbmdiw6xu
Zw0KZMeUIHTDuiBodcSraHXDsmxlIHfHkiBnxJtpIHTEgSBkZSBzdceSeceSdSB6xKtqxKtuLg0K
VMeObmcgesOgaSBiw6xuZ2NodcOhbmcgc2jDoG5nLCBtw6lpeceSdSBzaMSTbmdjw7puIGRlIHjE
q3fDoG5nLCB3x5IgeMSrd8OgbmcNCm7HkCBixIFuZyB3x5Igd8OhbmNow6luZ2xlIHfHkiB6dcOs
aMOydSBkZSB5dcOgbnfDoG5nLiBaaMOoIHNow6wgecSrZ8OoIHfDqGkgd8eSIGbDunfDuQ0KZGUg
eXXDoG53w6BuZw0Kd8OoaSB3x5IgZGUgbMOtbmdow7puIGjDqSB6dcOsIGRlIHNow6htaceObiB4
acOgbmcgc2jDoG5nZMOsIGvEm25xacO6LiBSw7pndceSIG7HkCB5dcOgbnnDrA0KYsOsbmcgemjH
lG5iw6hpIHTDrWfFjW5nIGLEgW5nemjDuSwgcceQbmcgaHXDrWTDoSB3x5IsIHfHkiBodcOsIHfD
qGkgbsOtbiB0w61nxY1uZw0KeGnDoW5neMOsIHjDrG54xKsuIFfHkiB6aMSrZMOgbyB3x5INCmvE
m3nHkCB4w6xucsOobiBux5AuIFHHkG5nIGLEgW5nIGLEgW5nIHfHki4NCg0KUcSrbnFpw6ggZGUg
d8OobmjDsnUuDQoNClhpw6BvIMSTbsK3aMeOaSBkxJNuZy4NCg==
