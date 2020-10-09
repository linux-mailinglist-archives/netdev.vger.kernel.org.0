Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2282899AE
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732506AbgJIUXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgJIUXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 16:23:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 796BE221FD;
        Fri,  9 Oct 2020 20:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602275004;
        bh=vCKA5aGghvuvrTk8ECw39QojG+q26rX7YmQI3hO8obg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K5HV8QiCFywSL9Rnb+21FLM7Qw41Fzr42kPN3FB2ebLHVQ4ePwQC9yUDEB6WwMHEj
         95HgTOAb13cxCJda4nN/V8OTmNzubv/A00ZiimR42Ml+UDtH4cItLGjJ7EfeHbE049
         xtRVnT8B3/NyXi0LtqoENGucOdvvcBqajs5npxfM=
Date:   Fri, 9 Oct 2020 13:23:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next 0/8][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-10-07
Message-ID: <20201009132322.3c6f8306@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
References: <20201007175447.647867-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 10:54:39 -0700 Tony Nguyen wrote:
> This series contains updates to ice driver only.
> 
> Andy Shevchenko changes usage to %*phD format to print small buffer as hex
> string.
> 
> Bruce removes repeated words reported by checkpatch.
> 
> Ani changes ice_info_get_dsn() to return void as it always returns
> success.
> 
> Jake adds devlink reporting of fw.app.bundle_id. Moves devlink_port
> structure to ice_vsi to resolve issues with cleanup. Adds additional
> debug info for firmware updates.
> 
> Bixuan Cui resolves -Wpointer-to-int-cast warnings.
> 
> Dan adds additional packet type masks and checks to prevent overwriting
> existing Flow Director rules.

Applied, thanks!

> The following are changes since commit 9faebeb2d80065926dfbc09cb73b1bb7779a89cd:
>   Merge branch 'ethtool-allow-dumping-policies-to-user-space'
> and are available in the git repository at:
>   https://github.com/anguy11/next-queue.git 100GbE

FWIW I applied the patches from the ML. Let me know if there is a
reason to use PRs, otherwise I think the patches from the ML are
easier for both of us - given those are the ones reviewed and build
tested.
