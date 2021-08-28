Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647BA3FA7D6
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 00:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhH1WIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 18:08:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46414 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhH1WIf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 18:08:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ry4UFAsqdgXS1OY+JsQtiI1dYNVCvwS5fqMYMwi+Tz8=; b=fxS45sDmEpBa3A0o3remtKKXea
        1E0BZaiODPWJubR/JDhI78OVQcHr9Hwreg3cG0rA5OCfM4FmD6LoYMtWkPwPwej/HN0ZGZwd7OxIL
        3djvQGPBLcRTvgpnw+XEIvTO7nEbBPw5O+QeUwbuDoN2zuFsRVVsiAKKlNqzm/0qbyhs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mK6UJ-004KLR-NZ; Sun, 29 Aug 2021 00:07:43 +0200
Date:   Sun, 29 Aug 2021 00:07:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edwin.peer@broadcom.com, gospo@broadcom.com
Subject: Re: [PATCH net-next 00/11] bnxt_en: Implement new driver APIs to
 send FW messages
Message-ID: <YSqzrxMtoZl1/uDc@lunn.ch>
References: <1630187910-22252-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1630187910-22252-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 28, 2021 at 05:58:19PM -0400, Michael Chan wrote:
> The current driver APIs to send messages to the firmware allow only one
> outstanding message in flight.  There is only one buffer for the firmware
> response for each firmware channel.  To send a firmware message, all
> callers must take a mutex and it is released after the firmware response
> has been read.  This scheme does not allow multiple firmware messages
> in flight.  Firmware may take a long time to respond to some messages
> (e.g. NVRAM related ones) and this causes the mutex to be held for
> a long time, blocking other callers.
> 
> This patchset intoduces the new driver APIs to address the above
> shortcomings.  All callers are then updated to use the new APIs.

Hi Michael

Does the firmware already support this? Or is a firmware upgrade also
required.

	Andrew
