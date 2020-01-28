Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD4914B007
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 08:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgA1HD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 02:03:59 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:35896 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbgA1HD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 02:03:58 -0500
Received: from marcel-macbook.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id B5D75CECDB;
        Tue, 28 Jan 2020 08:13:16 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [PATCH] Bluetooth: SMP: Fix SALT value in some comments
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200127223609.15066-1-christophe.jaillet@wanadoo.fr>
Date:   Tue, 28 Jan 2020 08:03:56 +0100
Cc:     Johan Hedberg <johan.hedberg@gmail.com>, kuba@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <03F1C6B2-0F04-4991-8912-7220F9F88F5C@holtmann.org>
References: <20200127223609.15066-1-christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe,

> Salts are 16 bytes long.
> Remove some extra and erroneous '0' in the human readable format used
> in comments.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> net/bluetooth/smp.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

