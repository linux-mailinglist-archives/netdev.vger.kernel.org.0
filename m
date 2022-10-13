Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B92F5FD61A
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 10:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiJMIWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 04:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJMIWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 04:22:19 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ED514BB7B
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 01:22:18 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id az22-20020a05600c601600b003c6b72797fdso880945wmb.5
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 01:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qz5m4uYWuY//lrHhuUGWc6RIXJ/h1FLIt3XLZzcRIK4=;
        b=DT7j51K4zOXeBFmvxHrd+PHucGQaXzzGBJxtSHz7I0p9mQyDjYriqUW7g9WJJ9XimU
         Bqfq6DegrNhc/jKvVz2Q0a3dtfcFWReHpjxAolliVti5B4f0opF5NPD2jYqQsh7w3Q0d
         AotaymFvhkkXT+RHy7P00DptRNJPXvHt80dqnjsrKYDHMhX4UpdWuZGJt/jwdir/pHC5
         47AQCdi+BQ7tQnQIAfEQzAP/P8pWdf6q08uSK1+6IcZu0bpX7XBwzNRBxjs9X2BxxFUn
         TZSXDY/IaTzj7iYKK9C0c8fQRcVio1iLb8JojZSHiwgZ4LtQIGU6MWuLqDhU9j6hoyYA
         bw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qz5m4uYWuY//lrHhuUGWc6RIXJ/h1FLIt3XLZzcRIK4=;
        b=mAqZHTcc7PBs6/zksiWDbJx7TzUGnOsC9TjC5ejljBzP0+PmzHxt2dLtC7wXAuqXcL
         MJvDt1jnno/c2APdk/aohr+gwy57fTaOxCsmfD7T2VkvmiQTm4VBHs+5k57BufQOoJaE
         EaIMzi/CekSj5RCppvW/bGJJTOGHzD4k3qjb0VRlaS38Vy/e1KnU8x13acTz/QYn8I8y
         eJKoH2d5K3T9gRYyfWMbIq988Yz3jjd5zMSXpueyeoQwmRffA+h67pRtuhszotSh93vD
         OJkRfHiUWXI5BoocZRfaM6pbqCkSrAVjotfVZnePMXzt0fpJBgzrxe9Lx+4vqePnFoPN
         Kuyg==
X-Gm-Message-State: ACrzQf2RGdauq0xnA0dXI+flf/wONGsBS3sPQ2sj3zlO0igNQEZufmuv
        AfJK8ofTqONdjtbvIYtePNVxisD0L92hcVIUJqU=
X-Google-Smtp-Source: AMsMyM5QVPump/ef115V4pkuhiScrXrKSXRZLjYPnoQwprXzfus0RUI5ciwv91nng6IDh5Sw5YffeSYZm+2O3gqCKIk=
X-Received: by 2002:a05:600c:1c22:b0:3b4:b2bc:15e4 with SMTP id
 j34-20020a05600c1c2200b003b4b2bc15e4mr5678826wms.69.1665649336903; Thu, 13
 Oct 2022 01:22:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:156f:0:0:0:0 with HTTP; Thu, 13 Oct 2022 01:22:16
 -0700 (PDT)
Reply-To: seybasaniel@gmail.com
From:   Seyba Daniel <mw979580@gmail.com>
Date:   Thu, 13 Oct 2022 10:22:16 +0200
Message-ID: <CAJZvF09xU5HxVPe5mS1QMcNewRyq4v3aZ0EPTJJK_WUtOWrkww@mail.gmail.com>
Subject: HELLO,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,

I am so sorry contacting you in this means especially when we have never
met before. I urgently seek your service to represent me in investing in
your region / country and you will be rewarded for your service without
affecting your present job with very little time invested in it.

My interest is in buying real estate, private schools or companies with
potentials for rapid growth in long terms.

So please confirm interest by responding back.

My dearest regards

Seyba Daniel
