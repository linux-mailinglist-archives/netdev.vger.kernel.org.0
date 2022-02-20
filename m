Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE474BCF97
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 16:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240987AbiBTPrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 10:47:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244183AbiBTPrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 10:47:36 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7761F4615E
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 07:47:14 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id s24so18093673edr.5
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 07:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=ymEpgIXl54yuSlZg88NLeYK1RJf0YDtYgXWD/9J1GQ0=;
        b=BH1U/LOKMPUv+nd6x4x34GdR6o4d4iBacQ787GaNHnf6vNx/SP+64cxyBXH9UZcLj/
         Hje1N9cY/gMnwyJVjFdTZKD6Z8XPkRQxuErf/XPjej8bGUqauW4vd5YL5ZaKR//G43GC
         amu7QvUO9oS7sfFuAIxGiBrGIveI3z5B96dFlnNewcFFC3y1fPRQHFf28c2F2BwZuI5r
         gR+X/xluV/0BPyD+je0HlzE7RpWLUjUzOEYcyfS5+jzL2yfa3Ul33pOvGsaLggCW6s6h
         oScm2xbpYX4BF+I22cB8rq10aawat8OY9DPpG+FnMEH69i7TqUD3TBcL8KVxKHC0WHXg
         vULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=ymEpgIXl54yuSlZg88NLeYK1RJf0YDtYgXWD/9J1GQ0=;
        b=VUTI7FGclyF7W/b7UzMNW1flo6QpncGTnmrpRJwSJlBmjMNh4X2LON+UZlEaPQ5kFe
         at3if5LHw2M9AV8H+Y7AIMc7M4aRizf3NZh2m2+3+85xVuDT0MsZYuzm/9YLbAP/Tjcl
         bD1FSBylcmRpIUcBBmSXV7C7KwwDNcJi8jhI5Ym2gqztS6o5+4M1BOpUJNopFU1FPoV+
         YCh/TmgGH7pGcF/GfjXS6f60hLoKtmE+826CwWet/ISnWEsp9ptO0kQ+V4QNcnAnYsuo
         Nqs4FUbGrVsgyaVauw0rhHuy6DpFR2/snOfKOYI1nTxbNKU6i+2dIoEZKNnwBZGti3cU
         W50A==
X-Gm-Message-State: AOAM530ydKCzHsnpALnaWxBMuMyS8lfBs15+6wzv+u2KlwmJoeEpAu2j
        +mS+bcCBZwDnGbIBoNuNSnnxKL0vVTxdrDw5fkI=
X-Google-Smtp-Source: ABdhPJw8ZJhY/kVcFchs7dUtktlFgvpEkXNrPFby/a4LOApXaZl8XaXKh2SidvFcd6ZIdiO+OYZ8y31dj8VcrvqrLws=
X-Received: by 2002:a05:6402:4245:b0:410:ee7d:8f0b with SMTP id
 g5-20020a056402424500b00410ee7d8f0bmr17414544edb.295.1645372032952; Sun, 20
 Feb 2022 07:47:12 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a54:38c1:0:0:0:0:0 with HTTP; Sun, 20 Feb 2022 07:47:12
 -0800 (PST)
Reply-To: fatibaro01@yahoo.com
From:   Fatimah Baro <imanosose@gmail.com>
Date:   Sun, 20 Feb 2022 16:47:12 +0100
Message-ID: <CAFEyOE7-qdYqVbyiqaWGnoopOjGnDhopvJU26gRgorooitZWZA@mail.gmail.com>
Subject: Business invitation
To:     imanosose <imanosose@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.8 required=5.0 tests=ADVANCE_FEE_3_NEW,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings from Burkina Faso,
Please pardon me if my request offend your person; I need you to stand
as my foreign partner for investment in your country. Please reply
immediately if you are interested, so that I can give you more
information.
Fatimah Baro
