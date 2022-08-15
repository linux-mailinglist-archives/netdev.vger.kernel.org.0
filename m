Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4753E592F43
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 14:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242648AbiHOM7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 08:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbiHOM7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 08:59:31 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F074E12089
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 05:59:30 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id l5-20020a05683004a500b0063707ff8244so5391154otd.12
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 05:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=I+y/ZymfRcUOa9dFnDPtZmH532laontsFG6433XUp9s=;
        b=RPBe4yEfG4GPMhV1hyyOgBVN2VnkFl+dPk/mK8m/wrsHS50odxxTSEPzxXJpLA8UrE
         w0rDRbRiA6XlWZqk9GMrExeRuFuOA/lmI3WG2mTyEhgNcpj2zAi1zy6cptFBv+MadGWt
         lOn3euQ4lUJ/Pnk2Z+wXnAoiU5jwvWMDhZ3yXI328SuGy3Ic+cBYu/UqB7PskNKEUxY+
         d1PfxgNG9gcIBIyf9dt2uQIo5Wzzeb0mY1DPD6cR5RC9HLOyfe/qSVFj5ugWodAT8CGm
         tcncP6+wj3sAcostf++0LCW2PkBuYeFB+KzD+flumPrxq1Cf8N3ZnfwmMohKSkBifJuF
         6lkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=I+y/ZymfRcUOa9dFnDPtZmH532laontsFG6433XUp9s=;
        b=b+KFByRCY7+v+Ci8HwWBg7++vd9aoPo+AY0qHLPUbn21hslL6iXF4fzZih5+cOJI++
         qQu6XZ17jx7qAErVRY6o1sK8v1BDZ5RDeG45HVO9F6oxzwyFafYUS7a765K7pQ8JGzAf
         /NFEc1Pnas0S4fR28dzYPoQMDD2iredz+ZnNd0g7bRc4X4a5JAH2toFlvmqii+dXi6Fm
         4Kh0xQq0HGZ+NzQokaJbbK6mxD7VOqMwmTlxY5w8Dr0mY6MY33oOeRg5zzNalstoh/L6
         VSgvAg5DleDEjw35nhuEPdsHhBjLYq3IWlPEgyPUNHW09PjbMO2gi04PReIvuaxCPtl5
         kuUA==
X-Gm-Message-State: ACgBeo04kYsS14FkV8VBT5yMXpFIZpOwCW3bxi7iaALfwnjC7GrVYGdm
        zgld5IeM++T+h0x/PZN8h1kt+tuWlaa/+o9Ib5A=
X-Google-Smtp-Source: AA6agR76rWWbbRCZ+tNG3wTjJu9X8ZEY2Yzz9fKJbXVRRouPzS3E2GCbIXZEstnw/9IsWj0ivyJYC9oDMKCYFu2+vy8=
X-Received: by 2002:a9d:4783:0:b0:636:fb26:6978 with SMTP id
 b3-20020a9d4783000000b00636fb266978mr5867008otf.210.1660568369982; Mon, 15
 Aug 2022 05:59:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:4a10:0:0:0:0:0 with HTTP; Mon, 15 Aug 2022 05:59:29
 -0700 (PDT)
Reply-To: cfc.ubagroup09@gmail.com
From:   Kristalina Georgieva <ubabankofafrica010@gmail.com>
Date:   Mon, 15 Aug 2022 05:59:29 -0700
Message-ID: <CA+hLP9BgvBxPm-PZDywEG5ah1YMEb_AU3LJtpE-CXLUw=7QNnA@mail.gmail.com>
Subject: =?UTF-8?B?7KKL7J2AIOyGjOyLnQ==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

