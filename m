Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9F95A0451
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiHXW4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiHXW4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:56:48 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF676A4BB
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 15:56:48 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id g189so2236426pgc.0
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 15:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=rWrcfqthh0R6JOPNpOaNK3PZSz6XORQ8YeJPmURtEvs=;
        b=XpAqCh4pU6/elE/eou8fSD3rAxp8sqn4uOXJlpPelliOGYztMr6nSYHq/7DqLw23/v
         QzpFZF/r+EsqscyjaGgr7yqqxOwcNmNtVY7M/LfebF+jPhmShe4eIwFKfYr+9IKy8eKo
         m8yPSY4hP6QV71DT62eRJld/+RdVVvBYIkXGHGmVl3tPVowxpnTH96/gYMM72dzd+eRE
         YkHpDNvY8j0ROhsg2lnePRkZi+6gBEEws8/k3yLYQOkeGiMiMXessLeCb26Lmrb0nGWH
         2b7dr7q4ROa3IxaibCHbykhC5Y7YrsO0eTVToRGezNMWhask/vTF3v/ZFOKFJXPnLEGZ
         U6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=rWrcfqthh0R6JOPNpOaNK3PZSz6XORQ8YeJPmURtEvs=;
        b=doknC/UHtQwGNmSifb7uIBXvbctNDDdFIUv4q9NnemVliEcVR/Q4LByoQkTxzVDc0U
         DG9GXJNgx3r3xxHK6TzWe7EL7Wygz7ME6T6O2zhKwlMHo9Anpb+6IEJCOH6vVLmNT771
         D6Aey7ApdPDd0oZPXQArwpwu+m+fYiBt217VwL6B/IBumclMEzPDY7fTpW85mqCnCClx
         yHD0IS6V/zrKdTTNlTNPkx7MaXq3bGkLueY1ORlRBR5nDdvEQK6+JHByszbomriFOuwv
         +zP9AFJr4xQqT3CI+ODwGucJxG+nK+Yiu0uLaTwE+IN5sWaS2zZyuOMddnFuVSDUSdUE
         24hw==
X-Gm-Message-State: ACgBeo0E8Asbv+ycAvpgQQID+JfuHzfh6pSsuZiJBrRjbJYnzQw/tM2T
        G2OVfBwhjIi4dhvTwZuoq0+RllQQ8jomQ204u8Q=
X-Google-Smtp-Source: AA6agR6KzBSiy0Ugh39vQQ9Tk5YUoqHVT7e6yE/W8SKeGrRSGPxJ+p2x+BCfBhx1oxXuJUbmRrBv/lJj1GXGUw09v6E=
X-Received: by 2002:a63:5b65:0:b0:429:7548:a7bc with SMTP id
 l37-20020a635b65000000b004297548a7bcmr871374pgm.617.1661381807553; Wed, 24
 Aug 2022 15:56:47 -0700 (PDT)
MIME-Version: 1.0
Sender: nwaonugoodnessozioma@gmail.com
Received: by 2002:a05:6a10:b755:b0:2d6:883c:a269 with HTTP; Wed, 24 Aug 2022
 15:56:47 -0700 (PDT)
From:   "Mrs. Margaret Christopher" <mrsmargaretchristopher01@gmail.com>
Date:   Wed, 24 Aug 2022 15:56:47 -0700
X-Google-Sender-Auth: PyY6HtlCT70AF4MSaoFLSxL1qDw
Message-ID: <CABNfLOxJPGkJ6+agvjRm2SKej=h7GnoythOmic29OSvkKMj2ng@mail.gmail.com>
Subject: Humanitarian Project For Less Privileged.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear

  Am a dying woman here in the hospital, i was diagnose as a
Coronavirus patient over 2 months ago. I am A business woman who is
dealing with Gold Exportation, I Am 59 year old from USA California i
have a charitable and unfufilling  project that am about to handover
to you, if you are interested to know more about this project please reply me.

 Hope to hear from you

Best Regard

Christopher
