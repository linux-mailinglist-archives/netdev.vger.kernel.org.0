Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC37193B69
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 10:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgCZJCA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Mar 2020 05:02:00 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:38318 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgCZJB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 05:01:59 -0400
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 23B15CECDB;
        Thu, 26 Mar 2020 10:11:29 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v3 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200326005931.v3.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
Date:   Thu, 26 Mar 2020 10:01:56 +0100
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <ADF19483-721C-4263-8CA8-CF4587E79BA4@holtmann.org>
References: <20200326075938.65053-1-mcchou@chromium.org>
 <20200326005931.v3.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

> This adds a bit mask of driver_info for Microsoft vendor extension and
> indicates the support for Intel 9460/9560 and 9160/9260. See
> https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
> microsoft-defined-bluetooth-hci-commands-and-events for more information
> about the extension. This was verified with Intel ThunderPeak BT controller
> where msft_vnd_ext_opcode is 0xFC1E.
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> 
> Changes in v3:
> - Create net/bluetooth/msft.c with struct msft_vnd_ext defined internally
> and change the hdev->msft_ext field to void*.
> - Define and expose msft_vnd_ext_set_opcode() for btusb use.
> - Init hdev->msft_ext in hci_alloc_dev() and deinit it in hci_free_dev().

so I spent some cycles on thinking about on how we can have this nice and cleanly without putting too much into the core stack or hci_dev. I took your patches and converted them a little bit into how I would do it. Please have a look.

Regards

Marcel

