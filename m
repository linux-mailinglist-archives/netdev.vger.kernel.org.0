Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F23E30F68
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 15:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfEaN6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 09:58:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44674 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbfEaN6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 09:58:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version
        :Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k7IVqDDw4ppIRgm5C/mOfj3zszuzw71YzhqJAhhpang=; b=OWNUf0PMuGTJ+uER7MyLJO7zoK
        SKbQ8VKEAWuTR6wYx3/YgAqDxlQwthcsxJGTjTZdwdWsW5aPRLrDW7Go8T9m9fdvlFwlDIq23agBx
        3vJ9eMfT9mIiAXGf/cKc4m20IOj6RtA2Ww5cVH4OIPv6M/Y4+MCBaM2A6R4qEyvJ2Q/M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWi3F-0006Bk-Hn; Fri, 31 May 2019 15:58:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     linville@redhat.com
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 0/2] Add 100BaseT1 and 1000BaseT1
Date:   Fri, 31 May 2019 15:57:46 +0200
Message-Id: <20190531135748.23740-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Import the latest ethtool.h and add two new links modes.

v2:
Move the new speeds to the end of the all_advertised_modes_bits[].
Remove the same_line bit for the new moved
Add the new modes to the man page.

Andrew Lunn (2):
  ethtool: sync ethtool-copy.h with linux-next from 30/05/2019
  ethtool: Add 100BaseT1 and 1000BaseT1 link modes

 ethtool-copy.h | 7 ++++++-
 ethtool.8.in   | 2 ++
 ethtool.c      | 6 ++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

-- 
2.20.1

