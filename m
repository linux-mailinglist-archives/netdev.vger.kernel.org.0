Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629BA664921
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 19:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbjAJSSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 13:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239207AbjAJSRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 13:17:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691EFB7D0
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 10:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6B6tMUKCmC9VSSZB9ZPdywW22zmbmtm0Zt/EUWQj5cE=; b=Nt+vPSemvsHjtCT3KUmQnK7QEo
        dd2rUrELC7E8jOvrbtXwQIjaWeX6VKlxFgQlP9Qltr8/FzUKU7H52ItEr4nA1yWbTgGqmyoL1Kgqn
        oE25+U8QrnzxLwu4pETWr3tx8kZnUhPPTaUE+/qO0pJ3URaps63fCTdtFQWtLGjCQelAcxH9b7dkZ
        /B5qqInT1NOi7ZHXuVfPWkBptGb6hFxxc6Hz8AeKBc+oh3K4kVkUjCdh7Hv+iRn7A9GBHcx+YpSsM
        I4P2KlJzrTXJ1kf2YYova908GS0XnSxrFeb8vSUUQRqm2eIuvhnLTW8Ppx6Ybluywn7wVaGzD2K+p
        LdTcFbLg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFJAU-003Qos-RK; Tue, 10 Jan 2023 18:16:14 +0000
Date:   Tue, 10 Jan 2023 18:16:14 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 03/24] page_pool: Add netmem_set_dma_addr() and
 netmem_get_dma_addr()
Message-ID: <Y72rbntNauzuI6+L@casper.infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-4-willy@infradead.org>
 <CAC_iWj+bDVMptma_DjQkCZzcardXxShJ965=6zc0_6ffciQhXw@mail.gmail.com>
 <CAC_iWjK38RHjaPfkBea68MOQHF2R_gUSsLjoHXniyW-ZRMHWMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC_iWjK38RHjaPfkBea68MOQHF2R_gUSsLjoHXniyW-ZRMHWMA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 11:17:35AM +0200, Ilias Apalodimas wrote:
> Ignore this, I just saw the changes in mlx5.  This is fine as is

I should read everything before replying ;-)
