Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4704E69B3
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 21:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353243AbiCXUOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 16:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiCXUOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 16:14:33 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1685BFE
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 13:12:59 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id dr20so11409026ejc.6
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 13:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=tJWmq9G1Gr+aa1y6az6AlHp+P9/CCOfAfKqWCIJvSkw=;
        b=aud3afepAu/+tXN4OKG5uhdJ9HqODGoyDwlJceaHmWpsg1UpMadYa07425Fqy9TtlC
         vlJPFPWM8U2XGeoKMZYcDuOg7f8PJ229ob2GmcS3A6H5hizGWvdnsRO4564jh6PVyHxN
         r/n6NgKw6PlWnPFmwzXUT9Y2FeITZeYfdL11nqzwKAX3t/X8uiBy5C6PXnKWnixD8tjw
         kUZ9o4VglCBGki2zcI6aWSW9COKDacM0011LTzKVEJkEUROETo62Yd9VRurmmaw/8qpJ
         n/xcP0Nf7Eiz10ErweDPDx6sT2PwJ9erjpnPxnxjtS5XhnLnFyCf4BUX4A+oRAyWBORW
         HkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=tJWmq9G1Gr+aa1y6az6AlHp+P9/CCOfAfKqWCIJvSkw=;
        b=QBJztuBcF39aBVjeGa8nOsz+yl3SSkbW2oVo3LwpppRPHQzTMCuDKqNwMFMFbCRhRU
         Oa0VztOm591dZNNMfYToeZPlPBxZHnyBjQrdJwP1K5uovMZ+IvTnGi7PnNLxIH5LUBDL
         0u+JSX7GpqDmzE2kngLiJIsm60wkb6BH/2VER9jZq5hG2ZZBVkyxWXSSE6IPTALvsXMJ
         vb8ANZFvTBKViKIjmQrvKWeiI1jreQadr0n/3ipvTH4iE/ki1YvJ25aAjM56l/Wpl542
         nztQnsdEs8tAnPq5qi6KShLkwZzQ2LcajhP6juV4P0qzxP6w0UaLtvmcmPHjkef7/uay
         KkeA==
X-Gm-Message-State: AOAM531slv8t46zpKqwXkDrCAFBYVetYf7NsGSQUcx1PTZBkPBlSt9ZX
        jwFg6CBWJqXh4p8Blio5mTj4429wldoA18xKPmM=
X-Google-Smtp-Source: ABdhPJz/afhhFZpt/2MYzBsv5Bvg3BFdJG6QMA0w/iMBuMdURYgTwwf6Nqr1vQpUKMrrTmL0OHuWL4c+59AJ9ofoDYU=
X-Received: by 2002:a17:906:7307:b0:6da:92e1:9c83 with SMTP id
 di7-20020a170906730700b006da92e19c83mr7760153ejc.459.1648152778428; Thu, 24
 Mar 2022 13:12:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab4:a501:0:0:0:0:0 with HTTP; Thu, 24 Mar 2022 13:12:57
 -0700 (PDT)
Reply-To: pm2956161@gmail.com
From:   philip moore <info.emperormarketing@gmail.com>
Date:   Thu, 24 Mar 2022 13:12:57 -0700
Message-ID: <CACL=WgR83q_vsehR9z=mCFPRJ-J+3oU=BhsJffnBT0_Yu4cqPQ@mail.gmail.com>
Subject: Urgent
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,


Hope you are fine .


Please did you got my previous email to you ?


With Respect
Mr philip moore
