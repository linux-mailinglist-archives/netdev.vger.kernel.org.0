Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BA846AEDA
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354067AbhLGARM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:17:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48484 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351131AbhLGARL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:17:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3557B81615
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 00:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E748FC004DD;
        Tue,  7 Dec 2021 00:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638836020;
        bh=92OsoLvFF+aNMFQ50kLHCk2ylLybdTDxz2rjnSJivm4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SQRoQ0HNJWLm/+VuTWjdHebuAwJ1HjTZitdDiXpubvVn4ANPvk8E2p0VX2W72sm7E
         yh0dEYpVPolrYIPXHcYhGaTo/TtW7tEenakOae5NDSG5EMOFyjvDxNO6cgrmb7mX6V
         VznetbdE6aYA50Hzs4zgsLniDa5z5Lh9InFzi9lNH7C2AfJ0dEUHOixTF9P41NGWNV
         hyrpqZ3mLrXuHtNscx/G6fHHN1g2KojaWh17IcxJNXRS65nkuC8dL8CeualGYv+MK0
         rHSQ8GSvi2Qopx807fJdqlmNamoqVHHQe2JMf38uiCRXGjmJI8N5303vabtT7agyKV
         Or0gbe1r9nFPA==
Date:   Mon, 6 Dec 2021 16:13:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next v2 0/4] WWAN debugfs tweaks
Message-ID: <20211206161338.02b80dd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211206234155.15578-1-ryazanov.s.a@gmail.com>
References: <20211206234155.15578-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Dec 2021 02:41:51 +0300 Sergey Ryazanov wrote:
> The 4th patch should be applied after the Arnd Bergmann fix for the
> relayfs support selection [2].

Please repost once the dependency is merged, buildbots can't deal 
with dependencies.
