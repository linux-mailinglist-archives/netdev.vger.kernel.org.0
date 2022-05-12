Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B375252A9
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356507AbiELQeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356300AbiELQep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:34:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2730420790C;
        Thu, 12 May 2022 09:34:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1F74B829F1;
        Thu, 12 May 2022 16:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FFCC385B8;
        Thu, 12 May 2022 16:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652373282;
        bh=qQZ/4IJfWJrhYXw2NQJHQT8gc8yChdQ8DtYqoF0wlRk=;
        h=From:To:Cc:Subject:Date:From;
        b=bnTiUDcMTAHiJPgcDPuamRXxhRXTT9tgeIz6PLM7ZPctt9i2azb1fIRmKbHZf+WQN
         bhoJqCW+10LlRMr28jIWPnpPYVfU4KJHhHbMNXxb6v+J9Mjnz14rwL3wb0WpthA+gZ
         pw/9asrRnoF9T+rjMMX2bULyoDPzWIt++DcvmC6f6IUJFxKNlLKuon8BB+X9kX8uhq
         SFPqpbLsOZ8RtEhatkF0OX7HP1c7gjO5zQn4JGm5fl8GHeyNXfOTir/XhlPPUTdjwM
         dMEcx1q9FYdr6K712zXxYSdjL2U+P9OD+bFWN9h+QCxzoDueIG+XHQVZcobjxzLe3d
         sO4jXi0rF7tdQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, toke@redhat.com, memxor@gmail.com
Subject: [PATCH v2 bpf-next 0/2] net: netfilter: add kfunc helper to update ct timeout
Date:   Thu, 12 May 2022 18:34:09 +0200
Message-Id: <cover.1652372970.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes since v1:
- add bpf_ct_refresh_timeout kfunc selftest

Lorenzo Bianconi (2):
  net: netfilter: add kfunc helper to update ct timeout
  selftests/bpf: add selftest for bpf_ct_refresh_timeout kfunc

 include/net/netfilter/nf_conntrack.h          |  1 +
 net/netfilter/nf_conntrack_bpf.c              | 20 +++++++++++++++++
 net/netfilter/nf_conntrack_core.c             | 21 +++++++++++-------
 .../testing/selftests/bpf/prog_tests/bpf_nf.c | 10 +++++++++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 22 +++++++++++++++++++
 5 files changed, 66 insertions(+), 8 deletions(-)

-- 
2.35.3

