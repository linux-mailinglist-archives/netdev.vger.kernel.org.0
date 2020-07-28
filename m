Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97767230308
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgG1GhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgG1GhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:37:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD218C0619D5
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 23:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=KiDTP41sE4uzumSoS4cvzqJRNtAsd1A53AOdngHd+Jk=; b=uJ0n8utbhWow6lBE2UjCIdpFCG
        7xOYlgCQphgzjtpWp8U+rdlkaOKCgDGQvmsbB3A78e+vM6f3UF2AHNuipTo0d6CbwwjjyTaNXTdLX
        yVyARSuM6h27HF4DXtjLF9dNzu1GsAYEpWngzAM2kckMznYDikPpVo4pYbsNdwHf76zHxCeIWRYHB
        n9jC/fqZcDfSd/ml22IR93h+ihqQjOEj/hgM7oDPIO1Nk/QVIEPpRymjlFHW2nU6qCWXLH4+Mm8vV
        32SG5n0A3Ck06F5hjaCdhyiLNgARo0kBG39xxOa9e1f1NeNnT2wOZFYbm4Z5mzcF8pQwGv5wVSJrV
        p1cAhfeA==;
Received: from [2001:4bb8:180:6102:7902:553b:654a:8555] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0JEC-0006je-DF; Tue, 28 Jul 2020 06:36:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jan Engelhardt <jengelh@inai.de>, Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Laight <David.Laight@ACULAB.COM>, netdev@vger.kernel.org
Subject: [PATCH 0/4 net-next] sockptr_t fixes
Date:   Tue, 28 Jul 2020 08:36:39 +0200
Message-Id: <20200728063643.396100-1-hch@lst.de>
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
