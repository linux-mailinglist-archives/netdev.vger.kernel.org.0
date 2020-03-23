Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A5B18FBDF
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgCWRur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:50:47 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:60799 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgCWRur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:50:47 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id BE1EBCECFF;
        Mon, 23 Mar 2020 19:00:16 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH 0/2] Bluetooth: Suspend related bugfixes
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200320000713.32899-1-abhishekpandit@chromium.org>
Date:   Mon, 23 Mar 2020 18:50:45 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <DB1736FA-94F3-4BD7-806E-7AC2E25D7D1E@holtmann.org>
References: <20200320000713.32899-1-abhishekpandit@chromium.org>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> After further automated testing of the upstreamed suspend patches,
> I found two issues:
> - A failure in PM_SUSPEND_PREPARE wasn't calling PM_POST_SUSPEND.
>  I misread the docs and thought it would call it for all notifiers
>  already run but it only does so for the ones that returned
>  successfully from PM_SUSPEND_PREPARE.
> - hci_conn_complete_evt wasn't completing on auto-connects (an else
>  block was removed during a refactor incorrectly)
> 
> With the following patches, I've run a suspend stress test on a couple
> of Chromebooks for several dozen iterations (each) successfully.
> 
> Thanks
> Abhishek
> 
> 
> 
> Abhishek Pandit-Subedi (2):
>  Bluetooth: Restore running state if suspend fails
>  Bluetooth: Fix incorrect branch in connection complete
> 
> net/bluetooth/hci_core.c  | 39 ++++++++++++++++++++-------------------
> net/bluetooth/hci_event.c | 17 +++++++++--------
> 2 files changed, 29 insertions(+), 27 deletions(-)

both patches have been applied to bluetooth-next tree.

Regards

Marcel

