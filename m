Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346922CD68C
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730666AbgLCNUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:20:37 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:40312 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730453AbgLCNUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:20:37 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id 764CECECFC;
        Thu,  3 Dec 2020 14:27:08 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH v11 5/5] Bluetooth: Add toggle to switch off interleave
 scan
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201126122109.v11.5.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
Date:   Thu, 3 Dec 2020 14:19:53 +0100
Cc:     BlueZ development <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        alainm@chromium.org, mcchou@chromium.org, mmandlik@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <343BDAC3-6B65-4BA6-8F28-B4DFC6B6041D@holtmann.org>
References: <20201126122109.v11.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
 <20201126122109.v11.5.I756c1fecc03bcc0cd94400b4992cd7e743f4b3e2@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
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
> (no changes since v9)
> 
> Changes in v9:
> - Update and rename the macro TLV_GET_LE8
> 
> Changes in v7:
> - Fix bt_dev_warn arguemnt type warning
> 
> Changes in v6:
> - Set EnableAdvMonInterleaveScan to 1 byte long
> 
> Changes in v4:
> - Set EnableAdvMonInterleaveScan default to Disable
> - Fix 80 chars limit in mgmt_config.c
> 
> include/net/bluetooth/hci_core.h |  1 +
> net/bluetooth/hci_core.c         |  1 +
> net/bluetooth/hci_request.c      |  3 ++-
> net/bluetooth/mgmt_config.c      | 41 +++++++++++++++++++++++++-------
> 4 files changed, 37 insertions(+), 9 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

