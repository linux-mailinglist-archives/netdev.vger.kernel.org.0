Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714B5352834
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 11:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhDBJJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 05:09:49 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:50269 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBJJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 05:09:47 -0400
Received: from marcel-macbook.holtmann.net (p5b3d2269.dip0.t-ipconnect.de [91.61.34.105])
        by mail.holtmann.org (Postfix) with ESMTPSA id 31879CED24;
        Fri,  2 Apr 2021 11:17:25 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] Bluetooth: Check inquiry status before sending one
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20210401111036.1.I26d172ded4e4ac8ad334516a8d196539777fba2a@changeid>
Date:   Fri, 2 Apr 2021 11:09:43 +0200
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <314A4670-B821-4FD5-B7A3-5B04B489D39D@holtmann.org>
References: <20210401111036.1.I26d172ded4e4ac8ad334516a8d196539777fba2a@changeid>
To:     Archie Pusaka <apusaka@google.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

> There is a possibility where HCI_INQUIRY flag is set but we still
> send HCI_OP_INQUIRY anyway.
> 
> Such a case can be reproduced by connecting to an LE device while
> active scanning. When the device is discovered, we initiate a
> connection, stop LE Scan, and send Discovery MGMT with status
> disabled, but we don't cancel the inquiry.
> 
> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
> ---
> 
> net/bluetooth/hci_request.c | 3 +++
> 1 file changed, 3 insertions(+)

patch has been applied to bluetooth-next tree.

Regards

Marcel

