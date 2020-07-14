Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF39621FDB2
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbgGNTpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:45:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729329AbgGNTpk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 15:45:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09AE6229C9;
        Tue, 14 Jul 2020 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594755939;
        bh=QgnZ+e+8zlV/Lh3hbtm/iY/2v9r7yDBTvT5hho/ja5A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cPDf59VyKIVcL/5JthyEADrSXPX73+7QXTZtZd6hvbSU7Qt2P+zIUEWzAExfcjuoo
         6OmdIWruShMFAU83HkeSo1zmVMctpk1T87LP2LX9glLus49CH45GWk/4oTzGUz+N70
         TpuNOx4x9kWfgXVSlN5LEZfyraMcAjQZWHqajD00=
Date:   Tue, 14 Jul 2020 12:45:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        OSS Drivers <oss-drivers@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, Tom Lendacky <thomas.lendacky@amd.com>,
        Ariel Elior <aelior@marvell.com>, skalluru@marvell.com,
        vishal@chelsio.com, benve@cisco.com, _govind@gmx.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        anthony.l.nguyen@intel.com, GR-everest-linux-l2@marvell.com,
        shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com
Subject: Re: [PATCH net-next v3 01/12] nfp: convert to new udp_tunnel_nic
 infra
Message-ID: <20200714124537.46d708fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAADnVQJYQFy+xdfPY6FSHgUvL-YZy=tZ4w0TU=d4wXCJTU7R1Q@mail.gmail.com>
References: <20200714191830.694674-1-kuba@kernel.org>
        <20200714191830.694674-2-kuba@kernel.org>
        <CAADnVQJYQFy+xdfPY6FSHgUvL-YZy=tZ4w0TU=d4wXCJTU7R1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 12:24:10 -0700 Alexei Starovoitov wrote:
> On Tue, Jul 14, 2020 at 12:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > NFP conversion is pretty straightforward. We want to be able
> > to sleep, and only get callbacks when the device is open.
> >
> > NFP did not ask for port replay when ports were removed, now
> > new infra will provide this feature for free.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Reviewed-by: Simon Horman <simon.horman@netronome.com>  
> 
> I received this patch at least 3 times in the last couple of days.
> Every time gmail marks it as new and I keep archiving it.
> Is it just me  ?

It's v3, that'd add up.
