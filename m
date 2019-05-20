Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B5B242C6
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 23:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfETVWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 17:22:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59522 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfETVWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 17:22:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ACxGq1M7IZr9P5SOjNrXmj2JEHCx2FH5VHBHcRDvXgE=; b=0lD7tXzo14MtzuLF0wcgWVz0U/
        eQlvMKzoDFBSVwFowb60/CDb7gflfUIvtSGm2idgX7nhK2ZVWcoYmuBEcj6oZhnzGNFg8o4HSpOSb
        MEEk/FrDChLBV7DN/zaIx/JNG3puK+nCH2fOzkot3BqH+jkYz7IZ6fEfkuiiaTHEwyVpTztCOEWYp
        eR3twNWOmLcFhIUJdSQqDcid9fTD+S1lwxk/QBdDssZSxBOpyn53YdBPk5sbNUiWrERVMrGmBui4h
        F968btKSgWvlwgCDomy1zuuUEG7XmZ+jQe7lEKdPYlvX8OTww30bp/yHoR9oqIq6nGJjjo/gUCCZA
        jks4cJeA==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=dragon.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSpjm-0004aE-8h; Mon, 20 May 2019 21:22:26 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] Documentation/networking: fix af_xdp.rst Sphinx warnings
Message-ID: <ba3ef670-a8ff-abfd-5e86-9b14af626112@infradead.org>
Date:   Mon, 20 May 2019 14:22:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix Sphinx warnings in Documentation/networking/af_xdp.rst by
adding indentation:

Documentation/networking/af_xdp.rst:319: WARNING: Literal block expected; none found.
Documentation/networking/af_xdp.rst:326: WARNING: Literal block expected; none found.

Fixes: 0f4a9b7d4ecb ("xsk: add FAQ to facilitate for first time users")

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
 Documentation/networking/af_xdp.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- lnx-52-rc1.orig/Documentation/networking/af_xdp.rst
+++ lnx-52-rc1/Documentation/networking/af_xdp.rst
@@ -316,16 +316,16 @@ A: When a netdev of a physical NIC is in
    all the traffic, you can force the netdev to only have 1 queue, queue
    id 0, and then bind to queue 0. You can use ethtool to do this::
 
-   sudo ethtool -L <interface> combined 1
+     sudo ethtool -L <interface> combined 1
 
    If you want to only see part of the traffic, you can program the
    NIC through ethtool to filter out your traffic to a single queue id
    that you can bind your XDP socket to. Here is one example in which
    UDP traffic to and from port 4242 are sent to queue 2::
 
-   sudo ethtool -N <interface> rx-flow-hash udp4 fn
-   sudo ethtool -N <interface> flow-type udp4 src-port 4242 dst-port \
-   4242 action 2
+     sudo ethtool -N <interface> rx-flow-hash udp4 fn
+     sudo ethtool -N <interface> flow-type udp4 src-port 4242 dst-port \
+     4242 action 2
 
    A number of other ways are possible all up to the capabilitites of
    the NIC you have.


