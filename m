Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31F8692E1B
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBKDws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBKDwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:52:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1A477B84
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 19:52:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B58FB826D2
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 03:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B0BC433D2;
        Sat, 11 Feb 2023 03:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676087563;
        bh=xB02ShZF0xNhBtMq4VkBwg6fYeU1HXIKvfaYHgQBDbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ef31sgSAbi29+o6vTASs2NiZTduisuAJys0zSoW9iJMirZ+NHo7F//7kC3iXthDw5
         CgW0i5q7/i6cK11Df5xjRCF5S+29L+6svek0GYdXQpdYaL6u+4r1D25cN3xKeK+EdD
         uTYjFOO3Db7qVGmmy3Sdc3Nwnf1DQ3Ow1V6vp2/4I26ZyJDpEuxeouRIHTYO9MndQe
         xATfFcWyG4ZY8T+e8QoO4PfesGYPV+wRpfdeXGJgYx/1NgNRrnen1KzdYBJx87Qgi/
         UCVgL1eTuFFeZdh5uncgbpnQ8ar8neLtjxl/OTESuo0AYtISdQmFeEpuW5SnF9i2LT
         hYuFCp8ke6A3A==
Date:   Fri, 10 Feb 2023 19:52:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next] devlink: stop using NL_SET_ERR_MSG_MOD
Message-ID: <20230210195241.35c3a7ce@kernel.org>
In-Reply-To: <20230209222045.3832693-1-jacob.e.keller@intel.com>
References: <20230209222045.3832693-1-jacob.e.keller@intel.com>
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

On Thu,  9 Feb 2023 14:20:45 -0800 Jacob Keller wrote:
> NL_SET_ERR_MSG_MOD inserts the KBUILD_MODNAME and a ':' before the actual
> extended error message. The devlink feature hasn't been able to be compiled
> as a module since commit f4b6bcc7002f ("net: devlink: turn devlink into a
> built-in").
> 
> Stop using NL_SET_ERR_MSG_MOD, and just use the base NL_SET_ERR_MSG. This
> aligns the extended error messages better with the NL_SET_ERR_MSG_ATTR
> messages as well.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
