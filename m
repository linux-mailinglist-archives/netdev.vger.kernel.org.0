Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478E327B700
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 23:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgI1V2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 17:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgI1V2k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 17:28:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9658C2083B;
        Mon, 28 Sep 2020 21:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601328520;
        bh=IF9F3UM03r/iNyJXTi0t51mU5oj04cKMIfaNEbf7mmY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BD88ckUyNUUGppnKl0WESwqc+MD4cW+2lFNSXRGuAqlWt8vZ+p4USWYtIKrUReeRs
         dbqeDTs7DkuylPik+9E1PVXsjKDQzfGgMvqQo26DY5lAqz02jMe9rpQRtLPR48dMcg
         /03tBWmyT/sZ5p0IoVXWCJJfvgtQcLRPqVSqBg/w=
Date:   Mon, 28 Sep 2020 14:28:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <jerinj@marvell.com>, <davem@davemloft.net>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [net PATCH] octeontx2-af: Fix enable/disable of default NPC
 entries
Message-ID: <20200928142837.0f529a24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1601103420-1591-1-git-send-email-gakula@marvell.com>
References: <1601103420-1591-1-git-send-email-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Sep 2020 12:27:00 +0530 Geetha sowjanya wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> Packet replication feature present in Octeontx2
> is a hardware linked list of PF and its VF
> interfaces so that broadcast packets are sent
> to all interfaces present in the list. It is
> driver job to add and delete a PF/VF interface
> to/from the list when the interface is brought
> up and down. This patch fixes the
> npc_enadis_default_entries function to handle
> broadcast replication properly if packet replication
> feature is present.
> 
> Fixes: 40df309e4166
> ("octeontx2-af: Support to enable/disable default MCAM entries")
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

The patches look good, but could you please resend them with fixed
"Fixes" tags? The tag should be on one line with no empty line between
the tag and the signoffs. So the above should have looked like:

Fixes: 40df309e4166 ("octeontx2-af: Support to enable/disable default MCAM entries")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
