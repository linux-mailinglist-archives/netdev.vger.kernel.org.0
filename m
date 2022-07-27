Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9FA1582626
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiG0MK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiG0MK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:10:56 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F3A275FB
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:10:52 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id d187so16327549vsd.10
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=t+pQa5dRvfaXNuusnmsa3SIVfyR2GaEPDHqht+u9DDE=;
        b=EY0waVmGLUine/s8tHPgn0tmi4Bk+in0wnLge/5sSUsqNY6CGR8QmnhW3ZUpcwYCmR
         evCf0CWCUgDQOzklDWK7muJ3civznvYwrNikajSautwWWRzQ/XrPYLyoQhxJpPWXzOMX
         cg6Tc6AT9PLIHXixiwApvLE8hTiamEXFr4t2SNy+bpnEvvhaIzIlY4o4xgU9IKsqsRfj
         YkMH2sCl0anh6FZjJX1GrEf+1HFAKAIzW3p1olJPn56lwr29IcDDWPQ6SPkkzSZbAjgj
         BbcpusOCXSp8LEY8APDPqPk0ZmjT62ardhuk/hu92MHm49Kf1dp7s6qjTlYA8k3xsl4i
         dVlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=t+pQa5dRvfaXNuusnmsa3SIVfyR2GaEPDHqht+u9DDE=;
        b=BCiT1bXrrh0bcXHmmkPxEC091u4GiEaq/uz04eb2JnjjH9Mo6DCkO2lnrD1NzkzSkW
         USKJovD2fS3LP93aNV0cdU7Sg+l3uVn2OoZQ/KwLO6kVRGJovU7yi7Rarx6x/eEjGkO6
         iKIJRKwlPlEK8fJNh4iZuN3m9IT+FOe9kmRYF8FAcNjGqB2xGBZ8VS1XfN1cBW6A70y9
         5FeY61AD4GT9v8a1lSZ6FXWzShUb8XNCboRzlFT3JwHwtQh0Horl/tuAfrfn2qhz2MPC
         IcRCryaqlyj5gt4SbVwr+HWBAby4ImPKr/rmINoCrairo2KZP5c7EWBHvst/HkIh4GnQ
         fO4w==
X-Gm-Message-State: AJIora9ix3t6YCDhhZwJTb+uRZU31cRwk1XxjE2IBtfO7Xqjlt1rONYy
        T3t05OW4zml+pGJ5nN35pWBw10kZF+TK/9AuDZ4=
X-Google-Smtp-Source: AGRyM1sZ8vsGV3lo3RC3emo00Mp7BzKX9wKrYfMQd34cZ1ceZVJv/PBzZMk2D4dVUmoINVokLcydzxc0fwOqnchB/YY=
X-Received: by 2002:a67:f649:0:b0:358:5ffc:7b3b with SMTP id
 u9-20020a67f649000000b003585ffc7b3bmr4770886vso.67.1658923851138; Wed, 27 Jul
 2022 05:10:51 -0700 (PDT)
MIME-Version: 1.0
Sender: hadjara.sawadou@gmail.com
Received: by 2002:a59:c74c:0:b0:2d7:23d2:7328 with HTTP; Wed, 27 Jul 2022
 05:10:50 -0700 (PDT)
From:   Mimi Hassan <mimihassan971@gmail.com>
Date:   Wed, 27 Jul 2022 13:10:50 +0100
X-Google-Sender-Auth: aru1spH_Vggc9EL-XZnivgP23YY
Message-ID: <CAKFm-kEa-aGta+mLLNg_xt7PHta03q12L3WSKe3rmoCCjmF-Uw@mail.gmail.com>
Subject: I WILL TELL YOU HOW TO GO ABOUT IT.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

i am Mrs Mimi Hassan Abdul Muhammad and i was diagnosed with cancer
about 2 years
ago,before i go for a surgery  i  have to do this by helping the
Less-privileged,so If you are interested to use the sum of
US17.3Million)to help them kindly get back to me for more information.
Warm Regards,
Mrs Mimi Hassan Abdul Muhammad
