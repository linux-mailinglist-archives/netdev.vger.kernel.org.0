Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D620E2CC635
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731084AbgLBTHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:07:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbgLBTHW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 14:07:22 -0500
Date:   Wed, 2 Dec 2020 11:06:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606936002;
        bh=gQFVrdJVQ56bQPhxt6k8c/Mna8CvNDfQ+aEYrWOOSkA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=XiOfdJCEzNFPZv5+ztVK6a0v1G9kfN4XAn2ggntFK7OD3HzzlfW0ru9hr9shGDyNh
         sUkWGUXEwOoHyRU8xgMNaYkWr25DM/0eAkQeDLpA/20DM63U5SorgRX+xnOqJY3mFR
         Ziutb5mI7pcUJNYF/7ocXDvwYHi5pq/r79M2HMW+Vsqc0/T4NK9R3GQky+tWx8ZO1C
         jf7ysQj0VoZBv7gTLaqvMgnb+Wd1pK92oto72yKP8oShfsRY0Wa6U4qXTHeZLx7Owo
         Xe5AOsR1SLRfG5douB6jScqD2gomPIez0j4fIVIrD38GFYM/malFjGxbDPBLm6rc5V
         egEIEZfjn0aDg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mario Limonciello <mario.limonciello@dell.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com
Subject: Re: [PATCH v2 0/5] Improve s0ix flows for systems i219LM
Message-ID: <20201202110640.27269583@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202161748.128938-1-mario.limonciello@dell.com>
References: <20201202161748.128938-1-mario.limonciello@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 10:17:43 -0600 Mario Limonciello wrote:
> commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
> disabled s0ix flows for systems that have various incarnations of the
> i219-LM ethernet controller.  This was done because of some regressions
> caused by an earlier
> commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for cable connected case")
> with i219-LM controller.
> 
> Performing suspend to idle with these ethernet controllers requires a properly
> configured system.  To make enabling such systems easier, this patch
> series allows turning on using ethtool.
> 
> The flows have also been confirmed to be configured correctly on Dell's Latitude
> and Precision CML systems containing the i219-LM controller, when the kernel also
> contains the fix for s0i3.2 entry previously submitted here:
> https://marc.info/?l=linux-netdev&m=160677194809564&w=2
> 
> Patches 3 and 4 will turn the behavior on by default for Dell's CML systems.
> Patch 5 allows accessing the value of the flags via ethtool to tell if the
> heuristics have turned on s0ix flows, as well as for development purposes
> to determine if a system should be added to the heuristics list.

I don't see PCI or Bjorn Helgaas CCed.

You can drop linux-kernel tho.
