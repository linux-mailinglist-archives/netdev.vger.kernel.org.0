Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C471F664E69
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbjAJWAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjAJWAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:00:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F25633A6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 14:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6P66+VNIdr5G9uibWlsPmMqdEbdC35MlJdCLgO4TDiU=; b=GBTzrVZWBoaRSn4kpQqMMg6hcJ
        QjoDWlSPcQfAbLAsHsavSjxwW22lyUV2L5ByFhZtr4TF3WxtzJ9bOnpW0HFkCIdxKluuusSMs3keM
        v+JAC75Rf43kiWib4/TkCt3WRi0Q3S8BuU6e2SzOzCcFJ+HYXG4wfXgvWMdEXXps1vHTvOI0ok1IQ
        isuRzBEELhTmkRbc7uoBCRF8ReKkyWPAryGxecc2rVJu+aJoHArvztm+Gsg4YXXUSswZSubyyiGvt
        HJcFcObvHwLeQWTReLYCjMNanHEBwg4gyGHlEXi7GAQvPZXMZEDB5Lz8x604I70C10UVuFdI2ysk9
        UqNtlGWg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFMfm-003ZDK-1G; Tue, 10 Jan 2023 22:00:46 +0000
Date:   Tue, 10 Jan 2023 22:00:45 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 15/24] page_pool: Remove page_pool_defrag_page()
Message-ID: <Y73gDakyrPx+C0H9@casper.infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-16-willy@infradead.org>
 <Y700Jp6rWBzNYRdf@hera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y700Jp6rWBzNYRdf@hera>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 10, 2023 at 11:47:18AM +0200, Ilias Apalodimas wrote:
> On Thu, Jan 05, 2023 at 09:46:22PM +0000, Matthew Wilcox (Oracle) wrote:
> > -__page_pool_put_page(struct page_pool *pool, struct page *page,
> > -		     unsigned int dma_sync_size, bool allow_direct)

Wow, neither of you noticed that the subject line mentioned the wrong
function ;-)  I'm taking your R-b and A-b tags anyway ;-)
