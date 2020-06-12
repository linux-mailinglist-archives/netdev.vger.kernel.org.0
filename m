Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC251F7CA3
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 19:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgFLRt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 13:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgFLRtz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 13:49:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E46D20835;
        Fri, 12 Jun 2020 17:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591984195;
        bh=J0DPukvkbx9lZmoUXIpR5Hr1tA3Fg6w8OyFfhndfJdg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ycGb4OgHXuBinxtKbBaVran6kE/iPBBGzgynhheGbRsY6QIsEiwJojYxeEGQswOR0
         obF/zqOAsHYdcBZgVKUmtl6EQkO9WgdMJe1sOkTI6Qv7HJ2ot1FgPOOPp6JE6l4R38
         3E6fPh2ncSMexCuYCljeTOleyf01XlgdhZA29T5w=
Date:   Fri, 12 Jun 2020 10:49:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Miao-chen Chou <mcchou@chromium.org>
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Yoni Shavit <yshavit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 4/7] Bluetooth: Add handler of
 MGMT_OP_REMOVE_ADV_MONITOR
Message-ID: <20200612104952.0955d965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200611231459.v3.4.Ib4effd5813fb2f8585e2c7394735050c16a765eb@changeid>
References: <20200611231459.v3.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
        <20200611231459.v3.4.Ib4effd5813fb2f8585e2c7394735050c16a765eb@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Jun 2020 23:15:26 -0700 Miao-chen Chou wrote:
> This adds the request handler of MGMT_OP_REMOVE_ADV_MONITOR command.
> Note that the controller-based monitoring is not yet in place. This
> removes the internal monitor(s) without sending HCI traffic, so the
> request returns immediately.
> 
> The following test was performed.
> - Issue btmgmt advmon-remove with valid and invalid handles.
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>

Still doesn't build cleanly with W=1 C=1

net/bluetooth/mgmt.c:4009:46: warning: incorrect type in argument 2 (different base types)
net/bluetooth/mgmt.c:4009:46:    expected unsigned short [usertype] handle
net/bluetooth/mgmt.c:4009:46:    got restricted __le16 [usertype] monitor_handle
net/bluetooth/mgmt.c:4018:29: warning: cast from restricted __le16
