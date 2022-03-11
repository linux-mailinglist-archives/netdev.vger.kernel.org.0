Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6093D4D5EDF
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 10:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347390AbiCKJ40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 04:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244592AbiCKJ4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 04:56:24 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D661B6E30
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 01:55:21 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id s25so11371549lji.5
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 01:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=sFqGxkPsvLgyKYtO8LM3BgAgzu/ZndcL6Uhn79oUxgQ=;
        b=MaXURPPTRmT0MpUhQ5/b4qAM+H0ts/SNGnwEKKpZ7cYtwuP180Mdwh+Q3PV03y2EOt
         uBjJK4LdBkHj1+bOiLW60/8GSStW/Nf+oARo2YT16Jj4xS3CwVVPtRwYhHl98iTKARVQ
         s5Fcw9/zzlp50uvNQhnAaGnML65z7oPGjim9d7wtLH/BsaDJJLd/4CoPInFtCC4l/Pkz
         kpYljYaGlhEuavocz/Gpv3GBVPWqiVud9Sa0gk3F4V4zf8Z8vHpGj8YhC4vJ6awHZ346
         UUc7KDgJgQDfnx+oZgJrnTwWz3Ku4lyM5Pz4/X3ODOdWZ79t339nsEIbVhHUjFgzikx0
         InWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=sFqGxkPsvLgyKYtO8LM3BgAgzu/ZndcL6Uhn79oUxgQ=;
        b=WMX25L8VKTp4Pslh5kvlFfcUfsfNuLW/Tu3CpRSYM7nOIBBrajsBGADGuxeSeN0Ygc
         CIOlQP9QDy0j4YYwmyaOFIJrlTeaLQqZjaTaq4Qw8O9RGfGCWLqNMDIMHhGK2v7ALVcu
         Hx4e2/d8ER6+E6xkmeeXEgI3oRrCm6tFL5CN3jW0GTmMmcVrFTIGRgnLSqhByuz8kTA9
         OQByVykvmvY1bauY2VR7BqYkC+iCTsLvNaYP+cPRrnWMCtcabMWUzZV2AcNS/attoa3T
         aViT32JBdK1r35pM7nkd/L24T6xBXO0q02P4cwgRZto9hEimpD766xKZ9hxXn4CsjWQC
         RH1w==
X-Gm-Message-State: AOAM530rnckEDfiTkpTHA4qSn4IcwIhstNdH/4uA+lEUdfQ1W4C7Upfv
        dLs12pgyLzzP9J82lztakU4LiyEerzwbDsXZSwk=
X-Google-Smtp-Source: ABdhPJwT/vy94IBs4xb+gOfiSxyBcuCMagc33kDuv5yIzqGW/7ZgzZJL4Rb63lsuPVIQ33wmnItoFbePJZBIaK1zREQ=
X-Received: by 2002:a2e:a58d:0:b0:247:eb93:e747 with SMTP id
 m13-20020a2ea58d000000b00247eb93e747mr5587115ljp.153.1646992520158; Fri, 11
 Mar 2022 01:55:20 -0800 (PST)
MIME-Version: 1.0
Sender: kaboreibrahim.10.1@gmail.com
Received: by 2002:ab3:489e:0:0:0:0:0 with HTTP; Fri, 11 Mar 2022 01:55:19
 -0800 (PST)
From:   MS VICKY WYNSLOW <wynslowvicky@gmail.com>
Date:   Fri, 11 Mar 2022 01:55:19 -0800
X-Google-Sender-Auth: N1aUJkZfWHNbiaqgznhePNvm4c8
Message-ID: <CAA3qQpsLbk+4izm7NEYRhh_nOEDNT5NrUrO3q5FhQU=pyZsQzQ@mail.gmail.com>
Subject: I NEED YOUR URGENT REPLY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,URG_BIZ autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, dear one
Am sgt Vicky wynslow, I have something important for you, pls reply
urgently for more details
REDARDS
