Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D978357043A
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiGKN0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGKN0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:26:12 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E1D326DD
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:26:10 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a5so6991256wrx.12
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7XKMQfy04h3ZNBXgXvnRliAigUZe18m6o8mDoe3+xtw=;
        b=nYZ58gJHsTP7SFxEPp3UPt9Yy8whk8B4W1Mp+/rNuQJQ2G3aVlG38sRxVuV/MEA20j
         s7zvHYCZdi5XffK4csryGWhoS1MeraHc81JLFhc6PHQJgC7A/YU4n+oLpztK+3uSn5fN
         l2J0OKFTjiBHA7wPV3YKDTE1TfhvQLaeaRZ4xq1My2CfEDXL7/XLx3jOMo3qmGh3Nxnt
         PTn5Pe6T8CE37iMp3aMjEiiKrxz7yms2CLD9tIwrxmw9LSZt0WksLwBb7+xG/Gg+cVN3
         AI91rDTkQc/c8bngONux9PIhmqWwxEbFhz2wQzvxocrYmIXuSLUGXc8GbqkolzWj5G1b
         Ro0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7XKMQfy04h3ZNBXgXvnRliAigUZe18m6o8mDoe3+xtw=;
        b=vUOfwReVea8e92OMiGksOLyKv/gtDJeIxOKC9OMj6CxgbwdWyQ2bhwb18KWBcwMQca
         UXVj/NBbfaqOSp6mS+q++52zU2HwbY0FyI09+1ArOJSPg05xseficLjl2IXhxBZKckh6
         occ0EJgs5uWhkqxi19TSdHcBvJ081J+gV0zwZMY8fT1xg6GaKyUIb0O0pYj1UFeboJBr
         LKhU30XvPXDcNx1akJWBvs0+HpRBRAo6VliP5X1wA6bUXAjseKBDNPxE0oQ69McJiTWq
         BAAkwoEbIcccGJU+x3pSASU6BsIUP+lmUT6vcLNbSyZDEtJ8kNgzJD8tKFHhT8Db+JAZ
         KPcA==
X-Gm-Message-State: AJIora/9fiUaFhfaC6ASSJ0olOTXiJ0hrYFcBTTMZ/UtaEuf+odfPKEc
        oZMGb9jwLfSRm9crGeybDlmRwd0dvVOQGhWz+nc=
X-Google-Smtp-Source: AGRyM1vFbtIItQjX22IZlJ63PdcSUUFcJ/Cnn1PMDwugl84Ulm6zWr2JQR5LkKIcqF5bLXVzoM8C/Q==
X-Received: by 2002:a5d:47ab:0:b0:21b:ca9b:2396 with SMTP id 11-20020a5d47ab000000b0021bca9b2396mr16681841wrb.206.1657545969262;
        Mon, 11 Jul 2022 06:26:09 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d15-20020adfe84f000000b0021a56cda047sm5794115wrn.60.2022.07.11.06.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 06:26:08 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v3/repost 0/3] net: devlink: devl_* cosmetic fixes
Date:   Mon, 11 Jul 2022 15:26:04 +0200
Message-Id: <20220711132607.2654337-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Hi. This patches just fixes some small cosmetic issues of devl_* related
functions which I found on the way.

Jiri Pirko (3):
  net: devlink: fix unlocked vs locked functions descriptions
  net: devlink: use helpers to work with devlink->lock mutex
  net: devlink: move unlocked function prototypes alongside the locked
    ones

 include/net/devlink.h |  16 ++-
 net/core/devlink.c    | 284 ++++++++++++++++++++++++------------------
 2 files changed, 167 insertions(+), 133 deletions(-)

-- 
2.35.3

