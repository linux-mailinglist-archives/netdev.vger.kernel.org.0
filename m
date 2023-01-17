Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6009366DBD1
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236791AbjAQLF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236693AbjAQLFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:05:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331A932539;
        Tue, 17 Jan 2023 03:05:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C422261259;
        Tue, 17 Jan 2023 11:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F70C433D2;
        Tue, 17 Jan 2023 11:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673953522;
        bh=F2V6EST1CT47fG0xpmIb+kkj3J1aCuuwZ9+tl+qRx9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l//Dxl90JRSZPjmb2IY90kDDZKOIZQCTI2mUeZHxzVk5dAo0bSFoD8zxQsqQierjn
         efCqaJFdZZDt0erqG6gUUNjk4YywsyudY1cuVi8ci6nnEV97L1TBeYGLFx9t2aHCfZ
         3zforAP0/on3GCw34j4mdS1x0CPwY+/NWrnUp6MJmZXN7oOBGgipRupdzF4bnAEk8o
         yeqVzWxVDR48O22wWGvD55eV1z2+tqCVuWItmGch73JF2HRJQd4JT3C6UKADymCygB
         gJaVaYuwLxcuYBSaJ04dV/J8wjJWt3KpAJat8Yppcu+ClGFuVROXVo0ZJfBZ62r32K
         xDlqPqWlq/zWg==
Date:   Tue, 17 Jan 2023 13:05:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Maksim Davydov <davydov-max@yandex-team.ru>
Cc:     rajur@chelsio.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, anish@chelsio.com,
        hariprasad@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net/ethernet/chelsio: t4_handle_fw_rpl fix NULL
Message-ID: <Y8aA7vOZByuN9ZGC@unreal>
References: <20230116152100.30094-1-davydov-max@yandex-team.ru>
 <20230116152100.30094-3-davydov-max@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116152100.30094-3-davydov-max@yandex-team.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 06:21:00PM +0300, Maksim Davydov wrote:
> After t4_hw.c:t4_prep_adapter() that is called in cxgb4_main.c:init_one()
> adapter has it least 1 port for debug. 

IMHO it is wrong to keep this interface and the logic for this debug
code should be deleted.

Thanks
