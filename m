Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC21A3BE704
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 13:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhGGL0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 07:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbhGGL0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 07:26:09 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B4BC061760
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 04:23:29 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id x24so1695250qts.11
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 04:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=oprwMzod/6MUSDVVxVpcrq6F+k0HVSo1xTGIJxIoykE=;
        b=DqW2cyZZIwZJ4L09491xinpuYZsp77ByyyyDW9DcccwdjOGPS2lSp4XwQTQw+10Biz
         AmxuEZwOgXapFupyUCTp2Zcr6tKGoYXYJHaiTYdw2TDxiIPERZ5BVvP19Kt++JVxvQiF
         NzFcee/8Vj4utri6qM1gZ03rKXDBski973YNremOlItHKXtvFEg6jHBOt0OqF34rN4YX
         HHfnVYmtTSh5Mp6/zh/85oOZjpuPbrktYEuf6gLfG08/dBplI2ePq4mb+ZoKXrYHK75U
         Ghb6TiFlB9yfud0zbPzBVLtA93WnICYt+Hdhrr5u7UpjYsKgl/RT4tiJRQdVkpAzePaK
         fEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=oprwMzod/6MUSDVVxVpcrq6F+k0HVSo1xTGIJxIoykE=;
        b=AQcr7pjbvx4WDKNxIwGxlTCv6dPOqHvnR9tOPZCs9tP7AT6XQ+YlZ3kf993qq5uoxD
         BIPrcH3JZ8gE5GDVTxcDAFd+d9/oMHKc7GxZjzsOpEUJiDsqpwbKNDfgO7MtiXn2qLE0
         +QBuS/CudtVJoykCp9i1iYnswtGDIZtyO/yLs1t6cexBBYqJKdbHYrrdWeltrJrzA1Fr
         QdUpEcsdjig1VQf2WeUL10uTKbcDQCDyrUbz0WLU1JMUUwU0Vni2JSDwJy1yzHgAJ07u
         p46eu3BM0saVwiVJetR+zqIKg3D476JYIu78HG1SYR68QLb0LPIwoZ5Qpr2m6RaGzS+1
         sfUg==
X-Gm-Message-State: AOAM5333hirmFR8P00b1S9HFIGY7zgXazWlnnxBFj1xR+wJDRFaEJmCT
        /DIw4RbIREvOxdv/QZYyYw+XBA==
X-Google-Smtp-Source: ABdhPJwGP0B7Jf4MSIvu3GKIZZEa50D7QRKZQ/AYy072z0n8z5dus4W4ssxepN+HHM/4Mm3C6f8myA==
X-Received: by 2002:ac8:775c:: with SMTP id g28mr9059154qtu.193.1625657008528;
        Wed, 07 Jul 2021 04:23:28 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id 3sm2353797qtz.5.2021.07.07.04.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 04:23:28 -0700 (PDT)
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, lartc@vger.kernel.org
Cc:     lwn@lwn.net
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Netdevconf 0x15 update
Message-ID: <7892184b-c981-d5d1-0664-e64844b39686@mojatatu.com>
Date:   Wed, 7 Jul 2021 07:23:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Folks,
Reminder that the virtual conference starts today with a keynote
at 3PM UTC.

A lot of great content, see:
https://netdevconf.info/0x15/accepted-sessions.html
Registration is reel cheep at USD $50 (50% for students).

The conference will be spread over the next 2+ weeks
(Upto and including July 23). See schedule (and registration)
here:
https://netdevconf.info/0x15/virtual.html
We never close registration - and this time to
accommodate for the different timezones we are going
to keep all the session recordings on site. So if you
missed a session because of a conflict or because it was
running when it is late in your location, as long as you
are registered,  you can login and replay the session.
As usual we will make all session videos, slides and papers
public after the conference.

cheers,
jamal
