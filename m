Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3805A937C
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbiIAJqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbiIAJqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:46:35 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28110119C7E
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 02:46:33 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id az27so21584184wrb.6
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 02:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=LFPwtab8rbgpFNZDOsjcj0KfIZRqV+4htJny1LIn6IUAb5hxU+d9CoNqSH9nyt4FV7
         gqRvtrF0VEDoGS6oZeQNAwle61y23BKjJayqI1oLN1Pgh6KtOg0vb59ia7Vst6PDZEPH
         l2T8lEK1ERrIiDVZpRlenEb92y0yGSADqObYoWYOHlO2Sfm6nOhCNNmH85ObfNpXwpoM
         7Nv7jzSrggmVaRHV+Sk7ZGUUgeidsD5Or22dgxiEWogsKlwjUN46zy3t3SBuh0QW7XXs
         g3D5Gn2A1Kgr0aoh49M0vztrcKmnkFcVIg3w3pXnHzCPSnwviTrDXMdcSl7F3JdzxLpH
         nL7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=6EEHzEBLhcOmbXzaOeA38nHP95WbmTkyMhwWKukuH1rUtOClV+KabTeYj2A26Jutx+
         R6ot2NSXMeoVNMCPWKYBI3ziGus8yoYY6/b/9WPpX/Aan1OvluA3TxJxxyAZyvf5aM2J
         6dbXKaYnaK0ruRK7nT0J34op5hzN0rmCiEDU+3LTg5Fu6TH8eO2X4F2V876Dbt43JrEC
         VSwyaeDIoL/XxDgcsEQsQZxMYWjTyjPJYQkLS3MeGUdUFIyX5TR92Fb9wt3CBq1Nyabf
         QxrEYtCoPYC1XQV5C6J9ZXm0/LOXKkh6Zzxbvw8igZ9VKucDdKxAZOX91dUqZy3jWd7/
         6GOA==
X-Gm-Message-State: ACgBeo3gy0OeH7HfchQHuCc55vrKomJnzt2zIlUPAOoNjJnce4GzNaFA
        CM2EyDPdL0Gvdo/pOJc59ycxvtMNRp83JKUcw4I=
X-Google-Smtp-Source: AA6agR4pATxEtvQXp7YP6JWjNXDTxxnrH4FSsouyGM+Tw6nM3ceVJ95myOrRd0DAyKemFWD8xZONSnNV8v5CkGhqpPA=
X-Received: by 2002:a05:6000:1188:b0:220:6c20:fbf6 with SMTP id
 g8-20020a056000118800b002206c20fbf6mr14562615wrx.372.1662025592486; Thu, 01
 Sep 2022 02:46:32 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6020:a04:b0:1ee:f93e:ec7e with HTTP; Thu, 1 Sep 2022
 02:46:31 -0700 (PDT)
Reply-To: maryalbert00045@gmail.com
From:   Mary Albert <rosefunkwilliams0257@gmail.com>
Date:   Thu, 1 Sep 2022 10:46:31 +0100
Message-ID: <CAENYjsk2xn6aph+LfM7Kh-9+7Kgg7Y4RCyevprQs-tD6p938Mg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:436 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4993]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [rosefunkwilliams0257[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [rosefunkwilliams0257[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [maryalbert00045[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,
how are you?
