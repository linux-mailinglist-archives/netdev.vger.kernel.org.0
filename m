Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4095037E9
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiDPTVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiDPTVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:21:00 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8FE457B9;
        Sat, 16 Apr 2022 12:18:27 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 32so11958907pgl.4;
        Sat, 16 Apr 2022 12:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=cEiFYO7CvfRyx2lxfp/dzLomivsTy3qKaQW3t/1AfgA=;
        b=hjhW4uwSoiJ3c41yfoxcSod5NklVn46w57mFDsyZSSAbFNscq7GfEDF2n69+jgBU/F
         ZhCf4FjSWojzwk+zZGwcEbar4ct/cbGfd2eveL/hB7gga5rsGJy7MENwxAGaVcc5pIo2
         EQIUYVmcm/ZID7UwqnIIxLDG/kPCxRKGpvywa3K8oyasbskgiAfNYJJ1vOl3XlIKBeCp
         xMdcpw05UCMjFnGsOYsm3qkFUOOyNo2QzfYIQkzYDbCxzdTC4B/dDlBNYLQW1iH5MTX8
         LD7nBPDyLaKRH29NiZbn3WYCc/vxBJczs183CgGDAeBiBPSHBiMzYnbYaY2lHcWe0U7K
         4iBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cEiFYO7CvfRyx2lxfp/dzLomivsTy3qKaQW3t/1AfgA=;
        b=WAuE0/o8S7gSjztp3gHwXiMwCFMZRIPKKkL41MUB0kgB9Xo0FxFF7TTvulvyM6WGu6
         6BmldKU4rLt0GI8Rlcu/sxQBOJ9OHc4nEiTha95dhkDTc8Nyhh5T19cX0tmKWs+mfDZ4
         u8IqAAubpXnjSUipSuWknkRhrTA1gSHmmFM0R+Z1YtTiVQfd1YYa/g+Q/0QmXe4Oy9T6
         fpqufM5AENRgfMZ8AmiZWFVA/QlU429l4fNzw9k6nPvIuR6Ir+pfoNS0EZ9ZW2CB4E/R
         +BjdeNeaQpWq8vY6TleqIxELa6CXdSJ6UkI2asa8k1mn9iylb2b40mWGtw8mXZOJab6I
         wXJA==
X-Gm-Message-State: AOAM533SpNDA64hmoM+VxnUU6BAYTfaXCIG6FTEigsaVR2kEqy1SvycH
        fzolZCNZrgBzT/AJA5QZST8=
X-Google-Smtp-Source: ABdhPJzgLqlNi+iTW3XfsMmksrs4Si6d6BxNd3yiSJYhM4GHXT37Bc+odwKwilPJVYOUYvT/NjF8gw==
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr4780091pfu.59.1650136707150;
        Sat, 16 Apr 2022 12:18:27 -0700 (PDT)
Received: from Negi ([207.151.52.3])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090acd0500b001b9c05b075dsm11913701pju.44.2022.04.16.12.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Apr 2022 12:18:26 -0700 (PDT)
From:   Soumya Negi <soumya.negi97@gmail.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, outreachy@lists.linux.dev
Cc:     Soumya Negi <soumya.negi97@gmail.com>
Subject: [PATCH v2] staging: qlge: add blank line after function declaration
Date:   Sat, 16 Apr 2022 12:17:45 -0700
Message-Id: <20220416191745.7079-1-soumya.negi97@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adhere to linux coding style. Reported by checkpatch:
CHECK: Please use a blank line after function/struct/union/enum declarations

Signed-off-by: Soumya Negi <soumya.negi97@gmail.com>
---
Changes in v2:
  - Correct commit message.
---
 drivers/staging/qlge/qlge.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index 55e0ad759250..d0dd659834ee 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2072,6 +2072,7 @@ struct qlge_adapter *netdev_to_qdev(struct net_device *ndev)
 
 	return ndev_priv->qdev;
 }
+
 /*
  * The main Adapter structure definition.
  * This structure has all fields relevant to the hardware.
-- 
2.17.1

