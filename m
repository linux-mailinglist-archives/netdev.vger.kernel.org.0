Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B53C32C488
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392572AbhCDAO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:14:59 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:32849 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452899AbhCCQvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 11:51:25 -0500
Received: from marcel-macbook.holtmann.net (p4ff9fb90.dip0.t-ipconnect.de [79.249.251.144])
        by mail.holtmann.org (Postfix) with ESMTPSA id E28C9CED05;
        Wed,  3 Mar 2021 17:58:10 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH v3 1/1] Bluetooth: Remove unneeded commands for suspend
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210303083400.v3.1.Ifcac8bd85b5339135af8e08370bacecc518b1c35@changeid>
Date:   Wed, 3 Mar 2021 17:50:36 +0100
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <2CB58E31-C5CB-4A61-9983-EB4C9485E8A6@holtmann.org>
References: <20210303163404.1779850-1-abhishekpandit@chromium.org>
 <20210303083400.v3.1.Ifcac8bd85b5339135af8e08370bacecc518b1c35@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> During suspend, there are a few scan enable and set event filter
> commands that don't need to be sent unless there are actual BR/EDR
> devices capable of waking the system. Check the HCI_PSCAN bit before
> writing scan enable and use a new dev flag, HCI_EVENT_FILTER_CONFIGURED
> to control whether to clear the event filter.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> ---
> 
> Changes in v3:
> * Minor change to if statement
> 
> Changes in v2:
> * Removed hci_dev_lock from hci_cc_set_event_filter since flags are
>  set/cleared atomically
> 
> include/net/bluetooth/hci.h |  1 +
> net/bluetooth/hci_event.c   | 27 +++++++++++++++++++++++
> net/bluetooth/hci_request.c | 44 +++++++++++++++++++++++--------------
> 3 files changed, 55 insertions(+), 17 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

