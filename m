Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23928449EAF
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 23:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240753AbhKHWfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 17:35:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240730AbhKHWfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 17:35:02 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73455C061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 14:32:17 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 4469CC020; Mon,  8 Nov 2021 23:32:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1636410734; bh=zud7OdEIkTpD43LRPIbRcXq7+R/QWPBlGp1XNQjDQTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YSwAC1Ld+GyuvCjOOo79KBMLWXQ3WMg7p2uSSU+bRtTDPRue+1gwnrlcZOQzZHgwr
         oczWHEQL4oGs5Tc11NNNhWdgTks1dtDYuD5pbjWGXTX0c0PN6xgfXNGQs6/CGleEHf
         KbQOvDle99VCOpwv4vIJS2dSKmyvYPaGfT5d3ecJafBXu3jY+GP1QVDalAN7/ifF6H
         UbMticei3nPs9E6vN47PToiFTf9OHrfjGQ21rBcMHjUFDASmZ4U47TJzFn1Aveuvnm
         yqbad62IFy8ZzjvAvPYr8hLIZ3HSE2FrmSHj6YGY7bS7yqIjKLn2jh0S4aIgUo7Xt/
         sBkZkVqYthxGg==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id DD4FFC009;
        Mon,  8 Nov 2021 23:32:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1636410733; bh=zud7OdEIkTpD43LRPIbRcXq7+R/QWPBlGp1XNQjDQTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pfnrVCuPOHphpsheOYkQIMC63MpA6sG2wtcv+JDOBIQenja8mFJvwh06DRVXs9wPm
         SpiE6EnhQJqz2kJDsaMgxBWt0xOm9DDSV16INlsPlAtYJCOb7gw0CLRoBo1cJeiHz8
         9I2UR2d7aPpr3p9O0R5uKXzn14r5dBQiO8Vfi/MucEwuGrxNMC9Sme0afi/l2fBlFc
         0wPe7KNArqacoQ6yzKSAROyqDJlKHS5QWnkq05z+A53w7B5GF+xEQetsstLN9nAxXJ
         RgI6fXUBnwufQlCGYPzx46MqBZYVcE48Un3fhZ9LR5gCUijbpibjCzWByCh/OkMIDQ
         Jl6u2lYAhrbDg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id e697cf90;
        Mon, 8 Nov 2021 22:32:08 +0000 (UTC)
Date:   Tue, 9 Nov 2021 07:31:52 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Stabellini <stefano@aporeto.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] net/p9: load default transports
Message-ID: <YYmlWC9k9jU/JXri@codewreck.org>
References: <20211103193823.111007-1-linux@weissschuh.net>
 <20211103193823.111007-5-linux@weissschuh.net>
 <c2a33fa1-30b0-4f19-808f-3bd0316a4ed8@t-8ch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2a33fa1-30b0-4f19-808f-3bd0316a4ed8@t-8ch.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thomas Weißschuh wrote on Mon, Nov 08, 2021 at 07:50:34PM +0100:
> I did not notice that you already had applied "net/9p: autoload transport modules"
> to your tree when sending this series.
> 
> Please note that in this series I modified patch 1 a bit, from the ony you
> applied, to prevent warnings in patch 4.
> Concretely I modified the prototypes of `v9fs_get_trans_by_name()` and
> `_p9_get_trans_by_name()` to take const parameters.
> 
> Feel free to roll those changes into this patch when applying or I can resend
> the patch/series.

Thanks for the heads up, it's ok -- I'll move the constification of
these functions to patch 4 myself.

I've just sent my pull request to Linus so will take your patches to
my for-next branch when that's merged.
-- 
Dominique
