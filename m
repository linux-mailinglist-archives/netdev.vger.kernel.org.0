Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0294B69C528
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjBTGOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBTGOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:14:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D0FCA2A;
        Sun, 19 Feb 2023 22:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=x7M7sReNmGHCI7sXjDHZhgMdVt
        kaJ2KgDitCJ8ylRRzZ59TkfcBa0GsdZnipJjk6e2uh8AauU6XMldxPfoxAECNne5jHrdGuV5+Sqor
        32g25hrWk6yCd5zpmNahbnRZ7JNtuzJ67W5QCS+i1YJplONXFeZyNxwuUrZfywmSnBGct6BNLyd3E
        0x+xKvoxsmD4jsvQIezIYjAUCsD3/WOUlmLmd9qo7iOXxSMNP/DzDMHG/d4NLU3ccWeM7ivZeVowV
        QUh5hQUe0NAa3Phm8rHvjLsg6jlfrAiyWCcaaa4Iexg0MFbC1/mj8km8neQyhlwg6eop/oar4hGL4
        QsX6vwWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pTzRp-0037cr-An; Mon, 20 Feb 2023 06:14:49 +0000
Date:   Sun, 19 Feb 2023 22:14:49 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Thomas Huth <thuth@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Andrew Waterman <waterman@eecs.berkeley.edu>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH 1/4] Move COMPAT_ATM_ADDPARTY to net/atm/svc.c
Message-ID: <Y/MP2YKf6H6ItbTG@infradead.org>
References: <20230217202301.436895-1-thuth@redhat.com>
 <20230217202301.436895-2-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217202301.436895-2-thuth@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
