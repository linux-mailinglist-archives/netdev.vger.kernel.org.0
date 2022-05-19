Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657B052DDA0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 21:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbiESTTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 15:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243255AbiESTTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 15:19:41 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEDD954AD
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 12:19:40 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-2ff1ed64f82so67136527b3.1
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 12:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=sldeoUHN+XKV/25qdr8o1yS1uyCAwpn/8BNmGuwP1dE=;
        b=SyyVPDFreVIed4F2sV83k9poc+45Jb+WqxPkZ/omInzKyokAJXiHPgFoDtp9coweXp
         3mBeyUymb6DpiVvEMxocVf8GSiSdkkvg5HGMouVzs1z/U4J1sm0bg6/I4K5qmeNb1nRM
         FF4c95EFkZsYxY1JwL1QmChvZjy43vHeCK2UAk0ZxvTId6rPDY12G6n5bgHnETKpFgWE
         aqpqpyLW2+ChDO1l7gPrN9zAKe4lF+s01I+Pgl1zEC3ELa6ez8xBrrkIUlJ+l26KLNv3
         KVyghHMXZzAbUD8MJ/AuIhcluIhAvnn3tsbJDwTkvwevYVo7zCVkgqt1L+3a4lWbVaag
         +TRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=sldeoUHN+XKV/25qdr8o1yS1uyCAwpn/8BNmGuwP1dE=;
        b=MqPBko0051/WyxIKNfPDzW6s0WC7Hqtm69oY+UbXpnCrpDz9MZDAo1icDscSNgApTf
         a8Gk/ANF33tdBbm9JCtAAu+lcrpQQc5ST+ayVLMgmrWs1mPcZC+Wlk0N/Og4AAWJM8Vi
         yFavAbS6OOuo/8uxQFSDJUMZlDU7cxEi9f4nmvIP0u/94cJGX2DzDr8KL/aKe6OE2y7P
         VgWBukfRfUV3dc/Ae5RARkFeu0Flac8QOg6fppYF14N/xcALAoMS4uhKiCE+1eVYV6ka
         qdfOUtLBGepPlxSJkteUP/jvUBgJO6mBl/5qPfQtZi2Sh+S7vHWTuvJOqEhBG13Qo49c
         fFAA==
X-Gm-Message-State: AOAM533YIt7BX7ATcVHNnJfp/cg6GR5BbxRLM18cszdPfr0MkTn/MOHj
        r4AjNjj+i9jYjJIUlBbZoCYLsu334lPpg63fFak=
X-Google-Smtp-Source: ABdhPJx0GTpEok0UGPaDo+g1K8BSabbm4WE0xQ20sfIzdw9xDStaeHxgPYS2OloETBHRBavyGXJg8COnNDJbwM23ros=
X-Received: by 2002:a81:1709:0:b0:2fe:f340:f870 with SMTP id
 9-20020a811709000000b002fef340f870mr6630488ywx.105.1652987979147; Thu, 19 May
 2022 12:19:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:6b12:b0:2ad:f417:94bd with HTTP; Thu, 19 May 2022
 12:19:38 -0700 (PDT)
From:   Manuel Franco <manuelfrancolove048@gmail.com>
Date:   Thu, 19 May 2022 12:19:38 -0700
Message-ID: <CA+PGJtAnx2vYcF0xj-PopGFk11Y6iJFB5VofDRSL+mX8vW-qmQ@mail.gmail.com>
Subject: Der Betrag von 500.000,00 Euro wurde Ihnen gespendet. Kontakt: manuelfranco4love@gmail.com
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ich bin Manuel Franco und habe am 23. April 2019 den Power Ball
Jackpot im Wert von 758,7 Millionen Dollar gewonnen. Ich gew=C3=A4hre 5
Personen jeweils 500.000,00 Euro und Sie geh=C3=B6ren zu den 5 gl=C3=BCckli=
chen
Gewinnern, die ausgew=C3=A4hlt wurden, um meine Spende von 500.000,00 Euro
zu erhalten.

Kontaktieren Sie mich f=C3=BCr weitere Informationen unter:
manuelfranco4love@gmail.com
