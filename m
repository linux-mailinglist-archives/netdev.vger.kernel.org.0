Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3CC6B7BB2
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 16:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjCMPQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 11:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCMPQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 11:16:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C41E2CFF1;
        Mon, 13 Mar 2023 08:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=eQO4dib77fwpq45HsemPbGF1tK
        B+NFfyH2P44jYfEUE2nMfCjsiuccczw3afR9tVukGid8aWh+Dhr0Ge4SUC7rA3i3QGZUze1NCFOuC
        7hajc8KEK+DKGhs5uaaxOEdT+81HoJHQ7wS/CaaLQRvxZVuJyNM/TmIi+MMMW9Sp0lmJJMPD4D7Qv
        eH8OGlLUx3OFWfk+ss5Cr5HccxxTQ4eXFEdOmPRMw5LDoJSfEss0qEYzF0mWlD+S0m81gtRguFJaK
        5DBrYDs2GoivzyJpWBK68NPJw5e1NWZ48ogQyGOfLyvmp0IxwBF0o5oMXS3ZWghCUeU8fl1DIVNk/
        7YM738OQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pbjuP-006OLK-TF; Mon, 13 Mar 2023 15:16:21 +0000
Date:   Mon, 13 Mar 2023 08:16:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Thomas Huth <thuth@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/5] pktcdvd: Remove CONFIG_CDROM_PKTCDVD_WCACHE from
 uapi header
Message-ID: <ZA8+RdetyyaNd539@infradead.org>
References: <20230310160757.199253-1-thuth@redhat.com>
 <20230310160757.199253-5-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310160757.199253-5-thuth@redhat.com>
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
