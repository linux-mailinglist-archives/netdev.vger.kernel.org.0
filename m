Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CEA30AC47
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 17:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhBAQGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 11:06:04 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:33297 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhBAQFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 11:05:50 -0500
Received: from marcel-macbook.holtmann.net (p4fefcdd8.dip0.t-ipconnect.de [79.239.205.216])
        by mail.holtmann.org (Postfix) with ESMTPSA id 513A5CED21;
        Mon,  1 Feb 2021 17:12:31 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH v3] Bluetooth: Skip eSCO 2M params when not supported
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210129135322.v3.1.I7d3819e3c406b20307a56fe96159e8f842f72d89@changeid>
Date:   Mon, 1 Feb 2021 17:05:04 +0100
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <57D64568-5DCB-4FAA-A23F-D16A2D7551A1@holtmann.org>
References: <20210129135322.v3.1.I7d3819e3c406b20307a56fe96159e8f842f72d89@changeid>
To:     Yu Liu <yudiliu@google.com>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yu,

> If a peer device doesn't support eSCO 2M we should skip the params that
> use it when setting up sync connection since they will always fail.
> 
> Signed-off-by: Yu Liu <yudiliu@google.com>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> Changes in v3:
> - Use pkt_type instead of adding new field
> 
> Changes in v2:
> - Fix title
> 
> Changes in v1:
> - Initial change
> 
> include/net/bluetooth/hci_core.h |  1 +
> net/bluetooth/hci_conn.c         | 20 ++++++++++++++++++--
> 2 files changed, 19 insertions(+), 2 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

