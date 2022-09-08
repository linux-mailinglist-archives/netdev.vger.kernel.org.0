Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86145B1E03
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 15:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbiIHNIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 09:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiIHNIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 09:08:46 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB11D2B36
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 06:08:39 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id bx38so19788921ljb.10
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 06:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=v0toXAugjGjZFZEfeoP4HAg6rhjEIJmWAL9nDlVQNu0=;
        b=Q8TRhyj04NCAf2+67tuiYTlLV7DHt0W1G5q/0cvHeuxyUn/YTwmEOOMNGbLcAJS/JS
         dgQyrwwX9We/ZBRT/WhKxj455JijIE5Mbb1omLAAPH61+TfN8yMXGHHiJzZpsFxd+j/B
         jkJHjb+Zu8pv9qKCHSBVxiAQUfppZWj3IalQ/TFPbi35j2dB8B6CRE1RY6+0T6Hp3OwK
         IASIHvDcxJ8fAuAg0jYpdCssNWADChT4s9t1cYe2wEMEoyai5WI7HH+HAxFSSpaG/B08
         iTx1oCPCjI78yj6jqBkClbvo8YVAhafI2T8tAqa+uHUvK416r2FtiStX+Ng/EKAVsBIP
         qAPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=v0toXAugjGjZFZEfeoP4HAg6rhjEIJmWAL9nDlVQNu0=;
        b=Do5WmsdaAZNNw5OkXRBaKhHgm47RlUAtf3PUWRc/iylCfkFuSA3qKywWD9ilgDfAXF
         etMmZOEaDTwfCuqpOUx9ST4irh8U3ZqrEY7f9ilO0SLWS9hbQyOHipzlkpFj/iBLVUev
         ZOxhiz2lxpGEsvUgM7LUgudhJY5hYem0EAY31tOnpElNcd08/SJ2jRWWAdeBp4aTNdbc
         4Ht7v+uPZFSRPXik7KGt//qxWKmt9B+HvFBWxRKJWYTzFO8swB1+s7WJquwG3nahqF7o
         fNfRRIrEC41va8zuT0pFYnw4R3iy1Q1P9cmVQ+teT99KpFQhohsVOb5JN8LtUXoy8sDO
         qYyw==
X-Gm-Message-State: ACgBeo0cWfExxH6HQMcBuVaVE2qFr2/9Nh8VFz9MBhxtQAmPTRb/8NPT
        KIuVEf2OVBcf1o9dgRw0xaPOj6f6vfFoyrodDj0=
X-Google-Smtp-Source: AA6agR7UQzvjJocMyuT72t+oA+V5H1FLs9A+DUzivOZLUHkBPATD/johdGFRD/P/yABr0CCOj/F4h+SSUUUXlE9XVZA=
X-Received: by 2002:a2e:854b:0:b0:26a:ccab:daea with SMTP id
 u11-20020a2e854b000000b0026accabdaeamr2600652ljj.455.1662642517271; Thu, 08
 Sep 2022 06:08:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:6785:0:b0:1da:cc05:b879 with HTTP; Thu, 8 Sep 2022
 06:08:36 -0700 (PDT)
Reply-To: fredrich.david.mail@gmail.com
From:   Mr Fredrich David <sinandja17@gmail.com>
Date:   Thu, 8 Sep 2022 13:08:36 +0000
Message-ID: <CALZJgRDzaXLH7JOo=4AiRpzBTy7wpEE+n6xcd5m2VbL_R6SA9w@mail.gmail.com>
Subject: I8N,D3
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And in the response to your emails, I write to inform you that the
projects have been completed and you have been approved  !
Best Regard,
Mr Fredrich David
