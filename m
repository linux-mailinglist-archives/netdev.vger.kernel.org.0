Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62641139D4A
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 00:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgAMXaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 18:30:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35538 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727282AbgAMXaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 18:30:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QwAoXOqjyyg/vJ5GZRN0tl9HB/BzOvUwdKHRpL6PwmI=; b=OvKpla9ORTpemj4RUAFr9Do/Ej
        d5IvnR79Rtu/GSeeBW7wb0+8Te29GyWtZruIrafjHVaz7flLIPYt/Z6Y9Yws0FHohEyeDONTTV/6q
        9DEyMxjGCmEaRFB9inmS+f/SSN+37wW0i66XpBaMOSSqtrIwJVnXEan9IFrMDtzspMsw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ir99v-0008CN-Sw; Tue, 14 Jan 2020 00:30:11 +0100
Date:   Tue, 14 Jan 2020 00:30:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, anirudh.venkataramanan@intel.com,
        dsahern@gmail.com, jiri@resnulli.us, ivecera@redhat.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [RFC net-next Patch v2 4/4] net: bridge: mrp: switchdev: Add HW
 offload
Message-ID: <20200113233011.GF11788@lunn.ch>
References: <20200113124620.18657-1-horatiu.vultur@microchip.com>
 <20200113124620.18657-5-horatiu.vultur@microchip.com>
 <20200113140053.GE11788@lunn.ch>
 <20200113225751.jkkio4rztyuff4xj@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113225751.jkkio4rztyuff4xj@soft-dev3.microsemi.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu

It has been said a few times what the basic state machine should be in
user space. A pure software solution can use raw sockets to send and
receive MRP_Test test frames. When considering hardware acceleration,
the switchdev API you have proposed here seems quite simple. It should
not be too hard to map it to a set of netlink messages from userspace.

Yet your argument for kernel, not user space, is you are worried about
the parameters which need to be passed to the hardware offload engine.
In order to win the argument for a kernel solution, we are going to
need a better idea what you think this problem is. The MRP_Test is TLV
based. Are there other things which could be in this message? Is that
what you are worried about?

Thanks
     Andrew
