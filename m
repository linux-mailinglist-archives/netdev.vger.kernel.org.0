Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFB21F3940
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 13:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgFILN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 07:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbgFILNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 07:13:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8449C05BD1E;
        Tue,  9 Jun 2020 04:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gcscR0Yfazu+mbRWZ4zmH8mLd3Y4emKJd4hyLaHgeiA=; b=Mr+GK9aS7fz437C7cOrYK/MY5w
        50scOJQ+OTdg0V4MZ6Onm4Kt2MnDEDupATCyukVE6ovW8GxEOUEfu4R5lgi7E3AyG7jcYUm0cA9Mh
        RxaMLKaLK+YtF9vjPhUwvtx11fK5/s/a/diWQasD3/Y1AgO/dzXf5vQuo5CjarB94r57raU5/N6Jp
        nouKAYmEak6wfqqPYL2HDFuFhHdoeMZ5QXwUYPFY4EyjJ12AKeYLtKR9nRwNIECIS1Zx44elCRfFa
        BZbr9vQMkd7IZshsNgsJQMiJc+T0VCPn2ZllAqJlXROPA96sWCWB6A+tJLlnpIPulPfogqWVBRHDa
        5pF+ytLg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jicC3-0003ai-GS; Tue, 09 Jun 2020 11:13:23 +0000
Date:   Tue, 9 Jun 2020 04:13:23 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v3 0/7] Venus dynamic debug
Message-ID: <20200609111323.GA19604@bombadil.infradead.org>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 01:45:57PM +0300, Stanimir Varbanov wrote:
> Here is the third version of dynamic debug improvements in Venus
> driver.  As has been suggested on previous version by Joe [1] I've
> made the relevant changes in dynamic debug core to handle leveling
> as more generic way and not open-code/workaround it in the driver.
> 
> About changes:
>  - added change in the dynamic_debug and in documentation
>  - added respective pr_debug_level and dev_dbg_level

Honestly, this seems like you want to use tracepoints, not dynamic debug.
