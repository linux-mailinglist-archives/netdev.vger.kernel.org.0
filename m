Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 635255311F8
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbiEWQEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236383AbiEWQEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:04:36 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C12E427D4
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:04:35 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u27so21227166wru.8
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=HQzxdI69iUzyvTdjSA1zSrJoQZmSYkTKblsFwdZ01b0=;
        b=VK18NVSEuYRnXpfWGrTJ6vG5D/XTeKg4hxNJDZ8ybkREvaHcMUC2FAbyrRunNnK/tD
         WVOA1SsL5skgItKtw6wGRltBSSzwf4eTHELFrOvwRRBjKzU6BMsQF73Iji9V41fv1hr4
         cNQGpv2yFAUDntYwUasAPaK6m1ootPInWtEQEV6WMDLhKdUFeWRy56y5PIskeyF5I2d1
         zOYuWUoTDVgq1uFxYmUOr+eT4C3XJwEL3+wvgELr4rGzZplJvJR21pY3RLx5MVwmO2xD
         LlXcE4cB8M1nrqkBgvw6qMHh1NoLcBh67t9GSOLEwnzTga8horA3zP8bEjbbM2RnvuHp
         i6Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=HQzxdI69iUzyvTdjSA1zSrJoQZmSYkTKblsFwdZ01b0=;
        b=hsW3mYS0Q3+HWQOc5sk5Ra5Zc1qbDFRdyNoU7yZUdQkQwZ7xjmfhWSy3ZyB8tArr8Q
         zwneqem9R/bAeEkbA7EugRtV2n5tmLfO6g4zmi+qOqwUAQAMED9Gy5Am7t6UzwozPqFK
         hyn1vzHZ5PjpZDRNSeXKdunHpRlee20aKk+mP/AVpWJNkjPvMv83cTbIRjdafSMoH6rm
         jIojQiBtB5EiUzlo+00zxxDfvx3TYMBAvItOB+Xgqs+nTz2sdjivw/SH/q/BgNecFaFF
         9vq1f+H6flkNcc/4jQTKWCtlNnqqYAbbmtwbqWqQ8psPPbViJjYCS+i2KfYJfqgcP88y
         yL3g==
X-Gm-Message-State: AOAM533mEMS2KyLaZH3YIwPk4q2ecHgj8tQ/WaUHmaiPjEhQwr3i1slk
        6Vr2Hsgs6Hz0LvL3uKyK+z85L4VSUz8iDlFScOnoi5qqAZlQFg==
X-Google-Smtp-Source: ABdhPJxj+JQJRF1bzRaNLpnre0vU4STIkRVwUdyaUzCme2xbyiDRZ438aMW8QhpDXgHIx20b1ff0+kdQmIhNqtfMOmk=
X-Received: by 2002:a05:6000:712:b0:20e:60a5:b12 with SMTP id
 bs18-20020a056000071200b0020e60a50b12mr19748583wrb.591.1653321873857; Mon, 23
 May 2022 09:04:33 -0700 (PDT)
MIME-Version: 1.0
Sender: sgtdanieldailey33@gmail.com
Received: by 2002:a05:6020:a949:b0:1be:85c7:b8ad with HTTP; Mon, 23 May 2022
 09:04:33 -0700 (PDT)
From:   Kayla Manthey <sgtkaylamanthey612@gmail.com>
Date:   Mon, 23 May 2022 16:04:33 +0000
X-Google-Sender-Auth: X3BncYjacspjCZz9_LBY4_hfqnI
Message-ID: <CAM5qAYSPwDGUsPdjne-UJsFGRTghLg=M1CHXTC+QV1bADKk34g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.0 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, I'm yet to get any feedback from you in regards to my previous emails.
