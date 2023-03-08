Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEFE36B0BB7
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCHOqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjCHOp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:45:59 -0500
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABD4C3638
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 06:44:35 -0800 (PST)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-536c02c9dfbso308062647b3.11
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 06:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678286674;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1GASPKoO+e28mJsssh+sY4z5RAj0iPshrV7WaXjS/o0=;
        b=bsX4GvojWCu1zcLNuT9ylaP8HYgWFyzK1VzzHsApTRHDH9hxWSevcpFc9sduDu0hG7
         6UrXD+yE7fUjfZ1T4ya+rUHBJPJ3Uu5XoMgBBq3UpQWLEpGFDef0O5dT0zzu8rL+f58o
         r0eU81r0rPUrkqJh/mjPAAAQ3I6FOGONaByvcR0H1C+MCAd25DV/FevmYY+2Np3XclLM
         qUD5WzwQJmcLVsj8YNEth//jsV1R34jlBKHphfAWffhHRWCCbokvCEvxS0II1F/Th1cl
         hN1O3jiOOJO6GfBYoJ14or+UeVO2ZIQQeWwO1jBQCIWGs0RGzEMDyEgF2f6zwDO/5m4X
         lwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678286674;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1GASPKoO+e28mJsssh+sY4z5RAj0iPshrV7WaXjS/o0=;
        b=d6ygRX7qov7bFikES4XPRmkBhyRH6o0Dn+/2hYinRasl8SHelx3brNcuOCRyHAAlC/
         TyrYmSfJq6UK5Ps1i6wZR+mnKgx9DbYVF6AoqjcStb/E+xejCS3F+D/61GnTV4oIS6z8
         F9GG2JzJD5khPY9PLP/hg8cHEcYfP9z/oKFVw1+00mbO3UsVonrFwtuI184EgiK0VdUB
         pYxtBwPgPeVQaoy/WCbv9Sj8JqNlkrcVYRklX1nNnbF8xUA+XPfOeAzyvRSXCcWqz+/W
         EQR1WGAiEieq/+CLDhpTmvTKAb26VeXd/zqmW1tkQILMWNGWBG+hP+LYRZqGWbtWzFcP
         hQvQ==
X-Gm-Message-State: AO0yUKX6sAakmVhONTykrHui3UQX/uBY/Ag2Zqg9EH6duD4UcOi3Qt6Q
        3qebv+zdujKoeenx/DGhr5So6deM/8r3A0wngt8=
X-Google-Smtp-Source: AK7set9SPXzpAH6QIEpSCpM2IfsshUm9dclG/VUpSSBgrnpeNeKkNsIVGid6baGSmy28VXaCYh5zz8vsVCkc+CzlZ3o=
X-Received: by 2002:a81:af4b:0:b0:533:91d2:9d94 with SMTP id
 x11-20020a81af4b000000b0053391d29d94mr11762167ywj.5.1678286673985; Wed, 08
 Mar 2023 06:44:33 -0800 (PST)
MIME-Version: 1.0
Sender: baatarog656@gmail.com
Received: by 2002:a05:7110:7018:b0:1cf:fc3d:8a8d with HTTP; Wed, 8 Mar 2023
 06:44:33 -0800 (PST)
