Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DE01FCAF3
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 12:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgFQKdu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jun 2020 06:33:50 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:60498 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgFQKdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 06:33:49 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 66051CECD1;
        Wed, 17 Jun 2020 12:43:39 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2] Bluetooth: Terminate the link if pairing is cancelled
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200616092341.v2.1.I9dd050ead919f2cc3ef83d4e866de537c7799cf3@changeid>
Date:   Wed, 17 Jun 2020 12:33:47 +0200
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4F76321E-918F-4A16-B35A-888733D5B75D@holtmann.org>
References: <20200616092341.v2.1.I9dd050ead919f2cc3ef83d4e866de537c7799cf3@changeid>
To:     Manish Mandlik <mmandlik@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

> If user decides to cancel the ongoing pairing process (e.g. by clicking
> the cancel button on pairing/passkey window), abort any ongoing pairing
> and then terminate the link if it was created because of the pair
> device action.
> 
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> ---
> 
> Changes in v2:
> - Added code to track if the connection was triggered because of the pair
>  device action and then only terminate the link on pairing cancel.
> 
> include/net/bluetooth/hci_core.h | 14 ++++++++++++--
> net/bluetooth/hci_conn.c         | 11 ++++++++---
> net/bluetooth/l2cap_core.c       |  6 ++++--
> net/bluetooth/mgmt.c             | 22 ++++++++++++++++++----
> 4 files changed, 42 insertions(+), 11 deletions(-)

patch has been added to my local tree. I will send an update with all pending patches in a bit.

Regards

Marcel

