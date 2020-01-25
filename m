Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE21149645
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 16:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgAYPeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 10:34:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54080 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgAYPeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 10:34:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZDYNRqwBExDRXRR1MBnllajpDkmWN72OefXMTvnpJxM=; b=pDIorN8GkvUAsYHcE3q9XkvtTH
        mOTju6Vz+39zitPiVfOOFlVO3gk1nnvmtxsftHXu6kBK+clKmN4Qs49LI426KGZjMaXrfkaWd0Blw
        dp9dEIcx9aDhwQIwJF/SpK5+tY3ght5DlnK+0dqsmyZbsUKcV11klQ5fU5csoI+uVJp4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ivNRj-0006wc-7X; Sat, 25 Jan 2020 16:34:03 +0100
Date:   Sat, 25 Jan 2020 16:34:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, anirudh.venkataramanan@intel.com,
        olteanv@gmail.com, jeffrey.t.kirsher@intel.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [RFC net-next v3 04/10] net: bridge: mrp: Add generic netlink
 interface to configure MRP
Message-ID: <20200125153403.GB18311@lunn.ch>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-5-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200124161828.12206-5-horatiu.vultur@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 05:18:22PM +0100, Horatiu Vultur wrote:
> Implement the generic netlink interface to configure MRP. The implementation
> will do sanity checks over the attributes and then eventually call the MRP
> interface which eventually will call the switchdev API.

Hi Horatiu

What was your thinking between adding a new generic netlink interface,
and extending the current one?

I've not looked at your user space code yet, but i assume it has to
make use of both? It needs to create the bridge and add the
interfaces. And then it needs to control the MRP state.

Allan mentioned you might get around to implementing 802.1CB? Would
that be another generic netlink interface, or would you extend the MRP
interface?

Thanks
	Andrew			
