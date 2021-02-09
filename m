Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCB33146C5
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 04:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBIDBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 22:01:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229891AbhBIDBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 22:01:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C35D64DF0;
        Tue,  9 Feb 2021 03:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612839629;
        bh=qXZkT72C5vnrrfr2zzxxgKKbNKzOR1Q0rOKZtEYwcgU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kEcZlZQjL59IYld7kneL2A7wIm59gw4Yr0Dh/Fnpaz7080hc8ApkNz4uWRWlGiLDO
         /GBoRp3AWYmqHIGYafHKErNY0ocWTQE7c6EMP6cmeisV+gx7IbZehWfenZ8/lZVS0c
         DavaYwVqOriKhorBaZORwaHmVz9oMbBFXQW3qeJZKpU3F43wr+BQbthPdRMsoaf8Ek
         z1ScyguPz2K9mWNrD/wnzitqdpwzYUxrPnKpijO+6B28Wo/e/zwxnNM4eSohNjbeTG
         PP57Q38HlcS9uCDUYv5ckPWuEZY+oNuCt/vpftUYE8D6tPa052U7Cj1fxvP18627jx
         +32jWSAMjirwQ==
Date:   Mon, 8 Feb 2021 19:00:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 11/12] ice: Improve MSI-X fallback logic
Message-ID: <20210208190028.218cff93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210209011636.1989093-12-anthony.l.nguyen@intel.com>
References: <20210209011636.1989093-1-anthony.l.nguyen@intel.com>
        <20210209011636.1989093-12-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Feb 2021 17:16:35 -0800 Tony Nguyen wrote:
> Currently if the driver is unable to get all the MSI-X vectors it wants, it
> falls back to the minimum configuration which equates to a single Tx/Rx
> traffic queue pair. Instead of using the minimum configuration, if given
> more vectors than the minimum, utilize those vectors for additional traffic
> queues after accounting for other interrupts.
> 
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
