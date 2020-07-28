Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9A4230FF4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731667AbgG1Qiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731650AbgG1Qit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 12:38:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578B6C0619D5
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 09:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=dWVWdJPZPQ01tnSr9hfYRwXVpsnEuhKQTIrTELkOEWg=; b=KSjeT5wr+8sZq98a3fRZBiifKv
        ktms0QBs0yqDGjwEl09xWrgmoLgmfjyvXlkBtP6FHvQttWopK9TsUYGSKd83ldc04V2TyT5cgqqGY
        mR+kUV6Adn4C7UV2Tu+Yv+fFdM0jvIMHdtpQjlysphiPnsZDFFsuJjXoJMxfk/JHXyomOl2soQ2G/
        Vrtrx39zSZX8TIJD8cKi4ZA3D8LkeuzcQsR7wUnfVOOmMdIqMr8RUNaY7szyVc6NJLGJ2o3Ju4pID
        oFoSRdXJoAvagRmLdWp0VrONS0g5enj1sFN+ZFsZ8/S/DRFFapjv0JS9GYM5vUNjWbxKy5vmHwBH0
        vZ9UFcWw==;
Received: from [2001:4bb8:180:6102:fd04:50d8:4827:5508] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0Scf-0007W9-It; Tue, 28 Jul 2020 16:38:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jan Engelhardt <jengelh@inai.de>, Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Laight <David.Laight@ACULAB.COM>, netdev@vger.kernel.org
Subject: [PATCH 0/4 net-next] sockptr_t fixes v2
Date:   Tue, 28 Jul 2020 18:38:32 +0200
Message-Id: <20200728163836.562074-1-hch@lst.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

a bunch of fixes for the sockptr_t conversion


Changes since v1:
 - fix a user pointer dereference braino in bpfilter
