Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4CC96EC6
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 03:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbfHUBXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 21:23:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46964 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbfHUBXH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 21:23:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JtC8HPDsaJT2ignF7Xz0LRvzJfhq+iIL8ZgA29FlRsU=; b=DBKpWqwk57sTJIOfUxkIqJwXOb
        GL0ryAQ+rOMAxg55cFE2/NX9PmBQpSPOLTzLP4ZKLIL2Zgf23za7FdApruCa0VRKeP+A8nui75bv/
        LyywAZ8l+dLfKljDReLca2Nm+uFOGiOYyoaK16pFA+oWieNHSweC4wT3QTP4j453jPdg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0FL0-0001dy-Vl; Wed, 21 Aug 2019 03:22:58 +0200
Date:   Wed, 21 Aug 2019 03:22:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Charles.Hyde@dellteam.com
Cc:     linux-usb@vger.kernel.org, linux-acpi@vger.kernel.org,
        gregkh@linuxfoundation.org, Mario.Limonciello@dell.com,
        oliver@neukum.org, netdev@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [RFC 1/4] Add usb_get_address and usb_set_address support
Message-ID: <20190821012258.GB4285@lunn.ch>
References: <1566339522507.45056@Dellteam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566339522507.45056@Dellteam.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 10:18:42PM +0000, Charles.Hyde@dellteam.com wrote:
> The core USB driver message.c is missing get/set address functionality
> that stops ifconfig from being able to push MAC addresses out to USB
> based ethernet devices.  Without this functionality, some USB devices
> stop responding to ethernet packets when using ifconfig to change MAC
> addresses.

Hi Charles

ifconfig has been deprecated for years, maybe a decade. Please
reference the current tools, iproute2.

	  Andrew
