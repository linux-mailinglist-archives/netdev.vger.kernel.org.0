Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7B347813A
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 01:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhLQA0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 19:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhLQAZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 19:25:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8615FC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 16:25:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CEE361FCC
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 00:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31240C36AE7;
        Fri, 17 Dec 2021 00:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639700758;
        bh=HZxpb8dzfvCjc4x3iHQv8lJA0K1b5qSlaMKwsGbOSOg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J6bMyiWLFZ/IwbBSlvuJmO5enrNzjFaGAvtaaDlzwcoRkxrYCM15fFYX7WytURDzY
         sIrz6+/CV393MW7qXgF3foCAuN7omvRXJeHcAXXbL37YIiJIIhPIbph+SXMRT+bCfF
         7NZrqWPYkrFI4UHI9D8EsfpBnVQKXHVazZmm59MqMVmUAZC0KMki5fR1/2tvxe/25g
         wTQNktg5uDCNWrK5f8X0K2Vr4kNg6pQM/rSYFzdWaJimFitYUJpZscxPjjzQO+/4/S
         5heSCpU6DZpcOYGBVarMcUQGSEKC3OwwvIQt1QeFcdA4tygvVp0yOXFoVlfOhdqVHg
         PcwNw3m0UYZvg==
Date:   Thu, 16 Dec 2021 16:25:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     luizluca@gmail.com
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        alsi@bang-olufsen.dk, arinc.unal@arinc9.com
Subject: Re: [PATCH net-next 00/13] net: dsa: realtek: MDIO interface and
 RTL8367S
Message-ID: <20211216162557.7e279ff6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211216201342.25587-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Dec 2021 17:13:29 -0300 luizluca@gmail.com wrote:
> This series refactors the current Realtek DSA driver to support MDIO
> connected switchesand RTL8367S. RTL8367S is a 5+2 10/100/1000M Ethernet
> switch, with one of those 2 external ports supporting SGMII/High-SGMII. 

nit: plenty of warnings in patch 3 and patch 8, please try building
patch-by-patch with C=1 and W=1. Also some checkpatch warnings that
should be fixed (scripts/checkpatch.pl).
