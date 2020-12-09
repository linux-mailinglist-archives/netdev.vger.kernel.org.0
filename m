Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623552D4EE3
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388643AbgLIXoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:44:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:32802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388631AbgLIXnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:43:50 -0500
Date:   Wed, 9 Dec 2020 15:43:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607557384;
        bh=+c0ca5zidLBtV0WQT+M6L2oC7W9CxOG6LU9fUbXq5IY=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=TuBdDqJnLVHUWgj9KXqB0UfcC/5bP/RHMgJZn8nUuPoL3Hn1TxQO76Mo5WbrVUWQb
         zmljHZpIs3RWMkWHk9x8Yoy/ZBixzGxVBY8lvkBGXEHQNzvXRnFItHUqG1+7UiHDtp
         jckQxb/dXxhIlcM4uPv/x+Vsntt4C/vdT+EyNjjuiTFM0pnFnJEU3gfPOhVtNjLf0J
         r5vghJv43vfE1DCK7sc2XOw8Ou3b4zKBVRn7lHqpYFRzNUZs/1FlYlxN6HJkRNBaxn
         Eb4NI8a/SvkcPpWWJTQn2Ij6yA+S51T+N57jhBbn0lBYuJgApEKTmEQOhYg5kYFjkd
         Uczq3U/xPe+Ug==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mario Limonciello <mario.limonciello@dell.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com,
        Vitaly Lifshits <vitaly.lifshits@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH RESEND] e1000e: fix S0ix flow to allow S0i3.2 subset
 entry
Message-ID: <20201209154302.266adf70@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208185632.151052-1-mario.limonciello@dell.com>
References: <20201208185632.151052-1-mario.limonciello@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Dec 2020 12:56:32 -0600 Mario Limonciello wrote:
> From: Vitaly Lifshits <vitaly.lifshits@intel.com>
> 
> Changed a configuration in the flows to align with
> architecture requirements to achieve S0i3.2 substate.
> 
> This helps both i219V and i219LM configurations.
> 
> Also fixed a typo in the previous commit 632fbd5eb5b0
> ("e1000e: fix S0ix flows for cable connected case").
> 
> Fixes: 632fbd5eb5b0 ("e1000e: fix S0ix flows for cable connected case").
> Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>

Applied, thank you!
