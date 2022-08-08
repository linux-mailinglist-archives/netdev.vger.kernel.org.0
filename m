Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7811258CAAE
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 16:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243205AbiHHOnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 10:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243112AbiHHOnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 10:43:04 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D830660ED
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 07:43:01 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x19so4733810lfq.7
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 07:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=0wy7MAyq4fdFSiO+pwGXAsuMDxE6clStI4aaCwQnGho=;
        b=WHV+TvRM+vzbSf9Z+62/f+NDFQ10w466I1nGHr7+OKd02ntGPRCy7jT61DUTKQ5eFm
         9wK7aaJsnJPGI1PBjqLwiPiPovCZxk7/67dACgAt7VaMuNQ4nqrI8TEgcIbHCRgjNohl
         PaVReB6VtPHYL9ym/Kr7MWLR3YcKuRTuOTkEDEMrx883pp6UNkG0hKlCgNAptrKWcEgI
         YaKYumKYqRN3mgbfQrUzu+Lalwm9n9AKktEZRQcbnHvplTE79qob8Gt8l9hyxRlpP+ot
         aeOCdaTeOCJwO9a3IyK3xUgW9jqznhCyhMkWn5DMtLIBbRs5P3wMj2My8u3IZwJgBuTN
         SpjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=0wy7MAyq4fdFSiO+pwGXAsuMDxE6clStI4aaCwQnGho=;
        b=JkRdiW8HihBxYIAktHWVnyRNuKvNBC3Hn07+B3UaCzCkqyH3ukUcAYTgVq9L+90MDi
         Kj+1zVHOdEDEH57zrRBVrvuzMPR7bkMZY0JpsUtkLU2GSHJaWKRSt/H9pQfKqvgvur5m
         3hRZJ8txL03TFOWlSnmBfEH7q+B5cuOHTtIiNkXnf+/9Nh1ehb/AyOYvSSFH/4MRcYDy
         njZ1GkruCuCEvfwqBitqxPDKYdoKqAcY1D/tgg1qtV3z2yCdrtnmsTf39fG1NKsYyQMH
         KVqsmDqGCTqblomxs8jkPUy+xaqibaUzPkhccXVXXVZKQJlT6MPMOCXbU7ChZDp7tSGw
         jzYw==
X-Gm-Message-State: ACgBeo0JiAcGGLieNb2cDMk4EACiggPJQdIAocaDpM+uUjkbclwObpIT
        jMNhUeUOwLDrMuvEK70kIzRps8mBq7eInP5WM6k=
X-Google-Smtp-Source: AA6agR40cgrDiCI3uitPzxBM5qZRXR/E7xy1FWQIp78dB5sijsLJxmCzm2lJY2qMcfCXdtT3dFb6BgTGIFVrceEUvlw=
X-Received: by 2002:a05:6512:3e06:b0:48a:fea8:9252 with SMTP id
 i6-20020a0565123e0600b0048afea89252mr6681214lfv.327.1659969780162; Mon, 08
 Aug 2022 07:43:00 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6504:995:b0:1d7:f6c6:a23b with HTTP; Mon, 8 Aug 2022
 07:42:59 -0700 (PDT)
Reply-To: lawrencerebecca396@gmail.com
From:   Rebecca Lawrence <okafarobinson@gmail.com>
Date:   Mon, 8 Aug 2022 14:42:59 +0000
Message-ID: <CAO3iBgc=zG=fjK24B352AjXgtx0th4z0cVyREV+RAQx+3SyODg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ciao cara
Mi chiamo Rebecca Lawrence, vengo dall'America, single e mai sposata,
voglio essere tua amica, per favore contattami sulla mia e-mail, ho
qualcosa di importante da discutere con te. La mia email =C3=A8
lawrencerebecca396@gmail.com aspetto una tua risposta
Rebecca
