Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3960510C33
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 00:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345286AbiDZWwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 18:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245546AbiDZWwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 18:52:37 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9306718CE6A
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 15:49:26 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2f7bb893309so189777b3.12
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 15:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=LVYChN1b3axTZtGWH2YuXOfiYmY0vQJpJTf839n7IHc=;
        b=l3p7LQTMU9ypCwLxjyEt0gysU0V2DQkLC6ymJpA0ThGGKqmISeFuu5GdqEN4Pmj4k/
         lhzz6lUNw0KiaH8jW2mz3feaB2ya9gb8cFSmxyj+Ts40ygHTanOjMJvpd8KhXrfKEjBv
         vR3Albb4WngtUc0oIXeq7q08qzyVHdMa76y4sNIfXbWz5H52EuC/UOPPAN3p33MUZnb7
         XPZ9qSyNi16MS6OepAxxf8WPNvG9TWg2xfVJ0wcCXXW/zgin0aG3etiXE80xWGdMoLbS
         yIZ04Jt5D3x56/Z2JE9MmXqCSK/OdQMhOkyYfZ/SU56dgmuIkZ0DfEVh1wmV+PXbK9ly
         +d6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=LVYChN1b3axTZtGWH2YuXOfiYmY0vQJpJTf839n7IHc=;
        b=2nGajgg7ZFAzu2dxhTAuQmgH2W5LWl0CtxBab3H40+3xtM8aJdg7jOMho9kFQyhPLN
         RnivPpEj77HyJb8y+YzHEhgJxwTxK/ZCpBZSYp+m3zq+J2/qdxqK0SrOzTi9irWXB50Y
         VdX1hkxZ+WQxJ0GPHZMcKTdcBvZw+vqjEU/+74lMA4uw5esaX1BKGSj5urVG9HJhPjyR
         M8vDQ8eiEYoCnb9FizexilSY9CxW3NWrpXzCXzWP+FULi1Td3TQpfTfFtKopaAQj0WHk
         4udOVXZ1eeVigFgF1TuA/J6o5OByw2cpCFUv7vI45HjGrydWsB6kC1r/jX6B3MQ6SGgX
         uV/g==
X-Gm-Message-State: AOAM5325zH3F+ocHLVwVldkUWdIrUE+QlmbPkjiEU0h+bSp4ZEK4xQjm
        JbTzwcgP/pZ5Cjr2cPH7OKBz4Ys6gt/5gxRUDfs=
X-Google-Smtp-Source: ABdhPJy6UWUyZpjwKsE0J33EJ9wUa8lGrXiIEUjCDUALxVv8JVkBe7DSB/vs+UBHB/Yws4e517tTKTX9bgfnhArir+o=
X-Received: by 2002:a0d:e20f:0:b0:2f4:e852:3e56 with SMTP id
 l15-20020a0de20f000000b002f4e8523e56mr23203195ywe.355.1651013365161; Tue, 26
 Apr 2022 15:49:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:558a:b0:176:7870:a4a3 with HTTP; Tue, 26 Apr 2022
 15:49:24 -0700 (PDT)
Reply-To: mrsreestabsobar@gmail.com
From:   "Mrs.Rees Tabsobar" <nbarragbor@gmail.com>
Date:   Tue, 26 Apr 2022 15:49:24 -0700
Message-ID: <CAFBsSW4Em_+hYSSw80yxX=PR_Avy+8X5NaQ2VCkJbw-GEkLHHA@mail.gmail.com>
Subject: =?UTF-8?B?7Lmc7JWg7ZWY64qUIOyLoOydmCDshKDtg50=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

