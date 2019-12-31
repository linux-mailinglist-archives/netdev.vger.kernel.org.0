Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C69F512DA74
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 18:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfLaRGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 12:06:16 -0500
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:35522 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfLaRGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 12:06:16 -0500
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 952A435F9A2;
        Tue, 31 Dec 2019 17:56:57 +0100 (CET)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1imKpF-00054q-0L; Tue, 31 Dec 2019 17:56:57 +0100
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH ipsec 0/2] ipsec interfaces: fix sending with bpf_redirect() / AF_PACKET sockets
Date:   Tue, 31 Dec 2019 17:56:52 +0100
Message-Id: <20191231165654.19434-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before those patches, packets sent to a vti[6]/xfrm interface via
bpf_redirect() or via an AF_PACKET socket were dropped, mostly because
no dst was attached.

 net/ipv4/ip_vti.c         | 10 ++++++++--
 net/ipv6/ip6_vti.c        | 11 +++++++++--
 net/xfrm/xfrm_interface.c | 21 +++++++++++++++++----
 3 files changed, 34 insertions(+), 8 deletions(-)

Regards,
Nicolas

