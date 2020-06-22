Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AC920303C
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 09:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbgFVHIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 03:08:47 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:50642 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726850AbgFVHIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 03:08:47 -0400
Received: from marcel-macpro.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id CA239CED25;
        Mon, 22 Jun 2020 09:18:37 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: Add hci_dev_lock to get/set device flags
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200619171016.1.I56e71a63b5d2712a1b198681e0f107b5aa3cd725@changeid>
Date:   Mon, 22 Jun 2020 09:08:45 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <362A4F69-4252-4D1F-86D3-03E9AA861BA3@holtmann.org>
References: <20200619171016.1.I56e71a63b5d2712a1b198681e0f107b5aa3cd725@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Adding hci_dev_lock since hci_conn_params_(lookup|add) require this
> lock.
> 
> Suggested-by: Miao-chen Chou <mcchou@chromium.org>
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> net/bluetooth/mgmt.c | 8 ++++++++
> 1 file changed, 8 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

