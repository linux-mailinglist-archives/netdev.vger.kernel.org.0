Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56B22DC742
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgLPTeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgLPTeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 14:34:19 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F19BC061794;
        Wed, 16 Dec 2020 11:33:39 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A403323E5D;
        Wed, 16 Dec 2020 20:33:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1608147215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oWFo8whnrVBtSiqbjBXhPZ1u/uhUnmI9/snorRDHcmI=;
        b=NLB+8EPPn7+sd2Na1GduE+nvGb7rd19MooirM3W5d4T18YkAWztLYc0fxKar6kuI/iaCZ+
        FEMkiZjf4QFL84WEgV+WhY1EJXfeQmlZXKTUUMZnfyRUkDLm1qlCOUJYM3Kz30QoEVaN+r
        Zurf1GM7aR+FNpUe8qh6Ezr7Ykp43p8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 16 Dec 2020 20:33:35 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: Re: [PATCH net-next 0/4] enetc: code cleanups
In-Reply-To: <20201216192539.3xfxmhpejrmayfge@skbuf>
References: <20201215212200.30915-1-michael@walle.cc>
 <20201216192539.3xfxmhpejrmayfge@skbuf>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <d5335485b0d62e7c399d342136ac6921@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-12-16 20:25, schrieb Vladimir Oltean:
> Hi Michael,
> 
> On Tue, Dec 15, 2020 at 10:21:56PM +0100, Michael Walle wrote:
>> This are some code cleanups in the MDIO part of the enetc. They are
>> intended to make the code more readable.
> 
> Nice cleanup, please resend it after net-next opens again.

Ah, I thought it will be picked up automatically after the merge
window is closed, no?

-michael
