Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F395EF35E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 12:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiI2KYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 06:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbiI2KYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 06:24:46 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C9DE080
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 03:24:40 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bj12so1784840ejb.13
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 03:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=bMddGAj3jSV8YAm337XHEgs7AyIDjjyq7hwfgzwMEbI=;
        b=oFU8eMhRLxAVr/dG/pixoT4m8YhgdySxKv3Rzo7jvAA532wq3sXs/1tuJ+QpNrW7NA
         B3heKg01vUnCVrWyN4Xl2XPHlR9EuCF86Y+9tbgzhdsHvHaGHAyA5G5wKXz7vWMXU6QK
         PSN4oLarrJ3qVR5zj1UpRHOqxS3RdTG6hCYosput8DC3LEokvWdhBVD4JJmDGIKpJLw0
         JPl2rkmALaXYAYyP624J8CS/k/KS6L82bHBosvUG5DTY9uAalu2pqByrOVgGdloOCcnO
         i9lKYKNpmZKEvi98vFTHFdKhMp4bVA43Mcu4z6dvWVelaCuJckvSsHbCrgIMfELh4J2b
         pOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=bMddGAj3jSV8YAm337XHEgs7AyIDjjyq7hwfgzwMEbI=;
        b=fQBY0iX/Ww3BtyF5YazVLhqudj/ku5DaN/qxnR8+q3rTGX+HSFA2NlfIcuSdD7CPsO
         kDM9mbd7/YTHnNaqBA8hfG2snsGw3xi1L9JLzIzoRMmYMRekwyJTDgxlR2SpqM4mPLYT
         awni6P0XVKdrfBCjj+Ob9Ir2Iqo/8NrBTupMQusGKlJb+BFrnMcIsG3FcToT5y1cx4SB
         aqBT/kZQLhqW63OQ1f9FmXx4vEL0q9A7vVqB0suDclRUUONQMTblhbBjbQiJGURIBJEU
         lOcmS8cAYrE7CA4d8vbZFwiC9Nll09lhvdgKOefoSE+W+jhO9yeO/yoAQweNQlRh4hHi
         /KOg==
X-Gm-Message-State: ACrzQf04WDrFWJE7br6HFiSGjXsk2MhF0eQfmicKuc4kw1YmO5AXoymu
        T1Xstul+pTIsM9LXpD1V9J6B0g2gv2xlzZuK
X-Google-Smtp-Source: AMsMyM7PNXEJv4TOtTwUxYC97Yac+cUxJqIqgRcsxPWQkp9HADS/w76HQI3AWrFUZuucEvoT4LAWsQ==
X-Received: by 2002:a17:906:ee8e:b0:730:3646:d178 with SMTP id wt14-20020a170906ee8e00b007303646d178mr2107800ejb.426.1664447078578;
        Thu, 29 Sep 2022 03:24:38 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kx9-20020a170907774900b0073dc8d0eabesm3746990ejc.15.2022.09.29.03.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 03:24:37 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com
Subject: [patch iproute2-next 0/2] devlink: fix couple of cosmetic issues
Date:   Thu, 29 Sep 2022 12:24:34 +0200
Message-Id: <20220929102436.3047138-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Just cosmetics, more or less.

Jiri Pirko (2):
  devlink: move use_iec into struct dl
  devlink: fix typo in variable name in ifname_map_cb()

 devlink/devlink.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

-- 
2.37.1

