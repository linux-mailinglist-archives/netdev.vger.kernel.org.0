Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62BF523E99
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 22:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347611AbiEKUOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 16:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbiEKUOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 16:14:31 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B415E754
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 13:14:29 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id u205so3133348vsu.6
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 13:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=cGqzklWXWDVELhuS+xgTophtvKPosdcmMHaKUXqQOh0=;
        b=Zt/b536x6W6lxrj7WSSyJ3R79/SObpYlAuibOK028NnHb0ZkrZKGQaeWhGDvnfd0rZ
         rvcHO8nlZxh9Ys3+Vo4Y5staczP4dZTPiy7vAc/0g2Vm+VUxd6f8kKk7Ck1UYVio0lAP
         CQWU7nMp6TNeNtHKhv4Rpee40pbRItjLHC7uwU07NHkMck6/+Sk4x+rKe2p7Qsix22vJ
         6if9mu80NrvliAFKz9V6td3VwnF7OxcEH9J3GKUN3oSJTn9PQIci+z1Jk/epelo1Nxqb
         2Trazwg3YuJa2Moz2lzZF+ylu42K69BkmgHS/oeRpjbfR7pm4KEWSIje2n4ssGbnq/Da
         /dwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=cGqzklWXWDVELhuS+xgTophtvKPosdcmMHaKUXqQOh0=;
        b=I59XFw5F1JPWsaFr4Fd4IBtDh6AmORlVm/GAUB3HOX6ivGbYMy4UWnihuHpyExaIRS
         4K3r42F7OayMABB4dy2+PKT1isoghq7QLeD9P30iav5rnCZJlJE2qaDfEUS0M7NMqeOp
         UzD/5yM3poUEIjRyZXUPAAm0gfKJZsjYFwr/JDFWYIBglNNGy+flIsRDtlEaxCru8Sxy
         0wso7wsHgG3sFHlhfEFbmmqgFTmiF4ZPQFMHRhmpD6swCR6BaGcF6D9MUJCMIRnSbFo0
         n8La4EzujwmdRsGsTI1tBbno6ffX4TLCR8b/YUPkO5Tx771TzOPzLXD3f7QfvWUx2N6u
         FN8Q==
X-Gm-Message-State: AOAM531zCwArSpeeEUIvkzXK9+m01ni16txdzxYmsZ6a8EOr8z8lDusq
        IuXTxS1owhdCmUs/WaDkWpQIFk28kJl67ACI5ho=
X-Google-Smtp-Source: ABdhPJz94QPolV8Q9u+ZGAqId7oCkbxCM9t58kplepURfRm/t3W45SCpLYTPciTyKA6pzYqG2tShTyWNtYdFh6OzdQU=
X-Received: by 2002:a67:ff0f:0:b0:32c:cf89:a66d with SMTP id
 v15-20020a67ff0f000000b0032ccf89a66dmr14738250vsp.17.1652300068167; Wed, 11
 May 2022 13:14:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6122:255:0:0:0:0 with HTTP; Wed, 11 May 2022 13:14:27
 -0700 (PDT)
Reply-To: frankmorsonn@aol.com
From:   Barrister Frank Morrison <arth5jhson@gmail.com>
Date:   Wed, 11 May 2022 21:14:27 +0100
Message-ID: <CAON3qUjNZSm201dRHBD5bbFzzVVz=10350Am37-fbxCOHuCahQ@mail.gmail.com>
Subject: Lkd
To:     arth5jhson@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I'm Barrister Arthur Johnson. Please I wish to have a communication with you.
I am waiting for your answer.
Regards,
Barr.Arthur Johnson
