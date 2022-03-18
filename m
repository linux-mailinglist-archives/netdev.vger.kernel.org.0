Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4984DDCBB
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 16:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237926AbiCRPZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 11:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237628AbiCRPZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 11:25:40 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B6CAC055;
        Fri, 18 Mar 2022 08:24:20 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nVESg-000DEj-Lb; Fri, 18 Mar 2022 16:24:18 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-03-18
Date:   Fri, 18 Mar 2022 16:24:18 +0100
Message-Id: <20220318152418.28638-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26485/Fri Mar 18 09:26:47 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

The following pull-request contains BPF updates for your *net* tree.

We've added 2 non-merge commits during the last 18 day(s) which contain
a total of 2 files changed, 50 insertions(+), 20 deletions(-).

The main changes are:

1) Fix a race in XSK socket teardown code that can lead to a NULL pointer
   dereference, from Magnus.

2) Small MAINTAINERS doc update to remove Lorenz from sockmap, from Lorenz.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Björn Töpel, Elza Mathew

----------------------------------------------------------------

The following changes since commit caef14b7530c065fb85d54492768fa48fdb5093e:

  net: ipa: fix a build dependency (2022-02-28 11:44:27 +0000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 18b1ab7aa76bde181bdb1ab19a87fa9523c32f21:

  xsk: Fix race at socket teardown (2022-02-28 15:39:53 +0100)

----------------------------------------------------------------
Lorenz Bauer (1):
      bpf: Remove Lorenz Bauer from L7 BPF maintainers

Magnus Karlsson (1):
      xsk: Fix race at socket teardown

 MAINTAINERS   |  1 -
 net/xdp/xsk.c | 69 +++++++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 50 insertions(+), 20 deletions(-)
