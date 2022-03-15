Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7481E4DA2FB
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbiCOTG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351396AbiCOTGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:06:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125E35C37D;
        Tue, 15 Mar 2022 12:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3046B81894;
        Tue, 15 Mar 2022 19:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C56C340EE;
        Tue, 15 Mar 2022 19:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647371073;
        bh=pIw3e0jpW/zGZrywEjJLJ+4mohDw8e8eurWkZjj0Qak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F0cbEQ+VX4ONQYf8PxUVBlGXjulChF4lmow0gXqGCyiAJRUnG8WPm2KhiT1t+lcuF
         P5W08DAi68qd9mNEEjjqKX+F75jywc1HU6HMZ7yF0h+qGgtte1TqJ87L4AhCuxHlGy
         AZ4zE6bnSdiIbHNrHraCr0mGvfIASCocRifzgWGWyJfC2ix185/7uh0cFHR2wRHvsK
         P8pJw0K+o4b3MeNo91Hfl3G1SucXbLv2hGdb9eCRAHGQgo6G3l1CcJkzZMVCl3Za4R
         quEqXyGcIc/EmNaztRmzbEcBH52Sdca2CtwWRD0seiePY2UlxzpBwTIOySJJr9PZDv
         h6VcWf6WjFVrg==
Date:   Tue, 15 Mar 2022 12:04:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Helge Deller <deller@gmx.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH net-next] net: mark tulip obsolete
Message-ID: <20220315120432.2a72810d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <29f1daf3-e9f2-bbc5-f5e5-6334c040e3fa@gmx.de>
References: <20220315184342.1064038-1-kuba@kernel.org>
        <29f1daf3-e9f2-bbc5-f5e5-6334c040e3fa@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 19:44:24 +0100 Helge Deller wrote:
> On 3/15/22 19:43, Jakub Kicinski wrote:
> > It's ancient, an likely completely unused at this point.
> > Let's mark it obsolete to prevent refactoring.  
> 
> NAK.
> 
> This driver is needed by nearly all PA-RISC machines.

I was just trying to steer newcomers to code that's more relevant today.
