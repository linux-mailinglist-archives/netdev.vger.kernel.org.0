Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24BDF5E615D
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 13:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiIVLlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 07:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiIVLlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 07:41:32 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDE2D6911;
        Thu, 22 Sep 2022 04:41:30 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r7so15116210wrm.2;
        Thu, 22 Sep 2022 04:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=rIDRC4Nj+ZNFkv/Gc+nXqgppwjKrH0iBitRrKcSv1L4=;
        b=UWvZ0PJi7tgJOd1sE7DPqHIK/KKrPT1bjEj3WKjxP6Hml7SBUpJut8/f5jwcyZ5KC8
         h2FRKu1JN94JW/SYi0oQ3mcCxylKOoz+EQPP8dCY4tWgjIXCW/qCJBJxB69wS2eDyC3X
         92si/mFf95Rp511Usq6OCFZWMAtspKojBzI/6IOP/+wL8FPrBWmYC1FKR65nJU6zr/gL
         03QQYoD4iozWnJXAOyyGSj5JzvcaQFynm+RK8md9yzn5lYdJVyzxms6zoeFhvtkZqip5
         zqZ851fPwWjVjLVk5mGzb1D8JhrbLrPpwLSiGVUTKNDsPOJX5s7/zyNRtkiMBGYfJ/zB
         Aw1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=rIDRC4Nj+ZNFkv/Gc+nXqgppwjKrH0iBitRrKcSv1L4=;
        b=dglRsZWxa6MQPvJ5ir+TYD0apQzoEVL2C1qcQxx7dcfMZXHSsXIKMVY55tMGRMm8vx
         Fe/Kv/9q+AnWdpdBglDwb/Q9JaeUELbHgOQXC5HxE9VB+BK7jYN24CiPcqlaIS3K7Dy3
         xR244VRczknJok3nHqQkY72m4MjSvsbI0FTM62no1hbjvFrn3tO/7jN8edFF8su5m2tC
         OKpDeJal9J5P6gvE9DPbQtw2ALATOe0eTahSzYHfnM3E3TUrLFyzEOlgRtq3Ont998my
         xEWfmMMLLJfJNZ2UyUBmfj4dVIbOPdS1Gko+E/q08aY2Xuqj5T69kJdwxrt1BDAKgTMA
         WnRg==
X-Gm-Message-State: ACrzQf2MOgfabUHlUkhxYPrNhvS3T7FiFTAYRJBuQO8L9sc5TC8DkEvB
        UeVi63n0cMuE66eLmQ/8JEY=
X-Google-Smtp-Source: AMsMyM7ICzvm8GZjO4En0ZR/EiftwPrVh2tH/GPJmvd26zpAw0pSaSjscb64sIsBWJ0eXJQxvVrxkQ==
X-Received: by 2002:a5d:6d81:0:b0:226:e0a4:a023 with SMTP id l1-20020a5d6d81000000b00226e0a4a023mr1691166wrs.660.1663846888418;
        Thu, 22 Sep 2022 04:41:28 -0700 (PDT)
Received: from felia.fritz.box (200116b826ee9d002d7918fb932a6deb.dip.versatel-1u1.de. [2001:16b8:26ee:9d00:2d79:18fb:932a:6deb])
        by smtp.gmail.com with ESMTPSA id h2-20020adffa82000000b0022584c82c80sm4761903wrr.19.2022.09.22.04.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 04:41:27 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Benjamin Poirier <bpoirier@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: rectify file entry in TEAM DRIVER
Date:   Thu, 22 Sep 2022 13:40:53 +0200
Message-Id: <20220922114053.10883-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bbb774d921e2 ("net: Add tests for bonding and team address list
management") adds the net team driver tests in the directory:

  tools/testing/selftests/drivers/net/team/

The file entry in MAINTAINERS for the TEAM DRIVER however refers to:

  tools/testing/selftests/net/team/

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken file pattern.

Repair this file entry in TEAM DRIVER.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Benjamin, please ack.

David, please pick this minor clean-up patch on top of the commit above.

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c9e8c850e0b8..635094fc523b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20099,7 +20099,7 @@ S:	Supported
 F:	drivers/net/team/
 F:	include/linux/if_team.h
 F:	include/uapi/linux/if_team.h
-F:	tools/testing/selftests/net/team/
+F:	tools/testing/selftests/drivers/net/team/
 
 TECHNOLOGIC SYSTEMS TS-5500 PLATFORM SUPPORT
 M:	"Savoir-faire Linux Inc." <kernel@savoirfairelinux.com>
-- 
2.17.1

