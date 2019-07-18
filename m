Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2549F6D575
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 21:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391404AbfGRTu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 15:50:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50896 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727687AbfGRTu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 15:50:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f9NYi/JQfKwrckhrLZX09z+ipOmqXvg6F6g6rgIJULA=; b=o7Q3/nGx8gD9nw1+QVSQHD+BN0
        aS19BJWloHnqgRVYcSmom4PtMuEC/oKOSQ3KSuS+O1q40bf00gKUYX3jJobXFIuZkAXz737PUgUe1
        /2Gxr0z8XPBCJ4q7UfzuDy43NiHl9lMKXirYYQAmooWOQtLYZMrEvJUWR/O9LvzimYPw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hoCQK-0002w6-Tp; Thu, 18 Jul 2019 21:50:40 +0200
Date:   Thu, 18 Jul 2019 21:50:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 0/5] PTP: add support for Intel's TGPIO controller
Message-ID: <20190718195040.GL25635@lunn.ch>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716072038.8408-1-felipe.balbi@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 10:20:33AM +0300, Felipe Balbi wrote:
> TGPIO is a new IP which allows for time synchronization between systems
> without any other means of synchronization such as PTP or NTP. The
> driver is implemented as part of the PTP framework since its features
> covered most of what this controller can do.

Hi Felipe

Given the name TGPIO, can it also be used for plain old boring GPIO?
Does there need to be some sort of mux between GPIO and TGPIO? And an
interface into the generic GPIO core?

Also, is this always embedded into a SoC? Or could it actually be in a
discrete NIC?

Thanks
	Andrew
