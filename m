Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9963F5D9C
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 14:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbhHXMFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 08:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbhHXMFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 08:05:00 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85338C061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 05:04:16 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id fz10so2684351pjb.0
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 05:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=IzHMi/tIKwAqWXBHyupq7PxJz62EDujX/CmnY9Uiy14=;
        b=GEbAEuKQr3lPC7KMQ9XwxzL+SJJDJdE+dSJ2Rct/xwNAyDCMI5ImB+qkXjdp34Ez+I
         WJojORe9IyeLBHzwVyjBIRM80iADKJ1hvV+Bl/SmivEkM76RjWb5HYzj9FpAbvL7oaC2
         1efqz1soSG2KT08l6L/Hmj+JDIWE+Y1B7fC31DRHCIcy1SfnxrTKLx7r3w4cU36Z2e1+
         ThlAsd1+W8HOpFJzOrokenIPlcHLnZEVb11aLSL3yOf4LIzZR5LauceDtTomlausLQtO
         GRkssWTMelkcOlhByQEZhK8uGD5AyiSPe/Qh3biP/Bw9c9bngIUkrnyBESQHUdZiyIsi
         zmQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=IzHMi/tIKwAqWXBHyupq7PxJz62EDujX/CmnY9Uiy14=;
        b=hmrp7aRcsZGlrrjm8vckH4BmnMaVXZCeFl4ylYpJai/8WxZnXfGlLyqDfgyT6wgoZC
         6DnmOS9Rc+LlnHQaBeJgbiSEwS5/eYl2jo0MpVLHl6+xCE7kCFmOdTCbH4ih7pTeQLbs
         4YQnKZJDqYevY81yRM+PfhYd1aVS3uCJLBfotjEP6ZGvT3KSfL019PFC5sG6q7wiKzeQ
         UEyKjMeEZc0KWepJxYl/Zl7fLDnbWTUkI77vAKeGub958ZvW75kBfLYf2gt3ihJOhEJp
         nHW4H7v7Ic+xALlV/QKl0DQ2t32f1AweEZZu1JhYS8Xp3ghc0hCYV0mr+z0MpECoGjz+
         xsaA==
X-Gm-Message-State: AOAM531qJlbsAdrhmOU6LAT7byNPLUoVA1w+1jyPLwx3jTANQ563En+3
        gb6IknKJbrnmDZE/LpiprBw+Q5SSUJ7pDH41YuY=
X-Google-Smtp-Source: ABdhPJzzv71u2XuG1KK971LhX9Tr1n/8bZ42F3Vz5fr64dWg4Q7lpxYuWNIJ6jM0uI4vyH3nowfy/zHjcu+IR6sFntw=
X-Received: by 2002:a17:90a:3fca:: with SMTP id u10mr1225779pjm.148.1629806656061;
 Tue, 24 Aug 2021 05:04:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a11:422:0:0:0:0 with HTTP; Tue, 24 Aug 2021 05:04:15
 -0700 (PDT)
