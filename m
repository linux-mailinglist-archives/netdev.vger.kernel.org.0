Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39A764EA6DB
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiC2FKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232263AbiC2FK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:10:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF525F47;
        Mon, 28 Mar 2022 22:08:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C46FB8128D;
        Tue, 29 Mar 2022 05:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9474C340ED;
        Tue, 29 Mar 2022 05:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648530524;
        bh=FH30I/+90xj9+ExVg/IDvXRKvmY1i4pHLOpoqwg9xyA=;
        h=From:To:Cc:Subject:Date:From;
        b=cIDcjADg5wKV8TUTSbqq/0mGRjJDt84FAcnFwlk32tMJgvfUCHvIJd05mNcuDPEc5
         vGaODZ/P0HiOv2mFE3D265AqNg0BcIBrHPyifUrcXIpSRuV/RxDdwUtbjUvJZdLwP6
         ia/9OlPgPYFHxa0bof53VOW0ckWYTjuMn8XfQ/H8EhJ+QIDMGQVfRkMM+1Fxnblgr1
         otA/2e0ECR1yNbI1o3hgr22rpnI2yRzjALnTN1bhnwJJW8g8SMgXsEjCK4SAKRCqLN
         tDv1tvTbeMYNdAd2BBGqymx/7gLMbmzeOSqELBWTdGzI5JEUdgoT3V4bA0UxOkyW3T
         /Xv4SlIcWp5og==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 00/14] docs: update and move the netdev-FAQ
Date:   Mon, 28 Mar 2022 22:08:16 -0700
Message-Id: <20220329050830.2755213-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

v2: remove non-git in patch 3
    add patch 5

Jakub Kicinski (14):
  docs: netdev: replace references to old archives
  docs: netdev: minor reword
  docs: netdev: move the patch marking section up
  docs: netdev: turn the net-next closed into a Warning
  docs: netdev: note that RFC postings are allowed any time
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
 rename Documentation/{networking/netdev-FAQ.rst => process/maintainer-netdev.rst} (75%)

-- 
2.34.1

