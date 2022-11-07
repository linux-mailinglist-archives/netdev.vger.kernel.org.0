Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8E0461FD98
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiKGSbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbiKGSbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:31:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76421A046
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:31:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 425006124C
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 18:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBF2C433C1;
        Mon,  7 Nov 2022 18:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667845906;
        bh=zBIRXsv2OIEP2sVPfGrxCE8cLGSieG9Abtwn/yK/m10=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E9mq3Gff/EtCwQ8BEa71rRwP1oDM1GKpTLXzBPHColOMFvPslKkBCDCjEbgf0vLdd
         0WyAtMgynFcOaph1Ez4WChzNF/Yv3CQyqExI/JjRlzugwKlAfDS2AT74rJs91UiI+x
         6k6TacEJ55cxK99SMd/FPlxyZXQ8JCXWySqSumNwKWeeTDBR69f+CIGs3VkfPybjAA
         TVTMoJEMDMe1KAyUws36vJqkqFZtZI+PxzLlCvJOfgoii5aNPudSBEndb6WJpS8rak
         Q83w46tRGgm+unTGNWzzCEqz4Qn8RnTO9+aTcOb2ipgjwqPI/6UpLduUAfyVcw4ey2
         09+CY3HjHWCXQ==
Date:   Mon, 7 Nov 2022 10:31:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
Subject: Re: [PATCH net-next v9 0/9] Implement devlink-rate API and extend
 it
Message-ID: <20221107103145.585558e2@kernel.org>
In-Reply-To: <561f25bc-40dc-78c7-0a2c-e7e0fe74ebde@intel.com>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
        <20221104190533.266e2926@kernel.org>
        <561f25bc-40dc-78c7-0a2c-e7e0fe74ebde@intel.com>
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

On Mon, 7 Nov 2022 19:18:10 +0100 Wilczynski, Michal wrote:
> I provided some documentation in v10 in ice.rst file.
> Unfortunately there is no devlink-rate.rst as far as I can
> tell and at some point we even discussed adding this with Edward,
> but honestly I think this could be added in a separate patch
> series to not unnecessarily prolong merging this.

You can't reply to email and then immediately post a new version :/
How am I supposed to have a conversation with you? Extremely annoying.

I'm tossing v10 from patchwork, and v11 better come with the docs :/
