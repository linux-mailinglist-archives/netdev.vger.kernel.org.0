Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1DC2192A3
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgGHVjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgGHVjl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 17:39:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F9EA206A1;
        Wed,  8 Jul 2020 21:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594244381;
        bh=5Y/6UM1ES9QZNUD07PvTmcbKu77ujHmh/fB3mOd66A0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YhOGqRFpPH6wDnpev+gYG0+QE5HaVST/J8+B7OWuMWyteSBWiGqSSg0/OXUOKNqny
         xboRLZZswJQbKNlsvCUhjiO71WRkKRB6YPARR3dFdcAPC4UtKDpa0fXXVYo2qpq19e
         U2OWOxXsF2j5QSkOooZ0yyfsUAckxav6j6EU0uvg=
Date:   Wed, 8 Jul 2020 14:39:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/9] bnxt_en: Driver update for net-next.
Message-ID: <20200708143939.62014a87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
References: <1594209241-1692-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jul 2020 07:53:52 -0400 Michael Chan wrote:
> This patchset implements ethtool -X to setup user-defined RSS indirection
> table.  The new infrastructure also allows the proper logical ring index
> to be used to populate the RSS indirection when queried by ethtool -x.
> Prior to these patches, we were incorrectly populating the output of
> ethtool -x with internal ring IDs which would make no sense to the user.
> 
> The last 2 patches add some cleanups to the VLAN acceleration logic
> and check the firmware capabilities before allowing VLAN acceleration
> offloads.
> 
> v4: Move bnxt_get_rxfh_indir_size() fix to a new patch #2.
>     Modify patch #7 to revert RSS map to default only when necessary.
> 
> v3: Use ALIGN() in patch 5.
>     Add warning messages in patch 6.
> 
> v2: Some RSS indirection table changes requested by Jakub Kicinski.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
