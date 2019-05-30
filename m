Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC1730177
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfE3SG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:06:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42242 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfE3SGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 14:06:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version
        :Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QD4B3Q1lOq4UBrpWM8gCbKN6W2aET31FB0SdKmLb+kc=; b=jR9JLRFmuVgmfNEDaf1Mkcjn7w
        jv30fJP1zi73PcEZ4w7HKi/YQqbiWCLtkUDy50q74JElSG5rq1Z2Mh/qSz53du+ORUg5mQHRr7rqP
        Oio+HETIizYtTbzUMan6go5JLGVYw1BYnF5RomdyqokHAxwYDan4x2riabWGPT5Gdb14=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWPRX-0000Oi-Hk; Thu, 30 May 2019 20:06:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     linville@redhat.com
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 0/2] Add 100BaseT1 and 1000BaseT1
Date:   Thu, 30 May 2019 20:06:14 +0200
Message-Id: <20190530180616.1418-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Import the latest ethtool.h and add two new links modes.

Andrew Lunn (2):
  ethtool: sync ethtool-copy.h with linux-next from 30/05/2019
  ethtool: Add 100BaseT1 and 1000BaseT1 link modes

 ethtool-copy.h | 7 ++++++-
 ethtool.c      | 6 ++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

-- 
2.20.1

