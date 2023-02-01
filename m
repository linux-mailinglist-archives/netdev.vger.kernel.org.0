Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC639685F4A
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjBAFw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjBAFw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:52:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1163B3C3E
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:52:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C26C6114C
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACF6C433EF;
        Wed,  1 Feb 2023 05:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675230775;
        bh=zKNHhOij/RUQOpQbntAecPzzSVXkC0tZO1RYkGtlTJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H03yPPjg9LF5SNlSJj3M3fO3dFxahbj/ER1GvQuTvpgrRGPfn86TpxEODF3/JWa4I
         wyq14ceR//GAW9G0bhReJ4OoEFAom/jxk3f9op1w1DqLf6ur6I0NUjQUkqzZtvT5CK
         BHShcnnkVgWV/ZzOf52huTjdbDPO4F9A6ZLLDac+RCPRwZiUk0L6lCOAOGqvy0Ipcj
         0RbRASJWvy8lbWNTNcelb62x/xTYcQZcPeFmjaXJirn69lllsu1R3IZbBaIrKkZyE6
         315XSPoUCc3eVNjCR/m9OK/jsIO9bIvKEw5kZZW8vD/c4Hg0GCXbq+EvVYOeeIhFu8
         /1gpSj/s+izvA==
Date:   Tue, 31 Jan 2023 21:52:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next v2] gve: Introduce a way to disable queue
 formats.
Message-ID: <20230131215253.0d480afe@kernel.org>
In-Reply-To: <20230131163329.213361-1-jeroendb@google.com>
References: <20230131163329.213361-1-jeroendb@google.com>
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

On Tue, 31 Jan 2023 08:33:29 -0800 Jeroen de Borst wrote:
> Changed in v2:
> - Documented queue formats and addressed nits.

You did? I don't see... I was expecting changes to:

Documentation/networking/device_drivers/ethernet/google/gve.rst

Also clang with W=1 now says:

include/linux/fortify-string.h:522:4: warning: call to __read_overflow2_field declared with 'warning' attribute: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
                        __read_overflow2_field(q_size_field, size);
                        ^

dunno if that's legit.
