Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEBC19329D
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 22:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgCYV1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 17:27:19 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:54800 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgCYV1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 17:27:18 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 45775CECD7;
        Wed, 25 Mar 2020 22:36:48 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [RFC PATCH 1/1] Bluetooth: Update add_device to accept flags
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200319184913.RFC.1.I4657d5566e8562d9813915e16a1a38a27195671d@changeid>
Date:   Wed, 25 Mar 2020 22:27:15 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <75E407EB-397F-459C-A346-255307D92AC1@holtmann.org>
References: <20200320014950.85018-1-abhishekpandit@chromium.org>
 <20200319184913.RFC.1.I4657d5566e8562d9813915e16a1a38a27195671d@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> Add the capability to set flags on devices being added via add_device.
> The first flag being used is the wakeable flag which allows the device
> to wake the system from suspend.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> 
> include/net/bluetooth/mgmt.h |  5 ++++-
> net/bluetooth/mgmt.c         | 42 +++++++++++++++++++++++++++++++++++-
> 2 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
> index f41cd87550dc..e9db9b1a4436 100644
> --- a/include/net/bluetooth/mgmt.h
> +++ b/include/net/bluetooth/mgmt.h
> @@ -445,8 +445,11 @@ struct mgmt_rp_get_clock_info {
> struct mgmt_cp_add_device {
> 	struct mgmt_addr_info addr;
> 	__u8	action;
> +	__u8	flags_mask;
> +	__u8	flags_value;
> } __packed;
> -#define MGMT_ADD_DEVICE_SIZE		(MGMT_ADDR_INFO_SIZE + 1)
> +#define MGMT_ADD_DEVICE_SIZE		(MGMT_ADDR_INFO_SIZE + 3)

as I mentioned in the other review. This is not backwards compatible.

Regards

Marcel

