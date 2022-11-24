Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5880663716A
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 05:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiKXERe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 23:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKXERd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 23:17:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325CB313
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 20:17:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD5A361FE6
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 04:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EFDC433C1;
        Thu, 24 Nov 2022 04:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669263447;
        bh=VaGqTJgbG5x92UuFc24a27+gdn0yYE+sMR/2aM7IO/g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pEt07a3HU9E9ojvxCgOhsJc9d3D+Czdg83otrfbI3fMtc382rfxYymS2May3KONJJ
         Z/qztUFJeLCGc+Mx+YK1lzW/aHA6ueVZwR+1cZhwzu35ZrsQlTLwbjjILjGi0TaaZv
         xqJAJEGJqUgG9HNXv5AAnzE6XiHx4aW4FMbDqGocyiyqAQXvtFKUd/ZgKHpve5AEsi
         czP0l4+XUFaGxyIAB+d+XNJEqGPJtHhUhUEZt6Aq6UBoH93Gv6V7TJLv1pinEXjwgc
         lJ2OYf5XGpe2c4nTeZjM1Z+ZMRXQin2KoBX4ncfUcTMd1IbPCdmbJHPiE5ujvn0Hrc
         Cv3X5K+PcXn4Q==
Date:   Wed, 23 Nov 2022 20:17:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 0/9] support direct read from region
Message-ID: <20221123201725.32bf4cfd@kernel.org>
In-Reply-To: <20221123203834.738606-1-jacob.e.keller@intel.com>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
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

On Wed, 23 Nov 2022 12:38:25 -0800 Jacob Keller wrote:
> Changes since v1:
> * Re-ordered patches at the beginning slightly, pulling min_t change and
>   reporting of extended error messages to the start of the series.
> * use NL_SET_ERR_MSG_ATTR for reporting invalid attributes
> * Use kmalloc instead of kzalloc
> * Cleanup spacing around data_size
> * Fix the __always_unused positioning
> * Update documentation for direct reads to clearly explain they are not
>   atomic for larger reads.
> * Add a patch to fix missing documentation for ice.rst
> * Mention the direct read support in ice.rst documentation

Acked-by: Jakub Kicinski <kuba@kernel.org>
