Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F80F6DB886
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 05:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjDHDSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 23:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDHDSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 23:18:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725F1E56
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 20:18:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CBA865542
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1428BC433D2;
        Sat,  8 Apr 2023 03:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680923890;
        bh=eUPclUk7/3Fr4vv1+bSGE5HCzeu5YngDSnevdXSRd2Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MK5sFIkpBB2/VO5/tg7fiDjEbQ8eDpths9ll6hWIyV6S3+ArRdAf9JzNqSqaP7P0F
         RjQYHYheJbye3iA7N3abCQrkiNHco0OF+K78LTc7RC+ZtiQxIqtKmzBsw7oBxPetDw
         SOrZM+XKv/c0yQy2p6T+ahmcYIduA1Ws0yAPB189gr664aQxw9LxJCi3Yjaq6tWhhx
         ICmxN0fC6UZAzmRUHFGnQe69tg1N+YzL/GGrR25YfZ9EUMdvjb0IL3YpJ2FHHwPV0W
         9lI0M+QASFnl/Jx7MLIrtSNskOHDDBVH53CrEn00JIsgxexO4ODb5Aa6u5l8ZlSZKa
         pO+VrT1DANTww==
Date:   Fri, 7 Apr 2023 20:18:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     <brett.creeley@amd.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <drivers@pensando.io>, <leon@kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [PATCH v9 net-next 00/14] pds_core driver
Message-ID: <20230407201809.17eba19f@kernel.org>
In-Reply-To: <20230406234143.11318-1-shannon.nelson@amd.com>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Apr 2023 16:41:29 -0700 Shannon Nelson wrote:
> This patchset implements a new driver for use with the AMD/Pensando
> Distributed Services Card (DSC), intended to provide core configuration
> services through the auxiliary_bus and through a couple of EXPORTed
> functions for use initially in VFio and vDPA feature specific drivers.
> 
> To keep this patchset to a manageable size, the pds_vdpa and pds_vfio
> drivers have been split out into their own patchsets to be reviewed
> separately.

Acked-by: Jakub Kicinski <kuba@kernel.org>

Let's hear from auxdev folks, tho.
