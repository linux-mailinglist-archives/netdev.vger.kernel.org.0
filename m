Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05874E850B
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 04:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiC0Czt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 22:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbiC0Czq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 22:55:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF29DFD8;
        Sat, 26 Mar 2022 19:54:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C4E460EC7;
        Sun, 27 Mar 2022 02:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5F2C340E8;
        Sun, 27 Mar 2022 02:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648349648;
        bh=Bx8vRJo8BZLqD2FbKxf4j8jrurF4ZgI7QwiWZ7HUvC4=;
        h=From:To:Cc:Subject:Date:From;
        b=Lo+9Csz5mR3xcGpLtPJlDQwfFznFfTXS+FbnD/VNbAnMkWvbCItWB+rTYG9Oyxyim
         chsIMYiEdW4xYaI32HkJgjVSiVS5C+2VK3gbYba3P7/r7nl0qYN5q5CELBDlbBbPGq
         NFycScYZb9T6lOEJJCQBK2ltvhQtg4cndYT7CZjCOwWT/C+WDkloFhQzphcxvTtJ6R
         FnRoGPxQ54CpLH74NFdkjXpzezzoIe+zwdCF2bCM7Gc3AACVfRaN7DAZ048ru2YPsm
         DcieZFSbGhtGHkeiqzmqve/LfOK7dEOfh7NcH5K8wxo6LjyX34zUcXqOHR2bEpsCu/
         kHr1BIh4xKGCw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 00/13] docs: update and move the netdev-FAQ
Date:   Sat, 26 Mar 2022 19:53:47 -0700
Message-Id: <20220327025400.2481365-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A section of documentation for tree-specific process quirks had
been created a while back. There's only one tree in it, so far,
the tip tree, but the contents seem to answer similar questions
as we answer in the netdev-FAQ. Move the netdev-FAQ.

Take this opportunity to touch up and update a few sections.

Jakub Kicinski (13):
  docs: netdev: replace references to old archives
  docs: netdev: minor reword
  docs: netdev: move the patch marking section up
  docs: netdev: turn the net-next closed into a Warning
  docs: netdev: shorten the name and mention msgid for patch status
  docs: netdev: rephrase the 'Under review' question
  docs: netdev: rephrase the 'should I update patchwork' question
  docs: netdev: add a question about re-posting frequency
  docs: netdev: make the testing requirement more stringent
  docs: netdev: add missing back ticks
  docs: netdev: call out the merge window in tag checking
  docs: netdev: broaden the new vs old code formatting guidelines
  docs: netdev: move the netdev-FAQ to the process pages

 Documentation/bpf/bpf_devel_QA.rst            |   2 +-
 Documentation/networking/index.rst            |   3 +-
 .../process/maintainer-handbooks.rst          |   1 +
 .../maintainer-netdev.rst}                    | 114 +++++++++++-------
 MAINTAINERS                                   |   1 +
 5 files changed, 73 insertions(+), 48 deletions(-)
 rename Documentation/{networking/netdev-FAQ.rst => process/maintainer-netdev.rst} (76%)

-- 
2.34.1

