Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205CF4C9B18
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239071AbiCBCSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiCBCSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:18:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C017ED8C;
        Tue,  1 Mar 2022 18:18:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBD8B6168F;
        Wed,  2 Mar 2022 02:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7EF9C340F0;
        Wed,  2 Mar 2022 02:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646187483;
        bh=0UAVaLD5wqBI1sqre5WfIpb45/ZkcP8Z8YK1KArm64o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DVB/ujafrSKrwEdXrqu7DfYs7aXJjAkySyUcyLIS+dVXz70Qxae1M2Ga8/deKYBAf
         wbdeai+ADboMtryM8y1YJMnlpIpGc52qHzH2ayNJVAOV6BZQomHxbyJfZP1mUlRyK6
         NKaMWUk7RQXdcv3u4nd9rI7n844jfIx/7JBr/vV63MmPD/NlWgwik2PZj5HhgbKgde
         awkUnLIm5m9rVXtZAY9J6qOVUGhZm357FlHgotvS5SWAmMVq0j5k0d3GepcDycXMW5
         yuq8sARnF1b6k3UX1T9PXnVM/G0cwcwwuA8zfduCQxa+1V5bJDvrI35V7AQxMjXdjZ
         ydch+JSVHvU9A==
Date:   Tue, 1 Mar 2022 18:18:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qing Wang <wangqing@vivo.com>
Cc:     Joerg Reuter <jreuter@yaina.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: hamradio: use time_is_after_jiffies() instead
 of open coding it
Message-ID: <20220301181801.20ea9451@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1646137579-74993-1-git-send-email-wangqing@vivo.com>
References: <1646137579-74993-1-git-send-email-wangqing@vivo.com>
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

On Tue,  1 Mar 2022 04:26:16 -0800 Qing Wang wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> Use the helper function time_is_{before,after}_jiffies() to improve
> code readability.

Please include a change log if you're sending next versions of the same
patch. I can't tell what changed here, and the previous version had
already been applied.
