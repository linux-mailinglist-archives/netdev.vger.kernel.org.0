Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EA946D65F
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhLHPIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhLHPIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:08:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80939C061746;
        Wed,  8 Dec 2021 07:04:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40933B8169E;
        Wed,  8 Dec 2021 15:04:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE06C00446;
        Wed,  8 Dec 2021 15:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638975883;
        bh=qUvfpjDEI3ABilYmDt9oChKf5p0JHlH+G35JVmCRMD4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q6hwaM37AvFWVtO13K0rS6lxky6JEyBBgyYFLha4e6FVPqkCGOPSN7T2JXS+1Thl3
         rXmAquSB1LG4sDwrdXoovg/cT/WgkKtvevOsQ1WM9pftE0mpHqQUR+/0Fqr4A9Xn76
         8YvDQhhqCqAIb1YkrBqMHRA61uJz2jYBa4F++pQkDgx6fK5pDZNwwhSv3i/kkgeZNb
         T8NAktVvaHgj9vS7UWbXNsarTgEqPRmlhLTYb1VPa1q/rfruu8wxrKPPdCLMeV4b3L
         83IA6tGHv0Dt3aNxpiE/xexPMeacWXZtryC4YhhuCCjU4Rf4L2xeEKgvK0MXjrGlM1
         jpZSazNRMzgXQ==
Date:   Wed, 8 Dec 2021 07:04:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ameer Hamza <amhamza.mgc@gmail.com>
Cc:     kabel@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: error handling for serdes_power
 functions
Message-ID: <20211208070441.0aef4790@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208140957.GA96979@hamza-OptiPlex-7040>
References: <20211207140647.6926a3e7@thinkpad>
        <20211208140413.96856-1-amhamza.mgc@gmail.com>
        <20211208140957.GA96979@hamza-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 19:09:57 +0500 Ameer Hamza wrote:
> I checked serdes.c and I found two methods mv88e6390_serdes_power() and
> mv88e6390_serdes_power() that were not returning ENINVAL in case of
> undefined cmode. Would be appreciated if  you can review the patch
> please.

A note for the future - please put more info into the commit 
message, it shouldn't be necessary to send a follow up email 
with the explanation.
