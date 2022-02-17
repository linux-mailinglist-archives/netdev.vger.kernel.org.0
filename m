Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE374B9624
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiBQC5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:57:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiBQC5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:57:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24631B12F3
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 18:57:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDEADB820DC
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9B9C340EC;
        Thu, 17 Feb 2022 02:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645066635;
        bh=oh+PIZflHIoCZbcbf9h9btVgpowJRPyxlGYbpdWYrTA=;
        h=From:To:Cc:Subject:Date:From;
        b=vJbDN6iQA13EVsDkDkrSrUawA1wyb9v2R3Xb73Y1qd7aD2f2oV8msbpR/KuXYbrjQ
         Ct1J8aC8vcoyQouPFF5s2KPCpVlbG1SWlB6NrqaxbfCAUqc3pwkGoFsThtXfdjMZpM
         SnVEZipz95dwVetkpRR2dCKeaYFyLBekH54d463R/aBdVH+Qjd1h0zOaCYg3sxsB3d
         ZK/Y+QFcwcjTIY4ODeUfrN6yh15cBiMk6Bj/34F4s28eXvZT+gIamAYrWe80PWiaX4
         pquXmW+g3mSL0NrLRVE6bYc/LvbFFrSgZbN6F7QwasKf+Xn+LxS+l4y7m4ElexYkxt
         WdFFypoc1PMnQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, parav@nvidia.com, jiri@nvidia.com,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 0/4] devlink: Remove custom string conversions
Date:   Wed, 16 Feb 2022 19:57:07 -0700
Message-Id: <20220217025711.9369-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove strtouint${N}_t variants in favor of the library functions get_u${N}

David Ahern (4):
  devlink: Remove strtouint64_t in favor of get_u64
  devlink: Remove strtouint32_t in favor of get_u32
  devlink: Remove strtouint16_t in favor of get_u16
  devlink: Remove strtouint8_t in favor of get_u8

 devlink/devlink.c | 92 ++++++++++-------------------------------------
 1 file changed, 18 insertions(+), 74 deletions(-)

-- 
2.24.3 (Apple Git-128)

