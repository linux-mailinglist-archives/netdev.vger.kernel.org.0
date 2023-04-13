Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429776E11BC
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjDMQHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDMQHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:07:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A46FAF19;
        Thu, 13 Apr 2023 09:06:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2553263FAE;
        Thu, 13 Apr 2023 16:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5FAC43445;
        Thu, 13 Apr 2023 16:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681402018;
        bh=7UpSyVAtwNT84JAbWIX2mRz/svkFLEyQ1Y2JkSBuIVA=;
        h=From:To:Cc:Subject:Date:From;
        b=D3tQKpG2VpnTOBodwzCy8ERn4FwU616rfzFwb7EWsmaymvQF12ssQX7yMgrfZ3gZC
         eyZUWaFTZrdnAQV4MKv42bdnMzsiBNwgDkHcggjpKmG4XRF21uo3hYzd2QjNWJiPYQ
         4emV66AMgclMPo1fEBnRCl5M9y2fezkPn7f3UaJz7Mq3DmhwMMqIE0cn2zlG5Se3MX
         0e0QgV0YwPel3j2pFbK3sHWWtfE9QrfnKcfsTLEKT2t9w/zJ+BICh480svNygb2LdN
         a6QT87i0Ol0BNbNbdcVD6kRpUr68GDnPIqAfebkHSpGm2Qu8NxDpxQxR3jgOI0L2K0
         KMgwLCr0+qACQ==
From:   broonie@kernel.org
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the origin tree
Date:   Thu, 13 Apr 2023 17:06:53 +0100
Message-Id: <20230413160654.3996931-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/bpf/prog_tests/sockmap_listen.c

between commit:

  989cdc373248a ("bpf: sockmap, pull socket helpers out of listen test for general use")

from the origin tree and commit:

  d61bd8c1fd02c ("selftests/bpf: add a test case for vsock sockmap")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.


diff --cc tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index f3913ba9e899c,8f09e1ea3ba75..0000000000000
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
