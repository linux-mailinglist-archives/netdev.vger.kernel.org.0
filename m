Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDFA268728
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgINIZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:25:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:33684 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgINIY7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 04:24:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 51C2BAC46;
        Mon, 14 Sep 2020 08:25:13 +0000 (UTC)
Message-ID: <1600070567.2534.3.camel@suse.de>
Subject: Re: [RESEND net-next v2 12/12] net: usbnet: convert tasklets to use
 new tasklet_setup() API
From:   Oliver Neukum <oneukum@suse.de>
To:     Allen Pais <allen.lkml@gmail.com>, davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        petkan@nucleusys.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-ppp@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Date:   Mon, 14 Sep 2020 10:02:47 +0200
In-Reply-To: <20200914073131.803374-13-allen.lkml@gmail.com>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
         <20200914073131.803374-13-allen.lkml@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Montag, den 14.09.2020, 13:01 +0530 schrieb Allen Pais:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly
> and remove the .data field.

Hi,

how would bisecting be supposed to run smoothly, if this
patch were applied? We'd pass a NULL pointer.

	Regards
		Oliver

