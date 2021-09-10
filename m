Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07C940679E
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 09:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhIJH3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 03:29:04 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:43314 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhIJH3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 03:29:03 -0400
Received: from smtpclient.apple (p5b3d2185.dip0.t-ipconnect.de [91.61.33.133])
        by mail.holtmann.org (Postfix) with ESMTPSA id 31D1BCED3D;
        Fri, 10 Sep 2021 09:27:51 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH v6] Bluetooth: Keep MSFT ext info throughout a hci_dev's
 life cycle
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210909140945.v6.1.Id9bc5434114de07512661f002cdc0ada8b3d6d02@changeid>
Date:   Fri, 10 Sep 2021 09:27:50 +0200
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <1E0E222B-4948-4584-B18D-C7010CC48841@holtmann.org>
References: <20210909140945.v6.1.Id9bc5434114de07512661f002cdc0ada8b3d6d02@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> This splits the msft_do_{open/close} to msft_do_{open/close} and
> msft_{register/unregister}. With this change it is possible to retain
> the MSFT extension info irrespective of controller power on/off state.
> This helps bluetoothd to report correct 'supported features' of the
> controller to the D-Bus clients event if the controller is off. It also
> re-reads the MSFT info upon every msft_do_open().
> 
> The following test steps were performed.
> 1. Boot the test device and verify the MSFT support debug log in syslog.
> 2. Power off the controller and read the 'supported features', power on
>   and read again.
> 3. Restart the bluetoothd and verify the 'supported features' value.
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
> 
> Changes in v6:
> - Split msft_do_{open/close} into msft_do_{open/close} and
>  msft_{register/unregister}
> 
> Changes in v5:
> - Rebase on ToT and remove extra blank line
> 
> Changes in v4:
> - Re-read the MSFT data instead of skipping if it's initiated already
> 
> Changes in v3:
> - Remove the accepted commits from the series
> 
> net/bluetooth/hci_core.c |  3 +++
> net/bluetooth/msft.c     | 55 +++++++++++++++++++++++++++++++++-------
> net/bluetooth/msft.h     |  4 +++
> 3 files changed, 53 insertions(+), 9 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

