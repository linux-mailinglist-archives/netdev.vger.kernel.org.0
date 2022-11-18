Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11AFF62FAE2
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 17:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242386AbiKRQzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 11:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242371AbiKRQzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 11:55:00 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C60774CDB
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 08:55:00 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id x21so7458578ljg.10
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 08:55:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DLuxvrtTwLpjQCdZkBOlAPtT4PuOt7o3XUb4SWGRYeY=;
        b=YbB0A+CRUD6S2MD68gsYt8H9kf2O/MCqLKzMGFmT0nqheeGKbQ+Qzdo8K08msmUr11
         6CWuKCdqLM/3h/OqS9w+mEXbK9Zkbq4rgM2XAutuWvXGZ6IKR16FRaMWHq2ch4xkP9PQ
         Hr1d27XN8TzbnQ5u0MPPo+MU+l3SR3J5V5o/zz8w4+BCwaZioiR4mF65EBVaSJVfcBe+
         asRGlU9om/KULxblcKmPdeSlR6pHSii/qau7pfMcOqrBtYWxRhsd6DnnokBDuv3AZvYz
         ZmC67/jbHQH123XtggLelRQFHwpt9NrpFDblWOeDhkV5GUkr1zASfYb2GgbL3WZWgtUZ
         l11w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DLuxvrtTwLpjQCdZkBOlAPtT4PuOt7o3XUb4SWGRYeY=;
        b=URF+MUs/riY0jUCLY3bgmXHMHL26OtOLsXNgdIZb3c0DKgflEZE9QvFu2EY6XnwZng
         ciWINjnEjvDTMbaRcDV+4VCOkCj3Z61Dubiw207svlMHhD8bBTIQ4a5du/lZ3A1BEy8e
         M6RqtJrplwq34VFRhDTHDaXR+qSBzDD1Igqkhdig4HnC8EDfZuw1hCz2paxIiWk3bAp2
         9s1vbbCC7ATvhCKggDa+LRnXUpK0N/m+PhbEr+1HeRy7PiRKrzV082a3KGafP33N9tnK
         OjPnsVTZIZtl9xQpkYHmjqcIFIXca1riRR/1f+eUMtJM3+db3cX9TZ9cu9RzRnOjU/cu
         IhmA==
X-Gm-Message-State: ANoB5plh4bkkQ57ZOffR+vuzb/c6T4kkrDgDHgOnDSqGuWtLkiGlbcOM
        z2vwupMzncJVa9Ficd3bGoR2MdgLC/xUhFAwq3Q=
X-Google-Smtp-Source: AA0mqf50W0i+xc4j1SC6RfI+4BNLEmlZx4mHGckqR2mx77CT7RnclO8i+RtEwS0ZSyYdpG1F0mS/URjAbJTIEJSyTcE=
X-Received: by 2002:a2e:a552:0:b0:278:eef5:8d13 with SMTP id
 e18-20020a2ea552000000b00278eef58d13mr2782995ljn.56.1668790498359; Fri, 18
 Nov 2022 08:54:58 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6520:4d0e:b0:22a:5eec:87ab with HTTP; Fri, 18 Nov 2022
 08:54:57 -0800 (PST)
Reply-To: thajxoa@gmail.com
From:   Thaj Xoa <illiasouamadou27@gmail.com>
Date:   Fri, 18 Nov 2022 16:54:57 +0000
Message-ID: <CAD1uFOckBb6ug0NR48vvZXjMpaS4d9xn1SdtX+MEd0yC+kbg4Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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
Dear Friend,

I have an important message for you.

Sincerely,

Mr thaj xoa
Deputy Financial State Securities Commission (SSC)
Hanoi-Vietnam
