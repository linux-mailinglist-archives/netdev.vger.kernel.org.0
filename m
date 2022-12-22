Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCB865467A
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 20:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiLVTW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 14:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiLVTWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 14:22:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20D7E0E7
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 11:22:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80B56B81F4A
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 19:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12E5C433D2;
        Thu, 22 Dec 2022 19:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671736972;
        bh=ctvWQIUcFcVwzIaMzaqm/ptvbAy4fMixDkgCriEfKdI=;
        h=From:To:Cc:Subject:Date:From;
        b=Vwn/DP+zZlbUvpP5T3WaNQKPns9iHJ0mJOB9cgmP9katuGvebTwh/A306WqpQVKfG
         xHqEz44vRSKA/0Nzv9sNB26hlu44KPVufGK7VuZxT1e5C/VGkWaI37X6RVtQOM7C/S
         gA5DHK8vwcC1332uJk3v0ijy+hgN/ZnD6eORMGKCFvM9z5Cq5dl8gbqF1b2WFPDVzA
         wyfAxCbycIm4OVRXMjxVoc6AmrufZp0bXSL/5GKBK+3NUGJKhqTPxIxa/uAIgvUYpB
         iLtuR0ei+IHQKtumtXrCJTVjBOaB/xbe2c4ADaSMlKjECKiq+8Z/ae5jWVnkFPGblM
         PK+2+1z3wn+Hg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        f.fainelli@gmail.com, andrew@lunn.ch, rdunlap@infradead.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 0/2] netdev doc de-FAQization
Date:   Thu, 22 Dec 2022 11:22:46 -0800
Message-Id: <20221222192248.1265007-1-kuba@kernel.org>
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

We have outgrown the FAQ format for our process doc.
I often find myself struggling to locate information in this doc,
because the questions do not serve well as section headers.
Reformat the document.

v2: update the headers
v1: https://lore.kernel.org/all/20221221184007.1170384-1-kuba@kernel.org/

Jakub Kicinski (2):
  docs: netdev: reshuffle sections in prep for de-FAQization
  docs: netdev: convert to a non-FAQ document

 Documentation/process/maintainer-netdev.rst | 369 +++++++++++---------
 1 file changed, 199 insertions(+), 170 deletions(-)

-- 
2.38.1

