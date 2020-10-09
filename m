Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A164D287FA0
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 02:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbgJIAxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 20:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725979AbgJIAxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 20:53:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73FB422254;
        Fri,  9 Oct 2020 00:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602204823;
        bh=pp6eYGaaCTBGwDZxZMDMgBqK0y/UiwZtwBUxmkvKcO8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sdDgiZvn47GKGauKPmCuJPeKBZpTwCqTA381UDDQSjCKo6iJsnVVp/iVCB1hgzZMd
         +ub2mjciTUWu4BCzT+T3jqCy+vsKB4oRr9Pp6Fe/35IW/nPx+jFSxS7qPdHTE6W4bm
         icYsbk1sOKR7BGuxbSEbBEQe6R8bX4TvVrFLXu+8=
Date:   Thu, 8 Oct 2020 17:53:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, alexandre.belloni@bootlin.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Divya Koppera <Divya.Koppera@microchip.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: add missing VCAP ES0 and
 IS1 regmaps for VSC7514
Message-ID: <20201008175342.01ea014d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201006150248.1911469-1-vladimir.oltean@nxp.com>
References: <20201006150248.1911469-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 18:02:48 +0300 Vladimir Oltean wrote:
> Without these definitions, the driver will crash in:
> mscc_ocelot_probe
> -> ocelot_init
>    -> ocelot_vcap_init
>      -> __ocelot_target_read_ix  
> 
> I missed this because I did not have the VSC7514 hardware to test, only
> the VSC9959 and VSC9953, and the probing part is different.
> 
> Fixes: e3aea296d86f ("net: mscc: ocelot: add definitions for VCAP ES0 keys, actions and target")
> Fixes: a61e365d7c18 ("net: mscc: ocelot: add definitions for VCAP IS1 keys, actions and target")
> Reported-by: Divya Koppera <Divya.Koppera@microchip.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks!
