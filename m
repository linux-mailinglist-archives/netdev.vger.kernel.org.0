Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD5A58617D
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 22:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237875AbiGaU4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 16:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiGaU4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 16:56:51 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D63295B5
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 13:56:50 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id k8so9714624wrd.5
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 13:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=YKokgaNBFzwRcXPgIXJHrC3hmjS4PtmpfoKAQSaSgfU=;
        b=nbab5+fvIC1Q1+aLMgvB/lVtauh+hTZM2rF52DrxVZ/UgAlzyx9Ju//4+jiO53Wsbs
         W9t1HoOjBLe419cJL8RbAaMX4sbhebQiqdCUDbuwjeBnKkwEf5qvpGzYTQIqDYTf4dnL
         bGsvorycOLo64kP1w0b5ammMHs4h8U0KNljsgn4l1CEZSqMwHWZ2d9ZeIzkHDOMta2fF
         v5ypzTORrKJDm6COcKoJMS/uQlJhL+ERppxFWPvc3k2Bf4+kgDksfnZLtpHFsplvzS30
         O5W1EaI+TMWQE74j2Fsb2K1pEW6/Ea2r3SLZ1ooEW08BllKkIfpt7/uC+1CW7a9DhTNy
         5mOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=YKokgaNBFzwRcXPgIXJHrC3hmjS4PtmpfoKAQSaSgfU=;
        b=I2LSTUKELCDnbhOB7oKNAPA8kbwDjMCkD4I7GyllgFjmaqyyc81+RDFuEEDVqK1VzY
         x6hhl+L8EioeL6qJnytEzchAnNxjDircb86mWtoeKhBuylGbl2Hhba1oM5oik3eF89DQ
         zM92y0QpSxhdhONjtHAIfqHI3e1h4YxaouSWHqUGZkB2xf5xohd2J2ruLJdZIuFtyJBh
         dbJ5aOC5iEAiBRosaaXFW6VXYHhOl/EOqSORM7IUmjMPx6b6d6/RTUUuFiZMQTgMrS1H
         a1u4CYtkr1bCNbM478MZMQ+wCqQj1m+Hfe9SU+IQSNm6N5a9LEOoadg976EAq58OQi3G
         UwXw==
X-Gm-Message-State: ACgBeo2g7n6L9QcB1ut/UMHtrgVqos/UDYEyR0YWrUj2BcYJRp9Ptsoh
        Nh0UQI0rfbnhLdyfohffJlL/bEe/BJSKUiKOUys=
X-Google-Smtp-Source: AA6agR7QLQW2tRfgjS5R87XfzTfEaqy4/VNiJ3ZRXEASyhyS76Bj07fBDSReP5vrmwktvf/vx9IuyuajNLZMgdfQWXA=
X-Received: by 2002:adf:f944:0:b0:21e:98dc:ad47 with SMTP id
 q4-20020adff944000000b0021e98dcad47mr8507382wrr.317.1659301008669; Sun, 31
 Jul 2022 13:56:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:fb47:0:0:0:0:0 with HTTP; Sun, 31 Jul 2022 13:56:47
 -0700 (PDT)
Reply-To: xu.cn99@gmail.com
From:   =?UTF-8?B?5b6Q5YWJ5ZWf?= <raymondwihl@gmail.com>
Date:   Sun, 31 Jul 2022 21:56:47 +0100
Message-ID: <CAOyhma2-h3Srx3rCMJyKUypFjxco7-WgB+FVFn+nHGTWF_Hcbw@mail.gmail.com>
Subject: Mutual Benefits
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
Hi, am Xu from China, We are still  funding any pending project /
business and if you are still interested in us, funding your project
then let us know to enable us to give you the terms and conditions of
funding your project for 2% interest rate yearly with a 2 year grace
period through 15 years loan period.
