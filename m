Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B29256D0A
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 11:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgH3JSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 05:18:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbgH3JSK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Aug 2020 05:18:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ACFF20714;
        Sun, 30 Aug 2020 09:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598779090;
        bh=4gJ7NN/H4ONVbNKPoKOQktRZKpaRJ+juo2KX4MEgL04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GzNpPawjHdJDC5Aqr+olvKQsVN5Tp+oHeiTDbaEpznDzXM7VF6OPu0I/vgyaBiXW8
         IN/2wyT5EjS8UULRfqAVr518SJa/C5X07H756FOZQCsgxizKmRgdcm9gvJ/VxMa3Ts
         bE9UbT/OOZSFaI+CE3vYXRKRab9ClY4tS3figrtE=
Date:   Sun, 30 Aug 2020 11:18:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anmol Karn <anmol.karan123@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com,
        netdev@vger.kernel.org,
        syzbot+0bef568258653cff272f@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, kuba@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org, davem@davemloft.net
Subject: Re: [Linux-kernel-mentees] [PATCH] net: bluetooth: Fix null pointer
 deref in hci_phy_link_complete_evt
Message-ID: <20200830091808.GA122343@kroah.com>
References: <20200829124112.227133-1-anmol.karan123@gmail.com>
 <20200829165712.229437-1-anmol.karan123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200829165712.229437-1-anmol.karan123@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 29, 2020 at 10:27:12PM +0530, Anmol Karn wrote:
> Fix null pointer deref in hci_phy_link_complete_evt, there was no 
> checking there for the hcon->amp_mgr->l2cap_conn->hconn, and also 
> in hci_cmd_work, for hdev->sent_cmd.
> 
> To fix this issue Add pointer checking in hci_cmd_work and
> hci_phy_link_complete_evt.
> [Linux-next-20200827]
> 
> This patch corrected some mistakes from previous patch.

So this is a v2?  That should go below the --- line, right?  And you
should have a v2 in the subject line like the documentation asks?

Can you redo this please?

thanks,

greg k-h
