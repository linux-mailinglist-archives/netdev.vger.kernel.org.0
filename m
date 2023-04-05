Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5406D7175
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 02:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbjDEAmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 20:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbjDEAmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 20:42:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4447F170C;
        Tue,  4 Apr 2023 17:42:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF7E263A08;
        Wed,  5 Apr 2023 00:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED446C433D2;
        Wed,  5 Apr 2023 00:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680655320;
        bh=+cjLkLoA9NyDufawosYM9Jf4qVxSowmmQusfhBSHjPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=muZKDKB5P0sEX3SdkbTj9DJgulX43zg4X3Yi7yrOuujMhekHFi6f2NNl5nrTaFzdD
         OstCzCC5UxPO0ADvSZdhEMkWMzGIYK4eR40he4I8hHPsqD04Fa7X02V/WIwwOHDIjL
         tGBIqG7+CHvUpJkKcunaaP3B7lKq/aWi2b6OKwP3hs4omSOnwi+22Okxe4Zj0urZF4
         FIlYJhR9t3T9gKEGHBjphW+4WyE508ehMCz3uES7LJqpSLgesheWai2X4tijPatnvI
         acmWW/FyfdY6PE1OzcSLmpXfACFvIy/guwFZoYmz42XarLeA2dRY4sbol68w6jjbOn
         dBEO3FdddrklQ==
Date:   Tue, 4 Apr 2023 17:41:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [linux-next:master] BUILD REGRESSION
 6a53bda3aaf3de5edeea27d0b1d8781d067640b6
Message-ID: <20230404174158.35ea7a71@kernel.org>
In-Reply-To: <642c8ceb.LBEdj8abbmwftu9h%lkp@intel.com>
References: <642c8ceb.LBEdj8abbmwftu9h%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 05 Apr 2023 04:47:39 +0800 kernel test robot wrote:
> drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c:148:31: error: implicit declaration of function 'pci_msix_can_alloc_dyn' [-Werror=implicit-function-declaration]

CC: Saeed, Leon
