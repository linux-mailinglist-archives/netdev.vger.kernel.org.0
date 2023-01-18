Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0746867133A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 06:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbjARF3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 00:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjARF3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 00:29:49 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC844C6FE
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 21:29:46 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso1081606pjo.3
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 21:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=N6ZfjOa5ENjPU/2KnnC0AG1kiE2/wK1ZlAuzFxu1awDKoXjjDpz4bfIfDxwxVc2mQb
         8Xbm7JC8YKTKznO15/VVuVa/MCOBddshuQwXxsnYIGJx+4hWp418btPHlTaUTpzT0mrN
         tqVyBfKWwMgQf8YD+YY/nH+bR+Evw5m52+VC5FAGdpSCHRDee5qB3Uc2v9GjQzVydOah
         kaTWF8dR4MDlsXoYe0YEVK96jLX2CgMpPGMlah9waCrZIKool+3YKR3KycgRhz49VJWD
         eeO7oD1pGhmLwNUrxpLChX6xOK7Ws1VPF5z+1GtZ2k4JKTcgg3JTyBEJjv/qIW/aJ1Cd
         TjXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=DGbejylPrjwZSr1V7p2UevbROBK9e1RgughlC28c+/WfteLh6as/H2YpeWSs1GKMbl
         HIxY+5W6yuk7M7Z2YZw/09YoS3WDRwO/BGfNokU+b1IqsB1gEFQtXegN3SPgRy/wugpc
         v4cDRrI1UMdd+CYsr4OofN7U6de4DY8wDCAPD2aUkjYNIqQkvkCnI9DtKUutSfkC2LVO
         //CpptIWlUKa9NnvOj0C9DGy+U3Lh4HK+SnLGLYy4PXsgi9LMe066MCSlivEMHlmLdiD
         2TFPA7lBhKQjkJmYAoBAQwMuVkGoaolVf5UwN5lZ9H4YAH185Itu28Cct9BDtQBouFOd
         d/JA==
X-Gm-Message-State: AFqh2kqHqQIg2gvW03YNY6kmF4Ep219r7kfEwF57nn3HXrYbu0OSU8aC
        oj784BR7+/1wVhrN3GJ7WMnA1pW3GEqrBkXO9S0=
X-Google-Smtp-Source: AMrXdXtW2rn4RhlXfxmmgkKUeaynwmj9VnrD4k0sNzlNc9zMmUaQdTepISE5AK5VpwjyavKtfvDhDyPtuYaRKUiXQx0=
X-Received: by 2002:a17:902:d507:b0:194:ab28:3284 with SMTP id
 b7-20020a170902d50700b00194ab283284mr389464plg.94.1674019785934; Tue, 17 Jan
 2023 21:29:45 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7300:7441:b0:7d:4892:97a5 with HTTP; Tue, 17 Jan 2023
 21:29:44 -0800 (PST)
Reply-To: mr.abraham022@gmail.com
From:   "Mr.Abraham" <mrdavidkekeli01@gmail.com>
Date:   Wed, 18 Jan 2023 05:29:44 +0000
Message-ID: <CAMsn+iC2bYJ6Jpbm6Uhm0QXETc33Z18e=SCRyJk1b2PgUa80Ag@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My Greeting, Did you receive the letter i sent to you. Please answer me.
Regard, Mr.Abraham
