Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C02563959D
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 12:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiKZLH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 06:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKZLH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 06:07:58 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18B910B6B
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 03:07:56 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-12c8312131fso7874581fac.4
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 03:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t7wrZvAkKeCjMLmhReJxhxYIm3R/2GcWH+genrPm1HQ=;
        b=JJ5IJZwW9HpECy3HtL1LYQ4b2IKV1nA6R9aIXw4BacTunEeolIL83NEJZ29RG1yELs
         C++iAX7EP0/nNyvGWyOnzNgV6MPLe3ifgqRWl0aAnHFBE57kj3TEYkWM+MKfTsykXo4h
         jiBwEV6l4rqBDCqJdMHjWRiYHAHdycDRiMKi271XfkPBMZLtmkqGRKcrKRpx/8DvWobs
         Qo20xbM1NDDC5xcyG08hyj+YsZdr7nDHHVPyDpLywFWjkekkiIXxjfslWcd6UznnWb4u
         ghK9k5GPNSUl0aEN+RHyzDf2oWYZequW7JtIdMWzAvvxUXmWb06Kh6AuzE6MTIEm+DdP
         wOrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t7wrZvAkKeCjMLmhReJxhxYIm3R/2GcWH+genrPm1HQ=;
        b=JqjGHjRaqaR07cbUFzhkDTyT9c0s0VGgRhX2Qkxx9clfuVdFpLHWWY4eflkuRwSDCd
         m9OcgdypHs2Z0koSpGtke6keAabUlLtdr1dWDn/64Jr6GTphQ/iaScWVgdT4hrcXTgTh
         StbRd/wPf9hOx6BczoRCXrkX8eRdqTs6sfHm/zK3IhkKXZckCVGLIRmEkXwhyjOJD2so
         UNMDX+d8F6zjxmiJb7VH5+GqijEvyBbrw2jQKiLwz9ULBvy0XRTvouObcgxIpH4a5sEI
         I37WMcyYYqnXEyQoNg3JJJaAkpy65sCStPdzifBJvfwXcst/GlRZpdO7JANOJTBCsjBI
         CaHw==
X-Gm-Message-State: ANoB5pmvHR9giIyGKeFdGyhDKPHCCjdU1YVyVdPZz9lVIn27D1f3XKsO
        Iso+k0a1GyjnyjWyw3QRAVJYlPtMr7Ge/OJVwmI=
X-Google-Smtp-Source: AA0mqf6Y63WJ9AANoy6dxYgqn+wOHkDIrIQgMDLYKlEcjY7dzoH0AubPDQFGL/VFNvW7Pkx4ERhS0IMF3Dnxx7BiiuU=
X-Received: by 2002:a05:6870:7d84:b0:143:4e3e:b8e7 with SMTP id
 oq4-20020a0568707d8400b001434e3eb8e7mr7336636oab.162.1669460876203; Sat, 26
 Nov 2022 03:07:56 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6358:9485:b0:dc:ea6c:b582 with HTTP; Sat, 26 Nov 2022
 03:07:55 -0800 (PST)
Reply-To: ninacoulibaly03@myself.com
From:   Nina Coulibaly <regionalmanager.nina@gmail.com>
Date:   Sat, 26 Nov 2022 11:07:55 +0000
Message-ID: <CAHTAA8qLr3R_oBqq0dk3kYuQyP72ePr1v_zd7hqXF_Fg3rtUmQ@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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
Dear,

Please grant me permission to share a very crucial discussion with
you.I am looking forward to hearing from you at your earliest
convenience.

Mrs. Nina Coulibaly
