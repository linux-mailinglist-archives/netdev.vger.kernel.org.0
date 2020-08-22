Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B182124EA48
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 01:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgHVXQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 19:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgHVXQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 19:16:11 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A3FC061573;
        Sat, 22 Aug 2020 16:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=1DaLBWDRNGrft4F1MDGX2ruiGpGJOJTjcKpZcnTIK6Q=; b=e8C+TAj22wRjAWi15ZcM7CAjr7
        VDrJMNdYsaS4ZTCZ+6TnA2y5GzFWXmu+NymNhno7RjX6ptbt2vSZN7FoDbBojRm3r/bJBEALBuvEl
        u/R4D/BwuMCb5Iq3Oy2K/yxG4FayHHuEs1iXQAIe3fRxyhJHBf9bWXZ8QBgOf4k4SYtt30n5Da4rY
        ZY+gKx9z66Mb1sHHGb5ggUu694VStX+LycXVUSm+nvNcIGhAyKE6oPskHjQgqfNDgG4jCA7FUTvhX
        h4LGLLR3qiTQJeshNwL0pABjKmN2HnRIAGxKCldxXIYxsQjqJOQ0jTXVgby8q05LTPheQM0NHUelp
        I1N9NEvw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9ck2-0006VD-0d; Sat, 22 Aug 2020 23:16:06 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 0/7] net: sctp: delete duplicated words + other fixes
Date:   Sat, 22 Aug 2020 16:15:54 -0700
Message-Id: <20200822231601.32125-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop or fix repeated words in net/sctp/.

Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: linux-sctp@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>


 net/sctp/associola.c     |    4 ++--
 net/sctp/auth.c          |    4 ++--
 net/sctp/bind_addr.c     |    2 +-
 net/sctp/chunk.c         |    2 +-
 net/sctp/protocol.c      |    8 ++++----
 net/sctp/sm_make_chunk.c |    6 +++---
 net/sctp/ulpqueue.c      |    2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)
