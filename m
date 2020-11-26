Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442B22C58A8
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 16:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391241AbgKZPyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 10:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbgKZPyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 10:54:25 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9140C0613D4;
        Thu, 26 Nov 2020 07:54:24 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id f9so1377646ejw.4;
        Thu, 26 Nov 2020 07:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LhVa8jfQzjJvmCilxYrG6nSbqJTzGo2dOTG8F9FmarI=;
        b=jr5i1JWhYnHIO/I1DiJ4KSMBdQ6y/w78vOmLhjyF6CmI3TvQEr/YrPXBaJCTUJm1rX
         VrJtpF1XD7ySBuPDcKNT+6WWK5yoznGNZjr3cBD3OW85mmFZt9rGiZPDLhgyYgvnI0PW
         ihj5GtTJ96GziJ3Gq/mFSQXnbAVAfikbeb/pKHl1KtYKnNMHUltAXb5dJKjPcfEJw2cT
         lc1T8xNqOeHYlGyRMceObwssX3Rdsjy8GXTHy3b7MTq7X2jygDEo4t4iezgQrFD43s99
         iLRdLmD081c2DWl+feUy6MTFszNqS2jPj8LwqGhUlaGRy/WRcW3odcykRxUHaL5GOHeV
         M6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LhVa8jfQzjJvmCilxYrG6nSbqJTzGo2dOTG8F9FmarI=;
        b=Ojyaud6lNqPD2UfzCsOZeT8IEEM8cUQ1WjoT/0++5Y9TU9zd7eOLs13MWJG2j12g62
         mN9beBRWhwXDuLV4GhQ8SNKJN1Hk6oitmqF22tVAKLzz/sEqUjnStNS0T5Uqt5WGvQy5
         fbzi0mLquPWj9scMvl6jC40yTrNUODzUZ4xwhAuGFJuV8nCUqn4gSy1xLujE6aU8xNek
         bjgG/c4VkyG7jg5NoVi8xD5tf7pC6sQs+p2D+YqOv8qtGBI8pxi+bv49E+FjtmzkRHE4
         r3LQBRws+Mw+Eswev0eeB+L+eELy1l+5k6//gSv+L2Ch1Kpyb8AyFAgZ1Cx+J1uQmkOr
         lNAg==
X-Gm-Message-State: AOAM530xzWuSckzhb89D1MJ6SuuwKS4lXfIKrKxiooCO3dY026//D/Yo
        lGBGoNZlzffNVC7vXdFlUKo=
X-Google-Smtp-Source: ABdhPJxdyy4xHY3ZhbV5pw0UXu1yYgkQlJ41NTDex2CIC+STH+hqK1oxHTSPU5nwSRQUJfOywLeEfQ==
X-Received: by 2002:a17:907:20cd:: with SMTP id qq13mr3298943ejb.141.1606406063457;
        Thu, 26 Nov 2020 07:54:23 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id dk4sm3496904edb.54.2020.11.26.07.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 07:54:22 -0800 (PST)
Date:   Thu, 26 Nov 2020 17:54:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sudeep Holla <sudeep.holla@arm.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] dpaa2-mac: select NET_DEVLINK to fix build
Message-ID: <20201126155421.2gd47fwxw7bgzfq2@skbuf>
References: <20201126140933.1535197-1-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126140933.1535197-1-sudeep.holla@arm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 02:09:33PM +0000, Sudeep Holla wrote:
> When NET_DEVLINK is not selected, we get the following build error:
[...]
>
> Commit f6b19b354d50 ("net: devlink: select NET_DEVLINK from drivers")
> selected NET_DEVLINK from several drivers and rely on the functions
> being there.
>
> Replicate the same for FSL_DPAA2_ETH.

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=078eb55cdf25e
