Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9C923D184
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725372AbgHEUB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbgHEQkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:40:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA4FC0A889E;
        Wed,  5 Aug 2020 07:04:19 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k3K1h-00GoxW-S9; Wed, 05 Aug 2020 16:04:18 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC 0/4] netlink: binary attribute range validation
Date:   Wed,  5 Aug 2020 16:03:20 +0200
Message-Id: <20200805140324.72855-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is something I'd been thinking about for a while; we already
have NLA_MIN_LEN, NLA_BINARY (with a max len), and NLA_EXACT_LEN,
but in quite a few places (as you can see in the last patch here)
we need a range, and we already have a way to encode ranges for
integer ranges, so it's pretty easy to use that for binary length
ranges as well.

So at least for wireless this seems useful to save some code, and
to (mostly) expose the actual limits to userspace via the policy
export that we have now.

What do you think?

johannes


