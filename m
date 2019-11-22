Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCCB1068F9
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 10:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKVJn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 04:43:27 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:47123 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfKVJn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 04:43:26 -0500
Received: from marcel-macbook.holtmann.net (p4FF9F0D1.dip0.t-ipconnect.de [79.249.240.209])
        by mail.holtmann.org (Postfix) with ESMTPSA id 1030CCED1E;
        Fri, 22 Nov 2019 10:52:32 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: [PATCH] Bluetooth: Fix memory leak in hci_connect_le_scan
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20191121202038.27331-1-navid.emamdoost@gmail.com>
Date:   Fri, 22 Nov 2019 10:43:24 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        emamd001@umn.edu
Content-Transfer-Encoding: 7bit
Message-Id: <CBF99933-AF98-4879-B4E1-C5E6153FE2DD@holtmann.org>
References: <20191121202038.27331-1-navid.emamdoost@gmail.com>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Navid,

> In the implementation of hci_connect_le_scan() when conn is added via
> hci_conn_add(), if hci_explicit_conn_params_set() fails the allocated
> memory for conn is leaked. Use hci_conn_del() to release it.
> 
> Fixes: f75113a26008 ("Bluetooth: add hci_connect_le_scan")
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
> net/bluetooth/hci_conn.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

