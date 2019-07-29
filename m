Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3175378531
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 08:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbfG2GqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 02:46:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfG2GqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 02:46:05 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 457435945B;
        Mon, 29 Jul 2019 06:46:04 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA106600C0;
        Mon, 29 Jul 2019 06:46:03 +0000 (UTC)
Date:   Mon, 29 Jul 2019 08:46:01 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Masanari Iida <standby24x7@gmail.com>
Cc:     helmut.schaa@googlemail.com, kvalo@codeaurora.org,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] rt2800usb: Add new rt2800usb device PLANEX
 GW-USMicroN
Message-ID: <20190729064601.GA2066@redhat.com>
References: <20190728140742.3280-1-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728140742.3280-1-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 29 Jul 2019 06:46:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 28, 2019 at 11:07:42PM +0900, Masanari Iida wrote:
> This patch add a device ID for PLANEX GW-USMicroN.
> Without this patch, I had to echo the device IDs in order to
> recognize the device.
> 
> # lsusb |grep PLANEX
> Bus 002 Device 005: ID 2019:ed14 PLANEX GW-USMicroN
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
