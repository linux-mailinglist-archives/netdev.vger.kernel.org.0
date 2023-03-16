Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6D86BD129
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCPNpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjCPNpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:45:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56107DD32;
        Thu, 16 Mar 2023 06:45:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4215D62033;
        Thu, 16 Mar 2023 13:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A975C433EF;
        Thu, 16 Mar 2023 13:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678974326;
        bh=IFBpd7OfWuYdVfbveasMQcIhr3pIZmts7EDU6oOkGLU=;
        h=From:To:Cc:Subject:Date:From;
        b=Al9xKvyk9j5o8Qqw8bfsgQzYRU/IhFoTqS5sfJT4LWSinQL6WOonC/ctuNnlAHCDr
         b4T3qLhvyjQx4Or1uEE3MDMHnaMby0TCSkROe+8EotWFJFJjxuFF7N/iHITxQ1w2G4
         5yxhMOlA+qRCNzGJSuPKz0luSGVTkwyCDWdXJ7fmD2F2vV29nXodvcw1dXCbmWKN7K
         +o6Ys0wcwT6IgO/6koVdNrJgLyqudMU+B7PJUwkqx0MK866zGR2QsO1V2ZDft/zOC7
         b1B6K8f/KKinw+6AaRtC69aAD6au0jlaGg5Jy5mdZSjYKTI46EedGPtPHcZ5TzFtD6
         LOXPLKlcxLcew==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Patrisious Haddad <phaddad@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 0/2] Add Q-counters for representors
Date:   Thu, 16 Mar 2023 15:45:19 +0200
Message-Id: <cover.1678974109.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The following series from Patrisious exports iVF representors counters
to be visible by the host.

Thanks

Patrisious Haddad (2):
  net/mlx5: Introduce other vport query for Q-counters
  RDMA/mlx5: Expand switchdev Q-counters to expose representor
    statistics

 drivers/infiniband/hw/mlx5/counters.c | 161 ++++++++++++++++++++++----
 include/linux/mlx5/mlx5_ifc.h         |  13 ++-
 2 files changed, 146 insertions(+), 28 deletions(-)

-- 
2.39.2

