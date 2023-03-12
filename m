Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0BE6B6904
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 18:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCLR5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 13:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjCLR5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 13:57:08 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2092039CED
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 10:57:07 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id d36so12939062lfv.8
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 10:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678643825;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IjxCsWjpVR9S+80StEn7s0e01LeLFs8YAtijTqjnySY=;
        b=UYR0gcnoH6Z/LB5xQg7yIDLtrBXa9pxgJXJub8uA29w6b62xQk29iKlCzGykoTNmJ0
         jw9J17RfvmeFapi0FaKOMGe3xJgzRprPsBCJCfBTokWZRDeTp5Kxr07vIrTak4TbxZCt
         wOzY3cOBl2X1hjsxh46nlz8TR7jMrp5f6HvJtgKjY2tp+0RR4iTUWlw1eNeqmStE104O
         YbyOL7a9LuNcbsF1YFH4SKgdn48kXiyXKuOJNwPmW9DMpQPgMKBLwjiStMtPhrck2nGv
         SIo333xTAqzm5Q+dz6L+RSlyL7vlBbyLHWe8VB2aBkul2dHZTBJCTr2+TCS7UYa/kAJD
         uEbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678643825;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjxCsWjpVR9S+80StEn7s0e01LeLFs8YAtijTqjnySY=;
        b=VpRzAfKcJeXKhEy0DlW2xft82kCG25JkKCiHuzZMMNJ38iL8ErnvrYvDqwZBjw6H3t
         ucZX66EFpSIkimHby1AskypgEo9pJ0k/u6eUCHMWr244F4K29qt7oKBnVHix8l5pWZSd
         uuWQW41+efyLEPHOLwvDY1guVbID9LiMCMV/7HkKHfW1jqas201csmxRiRzh1o7nXFUj
         jlb5skbeU0xll8OZ9OmrkdBVRyFtgPBKpmxFgLIlBAA19Vh4zO2tRofrfHYfYkz0m91Z
         a6X3APQCeWUlb5Sv3fNHs8KDe5fqOPVWR2n2jScEGZzGHrLvMrApP1O0cefd/oXEJ+Qk
         bgzw==
X-Gm-Message-State: AO0yUKUvEORyu3ZYWuhTgO5Y6z7M0FVvmyTIwT/CN/nG96ICUXh0EWsm
        yILzVkc/ua5o3QClnOWyrLeXbETueduMsADpX44=
X-Google-Smtp-Source: AK7set8KOh2tcl7+ry/+4+6hZdcDDXJjpVAHJfCQsrMJ7Bjbg1b6mfk0Q5F/hnMwINmyN0iiX5sYOWmDG2q/JQd2wrA=
X-Received: by 2002:a05:6512:15c:b0:4db:1999:67a4 with SMTP id
 m28-20020a056512015c00b004db199967a4mr9999819lfo.5.1678643825194; Sun, 12 Mar
 2023 10:57:05 -0700 (PDT)
MIME-Version: 1.0
Sender: qianghcastro@gmail.com
Received: by 2002:a2e:9bd2:0:0:0:0:0 with HTTP; Sun, 12 Mar 2023 10:57:04
 -0700 (PDT)
From:   "Mrs. Clementina Toussain" <mrsclementinetoussaint65@gmail.com>
Date:   Sun, 12 Mar 2023 18:57:04 +0100
X-Google-Sender-Auth: ScTYdF_zu87xhJUh9jRaysSbXDc
Message-ID: <CAADLgx86TS7+ngj5S5=03hpBQBbK1OQyi8mavU3RB54x3eKfxg@mail.gmail.com>
Subject: Greetings!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Dearest Friend,

I Am Mrs.Clementina Toussaint, I have something important discussion
for you, please reply
urgently for more details give you further information. And I hereby
advice to contact me by this email address  mrsclementinetoussaint65@gmail.com

REDARDS
Mrs.Clementina Toussaint
