Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BE76551D1
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 16:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbiLWPDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 10:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236265AbiLWPDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 10:03:02 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3787024BE0;
        Fri, 23 Dec 2022 07:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=taJ0i+7Nxx5EGMviFuL0glHUCiE6Cqkuar1xYPtimWg=; b=eu5UtAuXqQnUtZet6ohjMxkRpj
        2YyT7RAghaQAMTQy2NS6BNaIMxRK2e4Bll3mcM1weeC+Mv5CwfnvMxPxn2od+wlrLs56EjBjlKiVe
        pm5MwN0AexAFClgGmgb0s32Mrar687d4FANiQr21kvlzD2c3vUP7N4DLDXSW396w/NLRll0G+BRl5
        IVUjREi4cSxMhN/8hGC9QTRnSSS7CGuFEFVmXMwBrrooTlxHW4WqCUIUyQtJVty9Il4hGdV/V1J10
        vgkV7IlJaD3C7H+v5ty/NbJHa+d+JE+YMGcRZrbUfZja3VnayhHeAkgiq4vvumUeTe4j9Dagmx9xA
        DAsA0DRA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p8jZV-009ADo-MI; Fri, 23 Dec 2022 15:02:53 +0000
Date:   Fri, 23 Dec 2022 07:02:53 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     yang.yang29@zte.com.cn
Cc:     jirislaby@kernel.org, mickflemm@gmail.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu.panda@zte.com.cn
Subject: Re: [PATCH net-next] ath5k: use strscpy() to instead of strncpy()
Message-ID: <Y6XDHRVgKLbDLPNj@bombadil.infradead.org>
References: <202212231034450492161@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212231034450492161@zte.com.cn>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 10:34:45AM +0800, yang.yang29@zte.com.cn wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL-terminated strings.

According to who? Are you sure you are not just sending stupid commits
to get an increase in your kernel commit count? Because this is an old
driver and who cares?

  Luis
