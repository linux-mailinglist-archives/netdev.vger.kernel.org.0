Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924064CCD41
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbiCDFad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbiCDFac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:30:32 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C274114FF8
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 21:29:41 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id z15so6734664pfe.7
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 21:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=My30ydHXkzs1wLCdpBkFu367S0genttJp+zEnxRH31Y=;
        b=bT010UzPJ8zgzI8CmgeRfONKKUw4O2q1Qpzrv9n0lTVyC7Vc5Wtqmb737aIgDIDPzN
         1PCbd8ELd+e9sCIZ01xlHWIlc2Hj/p+IQiCI6FolTcHToxLNCv9I7nIIUVs3gJfcPGct
         P5Z5AoefMDWHPaZPUsf0bZ39/BqP1Wf3BVyjhKD9vArl1Z0WSRy9sTGFcNLc3QGPNlcu
         cjZCGYD5FuO8LiQ2gWPZDKvqg4UeZeGcZX/gLrf+MYNc0cE5+UN8MK9nqt4vZWvP0g1U
         f7v3WPWr9fnKCBtcLqX/GgG/6IQVjlAUl+YcDmmya9haggXPKzBads1cJXQsmA+9rkd3
         dhbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=My30ydHXkzs1wLCdpBkFu367S0genttJp+zEnxRH31Y=;
        b=oxJd6UefQj9e2qTWIqB0qX+dhdiCe/7vPN+tTCcNw0/HYsEu5rWXoo8/k2ntbZ+fQ6
         BDJaeaIrjyQCZNTnR/TTgD/6lagUi1dluE0+EWbKIuoXCOit5q5u8VJSEWR0LhSognT+
         OnhjhQrrISQTk+6GG8f3L0Bzxdi0KW96HmwRvjGFrG7HVNGVCIWKMkYyjfwbc6xCHro9
         Jy3yyTdeEL28AbJ48s6JwHxcFxIpL04+xLPUcY5WZHQ/JiGPuMwu+F1Tr5L1O/DEajbv
         Osrr/TMLHXQ+BDsK8RTajYn408tb+Ig/ZMB+y3YETnbdEsOYr14imL7+nigvMo1WjiXx
         6PfA==
X-Gm-Message-State: AOAM5313P97JeIOsOv3oFP/ARuVTHYbrtMfPXUK/ukqOgHweMpKeM5j6
        EkNR2tYOv4qT5EGtHUgbwLY=
X-Google-Smtp-Source: ABdhPJwKXI/2PyCQxPDaF7czBi04ODXpyd7hbaQBe6I+SnGsKLsnWgxQGlQ180ptsKAqFnXU04c7WA==
X-Received: by 2002:a63:9259:0:b0:378:9366:2556 with SMTP id s25-20020a639259000000b0037893662556mr20587002pgn.402.1646371780569;
        Thu, 03 Mar 2022 21:29:40 -0800 (PST)
Received: from [100.127.84.93] ([2620:10d:c090:400::5:778f])
        by smtp.gmail.com with ESMTPSA id s137-20020a63778f000000b0037c4e125decsm3449335pgc.40.2022.03.03.21.29.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Mar 2022 21:29:39 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        davem@davemloft.net, kernel-team@fb.com
Subject: Re: [PATCH net-next 0/2] ptp: ocp: update devlink information
Date:   Thu, 03 Mar 2022 21:29:38 -0800
X-Mailer: MailMate (1.13.2r5673)
Message-ID: <9B785F66-5B2C-4B54-ADCA-EE8D8D103A45@gmail.com>
In-Reply-To: <20220303205620.16c72929@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220303233801.242870-1-jonathan.lemon@gmail.com>
 <20220303233801.242870-3-jonathan.lemon@gmail.com>
 <20220303205620.16c72929@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3 Mar 2022, at 20:56, Jakub Kicinski wrote:

> On Thu,  3 Mar 2022 15:37:59 -0800 Jonathan Lemon wrote:
>> Both of these patches update the information displayed via devlink.
>
> You'll need to repost these patches with the threading not being
> broken...

Hmm.  Interesting tool behavior.  Will resend.
—
Jonathan
