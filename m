Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422CF265A54
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 09:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgIKHSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 03:18:45 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:54149 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgIKHSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 03:18:41 -0400
Received: from marcel-macbook.fritz.box (p4ff9f430.dip0.t-ipconnect.de [79.249.244.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id C6F92CED19;
        Fri, 11 Sep 2020 09:25:34 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH 0/2] Bluetooth: Report extended adv capabilities to
 userspace
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200825233151.1580920-1-danielwinkler@google.com>
Date:   Fri, 11 Sep 2020 09:18:38 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <EDA4EEF8-F025-4C14-BD01-D4391F083B35@holtmann.org>
References: <20200825233151.1580920-1-danielwinkler@google.com>
To:     Daniel Winkler <danielwinkler@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

> This series improves the kernel/controller support that is reported
> to userspace for the following extended advertising features:
> 
> 1. If extended advertising is available, the number of hardware slots
> is used and reported, rather than the fixed default of 5. If no hardware
> support is available, default is used as before for software rotation.
> 
> 2. New flags indicating general hardware offloading and ability to
> set tx power level. These are kept as two separate flags because in
> the future vendor commands may allow tx power to be set without
> hardware offloading support.
> 
> 
> Daniel Winkler (2):
>  bluetooth: Report num supported adv instances for hw offloading
>  bluetooth: Add MGMT capability flags for tx power and ext advertising
> 
> include/net/bluetooth/mgmt.h | 2 ++
> net/bluetooth/hci_core.c     | 2 +-
> net/bluetooth/mgmt.c         | 8 +++++---
> 3 files changed, 8 insertions(+), 4 deletions(-)

both patches have been applied to bluetooth-next tree.

Regards

Marcel

