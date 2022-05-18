Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B1B52C0B5
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239999AbiERQV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 12:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240030AbiERQUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 12:20:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B218F7C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 09:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB61461586
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 16:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D97C385A9;
        Wed, 18 May 2022 16:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652890850;
        bh=YnGirIvKvhg6NH/11WtxtK/xPeIPWmQIp/KKOipO6/E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bgyrZxrvZOn2Ssd47sPLX1wO1vDVYtnKVYkmRmMyH9mmUd3jx55DIlWchzbEx0FIN
         YlecQeWP2gSrQeYT2rRpqA1suduujiT2LRkorcHF0fLGmRoz3bfjcVwifWYdX1OIeq
         2Hh3u80v5y6gJ8VvooUw5FmjLfm7JBxG2tJkMMzWna1o3As+fDPAFfpE+xoD9QHoaC
         VHKeEea9RwnmOozNYiJEuTBHdMJgrCGBKB0j+m8xLXEpUBYcexumVLJuvDsbkmWM4n
         YgAU1zCDBHxgGPn4ZsnbantKE6oapQ8JdD+EFviABek99GJk2iWwkacCA5voIDF0lf
         05U5iwKj/l1Iw==
Date:   Wed, 18 May 2022 09:20:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Edward Cree <ecree@solarflare.com>
Subject: Re: [PATCHv3 net] Documentation: add description for
 net.core.gro_normal_batch
Message-ID: <20220518092048.7b46104c@kernel.org>
In-Reply-To: <acf8a2c03b91bcde11f67ff89b6050089c0712a3.1652888963.git.lucien.xin@gmail.com>
References: <acf8a2c03b91bcde11f67ff89b6050089c0712a3.1652888963.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 12:09:15 -0400 Xin Long wrote:
> Describe it in admin-guide/sysctl/net.rst like other Network core options.
> Users need to know gro_normal_batch for performance tuning.
> 
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> Reported-by: Prijesh Patel <prpatel@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