7Lmc7JWg7ZWY64qUIOyLoOydmCDshKDtg50NCg0KDQoNCu2BsCDriIjrrLzsnYQg7Z2Y66as66mw
IOuLueyLoOyXkOqyjCDsnbQg7Y647KeA66W8IOyUgeuLiOuLpCDrgrQg64iI7JeQ64qUIO2BsCDs
iqztlJTqs7wg7YGwIOyKrO2UlOydtCDsnojsirXri4jri6Qg64K0IOydtOumhOydgCDrtoDsnbgg
UmVlcw0KVGFic29iYXLsnoXri4jri6Qg64KY64qUIO2KgOuLiOyngOyXkOyEnCDsmZTqs6Ag67aA
66W07YKk64KY7YyM7IaM7JeQIOyeiOuKlCDrs5Hsm5Dsl5DshJwg64u57Iug7JeQ6rKMIOyXsOud
ve2VmOqzoCDsnojsirXri4jri6Qg7J20IOunkOydhCDtlZjqs6Ag7Iu27Iq164uI64ukIOuCmOuK
lA0K64u57Iug7JeQ6rKMIOuniOydjOydhCDsl7Tqs6Ag6rCQ64+Z7J2EIOuwm+yVmOq4sCDrlYzr
rLjsl5Ag64u57Iug7JeQ6rKMIOunkO2VoCDsiJgg67CW7JeQIOyXhuyXiOq4sCDrlYzrrLjsl5Ag
MjAxMeuFhOyXkCDsgqzrp53tlZjquLAg7KCE7JeQIOu2gOultO2CpOuCmO2MjOyGjOyXkOyEnA0K
7YqA64uI7KeAIOuMgOyCrOyZgCA564WEIOuPmeyViCDtlajqu5gg7J287ZaI642YIE1yLiBUYWJz
b2JhciBKYWNzb27qs7wg6rKw7Zi87ZaI7Iq164uI64ukLiDsmrDrpqzripQgMTHrhYQg64+Z7JWI
IOyVhOydtCDsl4bsnbQNCuqysO2YvO2WiOuLpC4NCg0KDQoNCuq3uOuKlCDri6ggNeydvCDrj5ns
lYjrp4wg7KeA7IaN65CcIOynp+ydgCDrs5HsnLzroZwg7IKs66ed7ZaI7Iq164uI64ukLiDqt7js
nZgg7IKs66edIOydtO2bhCDrgpjripQg7J6s7Zi87ZWY7KeAIOyViuq4sOuhnCDqsrDsoJXtlojs
irXri4jri6QuIOyjveydgCDrgqjtjrjsnbQg7IK07JWEDQrsnojsnYQg65WMIOq3uOuKlCA4NTDr
p4wg64us65+s66W8IOyYiOy5mO2WiOyKteuLiOuLpC4gKDgwMOunjDUwMDDri6zrn6wpIOyEnOu2
gCDslYTtlITrpqzsubQg67aA66W07YKk64KY7YyM7IaM7J2YIOyImOuPhCDsmYDqsIDrkZDqtazs
l5Ag7J6I64qUIOydgO2WiS4NCu2YhOyerCDsnbQg64+I7J2AIOyXrOyghO2eiCDigIvigIvsnYDt
lonsl5Ag7J6I7Iq164uI64ukLiDqt7jripQg7J20IOuPiOydhCDrtoDrpbTtgqTrgpjtjIzshowg
6rSR7IKw7JeQ7IScIOq4iOydhCDsiJjstpztlZjripQg642wIOyCrOyaqe2VoCDsiJgg7J6I64+E
66GdIO2WiOyKteuLiOuLpC4NCg0KDQoNCuy1nOq3vOyXkCDsnZjsgqzripQg64K06rCAIOyVlOqz
vCDrh4zsobjspJEg66y47KCc66GcIOyduO2VtCA36rCc7JuUIOuPmeyViCDrsoTti7gg7IiYIOyX
huuLpOqzoCDrp5DtlojsirXri4jri6QuIOuCmOulvCDqsIDsnqUg6rS066Gt7Z6I64qUIOqyg+yd
gCDrh4zsobjspJHsnbTri6QuDQrrgpjripQg64K0IOyDge2DnOulvCDslYzqs6Ag7J20IOuPiOyd
hCDri7nsi6Dsl5Dqsowg64SY6rKo7IScIOyGjOyZuOuQnCDsgqzrnozrk6TsnYQg64+M67O06riw
66GcIOqysOygle2WiOyKteuLiOuLpC4g64u57Iug7J2AIOydtCDrj4jsnYQg64K06rCAIOyXrOq4
sOyXkOyEnCDsp4Dsi5ztlZjripQNCuuwqeyLneycvOuhnCDsgqzsmqntlZjqsowg65CgIOqyg+ye
heuLiOuLpC4g7LSdIOq4iOyVoeydmCAzMCXrpbwg6rCc7J247KCB7J24IOyaqeuPhOuhnCDsgqzs
mqntlZjsi5zquLAg67CU656N64uI64ukLiDrj4jsnZggNzAl64qUIOuCtCDsnbTrpoTsnLzroZwg
6rOg7JWE7JuQDQrsp5HsnYQg7KeT6rOgIOqxsOumrOydmCDqsIDrgpztlZwg7IKs656M65Ok7J2E
IOuPleuKlCDrjbAg7IKs7Jqp7ZWgIOqyg+yeheuLiOuLpC4g64KY64qUIOqzoOyVhOuhnCDsnpDr
npDqs6Ag6rCA7KGx7J2AIOyVhOustOuPhCDsl4bsl4jqs6Ag7ZWY64KY64uY7J2YIOynkeydtCDs
nKDsp4DrkJjrj4TroZ0NCuuFuOugpe2WiOyKteuLiOuLpC4g7J20IOuzkeydtCDrgpjrpbwg64SI
66y0IOq0tOuhre2YlOq4sCDrlYzrrLjsl5Ag7ZWY64KY64uY6ruY7IScIOuCtCDso4Trpbwg7Jqp
7ISc7ZWY7Iuc6rOgIOuCmeybkOyXkOyEnCDrgrQg7JiB7Zi87J2EIOuwm+yVhCDso7zsi5zquLDr
pbwg7JuQ7ZWp64uI64ukLg0KDQoNCg0K6reA7ZWY7J2YIO2ajOyLoOydhCDrsJvripQg7KaJ7Iuc
IOu2gOultO2CpOuCmO2MjOyGjOyXkCDsnojripQg7J2A7ZaJIOyXsOudveyymOulvCDslYzroKQg
65Oc66as6rOgIOydgO2WiSDqtIDrpqzsnpDsl5Dqsowg6reA7ZWY6rCAIOuLpOydjOqzvCDqsJns
nYAg6rK97JqwIOydgO2WieyXkCDsnojripQNCuuPiOydmCDtmITsnqwg7IiY7Zic7J6Q7J6E7J2E
IOymneuqhe2VmOuKlCDsnITsnoTsnqXsnYQg67Cc7ZaJ7ZWY64+E66GdIOyngOyLnO2VoCDqsoPs
noXri4jri6QuIOuCtOqwgCDsl6zquLDsl5Ag66qF7Iuc65CcIOuMgOuhnCDqt4DtlZjqsIAg6re4
7JeQIOuUsOudvCDtlonrj5ntlaAg6rKD7J6E7J2EDQrtmZXsi6Dtlanri4jri6QuDQoNCg0KDQrr
toDsnbggUmVlcyBUYWJzb2JhcuyXkOyEnC4NCg==
