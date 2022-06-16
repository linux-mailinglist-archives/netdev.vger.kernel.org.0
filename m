Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9BA54E224
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 15:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377122AbiFPNie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 09:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377129AbiFPNiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 09:38:23 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2AF2A70B
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 06:38:22 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id r3so2237724ybr.6
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 06:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=uuPhMjIYHG3bflRbeI3wNwv/lcbjmuNxhdzR7jytfhk=;
        b=Gj/2+M3p1HpKWnYV6tr1R271Y+oG/l3vOoBbPKK9Vo4Er5Smqh2MV93bUFzg89InZR
         4YQqEraCtI9wvIjvx1YDJnYZoEdbWPfSnTvdQpszUIW3bMtrqVTBMlLAG/zXXWGRHuvU
         D99QdCDVxPCSWZSS8PKyKxdFDvzj7V6vSgodU9Xa6Ws2YjwFzJOn4xnUf/KnHruMi71I
         KqQoipAkYUEN/YXsGcczbm7jj7S8frogULDBAkRvX3KrhvY9WLUiBlKfthk1ioE1AD+d
         xaqVmfkXyGcgXEwBrjvdBALMr6awryuJSimevVipkuckIdiCim9ooPQfNiKkgG6U7lC3
         VDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=uuPhMjIYHG3bflRbeI3wNwv/lcbjmuNxhdzR7jytfhk=;
        b=g57qMC04QK/YnnGXEBxYlD/AGQpI3rFmJ6uoDK5/OnlD5Ik6LxuljXQX1BMOTI6rws
         YuNFWoyTUcnaidHxk2PvbQUGlI1O6TkV4ul8/dQTdY6buHKrvA5XyMBaErjabWOxIUZz
         8aMNRNFLxRSGJLV0pv+aRvwmKTLKjJwocgDEFH/I7tdULMWPucNZf7CprmWmRVSTWti8
         F7oin0NtmPn9UIfPmvQOKEniUeaNJMf6g0/80d1Vgfq8kdLXojWWsffAMR6wRv9WABQp
         UonLHIs+22bp09UhWWwxu2TK9zoggqkC7NFBpALDWvogadoBPpzFo2sgGim21TGHyUgh
         87AQ==
X-Gm-Message-State: AJIora/sBRcmD4m43LUzas2xWvMMnfOzs2ozFOU7tacrJQfkDiPAHE7C
        k+OMCbbDfLuczeGPDFIPOb2MnXTrhzhpFqHyYdQ=
X-Google-Smtp-Source: AGRyM1vXnB2l8ywNoTMu3lubNX99tIaB3XX6MaXo1x84573r/8TSE1EVVbBqpESG0z4he9RA+88BCfIJbbIkUghAq0Q=
X-Received: by 2002:a5b:20b:0:b0:65c:a0cf:812b with SMTP id
 z11-20020a5b020b000000b0065ca0cf812bmr5455479ybl.48.1655386702032; Thu, 16
 Jun 2022 06:38:22 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:138b:b0:181:81b0:fc8 with HTTP; Thu, 16 Jun 2022
 06:38:21 -0700 (PDT)
Reply-To: nak82134@gmail.com
From:   Barrister Kine Nampo <nbarragbor@gmail.com>
Date:   Thu, 16 Jun 2022 06:38:21 -0700
Message-ID: <CAFBsSW6CNhWPXAUZwwRzD+Gzv5s9VRxDBuxB2DKqsM-xR2zm_g@mail.gmail.com>
Subject: =?UTF-8?B?7Lmc6rWs7JeQ6rKMLA==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=3.2 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

7Lmc6rWs7JeQ6rKMLA0KDQrsoIDripQg67aA66W07YKk64KY7YyM7IaM7J2YIOuzgO2YuOyCrCBL
aW5lIE5hbXBv7J6F64uI64ukLiDqt4DtlZjsnZgg7KeA7JuQ7J2EIOyalOyyre2VmOq4sCDsnITt
lbQg7J20IOynp+ydgCDtjrjsp4Drpbwg67O064OF64uI64ukLiDspJHqta3snbgg7YG065287J20
7Ja47Yq46rCAIOyeiOyKteuLiOuLpC4NCuydtOumhOydgCDqsJXtg5zsl7Ag7JSo7J6F64uI64uk
LiDqt7jripQgNuuFhCDsoIQg7Iug7J6lIOydtOyLneydhCDrsJvsnLzrn6wg6rCU7J2EIOuVjCDs
gqzrp53tlZjquLAg7KCE7JeQIOydtOqzsyDrtoDrpbTtgqTrgpjtjIzshozsl5DshJwg6riI7IOB
7J247J207JeI7Iq164uI64ukLg0K6re47J2YIOyhsOq1reydgCA264WE7J20IOuEmOuPhOuhnSDs
p4DquIgg7Ja065SU7JeQ7IScIOywvuydhCDsiJgg7J6I64qU7KeAIOyVjOqzoCDsnojsirXri4jr
i6QuDQoNCuuCmOuKlCDqt7jsnZgg7Lmc6rWs64KYIOqwgOyhseqzvCDsl7Drnb3tlZjquLAg7JyE
7ZW0IO2VoCDsiJgg7J6I64qUIOuqqOuToCDqsoPsnYQg7Iuc64+E7ZaI7KeA66eMIOuwqeuyleyd
tCDsl4bsl4jsirXri4jri6Qu6re464qUIOyXrOq4sCDrtoDrpbTtgqTrgpgg7YyM7IaM7JeQIOye
iOuKlA0K66CI7KCE7IqkIOydgO2WiSDspJEg7ZWcIOqzs+yXkCA1NTDrp4wg64us65+s66W8IOye
heq4iO2WiOyKteuLiOuLpC4NCg0K6re4656Y7IScIOydgO2WieyXkOyEnCDqsJXtg5zsl7DslKgg
7J6Q6riI7J2EIOuLueyLoOydmCDsnYDtlokg6rOE7KKM7JeQIOyeheq4iO2VoCDsiJgg7J6I64+E
66GdIOq3uOydmCDruYTspojri4jsiqQg7YyM7Yq464SI66GcIOydgO2WieyXkCDsi6Dssq3tlZjq
uLDrpbwg67CU656N64uI64ukLiDqt7jrn7TqsozsmpQNCuydgO2WieyXkCDsl7Drnb3tlZjripQg
67Cp67KV7JeQIOuMgO2VnCDsp4DsuajsnYQg7KCc6rO17ZWY6rOgIOydgO2WieydtCDquLDquIjs
nYQg7LKt6rWs65CY7KeAIOyViuydgCDquLDquIjsnLzroZwg7KCV67aAIOuztOusvCDqs4Tsoozr
oZwg7J207LK07ZWY64qUIOqyg+ydhCDsm5DtlZjsp4Ag7JWK6riwDQrrlYzrrLjsl5Ag7Jqw66as
64qUIOydtCDsnbzsnYQg7Iug66Kw66W8IOqwgOyngOqzoCDtlbTslbwg7ZWp64uI64ukLg0K7J20
IOqxsOuemOulvCDsspjrpqztlaAg7IiYIOyeiOuKlCDqsr3smrDsl5Drp4wg6reA7ZWY7J2YIOyd
keuLteyeheuLiOuLpC4NCg0K65Sw65y77ZWcIOyViOu2gCwNCuuzgO2YuOyCrCDrgqjtj6ztgqTr
hKQuDQo=
