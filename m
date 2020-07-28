Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA314230397
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgG1HNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:13:10 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:49209 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbgG1HNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 03:13:09 -0400
Received: from marcel-macbook.fritz.box (p4ff9f430.dip0.t-ipconnect.de [79.249.244.48])
        by mail.holtmann.org (Postfix) with ESMTPSA id D2B49CECCD;
        Tue, 28 Jul 2020 09:23:09 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] Bluetooth: Return NOTIFY_DONE for hci_suspend_notifier
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200723104742.19780-1-max.chou@realtek.com>
Date:   Tue, 28 Jul 2020 09:13:08 +0200
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        alex_lu@realsil.com.cn, hildawu@realtek.com
Content-Transfer-Encoding: 7bit
Message-Id: <818B8B6F-F093-40DC-9B02-CFF0B9C9DE08@holtmann.org>
References: <20200723104742.19780-1-max.chou@realtek.com>
To:     max.chou@realtek.com
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Max,

> The original return is NOTIFY_STOP, but notifier_call_chain would stop
> the future call for register_pm_notifier even registered on other Kernel
> modules with the same priority which value is zero.
> 
> Signed-off-by: Max Chou <max.chou@realtek.com>
> ---
> net/bluetooth/hci_core.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

