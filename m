Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 161946D1732
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjCaGRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjCaGRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:17:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B675818FB2;
        Thu, 30 Mar 2023 23:17:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DAEDB82BC3;
        Fri, 31 Mar 2023 06:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4814C433D2;
        Fri, 31 Mar 2023 06:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680243460;
        bh=TQ6ycmVPKyu9jYtsJQjNQ+4N9VHAlZXO/54TyHjEAaE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GjLYN1ouzsZ/uo1pr6sbm8ilDUzxw2dBZGK8nEvsmetxj5nneJe25YkQFRELu35MI
         nyHOVbAJss8kmMYEVIsgaTomtYVC9OQbYXTSPMQPTQdEmb17aNb/mKV66z9rfG644u
         CoUY2w+1fyQOilRG16Q1rX9hdAhnO8HNmprSeIf8Vijs3t14lEyMgYtHb466qQR4pN
         UjJXsSYjegA6b5StYQxPinC3sIzB1RT9CvDev1yJRGIc6UnPiMRLFvSD6vc33ry9io
         JURZtcH0XfRoE3y0srrSCBtwytFZwZ8Viyevt76ezHKEAAt9oQrobVlWTg75Bs/p18
         HhBj5GIEbJ5lA==
Date:   Thu, 30 Mar 2023 23:17:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mISDN: remove unneeded mISDN_class_release()
Message-ID: <20230330231739.14ead816@kernel.org>
In-Reply-To: <20230329060127.2688492-1-gregkh@linuxfoundation.org>
References: <20230329060127.2688492-1-gregkh@linuxfoundation.org>
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

On Wed, 29 Mar 2023 08:01:27 +0200 Greg Kroah-Hartman wrote:
> Note: I would like to take this through the driver-core tree as I have
> later struct class cleanups that depend on this change being made to the
> tree if that's ok with the maintainer of this file.

It must be on top of .owner removal? Cause it doesn't apply for us:

Acked-by: Jakub Kicinski <kuba@kernel.org>
