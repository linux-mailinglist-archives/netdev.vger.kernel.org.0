Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDE2178945
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 04:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCDDy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 22:54:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47988 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgCDDyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 22:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=GC+lj6eenbd2TSJy0cX2Wg1Q0bAHWKP08Cg3HzsZgQk=; b=YO2oevSXeDr0WM3M+AQA3KkkLM
        c6r7LBqrAUZq00VODMib8P8ep3GEmynmZopHTPtTKWgrE1pFjQq6x8Dkcfrka9MlrBJnqfhiKCwzg
        lEq8VKpN3lW9HoT5AOzq1TL+nrNAwaW2ohgR7Jm1hSJO2+8eWFMwIkS+WLjtHvliqhIaEQn/PLUfe
        HRzW/s8dXZV0PjO5fbEqzHrb0SPuZDeOdTRYkgUMc1thgAYcgDA658mtQL/lJd/oHyimGPDG7EYIq
        cpPTrh2o8Vpt+B5BkUD7d0NAJUvARGA3jcyth2wjm1sqbQ7hnmAfAm4VytfW3jzpAFFbnevadTbaH
        shQ1PVKw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9L7X-0001mY-Gm; Wed, 04 Mar 2020 03:54:55 +0000
Date:   Tue, 3 Mar 2020 19:54:55 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>, netdev@vger.kernel.org
Subject: [PATCH] ibmveth: Remove unused page_offset macro
Message-ID: <20200304035455.GA29971@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

We already have a function called page_offset(), and this macro
is unused, so just delete it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 84121aab7ff1..4cad94ac9bc9 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -978,8 +978,6 @@ static int ibmveth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return -EOPNOTSUPP;
 }
 
-#define page_offset(v) ((unsigned long)(v) & ((1 << 12) - 1))
-
 static int ibmveth_send(struct ibmveth_adapter *adapter,
 			union ibmveth_buf_desc *descs, unsigned long mss)
 {