7Lmc7JWg7ZWY64qUIOyImO2YnOyekCwNCuydtCDtjrjsp4Drpbwg64u57Iug7JeQ6rKMIO2VnCDr
i6wg7KCE7JeQIOuztOuDiOyngOunjCDri7nsi6Dsl5DqsozshJwg7IaM7Iud7J2EIOuTo+yngCDr
qrvtlojsirXri4jri6QuDQrtmZXsi6Ttnogg67Cb7Jy87IWo6riw7JeQIOuLpOyLnCDrs7TrgrTr
k5zroLjsirXri4jri6QuDQrsmrDshKAg7KCA64qUIE1zLiBLcmlzdGFsaW5hIEdlb3JnaWV2YSwg
7KCE66y0IOydtOyCrOydtOyekA0K6rWt7KCc7Ya17ZmU6riw6riIKElNRikg7LSd7J6sLg0KDQrs
gqzsi6QsIOyasOumrOuKlCDso7zrs4DsnZgg66qo65OgIOyepeyVoOusvOqzvCDrrLjsoJzrpbwg
6rKA7Yag7ZaI7Iq164uI64ukLg0K6reA7ZWY7J2YIOu2iOyZhOyghO2VnCDqsbDrnpgg67CPIOyy
req1rCDquIjslaHsnYQg7Lap7KGx7ZWgIOyImCDsl4bsnYwNCuuLpOydjCDsmLXshZjsl5Ag64yA
7ZW0IOq3gO2VmOyXkOqyjCDrtoDqs7zrkJjripQg7Iah6riIIOyImOyImOujjA0K7J207KCEIOyg
hOyGoSwg7ZmV7J247J2EIOychO2VtCDri7nsgqwg7IKs7J207Yq466W8IOuwqeusuO2VmOyLreyL
nOyYpCAzOA0KwrAgNTPigLI1NuKAsyBOIDc3IMKwIDLigLIgMznigLMgVw0KDQrsmrDrpqzripQg
7J207IKs7ZqMLCDshLjqs4Qg7J2A7ZaJIOuwjyDthrXtmZQg6riw6riI7J6F64uI64ukLg0K7JuM
7Iux7YS0IERD7J2YIOq1reygnChJTUYp7JmADQrrr7jqta0g7J6s66y067aAIOuwjyDquLDtg4Ag
7IiY7IKsIOq4sOq0gA0K7Jes6riwIOuvuOq1reyXkOyEnCDqtIDroKjsnbQg7J6I7Iq164uI64uk
LiDso7zrrLjtlojri6QNCuyasOumrOydgO2WiSDtlbTsmbjqsrDsoJzshqHquIjri6gNCuyVhO2U
hOumrOy5tCDroZzrqZQg7Yag6rOgLCBWSVNBIOy5tOuTnCDrsJzquIkNCu2OgOuTnOyXkOyEnCDr
jZQg66eO7J2AIOyduOy2nOydhCDsnITtlbQg7Y6A65Oc7JeQ7IScIDE1MOunjC4NCg0K7KGw7IKs
IOqzvOygleyXkOyEnCDsmrDrpqzripQg64uk7J2M6rO8IOqwmeydgCDsgqzsi6TsnYQg67Cc6rKs
7ZaI7Iq164uI64ukLg0K64u57Iug7J2YIOyngOu2iOydtCDrtoDtjKjtlZwg6rO166y07JuQ7JeQ
IOydmO2VtCDsp4Dsl7DrkJwg6rKD7JeQIOyLpOunnQ0K6reA7ZWY7J2YIOqzhOyijOuhnCDsnpDq
uIjsnYQg7KCE7ZmY7ZWY66Ck64qUIOydgO2WieydmA0K7IKs7KCB7J24Lg0KDQrqt7jrpqzqs6Ag
7Jik64qYIOq3gO2VmOydmCDsnpDquIjsnbQg7Lm065Oc66GcIOyeheq4iOuQmOyXiOydjOydhCDs
lYzroKTrk5zrpr3ri4jri6QuDQpVQkEgQmFua+ydmCBWSVNBIOuwjyDrsLDshqEg7KSA67mE64+E
IOyZhOujjOuQmOyXiOyKteuLiOuLpC4g7KeA6riIDQpVQkEg7J2A7ZaJIOydtOyCrOyXkOqyjCDs
l7Drnb3tlZjsi63si5zsmKQuIOq3uOydmCDsnbTrpoTsnYAgTXIuIFRvbnnsnoXri4jri6QuDQrs
l5jrqZzro6gsIOydtOuplOydvDogKGNmYy51YmFncm91cDA5QGdtYWlsLmNvbSkNCkFUTSBWSVNB
IOy5tOuTnOulvCDrsJvripQg67Cp67KV7J2EIOyVjOugpOuTnOumveuLiOuLpC4NCg0K7KeE7KCV
7Jy866GcLA0KDQpLcmlzdGFsaW5hIEdlb3JnaWV2YSDrtoDsnbgNCg==
