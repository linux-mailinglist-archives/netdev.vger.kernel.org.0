Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA9F1A116F
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 18:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgDGQd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 12:33:28 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:46496 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbgDGQd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 12:33:28 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id E88BACECD8;
        Tue,  7 Apr 2020 18:43:00 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v2] Bluetooth: debugfs option to unset MITM flag
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200407122522.v2.1.Ibfc500cbf0bf2dc8429b17f064e960e95bb228e9@changeid>
Date:   Tue, 7 Apr 2020 18:33:26 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <9FED3BF8-B784-4E71-86C2-5BFACB18F1AA@holtmann.org>
References: <20200407122522.v2.1.Ibfc500cbf0bf2dc8429b17f064e960e95bb228e9@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> The BT qualification test SM/MAS/PKE/BV-01-C needs us to turn off
> the MITM flag when pairing, and at the same time also set the io
> capability to something other than no input no output.
> 
> Currently the MITM flag is only unset when the io capability is set
> to no input no output, therefore the test cannot be executed.
> 
> This patch introduces a debugfs option to force MITM flag to be
> turned off.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> ---
> 
> Changes in v2:
> - Rename flag to HCI_FORCE_NO_MITM
> - Move debugfs functions to hci_debugfs.c
> - Add comments on not setting SMP_AUTH_MITM
> 
> include/net/bluetooth/hci.h |  1 +
> net/bluetooth/hci_debugfs.c | 46 +++++++++++++++++++++++++++++++++++++
> net/bluetooth/smp.c         | 15 ++++++++----
> 3 files changed, 57 insertions(+), 5 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

