Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2762640D9F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbiLBSmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiLBSll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:41:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E4BEF89A
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:39:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95ADA623A8
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F8CC4347C;
        Fri,  2 Dec 2022 18:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670006390;
        bh=ARlY8p6V6V7fKPjNxjXpD0W4nY68kfRKCRnlXSI5xfo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l0Sh0hNxEZb6G1zNwQ96PnoHz+34AUv9c19HVPHl/XblSj9Qi3DCjfOWuLC8YC73p
         JeEucfCn6D2Lh0ZWFFiI+NS630YK5TImyJHFK0YxMB9OvfLZ/AauUrIVaeSnAikbHM
         0++0sXAAzErd6HYmLLn4Mr/PDsSCMwlKtUPjJagEpW7xZUCctdPI27PI7+J4yvPS9D
         t2f0XEQZ1uiKrre3hxetOx2SpdPtah50nubxyoweix9vjTzWMDZyxWpaO9grzDvtmh
         VusALGgNZ/5mUeW6a8gqdh+UJeweWSW3KGuFPDMfSZas2pCLXTh4DtRFP0KbIdDRZz
         N/P9bpleNM8cg==
Date:   Fri, 2 Dec 2022 10:39:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, danielj@nvidia.com, yishaih@nvidia.com,
        jiri@nvidia.com, saeedm@nvidia.com, parav@nvidia.com
Subject: Re: [PATCH net-next V2 7/8] devlink: Expose port function commands
 to control migratable
Message-ID: <20221202103948.714a0db4@kernel.org>
In-Reply-To: <Y4m/M+jeF+CBqTyW@nanopsycho>
References: <20221202082622.57765-1-shayd@nvidia.com>
        <20221202082622.57765-8-shayd@nvidia.com>
        <Y4m/M+jeF+CBqTyW@nanopsycho>
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

On Fri, 2 Dec 2022 10:02:43 +0100 Jiri Pirko wrote:
> I believe that you put reported by only to patches that fix the reported
> issue which exists in-tree. It does not apply to issues found on
> a submitted patch.

+1, I also find adding the tag for previous-revision-issues
misleading
