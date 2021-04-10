Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1B435B082
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 22:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbhDJUxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 16:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhDJUxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 16:53:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A0FC06138A;
        Sat, 10 Apr 2021 13:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=HTkpYNC2wTW6Zm43v2gmt2r8ARHTWf8+PnXOPO0doXI=; b=Ozahz+ujymLR6HRV/gUOZ0gS1P
        BDxgLs4uWmYMJEQ30kO1xYpxSOZuU3h08C7SIYNtLc/oIaEOgoADxjaJUBMDXKILVtnjSouZO/lPQ
        aNoJocoo0y+OakKVQFsGfNC6hCM05ztUqOsU3MOgwCGgy+1ypt/X4LiFKiLuwLF6p6spu4OyVf58l
        N5OKNtz1OCrsxBpSOE3NlX8z2plRdlW/ReN3u5na5rvYaJXfHDHZUmcZ+kaml3vrQ2iuDTwWob/C3
        MwFjTKUtdre3pEAuqIyXnRJCGrKsKCsCGWHfLX1nMevAlwYQof1vRaKjR1TB0qnKxtw8nmsW7AiZW
        zeNaEQmQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lVKb2-0027v9-QT; Sat, 10 Apr 2021 20:52:57 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH 0/1] Fix struct page layout on 32-bit systems
Date:   Sat, 10 Apr 2021 21:52:44 +0100
Message-Id: <20210410205246.507048-1-willy@infradead.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'd really appreciate people testing this, particularly on
arm32/mips32/ppc32 systems with a 64-bit dma_addr_t.

Matthew Wilcox (Oracle) (1):
  mm: Fix struct page layout on 32-bit systems

 include/linux/mm_types.h | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

-- 
2.30.2