Reply-To: ubabankofficeorg77@gmail.com
From:   POST OFFICE <sambonylome44@gmail.com>
Date:   Tue, 24 Aug 2021 14:04:15 +0200
Message-ID: <CAHgBFNEqBAnwuWg4n02uAnECp6raCP+WDpkGZZfTJ2bVtWtnwQ@mail.gmail.com>
Subject: =?UTF-8?B?576O5aW955qE5LiA5aSp?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5Lqy54ix55qE5YWI55SfL+Wls+Wjqw0KDQrmiJHku6zlsLHmgqjnmoTml6DkurrorqTpoobnmoTv
vIgzNzAg5LiH576O5YWD77yJ576O5YWD6LWU5YG/6LWE6YeR5LiO5oKo6IGU57O777yM6K+l6LWE
6YeR55Sx6KW/5YWx5L2T57uE57uH5a2Y5YWl5oiR5Lus55qE5Yqe5YWs5a6k77yM5bm25oyH56S6
5oiR5Lus6YCa6L+HIEFUTSBWSVNBIENBUkQNCuaIliBNb25leS1HcmFtIOWcqOe6v+i9rOi0puaU
r+S7mOezu+e7n+WwhuasvumhueWPkemAgee7meaCqOi9u+advue0ouWPluaCqOeahOmSseOAguaC
qOW3suaMh+ekuuaIkeS7rOeahOWkluWbveaUr+S7mOaxh+asvumDqOmXqO+8iFVuaXRlZCBCYW5r
IG9mDQpBZnJpY2EgTG9tZSBUb2dv77yJ5ZCR5oKo5Y+R6KGM5L+h55So5Y2h44CCIFZJU0Eg5YCf
6K6w77yM5bCG5LuO5oKo55qE5Z+66YeR5Lit5omj6Zmk77yIMzcwIOS4h+e+juWFg++8iee+juWF
g++8jOS7pee7p+e7reaPkOWPluaCqOeahOWfuumHkeOAgg0KDQrov5nmmK/kuLrkuobpgJrnn6Xm
gqjvvIzmgqjnmoQgMzcwIOS4h+e+juWFg+aAu+i1hOmHkeW3suWuieaOkumAmui/hyBBVE0gVklT
QSBDQVJEDQrmlK/ku5jnu5nmgqjjgILku4rlpKnmiJHku6zpgJrnn6XmgqjvvIzmgqjnmoTotYTp
h5Hlt7LooqtVQkHpk7booYzorrDlhaVWSVNB5Y2h77yM5Lmf5YeG5aSH5Lqk5LuY77yM546w5Zyo
6IGU57O7VUJB6ZO26KGM56eY5Lmm5LuW55qE5ZCN5a2X5pivS0VOTkVEWSBVWk9LQeWNmuWjqw0K
DQrpnZ7mtLLogZTlkIjpk7booYzokaPkuovmgLvnu4/nkIYNCg0K6ZO26KGM572R56uZ77yaaHR0
cDovL3d3dy51YmFncm91cC5jb20NCg0KVklTQSBBVE0gVUJBIOWNoemDqO+8iFVCQSDpm4blm6Lv
vIhAVUJBR3JvdXDvvIkNCg0K5bCG5Lul5LiL5L+h5oGv5Y+R6YCB5Yiw5oKo55qE5Zyw5Z2A77ya
DQoNCuaCqOeahOWFqOWQjSA9PT09PT09PT09PT09PT09DQoNCuaCqOeahOWOn+exjeWbvSA9PT09
PT09PT09DQoNCuaCqOeahOWutuW6reS9j+WdgCA9PT09PT09PT09PT0NCg0K5oKo55qE55S16K+d
5Y+356CBID09PT09PT09PT09PQ0KDQrkvaDnmoTogYzkuJo9PT09PT09PT09PT09PT0NCg0K6K+3
5rOo5oSP77yM5oiR5Lus5bey57uP5a6M5oiQ5LqG5pyJ5YWz5oKo55qE5LuY5qy+55qE5omA5pyJ
5b+F6KaB5a6J5o6S77yM5LiA5pem5oKo6YCa6L+H5Lul5LiL5L+h5oGv5LiO5oiR5Lus6IGU57O7
77yM5oKo55qEIEFUTSBWSVNBIOWNoeW3suWHhuWkh+WlveWPkemAgee7meaCqOOAgg0K6IGU57O7
5Lq677ya6JaH6JaH5a6JwrflvJfmnJfopb/mlq/lpKvkuroNCuiBlOezu+eUteWtkOmCruS7tu+8
mu+8iHViYWJhbmtvZmZpY2Vvcmc3N0BnbWFpbC5jb23vvInjgILlm6DmraTvvIzmgqjlupTlsL3l
v6vlsIbmiYDpnIDkv6Hmga/lj5HpgIHnu5kgSm9zZXBoIEdsb3JpYQ0KaWt1a3Ug5YWI55Sf77yM
5Lul5YWN6YCg5oiQ5LiN5b+F6KaB55qE5bu26K+v44CCDQrmhJ/osKINCg0KSm9zZXBoIEdsb3Jp
YSBpa3VrdSDlhYjnlJ8gKElNRikgKDYwMSkg5a6Y5ZGYDQo=
