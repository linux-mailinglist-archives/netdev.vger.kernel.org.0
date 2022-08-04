Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2425589BF9
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 14:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239644AbiHDMy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 08:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiHDMy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 08:54:58 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986B01EAD6
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 05:54:57 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id c17so12177471lfb.3
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 05:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=U1hEasta6NC0Fhws0/3UxCRL1y11e+6zcIcC0np0f/U=;
        b=E1Hyh/p6MIRwOdnA/Z9VxIHTCNrfpIF1pjR+DOEtc6waPmKsh1KyAB859NW4mk+pCY
         gj84Ryv6nCpQubUh9T2Q9Zi68DwnxwwxK3ODxk6P2KOZxarNkDhpy9DAH6Qe4KtBC/PN
         MAQ2gb7z/mQGehwFZUM6MD/UaAAiE6EqlZA1p9JV2keVik5ucblzrQOgCIcoaI2THou0
         SbDkGSCGyHNphFhJ0EZrbFN3E8d6m0J8FBzvXu5jqvJhdo9ZZilCXA7nCySGFroOUfkz
         9vAlja9BFglQjfedb9RbopY2TkR/vN5hXWOCZvorIvpG6YD9JhX/5B1VLyNTFud4EDIy
         wIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=U1hEasta6NC0Fhws0/3UxCRL1y11e+6zcIcC0np0f/U=;
        b=0HiOt+wWSszwQU5Beabx+D+k60UTOJFP/iiv/qf8mDd96QAoO6wE8w557Tvac/u6MM
         fdfxuMbD4/PmNxkKOk4Z5uA06dpsZOKEGkr/b7BaCDA29utOyZ/4ffjmD2zyMRP5T7HT
         e2YFYwuGet+rRRSA0xiCoy4ZoZZaalDi8HSgQv0sjB+GeMXzprM2uUCD1hyp/rcHTdfY
         J8YXfq4qSBelhhxD+tdfbB8rgwaCyDyKjLZC6OS8kfoBIEPYDHS+9NP5g4S57Eq8c3kV
         gyOHPx738cjvDOxE60+mg6I0Ij3sIZ4o2mbAb8eJTw+4VOBMyWJWE/4s3Tx+7z7OyO9l
         BLxQ==
X-Gm-Message-State: ACgBeo2dIMz5Fj81gO1o6D577wwikEFA31/Don83ansj+LXmwh+ZJGiF
        heGjOzR8lJLyGkuBkT3qmTH7/TAqpNKEKeTMQVI=
X-Google-Smtp-Source: AA6agR4yTr8VQqic1CzaHQxj9toM9IFSF3aIJ2prorDSjLeXgsRumr8ZZmFuU+KkZ5gIGdwk/nGKNRAvRM1j/ORXfZM=
X-Received: by 2002:a05:6512:682:b0:48a:407f:418c with SMTP id
 t2-20020a056512068200b0048a407f418cmr613311lfe.405.1659617695957; Thu, 04 Aug
 2022 05:54:55 -0700 (PDT)
MIME-Version: 1.0
Sender: bankatlantic28@gmail.com
Received: by 2002:a05:6500:c0c:b0:14b:e2a9:6aa4 with HTTP; Thu, 4 Aug 2022
 05:54:55 -0700 (PDT)
From:   "Mrs. Linda Harakan." <haralinda549@gmail.com>
Date:   Thu, 4 Aug 2022 05:54:55 -0700
X-Google-Sender-Auth: 34VldBaZ35jy9P_WjTNrOAi_Kw8
Message-ID: <CADtTZG3j5q4TAMFYrQeUvG87+0Pm3PnnHAKsGFYe_74HKgoz_w@mail.gmail.com>
Subject: PLEASE CONFIRM MY PREVIOUS MAIL TO PROCEED.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Recently i forwarded you an important message and i have expecting
your response, please confirm my previous message and get back to me.

Mrs. Linda Harakan.
