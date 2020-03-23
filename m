Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B33C718FD08
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbgCWSsm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 Mar 2020 14:48:42 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:60088 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727179AbgCWSsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:48:42 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id CA02ECED00;
        Mon, 23 Mar 2020 19:58:11 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [PATCH v1 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <421d27670f2736c88e8c0693e3ff7c0dcfceb40b.camel@perches.com>
Date:   Mon, 23 Mar 2020 19:48:39 +0100
Cc:     Miao-chen Chou <mcchou@chromium.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <57C56801-7F3B-478A-83E9-1D2376C60666@holtmann.org>
References: <20200323072824.254495-1-mcchou@chromium.org>
 <20200323002820.v1.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
 <04021BE3-63F7-4B19-9F0E-145785594E8C@holtmann.org>
 <421d27670f2736c88e8c0693e3ff7c0dcfceb40b.camel@perches.com>
To:     Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

>>> This adds a bit mask of driver_info for Microsoft vendor extension and
>>> indicates the support for Intel 9460/9560 and 9160/9260. See
>>> https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
>>> microsoft-defined-bluetooth-hci-commands-and-events for more information
>>> about the extension. This was verified with Intel ThunderPeak BT controller
>>> where msft_vnd_ext_opcode is 0xFC1E.
> []
>>> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> []
>>> @@ -315,6 +315,10 @@ struct hci_dev {
>>> 	__u8		ssp_debug_mode;
>>> 	__u8		hw_error_code;
>>> 	__u32		clock;
>>> +	__u16		msft_vnd_ext_opcode;
>>> +	__u64		msft_vnd_ext_features;
>>> +	__u8		msft_vnd_ext_evt_prefix_len;
>>> +	void		*msft_vnd_ext_evt_prefix;
> 
> msft is just another vendor.
> 
> If there are to be vendor extensions, this should
> likely use a blank line above and below and not
> be prefixed with msft_

there are other vendors, but all of them are different. So this needs to be prefixed with msft_ actually. But I agree that having empty lines above and below makes it more readable.

Regards

Marcel

