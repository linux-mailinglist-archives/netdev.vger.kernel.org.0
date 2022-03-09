Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B11F4D35AD
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbiCIRIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbiCIRHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:07:12 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C9A12F163
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:57:30 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id u10so5636747ybd.9
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 08:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=H2YfWCG0balrUsjNebe6NPqLv9wl/pqUnfwIaMT7BYE=;
        b=OTiovbqor7rPjK5jhzVjqvil/qPceEK2EFn0hbabWKBEfX9/whK8zkLNbTGGyZeYPd
         nd7r94SiquzndTfuAvmETMoTd+XK3gKA4s7wKkWtJzBbwPGmaQ+0G9Smo4H/wPUaMUGP
         /Xb+mJR2paumxGQtlK9uW5vmYLpHwWJvxP86k2PakkEz/lK/tMWhEFGTGQuq17vjeqPe
         egd9w1m1wNx2o8ecLEUdYU/CEJmYbIfEfukl3DvOt5EywGZpKUDQOOzzj15pTgYPJteK
         mnE7z5FuC8+yVS6UZ7IMVVqaWk7iORFGa9JJmt382IqKcDQiwZ4LbDW9Ypq56LfdGaU5
         D68w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=H2YfWCG0balrUsjNebe6NPqLv9wl/pqUnfwIaMT7BYE=;
        b=2QfUGKFyTu9561YHtT9nfYtCxaNztA83jl3BWMKO/tSccyJh6RepkXO17U9EAl5Kxi
         1c2ycpeWMLwa68SlEy/78a4PUFrpDS9NDqMCS3KUKR0bIqUF2w+QySEQuSC1mEHjmzn6
         8W0CCbWZZg+8G9L+Nv6dhmGer1k0XK3aI5Q61BhdcHtibDz42dDzI19joZSIHFrSbOvi
         auC9YwXJSjIN0VX0bs7hN8fa7ESQlC4GPPk+C73CI+qIIydwJEXCcK2Me87Y3ZxOrzK6
         Z8dyR9yEkArxNhvFehh6Z+pQTP7+n+6znt/9Xe/H4jqdIEzaufHfuvrbuvVNl9ZZ6fvj
         twng==
X-Gm-Message-State: AOAM532MvfaAlnxCCDbUCv5b5SKW7O2rqOmWpnDm+LT/GyWGHsFFQp1/
        buzUv/m39tgzwFI5wFzWqtqtoFcx8PTLWE2xuvM=
X-Google-Smtp-Source: ABdhPJwu0r5zKLzpWPqaHY47vOYFmqn+pmq1/tz98rbhzRxWRK7ADqNK/nVGgrvhFQKbGoATrsaXh4hQKhIi+HZbSLc=
X-Received: by 2002:a25:31c4:0:b0:629:f72:99cc with SMTP id
 x187-20020a2531c4000000b006290f7299ccmr503421ybx.549.1646845049442; Wed, 09
 Mar 2022 08:57:29 -0800 (PST)
MIME-Version: 1.0
Sender: bintaahmed2030@gmail.com
Received: by 2002:a05:7110:4b1c:b0:16f:cabd:46d0 with HTTP; Wed, 9 Mar 2022
 08:57:28 -0800 (PST)
From:   Lisa Williams <lw23675851@gmail.com>
Date:   Wed, 9 Mar 2022 16:57:28 +0000
X-Google-Sender-Auth: SjmnFRdBLqxNAFps1F5dg5A68Z8
Message-ID: <CAGQNKtSXcCi6bv+HC39pQ5VVppd=AOrAyoijEtWnLLbJghf_5g@mail.gmail.com>
Subject: My name is Lisa Williams
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hi Dear,

My name is Lisa  Williams, I am from the United States of America, Its
my pleasure to contact you for new and special friendship, I will be
glad to see your reply for us to know each other better.

Yours
Lisa
