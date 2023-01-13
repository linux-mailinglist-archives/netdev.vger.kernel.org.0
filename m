Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C76C66A37B
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 20:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbjAMTkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 14:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjAMTjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 14:39:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4933D7D26A
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 11:37:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D26AD62308
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EE5C433D2;
        Fri, 13 Jan 2023 19:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673638626;
        bh=hIDZ0DxMbH5cnRgHwukw6eEBkf1q8HULHWhnI8ESERw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WEhR219GuTOCTudcQXwusdJ7VJYyHSBA/h0UXPXmDsSrJuj+9gBQ0H+RrwhT62el6
         8lnz/yTg/mHXObEj1JozHoFtdKJ5gjiJo9PB3Vkz4BCB5kx5c4hqbPkOKy8D2PoTSa
         eEavcEkZpVZGJqsppq35OY0E69rERMvFqDa9jzGpVTuh8ouSls6nrVba26Y51LgRBl
         HoDiTBWRM8xH3jLCjZqYcJPVO8rI4lWrsIHJvSVf8KjjocwKR3ryF3d4DBT2klTAAN
         sPvN+ExnXhQ4MiQEOiKwx5NU3k3Z1006Qikn+QDQnrlqz37rJqpoih1aHqbwXiC9S7
         qCE39jjPPZ2ew==
Date:   Fri, 13 Jan 2023 11:37:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v8] net: ngbe: Add ngbe mdio bus driver.
Message-ID: <20230113113705.57a9020e@kernel.org>
In-Reply-To: <20230111111718.40745-1-mengyuanlou@net-swift.com>
References: <20230111111718.40745-1-mengyuanlou@net-swift.com>
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

On Wed, 11 Jan 2023 19:17:18 +0800 Mengyuan Lou wrote:
> Add mdio bus register for ngbe.
> The internal phy and external phy need to be handled separately.
> Add phy changed event detection.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied already yesterday (the commit / pw bot is broken hence no
response).

Please follow up addressing Simon's comments as an incremental change.
