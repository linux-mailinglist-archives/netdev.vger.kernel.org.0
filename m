Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A47B69C534
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjBTGPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjBTGPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:15:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB83CC16;
        Sun, 19 Feb 2023 22:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JSBx0Cyr0uWpOht2VzVwK6OCKh
        Q0QsCqKIdCRlkyCtDzFIcOnQsSVClvYtl/XTSnDQzmt4cemjApK9cHZo9OQqQCqmAJBvFc4meQas+
        bzBfzIABq2917+PAvycbDW+BwD5zKsRGm47m5QqFCdKVRhdgy613FIUYC0fQd6Mz7gM16/aqvYiL0
        Pw1GY0h2ykRXAb1nWA/1OkrvCmnXYfHsizRB1eJkepUnSyrZsyHwQjR8alt4PgUa29dfLTB9X7U7Y
        ehH7Ko0jXwYhBtf2TPKqk572rlJniFdWLb8jdLgfCTMPUweOAtYPB0EiZnYFbaqnZEKaPlepQwk5o
        emDnWj8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pTzSj-0037l2-5Y; Mon, 20 Feb 2023 06:15:45 +0000
Date:   Sun, 19 Feb 2023 22:15:45 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Thomas Huth <thuth@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Andrew Waterman <waterman@eecs.berkeley.edu>,
        Albert Ou <aou@eecs.berkeley.edu>
Subject: Re: [PATCH 3/4] Move bp_type_idx to include/linux/hw_breakpoint.h
Message-ID: <Y/MQEUh5cHMzYjDC@infradead.org>
References: <20230217202301.436895-1-thuth@redhat.com>
 <20230217202301.436895-4-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217202301.436895-4-thuth@redhat.com>
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
