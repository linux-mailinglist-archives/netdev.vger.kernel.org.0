Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7CB2AB84B
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 13:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbgKIMdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 07:33:18 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:44582 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKIMdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 07:33:18 -0500
Received: from marcel-macbook.fritz.box (p4fefcf0f.dip0.t-ipconnect.de [79.239.207.15])
        by mail.holtmann.org (Postfix) with ESMTPSA id 427FDCECC5;
        Mon,  9 Nov 2020 13:40:25 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] Bluetooth: Resume advertising after LE connection
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201106151937.1.I8362b4cedb0f34b7a88b8dbd3a62155085e02ea7@changeid>
Date:   Mon, 9 Nov 2020 13:33:16 +0100
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <7EEBEC7D-DC35-461E-A51A-4507AC690960@holtmann.org>
References: <20201106151937.1.I8362b4cedb0f34b7a88b8dbd3a62155085e02ea7@changeid>
To:     Daniel Winkler <danielwinkler@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

> When an LE connection request is made, advertising is disabled and never
> resumed. When a client has an active advertisement, this is disruptive.
> This change adds resume logic for client-configured (non-directed)
> advertisements after the connection attempt.
> 
> The patch was tested by registering an advertisement, initiating an LE
> connection from a remote peer, and verifying that the advertisement is
> re-activated after the connection is established. This is performed on
> Hatch and Kukui Chromebooks.
> 
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Daniel Winkler <danielwinkler@google.com>

in the future, please sure that the originator Signed-off-by comes first and
the Reviewed-by lines after it

> ---
> 
> net/bluetooth/hci_conn.c    | 12 ++++++++++--
> net/bluetooth/hci_request.c | 21 ++++++++++++++++-----
> net/bluetooth/hci_request.h |  2 ++
> 3 files changed, 28 insertions(+), 7 deletions(-)

Patch has been applied to bluetooth-next tree.

Regards

Marcel

