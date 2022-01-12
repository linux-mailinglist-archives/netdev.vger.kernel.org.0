Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B1E48BDC4
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 04:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350519AbiALDv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 22:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiALDv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 22:51:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9187C06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 19:51:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B017BB818AA
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 03:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D43C36AE5;
        Wed, 12 Jan 2022 03:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641959514;
        bh=fxfMcbofFmYEf5WvsjVXZuruFYe2u3Oadwm10rwWyiU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r54UDIsRQjSOrwKRKHcW3gPFfpkU/3AV8t/oVO87q4Fcm+wR2SKXsEqeSylaVOxTm
         YH8GR3sGluNz3HpdaqGxg206nnvHRVkav4217fE7Q/8trn+vQj4X4NIanYq87s5mbb
         C241BrxbEggF6VmFiA5g6S9dzsYt2S0iCobjGPbZ6c9hYH5OU+iU6NMHI+9DOFxuH1
         YfHmrY+hYG6sTX+4y+5yP4HutCphzGZtxileFjb3j7Nre+hF6U3fjXVXFJiLsp6rMf
         VpBiHCytEs9hPkKM9q/g0bUABhqLnm8bKSCABxitC9d0WLHCvvdm++2mI7rvsh8qhT
         rXo6EfnG8hYhg==
Date:   Tue, 11 Jan 2022 19:51:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net
Subject: Re: [PATCH net-next v2 1/3] net: phy: at803x: move page selection
 fix to config_init
Message-ID: <20220111195153.4be7a16f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220111215504.2714643-2-robert.hancock@calian.com>
References: <20220111215504.2714643-1-robert.hancock@calian.com>
        <20220111215504.2714643-2-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 15:55:02 -0600 Robert Hancock wrote:
> The fix to select the copper page on AR8031 was being done in the probe
> function rather than config_init, so it would not be redone after resume
> from suspend. Move this to config_init so it is always redone when
> needed.
> 
> Fixes: c329e5afb42f ("net: phy: at803x: select correct page on config init")

Please make sure to CC authors of patches in the fixes tags, they are
usually good reviewers.
