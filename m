Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77B86313C5
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 12:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiKTLyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 06:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiKTLyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 06:54:53 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002352980C
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 03:54:52 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id q83so10007832oib.10
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 03:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WIm6378Nh4ItLM2aDQbKBBMlM1ow1uuLRa5aF3FbeU4=;
        b=XNPdoJcQLCJO0UML68lsD7ToSiK6MYfhKqz7Z8/NzCFWKergZibNkwt8XtKGVZdHa8
         OMrXz1Zl77milh5R2ZYZLl4d4G20fNgzRNjydKYwLWy7L8tvt6wveQTKkD33ZnSvq0Hn
         LhABrvH8nJgtKN3J9kg3EotGUTZuz5qLcuix3pY1F8g90pWpu/fiugBLNXJb6UYkOvTS
         8Qb02rAHXyd1dC9nOVcRBThbZpiYpdd+Rh7rBL89l5yYhDJqRfS7pfKBuvJf6dGPb23/
         vgMdYjlPuQQIubZa7vrmoJAXOojDmMFe3coy5C56s2ShlFeCOHrYE0F7CLt1MGi7e4aU
         01mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WIm6378Nh4ItLM2aDQbKBBMlM1ow1uuLRa5aF3FbeU4=;
        b=v3yCYQGeV3U7CUu30TtqXC2ekrikBHqbPsQIsoKTyvk0/GJGYnmF7wRvZI8Y7ByuS1
         iafjn3GqXmfzj1dkaJ8dBgk80J7U6Z6eGre9Gan3YC8JuAxMs2es9xubajaKDemvCTOW
         9vKi8RHDlyIHyZX8Fe1TS2SC5MCllNAqF012YKlLuNoxrW0i8FKeaAW2VjxCTaan83+w
         TdIziq5W5wh/aVMyRwp3O9C8aaX+8lmzgiKgwP3MZEAxfRw9m8ldhltgTiVj9rEpHQ+9
         W4wDrKawb7olz56DmPxLTsZI/ttNjdwnVoAIC0PyjS9LqkAnAHCN5JtvxXv/HsMY707X
         +A8A==
X-Gm-Message-State: ANoB5pn3AUxanqzhYvakdTZZcADfsPsWoMW0Zm0dQJzLs6I6zCed0pHY
        1WJJFdSJ2d8OV7nPhV/zr3xvBefgcJp+ZDUIFXs=
X-Google-Smtp-Source: AA0mqf5zkr+ILKvVsFs6b9RHcvfPKs2KtykzhCWtfZ+awMmYFqx6yLRFrOow2t6sTqk/bL0+fm94UQQhbqNKHyR5Ke4=
X-Received: by 2002:aca:1112:0:b0:35a:6d81:204a with SMTP id
 18-20020aca1112000000b0035a6d81204amr9605099oir.102.1668945292252; Sun, 20
 Nov 2022 03:54:52 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6358:3d45:b0:dd:3611:ca34 with HTTP; Sun, 20 Nov 2022
 03:54:51 -0800 (PST)
Reply-To: wijh555@gmail.com
From:   "Prof. Do-Young Byun" <scsd7622@gmail.com>
Date:   Sun, 20 Nov 2022 03:54:51 -0800
Message-ID: <CACguRjJDmSTUvxCUvM2ZaQFC07ZMzkvGrsd8zaVgWWTTae3B=Q@mail.gmail.com>
Subject: Very Urgent,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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
Greetings,
We are privileged and delighted to reach you via email" And we are
urgently waiting to hear from you. and again your number is not
connecting.

Best regards,
Prof. Do-Young Byun
