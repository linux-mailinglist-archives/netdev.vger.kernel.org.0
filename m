Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274F96F17FB
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 14:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239875AbjD1Mad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 08:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjD1Mab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 08:30:31 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4616230E8
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 05:30:31 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id 5614622812f47-38c35975545so6699780b6e.1
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 05:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682685030; x=1685277030;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/fKCEYM2KoPdQbQRqbY2jd84Y5Lqt7lmpeVxv+tF86o=;
        b=OzV+DfYtsma7MhnY9mtlGvDSW7SqFkkGQ6dGHfP5FsQ+Pu8Dxe/Vpcqnc7j984Llcu
         JMp/hgO87zWy0mL4FpOtXkSapP02tEOYRajqWSykmAqMnBLJzr2hj2IvQODIySbFEtwi
         WRh2ATlbHUA+2RXMkM800dEZy8vQKJkfsOKjaX4jPm3g2HtIaYy69hg49YEFTKNl1vGx
         UiAGpGjHdYv9b3RHrcCiNHKVAHTjgZbEZ8KbOfKPcwmY6d8Otx26jsrASd917Jm+pJ3e
         HewYWO0lPDtrOvG9c8KagIXINa7QOU2z3Le7kbpXpvWhVsU0vs5hz9Xpxl67VwubIVz6
         1E7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682685030; x=1685277030;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/fKCEYM2KoPdQbQRqbY2jd84Y5Lqt7lmpeVxv+tF86o=;
        b=U+7ZmsjuvUJYQgVCpNfcf8Rt5NbttPjIdPis6UJ9hTtKSROuujytwi40JV15sdoPYm
         Xzo/jQAHl5TB9L+F0W+YA1UTQrGJDPaSFmR/dce+gn7lLppiSZedk/q6ipZ6FoYtyNqW
         GUCpOu7xj82ZJ8m80NWAN2fK8USAUb/Qcym4JPJPwijYlXr6kzK7mE2AWQkiJhqdqEmF
         Vvv7uz5k+qWA02KSdFeRMvEJ0dKgcA4+AtNWhHwqWBqYigwfYCTziPjAG7TGefX3xj0r
         PuAEmiR7N17HzdJgh3TqhWfX/feq1hKZenVG0e87q53x/O71s66GI4Mmr3IET9br+gqC
         zang==
X-Gm-Message-State: AC+VfDxdlJMv42P7dpxY6h9+L+LRWkGm7rQvAUgiT9IT70JszN2+C8Pg
        FsmEAtuGl1Yv+L3SsisvBhUAvKmBpLSBi7VPLKk=
X-Google-Smtp-Source: ACHHUZ7EyUms69xa1VK15AvaCDyLb8gAiC3YHpXwKgG+bNoU2QdetHD0FHIgPdIyR2a5tKN+ebkro7k2Xusx6kZydSA=
X-Received: by 2002:aca:1307:0:b0:38e:2879:735b with SMTP id
 e7-20020aca1307000000b0038e2879735bmr2217987oii.34.1682685030482; Fri, 28 Apr
 2023 05:30:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:494:0:b0:4d2:d43:316f with HTTP; Fri, 28 Apr 2023
 05:30:29 -0700 (PDT)
Reply-To: inforwugilbert01@gmail.com
From:   "Bryan W. Gilbert" <brinlydean4@gmail.com>
Date:   Fri, 28 Apr 2023 12:30:29 +0000
Message-ID: <CABw-X_RcFmQHMndgackBk-3zMrmAOKVokPJmJ1KrR6L6DQdv6Q@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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

-- 
Greetings,

I'm Mr. Bryan W. Gilbert, I work with a prime bank in Turkey, I have a
lucrative business proposal which I want to know if you can help me
achieve.
Kindly get back to me and I shall send more details to you.

Thanks, and God's blessings
B. Gilbert
