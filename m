Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0734591056
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbiHLLsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237535AbiHLLsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:48:15 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFCDAFAE9
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 04:48:14 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id h28so727481pfq.11
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 04:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=447DttLGWlnXVhl3+i4qWwJxEj6tFprhGwRHCuyrWEY=;
        b=KBmG7tzSoY4YZcO/9NZeQHLvT0HWiaBrUQqGuVHl9bMBthu/tkTo2YpJwAXqjiCeDy
         gGEyl1GTu+Inz3FCDfcLkpDBOug9NSQw5nUfV1IeSqrMKtzxBimOQNxacQJyO5NlyTCf
         YzKnRYSEMHM3+YL50wlNA/ibzG4LGCygChaTFP8VYYnnICF1z7Q+mQpW2Hg1H6XBBCo7
         0SggrLjimrObKh9rw2g/P5T/cJUYyluSYMYI7YkFRz+QS0S9T1494ORXojVlCifDeOit
         ErxbMfmjjzX9Wf096wwZs9Rss0+dPrANmx8J7/W04kmuiGl+nH2KDq3f8be25lulVhU5
         i8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=447DttLGWlnXVhl3+i4qWwJxEj6tFprhGwRHCuyrWEY=;
        b=l0EtcH1dDv0iDxS3+nyI4iE1SLI9Pn34JdqW1Nn4MVJ825bEnW2ZuPHFfzpm7Dc7PO
         JK1lPOqOACZ2LfbfbyRfBIu43CAY3LsVf6B+hbAOogOJid5gRhvxgmAo3z+mY2mxPSPy
         7RF6iHZ5agbhNpHFu5Hm02UtgVqqE/dNVw8JbRe4gvEWNFznRNGXZRFMHTINyO4C0v9S
         7P1CJTWoYZeZCijM413xNK0zlKISao5wy8MwDEfqYxcPWX/5B1pVZSDBg6JziyimfE6G
         VLT7wRQkHy52xrETpT1KCksuTI5HFzy6SJjeOIw6NlnkyvBi3lm3C6RfKgVirrvb8wvE
         sUgw==
X-Gm-Message-State: ACgBeo0VHZ9GcuXAlH7Y5/arRAzevhybnNQI75390z92JsIuAAOlUqtF
        +whe8oAUgXvEjcMXCbhsR3PQMpB63loQDxMiEmM=
X-Google-Smtp-Source: AA6agR5EX083RQMWxgFpLU6t3ElYjjf4hs5exL61hBqtIecz9vUTP5KOzU5gWCUZ98kwG7rDBEdDdrzQACm1ex7Xdkc=
X-Received: by 2002:aa7:982f:0:b0:52d:9787:c5c5 with SMTP id
 q15-20020aa7982f000000b0052d9787c5c5mr3619576pfl.24.1660304894467; Fri, 12
 Aug 2022 04:48:14 -0700 (PDT)
MIME-Version: 1.0
Sender: bazarkowanigeria@gmail.com
Received: by 2002:a17:90a:9f91:0:0:0:0 with HTTP; Fri, 12 Aug 2022 04:48:14
 -0700 (PDT)
From:   "Mrs. Margaret Christopher" <mrsmargaretchristopher01@gmail.com>
Date:   Fri, 12 Aug 2022 04:48:14 -0700
X-Google-Sender-Auth: nF1Flb71947AnpH-L0SoSE1o54c
Message-ID: <CAPgaJa2jLS9fUmxdA56aRgXUzd2T+ir5623sOS9oHx1PZ8=iaA@mail.gmail.com>
Subject: Humanitarian Project For Less Privileged.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear

  Am a dying woman here in the hospital, i was diagnose as a
Coronavirus patient over 2 months ago. I am A business woman who is
dealing with Gold Exportation, I Am 59 year old from USA California i
have a charitable and unfufilling  project that am about to handover
to you, if you are interested to know more about this project please reply me.

 Hope to hear from you

Best Regard

Mrs. Margaret
