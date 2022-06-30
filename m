Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92634561B39
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 15:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiF3NWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 09:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiF3NWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 09:22:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0019D2C65F;
        Thu, 30 Jun 2022 06:22:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A601BB827E3;
        Thu, 30 Jun 2022 13:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB475C34115;
        Thu, 30 Jun 2022 13:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656595371;
        bh=UhGTJtPGGpCZaifvl2bBXdMoBnYMhggoLhZXwHyx73k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SJ3EsU4yRwfBnIkJEdd4SgaUf5RVe/QW0Q9PxcZTB7c4HzlrVe5q92qd9oIL2x4N8
         PaaA8dhYxoxzxCRGJLnxnMqwaeSGCBcXUhf+fCs4dJbFugej3SrjPqy7O5mz9kxvXv
         EKa93kVeEBdf3vtuA6thT6oAjfiKPwHR02XdNjFc=
Date:   Thu, 30 Jun 2022 15:22:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: Re: [PATCH stable 0/4] net: mscc: ocelot: allow unregistered IP
 multicast flooding
Message-ID: <Yr2jqJumiLlwJXew@kroah.com>
References: <20220628172016.3373243-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628172016.3373243-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 08:20:12PM +0300, Vladimir Oltean wrote:
> This series contains 4 patches (1 for each stable branch: 4.19, 5.4, 5.10 and 5.15)
> which fix 2 variations of the same problem:
> 
> - Between kernels 4.18 and 5.12, IP multicast flooding on ocelot ports
>   is completely broken, both for autonomous forwarding and for local CPU
>   termination. The patches for 4.19 and for 5.10 fix this.
> 
> - Between kernels 5.12 and 5.18, the flooding problem has been fixed for
>   autonomously forwarded IP multicast flows via a new feature commit
>   which cannot be backported, but still remains broken for local CPU
>   termination. The patch for 5.15 fixes this.
> 
> After kernel 5.18, the CPU flooding problem has also been fixed via a
> new feature commit which also cannot be backported. So in the current
> "net" tree, both kinds of IP multicast flooding work properly, and this
> is the reason why these patches target just the "stable" trees.

All now queued up, thanks.

greg k-h
