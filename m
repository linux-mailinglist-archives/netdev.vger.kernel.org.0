Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A546AAC0B
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 20:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjCDTGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 14:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCDTGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 14:06:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBE51ACEB
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 11:06:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 174FC60687
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 19:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B347C433D2;
        Sat,  4 Mar 2023 19:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677956802;
        bh=llPqKaSk8yrwRDfiaCFBbc4Rc64fzYfNkvIE/ve5xro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CuynGzRaIPdUnKhPurzae1GC70tRn7poznmyzlKkq2GwcBTieSBASVphWX5zAvxW2
         bd4eqRcEMJ4AQnxp1jqFIxuoHJgYAEoOSVQCxQnnxqEkn3bXFlLRw+wV+BkYXU1Aup
         fQxmFuoTjMqvbPFPkd2jJt+pOPOR/6uCTFivTmDAtE2xXRUmX4OZUd0c0oaI8lc+Jb
         E51W9h5kd1QX4kX4bOpwgXkFS13iZ0NS/1IhZNM6FBVjemIOCY5/0Dt63HaaVIOkUF
         YCPlnPVQwraH0CYW/jl+/IcQu9PzD+0yg56xbRLH83F5qqRAQAUUj6K4mYabsM7Wvk
         RyVvAvGYjjHNQ==
Date:   Sat, 4 Mar 2023 11:06:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        khc@pm.waw.pl, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3] netdevice: use ifmap instead of plain fields
Message-ID: <20230304110641.6467996b@kernel.org>
In-Reply-To: <20230304115626.215026-1-vincenzopalazzodev@gmail.com>
References: <20230304115626.215026-1-vincenzopalazzodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 Mar 2023 12:56:26 +0100 Vincenzo Palazzo wrote:
> clean the code by using the ifmap instead of plain fields,
> and avoid code duplication.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202303041847.nRrrz1v9-lkp@intel.com/
> Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>

Please don't, as already explained it's not worth the code churn.

Nacked-by: Jakub Kicinski <kuba@kernel.org>
