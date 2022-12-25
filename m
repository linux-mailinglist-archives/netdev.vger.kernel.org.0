Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A794C655D47
	for <lists+netdev@lfdr.de>; Sun, 25 Dec 2022 14:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiLYNKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 08:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiLYNKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 08:10:02 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252D96300
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 05:10:01 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id 128so8388894vsz.12
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 05:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K1DFvd/qB2iPwiRdxjvsshI/YDS4Nv+p2asGKuDLehw=;
        b=IOjoR6E3xrSRc1h/vzh4ywDX4D8KcpV8NUbWBQolOST5S4/rqsiiIVzegQo6qUUfxG
         ms07edslAAi3te4oxW/82CmRDbNMUyl91XKYDYBaltk8m7NOS3Haa02gBgG8AenkZAWP
         4fQPL9vSDN/Vx6KVA+BDnMT2R96qQ/v30RSU0Dzkd3DE7PasfUGCGBMQcw1/BJtENrDq
         K3G42xXTmqBmlZV7deCrJ2dScEEPkhc+QYYJ14yKhfBRr2oLaVVBQYIQWpUg05V7MudA
         rf176LtiZxxZUa8L593TvIfUOD8ibwS0GS8ro0b1W/e/+4UqMB29D/mRPb0awI8X5NsX
         9qWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K1DFvd/qB2iPwiRdxjvsshI/YDS4Nv+p2asGKuDLehw=;
        b=yNxVJU4EwMaK7hNc3Upnov5Vw4HEdm47r/IYFljRwFPbnXiyVzkUOd9GJIQmW8Bc06
         icqV9BJB+8QKRJ2LW/Cgn75vLrPyZSVlpLqgxAzNaWZBWEIMET/80iZ7+t4YKfidPJTJ
         vjP6eZRWGmGT+FToZv0FsptL0RciOnlUeQd62q0DzW9jbB0+d/VYLAlEZ+YxmQ3BmMxX
         nNTqK94QJTknvUsjDe7xRkwBiYX9LYQPrkk6+vSuzfS3fYS9+ZmqLiW5XhEaAwZegXqW
         mg3Wm7wF8sepp4PmIDnU3tphYTjgiKMNewvThIPKJtC2rx+Gs9ZM/847xcwtFQ95o/t/
         vFaQ==
X-Gm-Message-State: AFqh2kp+y6+WDVRCSwCohzx2GYphWPpZ0NT9Sw8OAvWtfCRRfXvnnrm0
        cI3didLup4AUb/rioyzpyG6xUqCVv9n+Wmd+pvU=
X-Google-Smtp-Source: AMrXdXsOMXQVo855JFYwx7Le/ie5HeFuR9Lj1rO9OfTv1h5n+p3Ia/MSFuW0zfRxBJ2RDtZUe0m0eZLm6LPK16Px+mc=
X-Received: by 2002:a67:cf0b:0:b0:3c7:cfca:ee2c with SMTP id
 y11-20020a67cf0b000000b003c7cfcaee2cmr30741vsl.16.1671973800165; Sun, 25 Dec
 2022 05:10:00 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6122:1688:0:0:0:0 with HTTP; Sun, 25 Dec 2022 05:09:59
 -0800 (PST)
Reply-To: thajxoa@gmail.com
From:   Thaj Xoa <houseinemoustapha@gmail.com>
Date:   Sun, 25 Dec 2022 13:09:59 +0000
Message-ID: <CACb7pkC_av4p7bZc7aEKQiAJQ8bq14iV4o8Vpw_+Q0dbqjWc_Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Good Day Dearest,

 I am Mrs. Thaj Xoa from Vietnam, I Have an important message I want
to tell you please reply back for more details.

Regards
Mrs. Thaj xoa
