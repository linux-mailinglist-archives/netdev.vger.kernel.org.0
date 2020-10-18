Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFB1291913
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgJRTDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726249AbgJRTDi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:03:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0AB422267;
        Sun, 18 Oct 2020 19:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603047818;
        bh=grwSBB9QbtI9q+8ThvC366A7K50iHzDD1VRkp3UvbfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OrZ3CUZByjB0YxQcS6SAWrMzsGb2DmTx4XzB+WD3ICVXWxVoJKgVKck2bbhT3dPGf
         P4sfDMyFKe5BZkUpDTyeEA6ED0ZksQ3PfL2JLDCpHcVM8NcV6xdl4v38krZYV/raQz
         xYqpu6AjT/MWghczyfMltKqYQAIxd+9yfKqO3z3A=
Date:   Sun, 18 Oct 2020 12:03:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     sven.auhagen@voleatech.de, anthony.l.nguyen@intel.com,
        davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH v2 0/6] igb: xdp patches followup
Message-ID: <20201018120336.4a662b4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201018133951.GB34104@ranger.igk.intel.com>
References: <20201017071238.95190-1-sven.auhagen@voleatech.de>
 <20201018133951.GB34104@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 18 Oct 2020 15:39:51 +0200 Maciej Fijalkowski wrote:
> - next time please specify the tree in the subject that you're targetting
>   this set to land; is it net or net-next? net-next is currently closed so
>   you probably would have to come back with this once it will be open
>   again

Most of the patches here look like fixes, so we can take them into net
but please repost them rather soon.
