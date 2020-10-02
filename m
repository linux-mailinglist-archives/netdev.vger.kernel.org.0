Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7FC280F91
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 11:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387679AbgJBJJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 05:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgJBJJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 05:09:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3839CC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 02:09:56 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOH4a-00F9QD-Rk; Fri, 02 Oct 2020 11:09:52 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/5] genetlink: complete policy dumping
Date:   Fri,  2 Oct 2020 11:09:39 +0200
Message-Id: <20201002090944.195891-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

So ... Jakub added per-op policy retrieval, so you could retrieve the
policy for a single op.

This then adds - as discussed - support for dumping *everything*, which
has basically first an [op] -> [policy-idx] mapping, followed by all the
policies. When a single op is requested, you get a convenience [op] -> 0
mapping entry, but you might as well ignore it since the policy for the
requested op is guaranteed to be 0.

This series applies on top of Jakub's series, but I've fixed up his to
apply on top of my bugfix (let me know how you want to handle that).

For convenience, I've pushed the entire series here:

https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/log/?h=genetlink-op-policy-export
(I hope the cache will be invalidated soon, but anyway, in mac80211-next
genetlink-op-policy-export branch)

I didn't want to repost Jakub's slightly modified patches just for that.
Depending on how we decide to deal with the conflicts, we may or may not
need that series.

johannes


