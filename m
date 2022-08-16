Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 893AC596248
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbiHPSTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbiHPSTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:19:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E225385FB6
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 11:19:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A38461389
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 18:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98794C433C1;
        Tue, 16 Aug 2022 18:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660673982;
        bh=x7wUEBhUv2Zsis1AZdvQCy+8Ehl79DaoJc+YIWDjSrU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WOWAJAxOacp7lzoyOpYYGWLhKu8KY91l1/Xm2yMgRquyhqLxzjzjn1q6Ge2qsPsJK
         4nNosgqdrOX1CEvYcXQnfd6TOxgoPmqyX0KiFBeuKniNyR20UHzDnc7G4PZrwfRrB7
         pOWmRExPR5Hgo1ujROWEy4gnX5FM9aE5ihNQSmYdSstmJJxNAC/vTMy2V4QMl9Eqxn
         WqasLB56eU9lQZrGz3i98IJxsmMc30a4PEYpNjCJKtyMl13lZjKormpSjAODOhIwIj
         qXx8mOVjg8MKT/naoU9xjqCyz/Jkaqeq8XCKqiMZn+bH6NVeT4n5UagkXDX9G5SKGV
         gL1ElMUX8j4SA==
Date:   Tue, 16 Aug 2022 11:19:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: Re: [ RFC  net-next 0/3] net: flow_offload: add support for per
 action hw stats
Message-ID: <20220816111941.04242d4f@kernel.org>
In-Reply-To: <20220816092338.12613-1-ozsh@nvidia.com>
References: <20220816092338.12613-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 12:23:35 +0300 Oz Shlomo wrote:
> This series provides the platform to query per action stats for in_hw flows.

I'd like to make sure we document the driver-facing APIs going forward,
please consider adding a doc.