From:   MRS ORGIL BAATAR <orgilbaatar110@gmail.com>
Date:   Wed, 8 Mar 2023 15:44:33 +0100
X-Google-Sender-Auth: KU0q58kHr5w7RuatOleC-u2-dl4
Message-ID: <CANiov6RYB4dVN7qrPYR0hdJDMZbPhFVcvo5g8-wWUJ+g1ENKxg@mail.gmail.com>
Subject: =?UTF-8?B?5rOo5oSP77ya5Y+X55uK5Lq644CC?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5bCK5pWs55qE5YWI55SfL+Wls+Wjq++8jA0KDQrlm57lpI3vvJrogZTlkIjlm73oib7mu4vnl4Xl
kozmhI/or4borqHliJLjgIIg6KKr6aqX55qE5Y+X5a6z6ICF5pSv5LuYIDIsNTAwLDAwMC4wMCDn
vo7lhYPnmoTotZTlgb/ph5HvvIjlj4LogIPlj7fvvJrku6PnoIHvvJo2MzYzODM277yJDQoNCuiw
qOaPkOivt+aCqOazqOaEj++8jOmatuWxnuS6juWkluWbvei1hOS6p+aOp+WItuWKnuWFrOWupCAo
T0ZBQykNCueahOS4lueVjOmTtuihjOW3suWvueacieWFs+WbveWutueahOaUv+W6nOWunuaWveWI
tuijge+8jOS7pei1lOWBv+iviOmql+WPl+Wus+iAhe+8jOWMheaLrOmCo+S6m+WcqOasp+a0suWb
oOS4jeaIkOWKn+eahOWQiOWQjOWSjOS6pOaYk+iAjOiSmeWPl+aNn+WkseeahOS6uu+8jCDpnZ7m
tLLlkozkuprmtLLlm73lrrbjgIINCuavj+WQjeWPl+Wus+iAheWwhuiOt+W+lyAyNTAg5LiH576O
5YWD55qE6LWU5YG/77yM5Lul56Gu5L+d5q2j5LmJ5b6X5Yiw5Ly45byg44CCDQoNCuS4gOS6m+as
p+a0suOAgemdnua0suWSjOS6mua0suWbveWutuS7peWPiuS4lueVjOWQhOWcsOaMgee7reWtmOWc
qOeahOWkp+mHj+iviOmql+aKpeWRiuacieW/heimgei/meagt+WBmuOAgiDmnInmiqXpgZPnp7Dv
vIzlj5flrrPogIXlt7LlkJHor4jpqpfogIXmjZ/lpLHkuobmlbDljYHkur/nvo7lhYPjgIINCg0K
5L2G5piv77yM5oKo55qE6K+m57uG5L+h5oGv5piv5LuO5pyA6L+R6KKr5Zu96ZmF5YiR6K2m57uE
57uH44CB6IGU6YKm6LCD5p+l5bGA5ZKM5b2T5Zyw5a6J5YWo6YOo6Zeo57uE5oiQ55qE6IGU5ZCI
5a6J5YWo5Lq65ZGY6YCu5o2V55qE5LiA5ZCN6aqX5a2Q6YKj6YeM6I635b6X55qE44CCDQrogofk
uovogIXmib/orqTov5jmnInlhbbku5blkIzkvJnkvZzmoYjvvIzlronlhajkurrlkZjmraPlnKjo
v73ouKrku5bku6zvvIzlj6/og73kvJrpgK7mjZXku5bku6zjgIIg5Zug5q2k77yM5Zyo5q2k5bu6
6K6u5oKo5a+56L+Z5Lqb5L+h5oGv5L+d5a+G77yM55u05Yiw5bCG5omA5pyJ6aqX5a2Q6YO96YCu
5o2V44CCDQoNCuWwhuaCqOeahOS7mOasvuWPt+eggei9rOWPkeWIsOS4i+mdoueahOmTtuihjOeU
teWtkOmCruS7tuW4kOaItw0KDQrmgqjnmoTku5jmrL7lj4LogIPlj7cgLSA2MzYzODM277yMDQrl
r4bnoIHlj7fvvJowMDY3ODbvvIwNCuS4quS6uuWvhuegge+8mjE3ODcNCuaCqOeahOWllueKtuS7
mOasvue8luWPt++8mjA1ODcy77yMDQrlj5HooYznvJblj7fvvJoxMTM077ybDQrmmpflj7fvvJpU
QktUQTI4DQoNCumHjeaWsOehruiupO+8mw0K5L2g55qE5ZCN5a2X77yaIHwNCuWcsOWdgO+8miB8
DQrmiYvmnLrvvJogfA0K5Lyg55yf77yaIHwNCuaVsOmHj++8miB8DQoNCumcgOimgeaCqOeahOWN
s+aXtuWbnuWkjSBVQkEg6ZO26KGMDQrogZTns7vkurrvvJpNcnMgUkFQQUVMIEdPRFdJTiDlm73p
mYXpg6jkuLvku7sNCuWuoeiuoeWNleS9jUFUTeaUr+S7mOS4reW/g++8jA0K55S15a2Q6YKu5Lu2
77yadW5pdGVkYmFua29mLWFtZXJpY2FAZmluYW5jaWVyLmNvbQ0K55S16K+d77yaKzEoNTE4KTQx
NDgwMDQNCg0K6Zeu5YCZ44CCDQrlpaXlkInlsJTCt+W3tOeJueWkq+S6ug0K
