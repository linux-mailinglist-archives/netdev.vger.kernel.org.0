Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613C8547F8D
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 08:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiFMGfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 02:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiFMGfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 02:35:18 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F341B872
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 23:35:18 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id v22so8311676ybd.5
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 23:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=kHvqhKfwkSYWgIBUppKUElAVHImwDcI/W0up7OF2SsA=;
        b=GahXkDRiWekhoBGAreTUWA14TIYUsrT+a7YoLSgCRkMJKk9LMpDGolLth7Q06hmq7G
         x9hCgr07bG9sj7nB7zi8O09cQ8vaNw/wRyAF798b/C/OrwaaIBx3E79QJY9Vh9o2zZ7R
         GJYrJdKxHSCMllvqmVa0v9Bkvmxq5QKWkisbR1v9GcjHnJ8w+rhBOTUlYD6/9HH0gQE7
         z7CJH0B7rGlvSXOQWyW5ZLWmozQHiNimxNyFKEBSmaGxOGFLJv02QclspAmdigPs+Fju
         KB8U+e9fsTmwVQ7F1gUF/izlXohuOGLPU8SdllI/Ixpi6RKKkD62GpOA0RyS3SBRyYC6
         E/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=kHvqhKfwkSYWgIBUppKUElAVHImwDcI/W0up7OF2SsA=;
        b=cvkka4g+YfeHyl3ZTGQDRTxicHVdwxnyXgYPOWr8o56A/ta249K3jfupoHwd5lVnth
         /C8isfVnIonha77J1yZcAVDMXwiRtYblLkHjy7g4kYR4uEme+s1bMB+cBeaE7pKe8gVN
         cC0qLmaGfu4VORO0C6aDRUc6jXIhON470L2ZQnFBIdhZ5z7EXpwCGXxawK6nE1CQvZwS
         QfFUuejyH/3H+3MsIt9wvQUE9XAw1cQokQA3r24oWTUXjpN3KuzkBnGbr+gMuAqsppe8
         PFqJguozA/z62L8hMVZiJmv5oLfriuCjQ6kZoLTzPF0nv0UXwJmAnykA+LVf6p6+Qyce
         KLOg==
X-Gm-Message-State: AJIora+/anL9jNdzQ0Dv3MlX4J7rX5vQ0J7Ii5RfNRYDkNLea1WTiVEh
        q5Bpr7nJEJcLz8Pujj0qY0bjhD9v0SsZymfo+PM=
X-Google-Smtp-Source: AGRyM1sSpaaPoYhTznwmsIVDsvq9EOxGcDda0pWvaOHhj5fZq85i3Ag6XM+xliUFQIBH/6ZwtkjAeHOi20lO741LMyA=
X-Received: by 2002:a25:d0c1:0:b0:664:fd9e:8170 with SMTP id
 h184-20020a25d0c1000000b00664fd9e8170mr364614ybg.337.1655102117422; Sun, 12
 Jun 2022 23:35:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:b055:b0:186:8244:1098 with HTTP; Sun, 12 Jun 2022
 23:35:17 -0700 (PDT)
Reply-To: peterwhite202101@gmail.com
From:   Peter White <peterwhite10125@gmail.com>
Date:   Mon, 13 Jun 2022 06:35:17 +0000
Message-ID: <CA+01_CT2vCVLosQyY9H=2kcf2ZfYRsZhroFEtK_EDXAmaAWBmQ@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings from here.

I want to know if this email address is still valid to write to you.
There is something important I would like to discuss with you.

Thank you

Mr. Peter White
