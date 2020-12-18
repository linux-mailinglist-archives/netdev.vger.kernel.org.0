Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7742DEB13
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 22:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbgLRV2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 16:28:21 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:52708 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgLRV2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 16:28:20 -0500
Received: from marcel-macbook.holtmann.net (p4fefcdf9.dip0.t-ipconnect.de [79.239.205.249])
        by mail.holtmann.org (Postfix) with ESMTPSA id C0E83CED33;
        Fri, 18 Dec 2020 22:34:55 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: [PATCH 1/1] Bluetooth: Remove hci_req_le_suspend_config
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201207161221.1.I94feef9a75a69b0d0c7038d975239ef3b1b93ee6@changeid>
Date:   Fri, 18 Dec 2020 22:27:38 +0100
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Howard Chung <howardchung@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <C0715297-245B-45A7-A6FD-3A1A04710AD0@holtmann.org>
References: <20201208001254.575890-1-abhishekpandit@chromium.org>
 <20201207161221.1.I94feef9a75a69b0d0c7038d975239ef3b1b93ee6@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Add a missing SUSPEND_SCAN_ENABLE in passive scan, remove the separate
> function for configuring le scan during suspend and update the request
> complete function to clear both enable and disable tasks.
> 
> Fixes: dce0a4be8054 ("Bluetooth: Set missing suspend task bits")
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> net/bluetooth/hci_request.c | 25 ++++++++-----------------
> 1 file changed, 8 insertions(+), 17 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

