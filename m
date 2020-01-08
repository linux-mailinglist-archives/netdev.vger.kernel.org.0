Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA07C134DD5
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgAHUpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:45:08 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:38655 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgAHUpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:45:08 -0500
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id 33B67CECFA;
        Wed,  8 Jan 2020 21:54:22 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [PATCH] Bluetooth: remove redundant assignment to variable icid
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200107180013.124501-1-colin.king@canonical.com>
Date:   Wed, 8 Jan 2020 21:45:05 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        BlueZ devel list <linux-bluetooth@vger.kernel.org>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3C4BC7D9-4024-43C5-B68D-006EFB764FAE@holtmann.org>
References: <20200107180013.124501-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

> Variable icid is being rc is assigned with a value that is never
> read. The assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
> net/bluetooth/l2cap_core.c | 1 -
> 1 file changed, 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

