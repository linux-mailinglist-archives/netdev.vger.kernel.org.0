Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3152CD693
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730693AbgLCNVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:21:23 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:44598 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgLCNVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:21:22 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.193.87])
        by mail.holtmann.org (Postfix) with ESMTPSA id 9C786CECFC;
        Thu,  3 Dec 2020 14:27:53 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.20.0.2.21\))
Subject: Re: [PATCH v11 3/5] Bluetooth: Handle active scan case
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20201126122109.v11.3.I21e5741249e78c560ca377499ba06b56c7214985@changeid>
Date:   Thu, 3 Dec 2020 14:20:39 +0100
Cc:     BlueZ development <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        alainm@chromium.org, mcchou@chromium.org, mmandlik@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <F6E4AB1E-C39D-4B40-8D47-8FB6C3C1D9F6@holtmann.org>
References: <20201126122109.v11.1.Ib75f58e90c477f9b82c5598f00c59f0e95a1a352@changeid>
 <20201126122109.v11.3.I21e5741249e78c560ca377499ba06b56c7214985@changeid>
To:     Howard Chung <howardchung@google.com>
X-Mailer: Apple Mail (2.3654.20.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Howard,

> This patch adds code to handle the active scan during interleave
> scan. The interleave scan will be canceled when users start active scan,
> and it will be restarted after active scan stopped.
> 
> Signed-off-by: Howard Chung <howardchung@google.com>
> Reviewed-by: Alain Michaud <alainm@chromium.org>
> Reviewed-by: Manish Mandlik <mmandlik@chromium.org>
> ---
> 
> (no changes since v1)
> 
> net/bluetooth/hci_request.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

