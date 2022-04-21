Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D45650A3EA
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 17:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390000AbiDUPZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 11:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbiDUPZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 11:25:40 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC41403FA
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 08:22:48 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-e5ca5c580fso5719022fac.3
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 08:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=DwNR0QHQJKVtva7txhdn4m3BTTYDWyhsneVMjtRYB1g=;
        b=MlzNH7bJzHGS+0cPEXglUzVw1MbLiAFE2UZ+ziBrSOnIw/fYIbHydDM5KMZk1X7cRd
         4i0ZgMWaTAyDjgtkw9lX1nLmHfC+2vgg7LGGZuI+Kt/wvUONXGtDxwXejFqlO4OILkWG
         iPvUKwLu2EaZPTHozhPp/5xRQTsjZrEyBZYJv/nFs6miE7keib61XaKnOZfv8zD3w4qC
         /HOwR/nx1/bbRwjz4bH160y+OeSB+hkyl7A1ISTYFznc0rXO4ZKRluPIvWHmMp8FlA3O
         eHqshQBnctQeYxFyImcFyaJThXabJ1drvhWzJnsO2AhLWhNP6efnBobgo8CP1YExeChs
         DUNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=DwNR0QHQJKVtva7txhdn4m3BTTYDWyhsneVMjtRYB1g=;
        b=VkB4anjioxaclPwjWTJ9z+GhfgaBX3rlpjH66rolQwAYYfv6vr+dH2TuvHuG6Xfd0L
         tHNeaijcpQ7jh38bHko/7RDcZeR6g2Q8zg9ip9wtWp1EVf4qVKz2/TY5DiPT5xXz7Uya
         P0fvQuOsPuPACttpq7Jo1GEpE0VQW/F7Siu/WlkyU5B6TBj/h8UqbMUgJHx1QZhyVg5Z
         tVtOikOhFl78PoT6f3bIvaXvZLw/jBxAeK+NiCwzUszRCrl6KtjiL3raQu/aeFhiysV5
         3ktbpP9Ro/v1vuUthhgr/iXsjONGWj+h7BAwj1G1bTmUXunXF/Xm0RWc8fZzxzt7+nah
         fdHg==
X-Gm-Message-State: AOAM533SLD8LOgiE3kH3KK/7DyCN67/DFUXg5I3r7L6EgkqpDmyQuRbR
        VmBNTQsvm1HnzHkUyV6j1WHCo34kKNKcMrqkUko=
X-Google-Smtp-Source: ABdhPJwuMiKWH6hPYa2PkOYnRgOYEhXX9BxEGMzEj1XB/rjnfqBmYpACv1e9Orcc6lRO7MyWPSnUI2WaAdCiaWuVnFg=
X-Received: by 2002:a05:6870:95a4:b0:d7:18b5:f927 with SMTP id
 k36-20020a05687095a400b000d718b5f927mr39162oao.45.1650554568292; Thu, 21 Apr
 2022 08:22:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:e95:0:0:0:0:0 with HTTP; Thu, 21 Apr 2022 08:22:47 -0700 (PDT)
Reply-To: mchardfirm@outlook.com
From:   Richard Morgana <mchardfirm@gmail.com>
Date:   Thu, 21 Apr 2022 08:22:47 -0700
Message-ID: <CAAfweOavUt0yFxhs2mnfUx=Yu+0OR7EJxNwoKTfRBXNTdXZFJQ@mail.gmail.com>
Subject: Confirm receipt
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good day,
Please kindly confirm receipt of my previous mail.

Regards,
Richard Morgana.
