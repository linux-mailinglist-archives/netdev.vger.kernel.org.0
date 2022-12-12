Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B1F6499C7
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 08:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiLLHy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 02:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiLLHyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 02:54:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB242BC25
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 23:54:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8125060F01
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 07:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590D8C433D2;
        Mon, 12 Dec 2022 07:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670831660;
        bh=fXrhFI7hH7fpUEveC6viEaif2Ww8hvG/DPBYXyksHvU=;
        h=From:To:Cc:Subject:Date:From;
        b=apuLdWGr9xPdfjTzT3NkMTd6G0HOeMiactj67CDiujxiSIq0NfwiA7RqR9V8X+YYx
         5zMRc5vQ3iUHBIEZu7YrB7wOEtKyJvM40TrKOCVdmfKz67xgZLbWWkVZ9o5byZKHOn
         h7avxbT+Tm8S+qvuTJ5c1kL9sUaXxQ7o1tW1DmQ8Qa7cUBgFHq5HaQldwANZRZCq+C
         uXwBXdRhr8+/f3SOVQFc28AowR3ogOWlf6Kqke3IGa/0uPcqdV4/Vg2IpIuDOmGrBh
         KXLXjfMJm7kDoG5rJZ3mX3fHCAQw0cUZbZYJSNOxdU4zwspTThLvfvR2ZCOMuywhra
         KnsS8XY7EVCPw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>
Subject: [PATCH iproute2-next v1 0/4] Add new IPsec offload type
Date:   Mon, 12 Dec 2022 09:54:02 +0200
Message-Id: <cover.1670830561.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Extend ip tool to support new IPsec offload mode.
Followup of the recently accepted series to netdev.
https://lore.kernel.org/r/20221209093310.4018731-1-steffen.klassert@secunet.com
--------------------------------------------------------------------------------

Changelog:
v1:
 * Changed "full offload" to "packet offload" to be aligned with kernel names.
 * Rebase to latest iproute2-next
v0: https://lore.kernel.org/all/cover.1652179360.git.leonro@nvidia.com

Thanks

Leon Romanovsky (4):
  Update XFRM kernel header
  xfrm: prepare state offload logic to set mode
  xfrm: add packet offload mode to xfrm state
  xfrm: add an interface to offload policy

 include/uapi/linux/xfrm.h |  8 +++++++
 ip/ipxfrm.c               | 15 ++++++++----
 ip/xfrm.h                 |  4 ++--
 ip/xfrm_monitor.c         |  2 +-
 ip/xfrm_policy.c          | 26 +++++++++++++++++++++
 ip/xfrm_state.c           | 49 +++++++++++++++++++++++++--------------
 man/man8/ip-xfrm.8        | 14 +++++++++++
 7 files changed, 93 insertions(+), 25 deletions(-)

-- 
2.38.1

