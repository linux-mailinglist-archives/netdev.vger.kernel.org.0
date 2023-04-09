Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8756DBF7A
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 12:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDIKeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 06:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjDIKeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 06:34:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B16B46A6
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 03:34:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E188B60DE6
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7226C433D2;
        Sun,  9 Apr 2023 10:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681036457;
        bh=Ycs0r3nhNTqLgTwY4wX8YJzqm75b0YNp4s5ZERM7GjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rBypstF+RAHg2ZsPS1iN5oBl8CUzapLfWWbfUt9COR6kV6545l7pGXHWvAkDotL/m
         YwSryyYW0495rYB0XkqVNpkdI0VaJ7zwCgrvLj7VZO7rwb8oXqanx5pNHk7b93NAFv
         U8hMDRf5aOpE964TY9TxRAzF0Qtzrk99z9EEj3BQ/A3Vh+PgwG0rjGz5w7CS80rr9j
         O0xugyNA4Mi9dOuTqhrkm4sesmIX4hToIQyzMhrNjs5Ryo4bRn06bTypYqy/JMrQRg
         pVjJZnjVJpt1cm/1LLnZZ79Kfgvld+ztYZ08ZALGULWHop6d4s4AdVKBqLJw+DxTpL
         wqVgkDuzUS8SA==
Date:   Sun, 9 Apr 2023 13:34:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        wojciech.drewek@intel.com, piotr.raczynski@intel.com,
        pmenzel@molgen.mpg.de, aleksander.lobakin@intel.com
Subject: Re: [PATCH net-next v4 3/5] ice: specify field names in ice_prot_ext
 init
Message-ID: <20230409103413.GN14869@unreal>
References: <20230407165219.2737504-1-michal.swiatkowski@linux.intel.com>
 <20230407165219.2737504-4-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407165219.2737504-4-michal.swiatkowski@linux.intel.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 06:52:17PM +0200, Michal Swiatkowski wrote:
> Anonymous initializers are now discouraged. Define ICE_PROTCOL_ENTRY
> macro to rewrite anonymous initializers to named one. No functional
> changes here.
> 
> Suggested-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_switch.c | 51 +++++++++++----------
>  1 file changed, 28 insertions(+), 23 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
