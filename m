Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BD54D0B0C
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 23:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239219AbiCGW2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 17:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbiCGW2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 17:28:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2B944773
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 14:27:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8CE5B81729
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 22:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A35AC340E9;
        Mon,  7 Mar 2022 22:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646692040;
        bh=V5f2AdcF7eWPoKIFSt8+g3SgmluZsxiP88MXorKkpu8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EMhxAJ36x3HAU5vkL2lNP2ZvGLc4vsHWcOIgxKoj99bpy1fs1tN2hkSM6DfsEEB9M
         GMXMqXzEjD+j2L8LJN0PW1m4IqewQ6oSPf6wEKoBHyY9AUTqNE5sWUrdQJqQTQ5Fkg
         7qP6Q6fk1CmVLIqxFHHz7SErVk8c1JrDemJwdHse+dHuvlQsXzqIoLp1JhpqCqL1rn
         tzZ3XShY8dh/NRZ/SZvvP71isfERU+8mRiK5SwanxArScDus2EXWHJKnUAryA0PQ2o
         t7f4ICJ2R8HWidJ+o/VLzQYi/Sz8FGgWAQ/TKuMIOKnIv37Y7LRs8H8ZoaB6fneEJc
         R8UDzRXu9jgSw==
Date:   Mon, 7 Mar 2022 14:27:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next 0/9] bnxt_en: Updates.
Message-ID: <20220307142719.1501043b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
References: <1646470482-13763-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Mar 2022 03:54:33 -0500 Michael Chan wrote:
> This patch series contains mainly NVRAM related features.  More
> NVRAM error checking and logging are added when installing firmware
> packages.  A new devlink hw health report is now added to report
> and diagnose NVRAM issues.  Other miscellaneous patches include
> reporting correctly cards that don't support link pause, adding
> an internal unknown link state, and avoiding unnecessary link
> toggle during firmware reset.

The devlink parts are missing documentation, I'm not sure how it's
supposed to operate and AFAICT it's not just a normal health reporter
implementation.

Please stop posting patches during the weekend.
