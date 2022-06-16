Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1BB54ECC9
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 23:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378582AbiFPVox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 17:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiFPVow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 17:44:52 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B505F8C9
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 14:44:50 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id u99so4301373ybi.11
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 14:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=w3tvhlX7chm302pR6kI1R+OPbmJ28EmkuSxJgd1jR4I=;
        b=UdqFaJMjUHG6bmfiwl+8LBDh6FMR1ZXYpmV0c3AZUYlGeosI+/qDOX/ljFFMYcWXBy
         JeCp8AyKdz/bEsyUA58eYJKhm1n+cDAQAeSOnFy9BacPxnzhlnWFH4XKw34W4oUu44fL
         gBpwU5gy676Rinco3HJpGnmr8sORpn93S9lyiMWDK+kLqUSyazq6irZ0dBk2stjHCZEE
         avq5ALF9BbC3WijFNMLSpeleH+YOeXixY+lgMUQv6TBs8vnzmDBL6XOVzlaBhumYqFdn
         gpQndbB2u+RVCug550TequZ17IcJiWIvOv23IhPtn0t9PcDwAbQNWlIIoGv9Ux+sabyl
         cr1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=w3tvhlX7chm302pR6kI1R+OPbmJ28EmkuSxJgd1jR4I=;
        b=Sctc8zWQYPPLhFsjgxALr5XWkQvETGra0qw54rkXEoPwQDZ+accnYP8seDlQ9jemo8
         MgeWVJip6x5uEKxy9YuVSCO95RW0wNCYBjdvQAa/bjgq+UCCuAlKbTNaV7zBks4z8QG6
         UZGYBChntyhLf7i+VPx05ezqHFl0gsCIRR7K40hnlHSLKBueuuB+PE+hAiNkcHyKyO2H
         N71UyykpnOHdmIH35G4eSD0Xbp5oew99hmanSv5wGLzcyHR98CtTFzBUHGarVkLEfaip
         HE9hOvtQAIPwQM9nuhghJY9hBpdzAHWCloNMFI3NbrwYXJ+HgVt/m8IEChpg+e5Gaqds
         jc+w==
X-Gm-Message-State: AJIora/hH3Tl/TyfLkN7OPSsSSPhXdTEeDfHxFTPQweFldcZMS8K/l2l
        g7dRJnFMQuxp6MLu5K1d5H2viI5N6fS3LdXlwWYCTH8r9Zc=
X-Google-Smtp-Source: AGRyM1vqHiXGZqeCLjmERM+SBHizsLh3cAOcMaKjNy23JWK2QjPLyABBJE9MuwPIAm/I91ER8TbQM2MRK/AuXd5rzvo=
X-Received: by 2002:a25:3251:0:b0:664:2ec8:3402 with SMTP id
 y78-20020a253251000000b006642ec83402mr7840823yby.512.1655415889651; Thu, 16
 Jun 2022 14:44:49 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sgtkaylama@gmail.com
Sender: komivisoklou@gmail.com
Received: by 2002:a05:7110:a24d:b0:185:d2da:38c0 with HTTP; Thu, 16 Jun 2022
 14:44:49 -0700 (PDT)
From:   sgtkaylama <sgtkaylama@gmail.com>
Date:   Thu, 16 Jun 2022 21:44:49 +0000
X-Google-Sender-Auth: Mo5UTIfDsXhCl0v-uPPaxd2C2Ss
Message-ID: <CAEW9iQ_xzk-7w+RTxkKiwLALFVJ7B6KhvJf3vY46gG+9K8+O3w@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

labas brangusis, kaip sek=C4=97si? Tikiu, kad tau viskas labai gerai.
Negird=C4=97jau i=C5=A1 j=C5=ABs=C5=B3 d=C4=97l ankstesn=C4=97s =C5=BEinut=
=C4=97s. Patikrinkite ir atsakykite
man.
Geriausi link=C4=97jimai.
Sgt. Kala Manthey
