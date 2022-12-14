Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA75D64CC90
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 15:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbiLNOoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 09:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238729AbiLNOo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 09:44:29 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3529E66
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 06:44:28 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-3b10392c064so239422637b3.0
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 06:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PAGV2Q8tueB9u6nAu32uT5tMQP/9mkBrRApmZJ0yLwI=;
        b=pcy9+cJK3EA0+ooRffaSvLLYxignVnG72PEX/xCJ27/hYsHE5cgG3T1J9djsZB8sVu
         nb5wjWsxp7KFM72nhqocvh9USAaIDtchAmksV81dJ2MOOEG4dIPoVnLCyru070ykEKgQ
         NdUNuNOhpxtUUdmWWdf3IxPJR1JSDJehd7fFrL4diMUbvSU8I7gS7Nzy7HI23DEJAZQ0
         FsfJEOWo2bn487QsnThqrV2TIIwOwm9mgakFb4pPrnLqgF8XIeJrxI3zD9l1ODubeWCP
         63BpXyJm4p7iOIoGDhdFR3xwTwtWu7Y3VVfk7pNWu+fZ81HziKRcJikPufkGHFBAzmxM
         IVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PAGV2Q8tueB9u6nAu32uT5tMQP/9mkBrRApmZJ0yLwI=;
        b=ZMVSNNg3uZfe1CHxS/z5Qg3gMY4JrXARihVTTnIboRDF1BCqt0L76HKN661J3lJ4qI
         waRpPG3PXpXBj/c0k0D3OaN7xzRz3WyNs/gO+pcTDsYV2SVfo6KEGKkFPFnzpsZlw/gX
         KRbaGAGYHbLpF/hOMFHfOVOKWc3IFfQcoLqHBimKlyVnMOwYEVsV+Ihh7u17nBlgUg2P
         s2324Q94XGj4n+FRwGm+s/g2aanDOcXHBqHKS4gV+s9G8aJ01X6YYtPgCQkYsT+z7NYh
         KUBmjfhShaxwLhWKxn2HQbcC+HCb2drHblJF7he2EmXYZO6eYyKlBuXWP0uvmpGRomJC
         x2kQ==
X-Gm-Message-State: ANoB5pkeU94mhcx+Ei/3HRjyfeP1V79RGN3pUTLf/FD8MCuxwwy1TEC9
        xdWHJKpkTRg5pa34SrmQN2kiHWLyDOL8eO47sno=
X-Google-Smtp-Source: AA0mqf7z7H2uvb0ClN9oXWcOlkTyDYuYuUD71FL8I1SYlH3SilSdHDe03rHpQdjqzH9t5GFoWXX/lnnGhrUzH9w7MwQ=
X-Received: by 2002:a81:4f57:0:b0:3df:6a50:40ec with SMTP id
 d84-20020a814f57000000b003df6a5040ecmr29944725ywb.340.1671029067765; Wed, 14
 Dec 2022 06:44:27 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a81:4416:0:0:0:0:0 with HTTP; Wed, 14 Dec 2022 06:44:27
 -0800 (PST)
Reply-To: felixdouglas212@gmail.com
From:   Douglas Felix <mrjoshuakunte23@gmail.com>
Date:   Wed, 14 Dec 2022 14:44:27 +0000
Message-ID: <CAE8KSLzhja2FE+Jj_Zo-CqgQmChYhYudTY=KdLGiM6RiXoJoOA@mail.gmail.com>
Subject: Good Day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
A mail was sent to you sometime last week with the expectation of
having a return mail from you but to my surprise you never bothered to replied.
Kindly reply for further explanations.

Respectfully yours,
Barrister. Douglas Felix.
