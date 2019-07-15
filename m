Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D98686C3
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 12:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfGOKAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 06:00:33 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:35100 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729257AbfGOKAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 06:00:32 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id ECDE12E8833;
        Mon, 15 Jul 2019 12:00:30 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1hmxmY-0002E3-M2; Mon, 15 Jul 2019 12:00:30 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH ipsec v2 0/4] xfrm interface: bugs fixes
Date:   Mon, 15 Jul 2019 12:00:19 +0200
Message-Id: <20190715100023.8475-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <df990564-819a-314f-dda6-aab58a2e7b6e@6wind.com>
References: <df990564-819a-314f-dda6-aab58a2e7b6e@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here is a bunch of bugs fixes. Some have been seen by code review and some when
playing with x-netns.
The details are in each patch.

v1 -> v2:
 - add patch #3 and #4

 include/net/xfrm.h        |  2 --
 net/xfrm/xfrm_interface.c | 56 +++++++++++++++++++++--------------------------
 2 files changed, 25 insertions(+), 33 deletions(-)

Regards,
Nicolas

