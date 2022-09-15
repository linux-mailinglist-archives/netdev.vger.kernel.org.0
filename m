Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93805BA305
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 01:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiIOXEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 19:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiIOXEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 19:04:12 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F4058DC1
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 16:04:11 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n23-20020a7bc5d7000000b003a62f19b453so18666932wmk.3
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 16:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=V/nIhXRBT1A2wzKeDfWK4R9H8lrNG6z19UeD0gFaEww=;
        b=C+3ubFk9/+Kb9OAuaYVtEua4H+6Hk6a1HfWJvfO6wL6dP5yzQlfWM2OHBr24Io9mju
         ALNJZ4T1BJ5kwX73ud0BMylXZzy9efXz+DvNnKu3vzD6C4lyyQY6EqhPDZgwbozD9WDx
         5+O6uZum1TXFNKHsctgE2QFrgahYZHhwKd1qNRS4+otN7CQ0zhsY+R90HwxNp5Q4yENy
         fuP+PwEQg2cdxmaswIAjLRkFxaSDRZjCR6n3810ISMKR+W9eU7I8AJIU0/cM2FiKwrXg
         92oi28yJ/+iidDfcXygkDmZ8Vnmun5zWPQ5ZOeVz3ejl6EOl6KB0r3FWy8r2S7RZF4jh
         KGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=V/nIhXRBT1A2wzKeDfWK4R9H8lrNG6z19UeD0gFaEww=;
        b=qmSkIbS/Oc5yd21B2uUDqTXqLXu3IY+WMSapZddYU4b/M4qr0ULiHSmlvukj6OOixM
         qA4rz/WZX4CZMpQJNtuBFK0QgPQ7WxZXMetkmLE11VXR8wWGJkTegS4u+AoLvzv3MiH4
         KLtnXhLJCfOoZvnJ4HZhU/6OhyGlM94ziv0K+octadmk/5sdRUTkV+bdjhDSZI0QgC7I
         u2Pyjdw863qdqMAdoOW9SkpEcsIBxvwW/cAGs6xeRhm/eO8w9HYib1y9Lf/fLSFrzLzt
         JkBOlI7705YxBzzy5T1sijWpNOk7Mt9iP7xD2AtMawtNEQab+/z+3O5+XGzkPwPq/Nf/
         RI9Q==
X-Gm-Message-State: ACrzQf3K/APPwdBnt2iTvQZneOqrGGlBHcD2KiVYEPsNoo1OHGpxFh5g
        9HuGjZdGIg+u4rONBojKCuV+F8687iVE6TPXqdk=
X-Google-Smtp-Source: AMsMyM64GhGKLPIWQWiBSF+YkrU67tGplO5jvaDeVfT+7p60RbjKtGSsOIAbMesFLPsFGuMQdDK3aD424ne8nAVjlsk=
X-Received: by 2002:a1c:7c04:0:b0:3b4:aaa4:9ec8 with SMTP id
 x4-20020a1c7c04000000b003b4aaa49ec8mr1343020wmc.44.1663283050304; Thu, 15 Sep
 2022 16:04:10 -0700 (PDT)
MIME-Version: 1.0
Sender: unura67@gmail.com
Received: by 2002:a05:6021:2189:b0:211:62eb:6d76 with HTTP; Thu, 15 Sep 2022
 16:04:09 -0700 (PDT)
From:   "Mrs. Margaret Christopher" <mrsmargaretchristopher01@gmail.com>
Date:   Thu, 15 Sep 2022 16:04:09 -0700
X-Google-Sender-Auth: XAmuIdDWg3aUriTVwYWwjbQv0pc
Message-ID: <CAOuvuUHR72onhzSb01P3At9sfQLw-yiLY-9F_phA8WC+5HPwQg@mail.gmail.com>
Subject: Humanitarian Project For Less Privileged.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_HK_NAME_FM_MR_MRS autolearn=ham autolearn_force=no version=3.4.6
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

Yours Faithfully,
