Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B184C9B8F
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbiCBCzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiCBCzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:55:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FC3403D9;
        Tue,  1 Mar 2022 18:55:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B2CF61686;
        Wed,  2 Mar 2022 02:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E21EC340EE;
        Wed,  2 Mar 2022 02:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646189707;
        bh=ddZiuRfG/pCjWbi6WqOWsXn5TumLyIc1oQDqNkZnoB0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ImFQjPN9wpJveDl0gLQK9UlifidI2fSbkxhse8a5XqFIP2287QhESbvoVvBSwufIA
         kBYxSH1vCxcSFkqLyStRP0TGdIxu8ZmdH3nqn1e0T9/9h46LiqPFxoUWjJSUzWk4di
         66nCxsRIZnroz8+LnkEME85egnmSrehRx8Zuc4Ff/dKRddXCQdNv3d/2bi1wrldQoP
         V3ajxyLCYza/EvwgrEKwBko2I8ZBn/jgbUtcB3emn6KrGK4mL4Mz+s6dlN7ga0COWv
         lUg7H3KnjfMep7Rnq7KBf2T1Bn3vLP/BkCFsG5QlHhYX7D8DWiV19UH7umDEmvJyZV
         iDEociZLdne3A==
Date:   Tue, 1 Mar 2022 18:55:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qing Wang <wangqing@vivo.com>
Cc:     Joerg Reuter <jreuter@yaina.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 RESEND] net: hamradio: use time_is_after_jiffies()
 instead of open coding it
Message-ID: <20220301185506.64c3aa0a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1646188174-81401-1-git-send-email-wangqing@vivo.com>
References: <1646188174-81401-1-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Mar 2022 18:29:31 -0800 Qing Wang wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> Use the helper function time_is_{before,after}_jiffies() to improve
> code readability.
> 
> V2:
> add missing ")" at line 1357 which will cause compliation error.

I see :S  So since the v1 was already applied could you please send 
a patch that only adds the missing bracket based on this tree:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/

? We can't discard the old patch, we need an incremental fix.

Thanks!
