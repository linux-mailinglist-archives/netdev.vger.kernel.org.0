Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F75B2611C4
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 15:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgIHNFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 09:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729738AbgIHLhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 07:37:38 -0400
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F81C061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 04:34:13 -0700 (PDT)
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTPSA id A968A14085D;
        Tue,  8 Sep 2020 13:33:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599564787; bh=gqMctQWgY8AVqR4b1tmHLbntyd2feNj8b9JqhcG4QBk=;
        h=Date:From:To;
        b=mVZuTg5xyLy/F/ffIomo3OFwqcPGEC7HnSGJFxvz5vJXCj++RAo6Rb/bqu/G0EVXI
         27eyHbnaK2hMd07G23iYWwN/awuLNyjFErO0AoLbk0sF5olRPxBkzjlHwC88fHXRaw
         8Eshwlyv3LK/WnvuLw+ochtuX97laxNXzbbyFUXM=
Date:   Tue, 8 Sep 2020 13:33:07 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v2 1/7] net: dsa: Add helper to convert from
 devlink to ds
Message-ID: <20200908133307.2dfd9f03@dellmb.labs.office.nic.cz>
In-Reply-To: <20200908005155.3267736-2-andrew@lunn.ch>
References: <20200908005155.3267736-1-andrew@lunn.ch>
        <20200908005155.3267736-2-andrew@lunn.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Sep 2020 02:51:49 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> +struct dsa_switch *dsa_devlink_to_ds(struct devlink *dl)
> +{
> +	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
> +
> +	return dl_priv->ds;
> +}
> +EXPORT_SYMBOL_GPL(dsa_devlink_to_ds);

Hi Andrew,
why not  make this a static inline function?
Marek
