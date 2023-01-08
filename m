Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D0766154A
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 14:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbjAHNBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 08:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAHNBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 08:01:04 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B51FDF58
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 05:01:03 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id tz12so13812311ejc.9
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 05:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=anv9cJSG9EkNJZvS3w3gd0liIV4O1Zny7WSBE9x02Vk=;
        b=djhmq8hg3C6qrKhgeDuoijJ/loGtXUvcwW6S6nIlnV2sz6lb0GiKkwZnnSNK5r7Ga9
         qJ9z21r3mrtSaOVIjZTrGK/bPmvpXdTTFLXS7Q8uh6s7jVavcU+ilpIdVhadoIWu1WuD
         kmXfk82Bcv0P1VoIiNu3ApH1BaW+NlUfgiBNQTV29GcemonmnWv2vVIMPKmDbG75i9tx
         w7MGT5mrgiCHZrnIZtQGZdrs+R3SSimCrlM/pD8cjG3EF3lbtWqYUqKO6GCDjf/rCeth
         Ax+qtZ7N1kn+2Cd4kfxTf9qEDaAblIZFgShA2qraTNwxeDPPPKII/+KtF5cgdkNQ2ziL
         r5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=anv9cJSG9EkNJZvS3w3gd0liIV4O1Zny7WSBE9x02Vk=;
        b=WDPYmW2QYTg9NNtTT6PvP8I/lMmyn8QD1SuqgYw7pt5DZm88t1QJdqRMtHub4GTgGn
         WhXcBPsBTkgh4uE5txdSg0RIzXfMO2wkb26NKXrJZffgTgBjsfiKAT1zzlDoeHemaGil
         n7JGbSowoD9rKHNHbwTAfPgj4tS/uldogZXO6zcDGXGC72Kxo5AHyCScvY7U7ZDBO8d0
         TlvYsi6S5nThcBx8qshKNgPm4XFtSkx0QmU5FvDK3/iG35vf5u8ie5KjRmSa5AYFg/64
         iAq63l/kKjLaTjQFNrsWvQIxJR8XWioJ5LcK4nvsDPOdNv1UclEK9uySMB6soeB7NElk
         +OYQ==
X-Gm-Message-State: AFqh2kp637w/56/A3J8BdhWD6wJGD+ci6x6eZSQyzDO7Fa8SVoHocbUS
        A5T/5inPDul07dsmuLhDre0WTvmuYfbdxW1u8/HXdSVkN574dQ==
X-Google-Smtp-Source: AMrXdXuJ2SBbSH8Nip7ww2hrvfywjAbhJ6zarr2rOf/nmoW/DneKfRKn7qbicG9bjnrwa/fIqcrpXSuq0Ps6weI4QRQ=
X-Received: by 2002:ac2:4903:0:b0:4b1:7c15:e920 with SMTP id
 n3-20020ac24903000000b004b17c15e920mr6105564lfi.453.1673182851629; Sun, 08
 Jan 2023 05:00:51 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab3:7f41:0:b0:217:d560:fc0 with HTTP; Sun, 8 Jan 2023
 05:00:50 -0800 (PST)
Reply-To: susanklatten0411@gmail.com
From:   Susan Katten <rwanjirunganga2022@gmail.com>
Date:   Sun, 8 Jan 2023 05:00:50 -0800
Message-ID: <CAM=OBJhhw5HWi56BOkDovNLsqQBa_iKdqe2xegZbtcOixJO4cQ@mail.gmail.com>
Subject: Kredit ?
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello, I am Susanne Klatten.

Do you know our company gives out Xmas loan offer, Do you need a loan?
If yes contact for more details..

Email : susanklatten0411@gmail.com

Executive Chairman
Susanne Klatten
