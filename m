Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4718C64DC70
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 14:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiLONrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 08:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiLONrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 08:47:40 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0E82792F
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 05:47:39 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id q71so4177894pgq.8
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 05:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=p5Kz0u6d1Chs7njAZ3NLuEI3VrWfKdENsZhv2WpX+KZ7rUV9/f36ekf0yNKgAmfHXu
         RXnSJvH/U+5Qm+tqAdZmRChzGI8rL1QaswOixS0jrQOEYvJMtzGIn/6OZQE3HmxyHbMF
         Nv7nfA38X5qxmkJ+oJ+WZkFPpkB/HuiG9uyC0eDZ0jlCR4xEhUfBXBKtE3Y1pf7n9Pdq
         ibMxis2jzryT1fcoDkwDl0/Q99kDVYwAV4BfxiThpvMGLG4FLOAPfILjcFVsYYpMbwLE
         h4TebISLVkMFW5JuYrGjh+7eLY19m8oyqNSj2vUR0i3QzjiNhFQ5ObFbWCFa3aEhTn1S
         YTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=BPLF91NCUN8+YCuMgEuYZtknRL4TPDFOyZnmCHGbGiT6/ibRswOBYxsNdYcVTeMx3i
         qPG+x6dymOj1nc4P/Pd8lxw99jJ5gpvJB9FOWfyFkeTA9+NzTOmJ41YCNdGORm5CpTlL
         zoWfOpFQJzWmk9OmZo7Vx9MkmsfePX7RJ91+gaANcSiJDgk0QnN5X90y7zNCCR523vXE
         paOjEfU6PhF+slCylogNdIDh2hUo+UDNi3oH54Db02Cj3e9HMYYnhlsjqE06Vo+KQdk/
         u5fKjLdOplV4kAosaqAHmgexuGTHU/gzSz14FbxwTpeMpdqectV8SkZ0FgBIwtLEWP5X
         Lrjw==
X-Gm-Message-State: ANoB5plj1Nq/2MmISM0J55AmSFNBeQM7xXYvexZ1DGvqTVEDK/UuLywI
        GEshHTfrhKVraXBXfftjbozT1Bo0Vi/VOijErPJ0IB+KU/I=
X-Google-Smtp-Source: AA0mqf4AG4yxj9n9jmo4jpijMPLd/FkS0SdEO46hyDhgmhV09Px6qDZrtngDq2oW1TPQ0ArdnYqyx0LDKpQ+40jDWhQ=
X-Received: by 2002:a63:117:0:b0:476:f43d:913e with SMTP id
 23-20020a630117000000b00476f43d913emr69346718pgb.386.1671112058806; Thu, 15
 Dec 2022 05:47:38 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:2d04:b0:360:e481:1a38 with HTTP; Thu, 15 Dec 2022
 05:47:38 -0800 (PST)
Reply-To: subik7633@gmail.com
From:   Bikram Susan <susanbikram73@gmail.com>
Date:   Thu, 15 Dec 2022 05:47:38 -0800
Message-ID: <CALpyRY3jymv1VYkGOuda=oyMhuJ+Yse4Na66DaLeVERFg1Z3Mg@mail.gmail.com>
Subject: please can i have your attention
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

Dear ,

Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.
Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Susan
