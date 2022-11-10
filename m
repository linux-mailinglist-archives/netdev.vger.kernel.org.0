Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBF7623F13
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiKJJv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiKJJvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:51:54 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D10818383
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 01:51:53 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v17so2225235edc.8
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 01:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpuYn3Uptban4FllPlHUZK0/ZbVvDjvpk4g4PTmoaWA=;
        b=q3Oa/dt8v2i/6aNRGCIMIej3YAeWNN4tBSQptbY8QH0F1PDv7appsO3xrT7iXWOGl7
         sQgxL5Fg/YgzNS/Q3rd5R/WVsNd77vp27u3pVolEVHfyaTSKsilxs1equ+YY9h0PjHR0
         y24A3i3qUbdQWvxBAZ8fUy6E0b5CqbgjWe6nFCq5DqTef3VMFVY7IQnfMX3q8mQZvzzw
         6AD4/fbPPx3oUcWWpQmGK5ZrAkUzD8Khy5SdMPYmlAJypvWwctOLI7w/z+b8KNzGYVOE
         k/b9oJyqMcpJUaiWFl7EMfgci9T9EqcnRaacESwmNMwmnwuqvUQBMGh25tsM4TNA5t3T
         rIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jpuYn3Uptban4FllPlHUZK0/ZbVvDjvpk4g4PTmoaWA=;
        b=29ZsvVyBrbkgUC8ENmCMZmOhRahDU5xm0QB6UmpeqSy8URymeAybsC297YQMccVr9e
         4GTSew4H3lXrG/+7KGNffIMb51XSNMKYDJq9a1UnyPi4AMhrFXnjYyXNW6TC/b9ZLAPp
         9DZ/8mreK6xlZTybsA3KHhM2OGLxO2MVSxdGg5XaAYrHOFj20SEIqPF2kxiUw12dB7BE
         w0W3g4K+y9TkBY+bT9wVaW8KL/YdnlX9+jq/dbSPymk+s/SVl22pzmHI/+6BqvwQgiWy
         gU3LfDL4uzhMHAzIUNRnMWP2ajqDTm1wCOazo54Mxh+ImrpgpebU8W3//Tuu2jri+af/
         KC9w==
X-Gm-Message-State: ANoB5plCtuB2IEu4N1wd3kTkXNgmN1bUJcdAvVAlsNj3nPogL0Ets1Ne
        eKgGlisqouQ945R8sZKAfTqE4DE2K2P8/Q0Rtps=
X-Google-Smtp-Source: AA0mqf4Sogw5cvoJiUyQ4NddU1uCtmFMVSRftkAQnigNxWAHiqOUGz1ZQRte8CuWnfcrZsLhVuFiDLyN3pCkSbqmyc8=
X-Received: by 2002:a05:6402:241d:b0:466:55e:5c60 with SMTP id
 t29-20020a056402241d00b00466055e5c60mr26138938eda.189.1668073911771; Thu, 10
 Nov 2022 01:51:51 -0800 (PST)
MIME-Version: 1.0
Sender: aliloukoumane04@gmail.com
Received: by 2002:a05:640c:2dd3:b0:187:fa3b:dcad with HTTP; Thu, 10 Nov 2022
 01:51:50 -0800 (PST)
From:   Tomani David <davidtomani24@gmail.com>
Date:   Thu, 10 Nov 2022 09:51:50 +0000
X-Google-Sender-Auth: NnpcDg5NEK83FzrcLoKO263In-g
Message-ID: <CAJJvKLvOz=fsmPSaYWgdchkoXQJYnMD5-L82_J0ku6c51sDw9g@mail.gmail.com>
Subject: Opportunity
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good morning,

I want to discuss business with you.


Regards,
Mr. David
