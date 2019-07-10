Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18AEF64302
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 09:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfGJHpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 03:45:42 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:44448 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfGJHpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 03:45:42 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 3F5802E41CD;
        Wed, 10 Jul 2019 09:45:40 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1hl7IK-0001yQ-4U; Wed, 10 Jul 2019 09:45:40 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH ipsec 0/2] xfrm interface: bug fix on changelink
Date:   Wed, 10 Jul 2019 09:45:34 +0200
Message-Id: <20190710074536.7505-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are two bug fix seen by code review. The first one avoids a corruption of
existing xfrm interfaces and the second is a minor fix of an error message.

 include/net/xfrm.h        |  1 -
 net/xfrm/xfrm_interface.c | 20 ++++++--------------
 2 files changed, 6 insertions(+), 15 deletions(-)

Regards,
Nicolas

