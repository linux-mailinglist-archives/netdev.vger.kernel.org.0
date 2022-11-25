Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B4863864F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiKYJaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiKYJ3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:29:53 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D1340470
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 01:29:24 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id bj12so8944960ejb.13
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 01:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p3aGB9s9xSZ5WYEncDSqeNINaDxaO73J3UsKw5XG3VI=;
        b=f6JdPurxQ4c7NqhzZXqDZqgwf8UfodoLYc0TRRpm0+EaJ9F/Jlz+4xSykhY7/Xj53Z
         ttbfN55w1B7FyHkkT8a0Ia83qJOKw8IMViS+Whf/3Q9WArTJZ0nECUB8hfvmEbHOCTq3
         r6WGMMP4dBwwc4f2f7tzC91Hb5AO09bUehVvHQh3q0g+z+NnwznH3354b3a3y1dOyd87
         2Qwos4X0hkSt0p2Fpve+4lkwt9VcwTug7DWg/ioR20BQegpNuhGaPMeOW0yLegLDjt/Y
         DSqmS0XLmEbnOcB70vAd/ZrsxIAf6kgYrTDcOKedcSpk4/T3O7y4DjKqX3YZjK5iFXMA
         Nxjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p3aGB9s9xSZ5WYEncDSqeNINaDxaO73J3UsKw5XG3VI=;
        b=PL2I57S4gneMuFRpPk/q/FVsoP1tjGc6CyLDVtDajFU/XTlDCDeDf+kgCFJUql3pt8
         3Gn62fgVSM2vq+OufZ8hgI4wFsEiPeELv5DIlh0B4Z+UpZo+vekmKu4mkh8b6LLsGxMG
         e8O9SJmVMi7DxWsESFGt+o4lJBOwpr/l1E6k+F25dGPdQ3hgL0rmcL1I66fgcNUCt8kn
         lHjaNHoE+ZkzOEasth9bFYqLSf75xuZpKvpN/u8WFByfZ0vztvYzYMBHh5ncB+ZiS+kJ
         F3i2uXQVwpopDXWACcMR54GOvdCChrbTUjmBIy42yKSSoMVhhyasDcGULZ8sDgCTncm4
         0ocw==
X-Gm-Message-State: ANoB5pmeAvZ4BZkrKr4DhY6ItsOMqYyYf9hWw6+8yjoXm2Xy+TA9f8CX
        4PmsXjDepIY1xgVYOonJOyldoKMQ3UsAwVtC
X-Google-Smtp-Source: AA0mqf6p+Ks+9aZKz35t5itaYFuwL0CrZUFnEOTMNOcYOPwK/IcDnSfaKrlVvBemswFD8qFUGWEsVA==
X-Received: by 2002:a17:906:3e41:b0:78d:bc9f:33da with SMTP id t1-20020a1709063e4100b0078dbc9f33damr30580065eji.80.1669368558432;
        Fri, 25 Nov 2022 01:29:18 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906200100b007b839689adesm1328969ejo.166.2022.11.25.01.29.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 01:29:17 -0800 (PST)
Date:   Fri, 25 Nov 2022 10:29:22 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     netdev@vger.kernel.org
Subject: stmmac compile error
Message-ID: <Y4CK8n8AiwOOTRFJ@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!
I've just checked-out the latest changes from
git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/master
commit b084f6cc3563faf4f4d16c98852c0c734fe18914

When compiling, I got the following error:

drivers/net/ethernet/stmicro/stmmac/stmmac_main.c: In function ‘stmmac_cmdline_opt’:
drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:7583:28: error: too many arguments to function ‘sysfs_streq’
 7583 |                 } else if (sysfs_streq(opt, "pause:", 6)) {
      |                            ^~~~~~~~~~~
In file included from ./include/linux/bitmap.h:11,
                 from ./include/linux/cpumask.h:12,
                 from ./include/linux/smp.h:13,
                 from ./include/linux/lockdep.h:14,
                 from ./include/linux/mutex.h:17,
                 from ./include/linux/notifier.h:14,
                 from ./include/linux/clk.h:14,
                 from drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:17:
./include/linux/string.h:185:13: note: declared here
  185 | extern bool sysfs_streq(const char *s1, const char *s2);
      |             ^~~~~~~~~~~
make[6]: *** [scripts/Makefile.build:250: drivers/net/ethernet/stmicro/stmmac/stmmac_main.o] Error 1

NOTE: I did not make any changes, it is a clean build.
Anyone knows what this could be?

Thank you,
Piergiorgio
