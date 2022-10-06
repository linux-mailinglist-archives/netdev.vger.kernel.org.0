Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1435F655B
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 13:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiJFLoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 07:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJFLoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 07:44:14 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE4889816
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 04:44:13 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j16so2303662wrh.5
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 04:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=Q3ch4MTZezNKbXvxefE+mO0E2ZEd5rYGDEvrJEQerr1h4h1HnHnZCBjPaRNXWrY7hj
         SQ7sFqnlZPlwOsfNQOscILk490fFDFMYLESkCBSJqKq7Gal65JchQxVe5AgmjtiznIjf
         mf++BRl2IVjaNGnuvroj9nkVzm4dcpzoo4Fmdg2XWusE6GKEsI5TLcQecBvAI7lAleFn
         XlLNYamYG7dJrDEdc4ttYMsOnSI+HXSI2VxP3VO9UHa1WV9RxSzCvYRO21aoy/dk7ZQ1
         rtOs6sGxdHRGMdYzVwuSvWbKybgGxSgrYO8Erdt/ytZzis/LrBOkADWj7lrIIsp2b++X
         Re+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=FcyQcUXi9xALQQ6Lm7VNXiWYStBjH/LCUTADg6v4m+k=;
        b=T42kA6c1i2A4a58fapgSoJTICOeDR7INTCh8zYFzE7F6WcEohVmUakuDjHCaSeyqp8
         OXibuMHmQR4FZJHAjn6AqVXfVEDvUqWaS0ggA3ufuQIpgkkNQNS/BHcb5nUjmGjSKFIX
         cxhUmgCE3HKwLV+qkm93NCbDt/yQqzc/e5lFd1Vzeqx27w8/+a3z0z79EhTHEOK3iQwh
         jZIuUEgQaqAMXdi1P1uXues7VRc1A6FitBqDy7xlDDh/r3taLJSirp75xhWh6bkQ9l51
         KEfLt9SbjoFtkdyTXjA81pmu3vMS6L+qt0b1nhdtz4CURqbgzsG0XHM4drUjINk0V4Yf
         /PAw==
X-Gm-Message-State: ACrzQf0kpeoAmjxHW4XwFiJ7YrMyxosfnGOJr8zOnv883vEcbaBFxY7o
        E7HnhUylC2VXfsZ5Ik/VMnw3j/9/0D5rqpEtpyw=
X-Google-Smtp-Source: AMsMyM4RXeDkElXLJLfWUQGKyR+hlS59USqWZ3RYd62zRPQo2CfBUDHqTgDcOznHqKlKse0TPalK0L/GqVzY9pJvlIY=
X-Received: by 2002:a5d:6d86:0:b0:22e:4049:441f with SMTP id
 l6-20020a5d6d86000000b0022e4049441fmr2969577wrs.198.1665056651922; Thu, 06
 Oct 2022 04:44:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f94f:0:0:0:0:0 with HTTP; Thu, 6 Oct 2022 04:44:11 -0700 (PDT)
Reply-To: linadavid0089@gmail.com
From:   Lina David <ltchadao@gmail.com>
Date:   Thu, 6 Oct 2022 12:44:11 +0100
Message-ID: <CAKVcA9sSaMXPUQ+u6FPAwFJ9vx_=127ogsBVd=zKZrEPSipOng@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,
how are you?
