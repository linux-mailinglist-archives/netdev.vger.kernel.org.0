Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D9667F523
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 07:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjA1GGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 01:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjA1GGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 01:06:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2677C31E;
        Fri, 27 Jan 2023 22:06:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9DD0B821EF;
        Sat, 28 Jan 2023 06:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04233C433EF;
        Sat, 28 Jan 2023 06:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674886008;
        bh=cCghuNYffKQu60ysymDGhz6B5xEH3az0BIqTSBRNr6E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C8Az1qnyESWc/tN/73/qnLWbaN54Ma0Nc9RopFVSulLc+S+vGlxmfvoGO4VCVX297
         wdDM64PHnGVXmN93XeKypjo80C9uYcj/Yls/aw6aLvMRbcisEvKy5RapiNz3pRfBGm
         DHT5pX70YPDZR0BIHFdZ9yiwtHe74LqMM8edlTfpE1YXUjDfU7HJv7+kDh83gYvscW
         EgQE+6dmfdtS/Lx6C09QbkNC4u2mcgwXi5+uTeLTkN3zweqHu+Q3kuFBrLK1maXGZa
         pnaicXL6nuX2YI3xIxsaC8m+Ozv5p0q53/Nt/FfAmUBA6ipbf088GRqfFD/hqqZ36d
         aIUUiHpD3KL5g==
Date:   Fri, 27 Jan 2023 22:06:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 13/35] Documentation: isdn: correct spelling
Message-ID: <20230127220646.2345909b@kernel.org>
In-Reply-To: <20230127064005.1558-14-rdunlap@infradead.org>
References: <20230127064005.1558-1-rdunlap@infradead.org>
        <20230127064005.1558-14-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Jan 2023 22:39:43 -0800 Randy Dunlap wrote:
> Correct spelling problems for Documentation/isdn/ as reported
> by codespell.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Karsten Keil <isdn@linux-pingi.de>
> Cc: isdn4linux@listserv.isdn4linux.de
> Cc: netdev@vger.kernel.org
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org

Acked-by: Jakub Kicinski <kuba@kernel.org>
