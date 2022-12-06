Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052CE643B05
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 02:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiLFB5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 20:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbiLFB5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 20:57:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABB11B7AF
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 17:57:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04E9561502
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03EEC433D6;
        Tue,  6 Dec 2022 01:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670291819;
        bh=Jo+WVvriOBgVw7dFNsOUd5K8eSUzNcaf3GQ5zeBHxKY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hfdOyk+XRV5DjhXPGcZL9PskqqrxBUDXVkGCR54y3SOXTYbh98mtyxUnmL34b9bzi
         BC63pqXpzNJ9BIn8V/USlRXcwEmU85iC5/qzI/qznjNCfl4xuF1LkGiqnkgC1lt6j7
         2sofhVBBuiP4V6x93kSJvKiPvoNQ8trt57uBxe6toA5RFXQyk8Qipkqi4f3zFKbLjf
         Z5x1gQJ90ClI4Kh85rH31q6K9T0uIvQ7hX+hvihYdcJ1VFZGpYpedbRfAUMSRF0uxz
         gKJqvNJfskAVwZ90SGjeLbCEtxH2iFMEXZPpdoaXces6km8KYwxxlSfBI6beCh9lTz
         jbS9g1+T75hIA==
Date:   Mon, 5 Dec 2022 17:56:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, danielj@nvidia.com, yishaih@nvidia.com,
        jiri@nvidia.com, saeedm@nvidia.com, parav@nvidia.com
Subject: Re: [PATCH net-next V3 7/8] devlink: Expose port function commands
 to control migratable
Message-ID: <20221205175657.7747c98c@kernel.org>
In-Reply-To: <7e3deb3a-a3fd-d954-3b6f-8d2547e036d5@amd.com>
References: <20221204141632.201932-1-shayd@nvidia.com>
        <20221204141632.201932-8-shayd@nvidia.com>
        <7e3deb3a-a3fd-d954-3b6f-8d2547e036d5@amd.com>
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

On Mon, 5 Dec 2022 15:37:44 -0800 Shannon Nelson wrote:
> > +        * @port_function_mig_get: Port function's migratable get function.  
> 
> I would prefer to see 'mig' spelled out as 'migration'

Seems reasonable, if anything we should abbreviating "function" here.
Devlink code and attrs use "fn" already.
