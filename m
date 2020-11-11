Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AC62AEF49
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 12:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgKKLMv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Nov 2020 06:12:51 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:52581 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgKKLMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 06:12:35 -0500
Received: from marcel-macbook.holtmann.net (unknown [37.83.201.106])
        by mail.holtmann.org (Postfix) with ESMTPSA id BFDE9CECFF;
        Wed, 11 Nov 2020 12:19:32 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH 1/2] bluetooth: hci_event: consolidate error paths in
 hci_phy_link_complete_evt()
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <b508265e-f08f-ea24-2815-bc2a5ec10d8d@omprussia.ru>
Date:   Wed, 11 Nov 2020 12:12:22 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <EA8EC09F-6AB5-45DD-9889-C05D1FC9AAE6@holtmann.org>
References: <bbdd9cbe-b65e-b309-1188-71a3a4ca6fdc@omprussia.ru>
 <b508265e-f08f-ea24-2815-bc2a5ec10d8d@omprussia.ru>
To:     Sergey Shtylyov <s.shtylyov@omprussia.ru>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

> hci_phy_link_complete_evt() has several duplicate error paths -- consolidate
> them, using the *goto* statements.
> 
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
> 
> ---
> net/bluetooth/hci_event.c |   16 ++++++----------
> 1 file changed, 6 insertions(+), 10 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

