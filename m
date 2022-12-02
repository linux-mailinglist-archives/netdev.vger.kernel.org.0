Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DD7640E03
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiLBS60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbiLBS6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:58:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59FB9D2DA
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:58:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67AAA60A3D
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1A0C433D6;
        Fri,  2 Dec 2022 18:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670007498;
        bh=kGUejsnGksGrxdaQ03uTGoTcErly9BYXBczEnPcWhHM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KogK+NM6o6l5XFTfrdE+EyYAB6BzdMuuMv0M5KcZm66SThXrTjXkA8f3LxCG8Wd7A
         CdezTDnTkDifX2nibDu3lg/d7SQj9OL5nDfpv30JhqQ/IvVekT/h8Gj1lHRt+S8IjF
         7a+D+zZmeoCeNlnfvT12E2UvitVojV/P0QQGfQOM6XV5peV4M5YBcv0L88cdYVw1ZX
         9w8m/MBPYQ86tWIpqDTP1T+d3mD3D7TEXYMvDWkMfHKM5PpdUz1F68rlBXgZRnPufD
         0TjOq3kf0d+n/EqHVTsuE4Z9CBMCGsDqKZg70yfOiLA6MY27anP+M/xppXJVvDsedB
         Nc98RtGFzfZtg==
Date:   Fri, 2 Dec 2022 10:58:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Drory <shayd@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: Re: [PATCH net-next V2 7/8] devlink: Expose port function commands
 to control migratable
Message-ID: <20221202105817.2b0cc49c@kernel.org>
In-Reply-To: <20221202082622.57765-8-shayd@nvidia.com>
References: <20221202082622.57765-1-shayd@nvidia.com>
        <20221202082622.57765-8-shayd@nvidia.com>
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

On Fri, 2 Dec 2022 10:26:21 +0200 Shay Drory wrote:
> Expose port function commands to enable / disable migratable
> capability, this is used to set the port function as migratable.

Could you CC Shannon on v3, please? 
