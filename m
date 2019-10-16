Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36282D993A
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394238AbfJPSbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:31:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391082AbfJPSbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 14:31:11 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5851D10C092D;
        Wed, 16 Oct 2019 18:31:11 +0000 (UTC)
Received: from localhost (ovpn-112-25.phx2.redhat.com [10.3.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23FAD60605;
        Wed, 16 Oct 2019 18:31:09 +0000 (UTC)
Date:   Wed, 16 Oct 2019 14:31:08 -0400 (EDT)
Message-Id: <20191016.143108.2159602485232151042.davem@redhat.com>
To:     hayeswang@realtek.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        pmalani@chromium.org, grundler@chromium.org
Subject: Re: [PATCH net-next] r8152: support request_firmware for RTL8153
From:   David Miller <davem@redhat.com>
In-Reply-To: <1394712342-15778-329-Taiwan-albertk@realtek.com>
References: <1394712342-15778-329-Taiwan-albertk@realtek.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Wed, 16 Oct 2019 18:31:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 16 Oct 2019 11:02:42 +0800

> This patch supports loading additional firmware file through
> request_firmware().
> 
> A firmware file may include a header followed by several blocks
> which have different types of firmware. Currently, the supported
> types are RTL_FW_END, RTL_FW_PLA, and RTL_FW_USB.
> 
> The firmware is used to fix some compatible or hardware issues. For
> example, the device couldn't be found after rebooting several times.
> 
> The supported chips are
> 	RTL_VER_04 (rtl8153a-2.fw)
> 	RTL_VER_05 (rtl8153a-3.fw)
> 	RTL_VER_06 (rtl8153a-4.fw)
> 	RTL_VER_09 (rtl8153b-2.fw)
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> Reviewed-by: Prashant Malani <pmalani@chromium.org>

Applied, thank you.
