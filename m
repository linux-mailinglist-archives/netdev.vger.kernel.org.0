Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE89251E3B5
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 04:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240798AbiEGDDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 23:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiEGDDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 23:03:07 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CE06FA21
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 19:59:20 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p6so8591413plr.12
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 19:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=VhbT+I+m/j1zIBMdGQ5YCdD5f5II+ZRqGX/fHpao/tc=;
        b=hPqD9UFNZDXSUEdrs3wZGxi2trainH5yHnQai9TtqAdN9t4wtDIAxB8ZU34wGBS/v8
         g1lXf0Z7Wl3MYpi5H9ypLzvUazqVcys/hHsRbdvDg6ygNtYdfLuUpuO31enQk3KJ2jZP
         3hB3+2D9eUSGCPmAzXNrhZmr2V/W3OBDmAZNGKXlSqretBzNE2mEHUwQ1+TyRS+MjRgz
         62duYrVTPjMFlHBgGjDRgQSQFFtSjhiYXLuNDOG7c0fnXfyJ4e0518joG8pHbP2TJ+I5
         Z8Sbosprn9OoAGIJoVhAbsQGsODhqpCiA7/KFjBxb4zBfWxO8fpYYNkYi4FVPbIttCGn
         CeQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=VhbT+I+m/j1zIBMdGQ5YCdD5f5II+ZRqGX/fHpao/tc=;
        b=C8o1GmntD8ODfGyBmCgQCtDv2SgK02FcaGeriYBRt7/0/suwtDAxw+6tlEEHm1iieL
         ZsArWYkfMCOQKA9Z5h+VYRieOUhomryBefHkOHjWOY/SL0W9hgbDIYrtSVE26oQsQLch
         loOKb1ZLNeWTVBTrie1dk6PUL3+qF2l0sx2523DbXOx0KWAZeoHs8H1ydybvDkAV0lMe
         RvvL24WC2YAFWKBdnWP2le7UV3uWtiC/kmOrrY6/F74PdcT68hCaTYNJyBFz86Lr5sXJ
         ffBPwnbl6aHXomgywNiCy3wIHQ8A1Y5kBeXWwsfJILN/nV5E9B0w/xvQzdA/Hqsmm7fA
         +K9g==
X-Gm-Message-State: AOAM530n7IqrQgC8J/U9rNF1wmsPMjXXOc4MSSNqrbFnQ8aH0usPb5K4
        KAkrzARkAaxF7xRnRC0sQfp/9zfU2MO78VCCNQ==
X-Google-Smtp-Source: ABdhPJxyddBwhVuGlJQlSgZoHirdmIk+S2BqxBqwuFFhgqNiFPBejXnljl6X3Nvt3rpL+7qdw7p84aG+MZOyfdrojGY=
X-Received: by 2002:a17:902:7891:b0:15e:f845:b816 with SMTP id
 q17-20020a170902789100b0015ef845b816mr2042182pll.60.1651892359669; Fri, 06
 May 2022 19:59:19 -0700 (PDT)
MIME-Version: 1.0
Sender: mrssabahibrahim005@gmail.com
Received: by 2002:a05:6a06:2101:b0:4b1:d51e:5c18 with HTTP; Fri, 6 May 2022
 19:59:19 -0700 (PDT)
From:   Elena Tudorie <elenatudorie987@gmail.com>
Date:   Fri, 6 May 2022 19:59:19 -0700
X-Google-Sender-Auth: 8c3LiGSWcQzsbWb9vD-moVYSdlk
Message-ID: <CAC8tt8YTGd-pii11OSibkx+hADu1BCE4whd8swC4FpAAj8wBQA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URG_BIZ autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello
I Wish to seek your conscience about something urgently, Please reply
this message, once you get it.
Yours sister,
Mrs.Elena Tudorie
Email: tudorie_elena@outlook.com
