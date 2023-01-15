Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE19066B455
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 23:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbjAOWVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 17:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjAOWVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 17:21:15 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB664EE6
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 14:21:14 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id s19so31137qkg.7
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 14:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5MJ48WLyAPTrpFFJQr7ltRrOLiJapBHuPrelDSbj/6w=;
        b=Ry5bmOt1NJwU+Z1PNedcfAWzH1AHAM0dQjOLPgyGvoq5WhNkJ8dWDC+4HoOFbITUHC
         MyFtcS7/eqR6YKgxzx9W/EmVdapFO4UO+RUShqKNg+3hMylzJBxb3TEIkQA+CCk7eO3F
         EB9kPp+QH5O2XRgCM3rRuVFBY3yeng7/+A/zfu0po6UpQyfPPACAZ4TaJs4pAaXcTB05
         veEwXXtT0TuP9dk0+ZWQrWCbxwAKKpKNgcfOm34C6HqdJ2JtZttynw9Jl0t4IkkkMR6H
         WI6JlFYXwPFcZM/bsOvlg5nKOqNGLPtOQ6O8j5Q3sg7Aee34Vk/A49OHZC8LW57Fk/iU
         oyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5MJ48WLyAPTrpFFJQr7ltRrOLiJapBHuPrelDSbj/6w=;
        b=uOshizT6bC2qy2Tm7z2UvcsEBAGdO9/E5bZQm5vWygA0srLH8XdASg7jtBigbdRL1q
         4fvmumuvkOjn+0utry1Xa19MDDGa7aqXw7OCjjO44cX5SIVOGekLSGiIeN6Smc/jTdc3
         MdoVN9QlpAqr14srgyYD/sJKUevQ5Ndt2HTyfPxhHkfESZRokKhSCnfQEQP+gO3TUskA
         c132RN8CYgNV6ZwSosf5d1oFzZW7xRYQeQLB21m77kgOc1fLeszvIGloz20ZcXFCrNDu
         DZmHNRVv+Y2vCrLkZw3wtQPaiid6wb8K5I/yWEFSthULRb/ZRcc6HBAx+DNkRnrvqSy2
         ZcZA==
X-Gm-Message-State: AFqh2kpwokf/TuABlscl7SJBDywyCPd5tcQehEAeRs6f5vVElD86CNoy
        wDpjZBYhZD0aaZoU14Ry7TyNC8rF+R1sXurpU7UNSba0TkEC8g==
X-Google-Smtp-Source: AMrXdXu0oXbgQb019iDCEDJRSZHTOt/OtpyLkfRB84Gw8jiQFfWNL6Ba5RvCz6d9SvoEjn7SJ4U29V4WzX298oJs8cA=
X-Received: by 2002:a05:620a:996:b0:706:7243:11ca with SMTP id
 x22-20020a05620a099600b00706724311camr20534qkx.710.1673821273387; Sun, 15 Jan
 2023 14:21:13 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a0c:d6d0:0:b0:535:1bf2:f22e with HTTP; Sun, 15 Jan 2023
 14:21:13 -0800 (PST)
Reply-To: agneselizabethgiftfoundation@outlook.com
From:   Agnese lizabeth gift <ruthdiana691@gmail.com>
Date:   Sun, 15 Jan 2023 14:21:13 -0800
Message-ID: <CAFy6VNejmSuxy9-+yd8OxzsBPbUQAHw1Y9=pMDuew3EOMFasNw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Po=C5=A1tovani vlasni=C4=8De e-po=C5=A1te

Ljubazno potvrdite vlasni=C5=A1tvo nad svojom e-po=C5=A1tom. Je li
nije iznena=C4=91enje, objasnit =C4=87u vi=C5=A1e kad dobijem e-mail
je va=C5=A1a donacija od 1.350.000,00 dolara od zaklade
Agnese Lizabeth dati. Po=C5=A1aljite potvrdnu e-po=C5=A1tu na
agneselizabethgiftfoundation@outlook.com
