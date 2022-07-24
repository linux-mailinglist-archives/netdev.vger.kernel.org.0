Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7497B57F53B
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 15:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiGXNku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 09:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiGXNkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 09:40:49 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A60E03F
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 06:40:48 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id 129so804847vsq.8
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 06:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=LIYkXsh8NuZ+kWZJQV6Z3UgDflGRM7baotKUMbx/XVo=;
        b=maAhf+F1GQTCI4x/uXteqFv+OyqVoMAIs+BiOB4YnJ2dImFSDj0WyXTtKIVNAsd48z
         iJRsGDbk+TMETTdwryhJ6qSTWIqaOPzHpGfIPccvz3TXXL1NrkrF0EA60vCRmROjyL40
         d7J129d3ffFy7x4Vdnv1A9/WrH0IJl/lfU+HrHxdjGqd00JdHaAHNfVEebBoyrgOJqDi
         RYNKS0N7UwqEVoj+B/ZDF9itoINO1im71A//gPx8yFa4DxaHnoJAHvuIOx5MArU9ZVJn
         h9/fCt4xJPd4z92ynYGAlUWZWlgyItMkVBjhJO93JNlGsusUc6Qx/qK44nmPLgYR2Rdc
         ooIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=LIYkXsh8NuZ+kWZJQV6Z3UgDflGRM7baotKUMbx/XVo=;
        b=58V4tq1oE6cYbkfJnvwHqnaaBiRVYJhQ2Qr+FBfe30gKsqXug/ocMVycW/l9XpqExu
         +zqrQEVytNDAIM1uA0STD+8FLmw9ZhwS3Qiros76Pq/5ETolanPk0G7pj7QYC0s8I8Kn
         o0o58tH3F52kTq3hMe6C0RAE5eASzlNCGG9suXwSgrA4Ry+Q1v3aLA5H0iaYY5y2B1vB
         lKAROjE1tuRTR86j8eO2qY0OiwaMwJn5Cl1dUr2kWvTF3zlPHMD2Pq0y1aWFv+v28xFN
         RO7S+1rrjDUGsEiLpKtFJGAUjIju6GCXPzsfLznejwiqlrXh+GM8J07HnxgKgH9KKnMe
         vAeQ==
X-Gm-Message-State: AJIora/qvu18If6GtnmiRsMh9JzwiVIZvZuKfA750Xsx/UVpWCLBBxDf
        IHXCTi87LQgkhaVYBK4iA/XQyEiWelaDmM0mDfU=
X-Google-Smtp-Source: AGRyM1s4zWQkETPlMq3ujbT01urA+B08TCMksgcKlcALjijvuUedfO7wDPYSlBUs3jawsoPNs5bf1FFHgDDKlrVOFbA=
X-Received: by 2002:a05:6102:cd:b0:358:4834:71ed with SMTP id
 u13-20020a05610200cd00b00358483471edmr1897280vsp.50.1658670047262; Sun, 24
 Jul 2022 06:40:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:d088:0:b0:2d6:1571:aac5 with HTTP; Sun, 24 Jul 2022
 06:40:46 -0700 (PDT)
Reply-To: te463602@gmail.com
From:   "Mr. KAbore Aouessian" <kiboraouessian@gmail.com>
Date:   Sun, 24 Jul 2022 06:40:46 -0700
Message-ID: <CALGXYcRncbfOXBMytENTPJ9gOvDNKk_2TbQMdmpqsTt5i-80xw@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Greetings,
I'm Mr. KAbore Aouessian, how are you doing hope you are in good
health, the Board irector try to reach you on phone several times
Meanwhile, your number was not connecting. before he ask me to send
you an email to hear from you if you are fine. hope to hear you are in
good Health.

Thanks,
Mr. KAbore Aouessian.
