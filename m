Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B993503469
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 08:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiDPGXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 02:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiDPGXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 02:23:00 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F129C6F17;
        Fri, 15 Apr 2022 23:20:29 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q12so9848985pgj.13;
        Fri, 15 Apr 2022 23:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=mID4Q7Oy5vdVFWCrost986cUNbsemXABJB5WYtGqo7s=;
        b=MOsQpB6P6OmUeKPIYslvJ0lIWOikcXOjyVnuW3mRJ9yPuHGk4t/d9nL1IxsDRRYnCf
         DDhS3UW5qLDjgK/SVsboQrrF6nV8igkpEzXLlPRj5ABwqhAtbd6PfTIcTGKnLKrlayhD
         2RG/SV4Qxo3v0T8HkCg0WhBaHiQBP41cojQiL7cqB2tTJTgaCeE0j01gz4Hp+UUdX931
         ZSjG/HxQ1yDauGl4iVqjUmPD3i0HsIKw5MW+AHAThE1+n3n9kAgzlAORsUVSOF7kza5I
         chpQ+Cinzer5Xb9HH90oq2lV2dnjwAugfKGIshAlQTrxRtDIl+3POJFzH6ztDtBW/z7A
         WMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mID4Q7Oy5vdVFWCrost986cUNbsemXABJB5WYtGqo7s=;
        b=H9cZyqidEsnDH5QibcKpiVFoel03I2qcBPS+JW6gJmLQzDroPQeTo2kI1uUF9C6JYm
         uG64PzVrBEfC7NbZfuV1MUtsE+YxYGsA755hfdwvNboB2fP46iKDIxRhQ3/J1W37m1ga
         4249TReMD1d4NddoyCdWehuN4XOmoIqG2qpQEsYQ3UrJGN+wPIOJ0IU7rAjRUNdbJ56z
         1hlW+gVv7IpqpYHwZXfMiWtixf02Edi9XASkMP70L59II4eglvXKPfYpZ6xsfptYxIfK
         QIv9f0Eey55wLEL2Ch9YvrVhsxwqoOThTxBzwgADlNFM3l62ONzithe14NcxXuSc0iFP
         9JIQ==
X-Gm-Message-State: AOAM5339gVlV6DZZq+SX7/hgzDvGWqDir5I5I5MhhV9nhWt3efBH4pJF
        LuknV+Er9XfGTaJQ87fJrzM=
X-Google-Smtp-Source: ABdhPJzCBF4WLTMb+id3pXyWZx9SOAxqCcgwN3ur3pGF6UG2W+luavjOfk77uSXxP1vpp0IATQUAyg==
X-Received: by 2002:a63:b20e:0:b0:398:5b28:e54a with SMTP id x14-20020a63b20e000000b003985b28e54amr1874512pge.443.1650090028828;
        Fri, 15 Apr 2022 23:20:28 -0700 (PDT)
Received: from Negi ([207.151.52.3])
        by smtp.gmail.com with ESMTPSA id o123-20020a634181000000b0039d300c417dsm5988151pga.64.2022.04.15.23.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 23:20:28 -0700 (PDT)
From:   Soumya Negi <soumya.negi97@gmail.com>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, outreachy@lists.linux.dev
Cc:     Soumya Negi <soumya.negi97@gmail.com>
Subject: [PATCH] staging: qlge: add blank line after struct declaration
Date:   Fri, 15 Apr 2022 23:19:36 -0700
Message-Id: <20220416061936.957-1-soumya.negi97@gmail.com>
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

