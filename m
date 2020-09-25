Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BC1278FB7
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgIYRgk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 25 Sep 2020 13:36:40 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:43069 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbgIYRgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:36:40 -0400
Received: from [172.20.10.2] (dynamic-046-114-136-219.46.114.pool.telefonica.de [46.114.136.219])
        by mail.holtmann.org (Postfix) with ESMTPSA id 27265CECDF;
        Fri, 25 Sep 2020 19:43:35 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v5 4/4] Bluetooth: Add toggle to switch off interleave
 scan
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200923172129.v5.4.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Date:   Fri, 25 Sep 2020 19:36:33 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        mmandlik@chromium.orgi, Miao-chen Chou <mcchou@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D9C4CE14-371B-46DD-8FF7-FBA4593788B6@holtmann.org>
References: <20200923172129.v5.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
 <20200923172129.v5.4.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> This patch add a configurable parameter to switch off the interleave
> scan feature.
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> ---
> 
> (no changes since v4)
> 
> Changes in v4:
> - Set EnableAdvMonInterleaveScan default to Disable
> - Fix 80 chars limit in mgmt_config.c
> 
> include/net/bluetooth/hci_core.h | 1 +
> net/bluetooth/hci_core.c         | 1 +
> net/bluetooth/hci_request.c      | 3 ++-
> net/bluetooth/mgmt_config.c      | 5 +++++
> 4 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index cfede18709d8f..b0225b80152cc 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -363,6 +363,7 @@ struct hci_dev {
> 	__u32		clock;
> 	__u16		advmon_allowlist_duration;
> 	__u16		advmon_no_filter_duration;
> +	__u16		enable_advmon_interleave_scan;

I really have to see the patch for doc/mgmt-api.txt first and I am certainly not really in favor of using an uint16 for a simple boolean on/off value just because the kernel code is simpler that way.

Regards

Marcel

