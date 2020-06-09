Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4081F390C
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 13:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgFILJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 07:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbgFILJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 07:09:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760DDC05BD1E;
        Tue,  9 Jun 2020 04:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jzlGHVTHxHocaBNnVtWkIwZrj7yO/ADtEgfhe970dr4=; b=HlftRkd+efYJpZYlbgE32i9wn+
        7aRy9RCVjvkXe262spiOpmcVXldxbLW7/W5eyOq9mvWooSAG/hcztag1XNy4s0gXBYEIv1gcOoyO2
        zrBjMdqcH5Ek+oSdQdd1dejxY3IBaOgYUPrTAHFhJx3IFdrGCMnlGCyfXq1w2U14RudltTDExUbsr
        GJSNOz4/zHKBwH0/gwBkkf+NO7Bbshuq3RFwe0ldmA0t2uoKvfBHPU+aOG9td0tWJoKfJiPGF00pV
        watWjdSNArWtDhX0Mbr9Ujl7T3aHwjfpHvsF+t7bDMIvuVOhuPRWBCvr+RlgBosN86SBvFV+IFiGN
        ZxdQjVhw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jic7q-0008MC-0t; Tue, 09 Jun 2020 11:09:02 +0000
Date:   Tue, 9 Jun 2020 04:09:01 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 1/7] Documentation: dynamic-debug: Add description of
 level bitmask
Message-ID: <20200609110901.GZ19604@bombadil.infradead.org>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
 <20200609104604.1594-2-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609104604.1594-2-stanimir.varbanov@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 01:45:58PM +0300, Stanimir Varbanov wrote:
> +level
> +    The given level will be a bitmask ANDed with the level of the each ``pr_debug()``
> +    callsite. This will allow to group debug messages and show only those of the
> +    same level.  The -p flag takes precedence over the given level. Note that we can
> +    have up to five groups of debug messages.

That doesn't sound like a "level".  printk has levels.  If you ask for
"level 3" messages, you get messages from levels 0, 1, 2, and 3.  These
seem like "types" or "groups" or something.

> +  // enable all messages in file with 0x01 level bitmask
> +  nullarbor:~ # echo -n 'file foo.c level 0x01 +p' >
> +                                <debugfs>/dynamic_debug/control
