Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22865EF23D
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbiI2JiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 05:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbiI2JiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:38:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987126421;
        Thu, 29 Sep 2022 02:38:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BEF960022;
        Thu, 29 Sep 2022 09:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4B9C433C1;
        Thu, 29 Sep 2022 09:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664444283;
        bh=1jp7G5YeIFk6R583OyEfuXLFd7weNod/Eu3ajmd7lSk=;
        h=From:To:Cc:Subject:Date:From;
        b=kyi+BVuW5x/JOoECf5YJHsEZJ7qBns5AtF6uH9rAqothMkbNZsPDc09u7ChqZtvZF
         wZKb0LwJhtgHZq4CwQG7IiuZ4f9B22Cj6pQE5HwQ7RCbkBZxp+xqsUMADC0I575Xv6
         q/gL9og0Ez3ILyFgFGWndfsxaZZ/Mo/MReUxOWVZTwe6909TAFy0gQILAmJEZA0Vcn
         Ci8S1/Y2jAw0brT9azN9PFZzvuoZ7DmmdBF2uwGu5tw1JKRQVt17Fln5KfmbZ279eW
         gv8+PCpzwf3pNiqfH9x/0BVvhRCZh6OqCYz04sYodSxv7SzjXges8z0bNbkrFZj9xQ
         2qKblppR/QvHA==
From:   Leon Romanovsky <leon@kernel.org>
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux_oss@crudebyte.com, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Dominique Martinet <asmadeus@codewreck.org>,
        syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, lucho@ionkov.net, netdev@vger.kernel.org
Subject: [PATCH 0/2] Fix to latest syzkaller bugs in 9p area
Date:   Thu, 29 Sep 2022 12:37:54 +0300
Message-Id: <cover.1664442592.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is followup to our discussion https://lore.kernel.org/all/YzVIGuISTnIFSIs9@codewreck.org/
with fixes to two syzkaller bugs in 9p.

It is based on linux-next.

Leon Romanovsky (2):
  Revert "9p: p9_client_create: use p9_client_destroy on failure"
  9p: destroy client in symmetric order

 net/9p/client.c | 47 +++++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

-- 
2.37.3

