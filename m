Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B652ABD9A
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731825AbgKINr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:47:28 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:55320 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgKIM5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 07:57:05 -0500
Received: from marcel-macbook.fritz.box (p4fefcf0f.dip0.t-ipconnect.de [79.239.207.15])
        by mail.holtmann.org (Postfix) with ESMTPSA id 81D68CECC5;
        Mon,  9 Nov 2020 14:04:10 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v2] Bluetooth: Move force_bredr_smp debugfs into
 hci_debugfs_create_bredr
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200929080324.632523-1-tientzu@chromium.org>
Date:   Mon, 9 Nov 2020 13:57:01 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4B6CE6A7-CE12-4057-AA58-32B4303D87F8@holtmann.org>
References: <20200929080324.632523-1-tientzu@chromium.org>
To:     Claire Chang <tientzu@chromium.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Claire,

> Avoid multiple attempts to create the debugfs entry, force_bredr_smp,
> by moving it from the SMP registration to the BR/EDR controller init
> section. hci_debugfs_create_bredr is only called when HCI_SETUP and
> HCI_CONFIG is not set.
> 
> Signed-off-by: Claire Chang <tientzu@chromium.org>
> ---
> v2: correct a typo in commit message
> 
> net/bluetooth/hci_debugfs.c | 50 +++++++++++++++++++++++++++++++++++++
> net/bluetooth/smp.c         | 44 ++------------------------------
> net/bluetooth/smp.h         |  2 ++
> 3 files changed, 54 insertions(+), 42 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

