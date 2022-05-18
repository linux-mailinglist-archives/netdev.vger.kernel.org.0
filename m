Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49BB152B6C4
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbiERJdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234344AbiERJdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:33:45 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F56DAFB23
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 02:33:36 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id s28so1709301wrb.7
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 02:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=giem2v+IxcxTWhEwccgk3aA5guR+BTmFBP3dLJ+TN9veiWxWw9pMz7j19LVUCAjV5Z
         e7/OjhXMnIRy8GsVERcaBuqGEJqQpQMDeg8p4gnIhWEbCQEZbYdLD4qE1O4GhRmv9suX
         rlhk6SkzhiYb5t3O+K2yOMiYfG8/puj/wNY5e+NiL6OpazhR/Q2DdZzmS59v3ih6h8dw
         RxAEpTv93gTy6qUV1Nj3alGAqRniK6Ue92qaBLwk1iB1qcgIKyb5qRZSlf0mW3X8Owzd
         JQxj37GBo8RX9I55kxEnS3UhesXqMAWJaGPp9LQebXSS51YxbtxWvcZzvOQC2OjXfqDt
         vP4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=kXiq2W6tlA0Y7GKmyurdwaKSIcR1ERCVQxRLKLVNxEVQ97EDu5EemJ02//boWZ3I1a
         QKi1XUoZlZrkepjV3yDfrLx7g0GBgzVlRQIarjhvVOCahXzN+jHExePerXfiaJZKnaV6
         BV0Y0YnuFcwvTUPGFZQbmjyXhyvaHIBIu+p27OXFiHIE1t5yafwoc7bsm3z3aO8P16xq
         pKsr4GlRNMUdCymjRmbjComCmwqQ5W/kORsDseoQ1aVj/3/mPrW3SQo6nERQ+BIutuAy
         YtZCzkzE/Zum0T/mCWTCUEZG0Z4UBkRBHrKjJvuYperCXMPQ9aeyKPueBzVl1Trw83xV
         tXQA==
X-Gm-Message-State: AOAM533Aq3aq7RQmK0qNadTUJHUx820AC8cmxTw34d+kz2I72MF51rb/
        gH052qleAMnQoJprVuDd8YZKZpjSZZfe0d7adeU=
X-Google-Smtp-Source: ABdhPJymLkMob4U5/W1xMS8MYEv6vFtG9EOWJLAaf5BNA1K/TUI3+AFVOrFD9nietjV+iKcQNSprNiVrrVPZMigJOA8=
X-Received: by 2002:adf:f8ce:0:b0:20e:5ecf:d1ca with SMTP id
 f14-20020adff8ce000000b0020e5ecfd1camr2805137wrq.143.1652866415232; Wed, 18
 May 2022 02:33:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f750:0:0:0:0:0 with HTTP; Wed, 18 May 2022 02:33:34
 -0700 (PDT)
Reply-To: davidnelson7702626@gmail.com
From:   brigitte Patayoti <brigittepatayoti0@gmail.com>
Date:   Wed, 18 May 2022 10:33:34 +0100
Message-ID: <CADhLwcRhLe4chjvWTbzifH0rY2YQdAivPubfJ0TcDE31Wd4NsQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:436 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [brigittepatayoti0[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [davidnelson7702626[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [brigittepatayoti0[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.4 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello friend, I want to send money to you to enable me invest in your
country get back to me if you are interested.
