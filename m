Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0D11FCAEC
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 12:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgFQKcC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Jun 2020 06:32:02 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:59193 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgFQKcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 06:32:01 -0400
Received: from marcel-macbook.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id 5B372CECD1;
        Wed, 17 Jun 2020 12:41:50 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v5 1/7] Bluetooth: Add definitions for advertisement
 monitor features
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200615172440.v5.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
Date:   Wed, 17 Jun 2020 12:31:57 +0200
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <09444691-8D9E-4530-AFC9-5935D775C04C@holtmann.org>
References: <20200615172440.v5.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
To:     Miao-chen Chou <mcchou@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Miao-chen,

> This adds support for Advertisement Monitor API. Here are the commands
> and events added.
> - Read Advertisement Monitor Feature command
> - Add Advertisement Pattern Monitor command
> - Remove Advertisement Monitor command
> - Advertisement Monitor Added event
> - Advertisement Monitor Removed event
> 
> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> ---
> 
> Changes in v5: None
> Changes in v4: None
> Changes in v3:
> - Update command/event opcodes.
> - Correct data types.
> 
> Changes in v2: None
> 
> include/net/bluetooth/mgmt.h | 49 ++++++++++++++++++++++++++++++++++++
> 1 file changed, 49 insertions(+)

I have added all 7 patches to my local tree. I added minor style modifications and merged it together with the device flags support.

Regards

Marcel

