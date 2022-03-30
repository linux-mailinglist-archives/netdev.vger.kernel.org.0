Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF6E4EB97B
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 06:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242517AbiC3E1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 00:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241100AbiC3E06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 00:26:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CD1DF6A;
        Tue, 29 Mar 2022 21:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D755FB81B31;
        Wed, 30 Mar 2022 04:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C40C340EE;
        Wed, 30 Mar 2022 04:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648614311;
        bh=MGtOjDnQR/PaUdsBmvZaZlbitpr7QGgSaefji6w9W5g=;
        h=From:To:Cc:Subject:Date:From;
        b=ssCashQjYa1SiavsT4vmFL9cqLz/84T0oLGei4RHNgwzALTmdzYCJaEcj9jn2wt0/
         1zU88Ho2fzmTfij3xXQeVOznqAjWpxs6TgLKP7IeYuK98fJpcB4FdF8+LhhWLkiEPs
         m9TYnyTZpnkU4hASSKAg8jVcjeBmETvf1C5YGIgEJB9VR6J8/N0R20l8D+a+1R/3p6
         7yJkofZT0JE20VZJM93waKRfVOJuZsatokZsKLZWjoLZYWwcOGHwkzUDxN6c6JD/pw
         guAvHkP6RmZHOVrVlPvGzOzjhI5o9tLCwHW03/aTFxkV5kPBmJN464KjToGkY5a+hh
         zNkbgtlTTC/yA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v3 00/14] docs: update and move the netdev-FAQ
Date:   Tue, 29 Mar 2022 21:24:51 -0700
Message-Id: <20220330042505.2902770-1-kuba@kernel.org>
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

v3: remove some confrontational? language from patch 7
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

