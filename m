Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3376912A9
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 22:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjBIVbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 16:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjBIVbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 16:31:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC28122
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 13:31:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 548B76187F
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 21:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E311C433D2;
        Thu,  9 Feb 2023 21:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675978305;
        bh=JhyFWkqokhmVclbImJo7X6etr1gOHSmub8yUczYJL8g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SHrIl9wZeC//DcetAOAB4IE9qjephJqnq7XD8I8fHJoGqMIbfoYHcbIOUV7w3bDEH
         SCt/BErGMx2c0KNk4el6V4CcjgDcBLpMKWNjloKi7vURgCY447U64v3MqLs1xqePIS
         ASvKL8i/c7fyMVYwObOMFvFjpdRh9pe/71zbSSGq9YprUGg0EsCLl0UbRmEZnac1Zz
         gxpDxDpX3piKXhC0Sfxup5xPuQMEITFpXIeLHNmj+ouvO7+ytnrK2wg30P5wyRZ7J1
         dd35f2aLUQm382PVuCQrCiO+XLrbgixcL+HOtRpvEZN+K9Nl/qogsM0KWRW+qkf7bL
         C1lqbYC0aFTqg==
Date:   Thu, 9 Feb 2023 13:31:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>,
        <jacob.e.keller@intel.com>, <gal@nvidia.com>, <moshe@nvidia.com>
Subject: Re: [patch net-next 0/7] devlink: params cleanups and
 devl_param_driverinit_value_get() fix
Message-ID: <20230209133144.3e699727@kernel.org>
In-Reply-To: <81b9453b-87e4-c4d4-f083-bab9d7a85cbe@amd.com>
References: <20230209154308.2984602-1-jiri@resnulli.us>
        <81b9453b-87e4-c4d4-f083-bab9d7a85cbe@amd.com>
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

On Thu, 9 Feb 2023 15:05:46 -0600 Kim Phillips wrote:
> Is there a different tree the series can be rebased on, until net-next
> gets fixed?

merge in net-next, the fix should be there but was merged a couple of
hours ago so probably not yet in linux-next
