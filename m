Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FA82D3FF1
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 11:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbgLIKbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 05:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729897AbgLIKbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 05:31:38 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38397C0613D6;
        Wed,  9 Dec 2020 02:30:58 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id p22so958385edu.11;
        Wed, 09 Dec 2020 02:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xZNCN85ThsCwBpsgS1T7+rkYAAc0SbaHgPNn3428lNA=;
        b=HvZpPoZ1jiv2obIcol4yv9Cz6MvAXoAC2vUgXWUZlNwMqddZAmgJ/cU+3u+t2lFR1K
         FwE1L6QNH0qshZfloUZ09O2o/EKg4igjVhT4+P3WR6u0bO103kw3XIpSF6/cGz7o0UE7
         u/XlqZMVLQSGVDZYUBR/ceqhCCjxUMJPCBOV8Mmdna+qTAHCZii0h6jTClWpwmjPbd2g
         smrnhndru4HjIZqkz1ESEXtKbben9B7logHbPWELtEMKZ1XIc7kFazwA/ZGh58YGY/8Z
         Lp+2LraTXyIx+IlmLXJXyoXF4GWxv0RFfN0UcC0zeL4N6OSkdeLgfo/6H+yjYQ4ap7im
         Qogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xZNCN85ThsCwBpsgS1T7+rkYAAc0SbaHgPNn3428lNA=;
        b=Fw/YrZMok6Yj8R5pBuIpGEa5ttNTieWFEyFL660YVVYqEJTZtE1CSScxVBT08A7Boo
         LnsMPVsx/S3u1O41mfRDIsWq3Z56pM4uZ0R6MyCJ8fr1LjuTG2RuY5Wy/sERPDilFuIZ
         YombSUBDttH8aW1hadY4KPeacdSeio+JUjCXZyNwJ3X3uJdL3VFLC7LuFCPYbUnX5bOC
         H5ScL+M38fGfFbIAx2PR8XhHkDb1bIz0gckji0PxGskVC6GtCQZiQDncfkucv1ahpZGP
         ISK3v9OR0BikVZZu4mmV9dbFOfBeKCC4W/+ycgJEPVn2fxrcjlX0CY4/yltEj7vfNM8G
         gk7Q==
X-Gm-Message-State: AOAM532wVib9xyO+NCWBAf5vYCC+xAji6nah3YYVIvTYZYGWk4FaUFZ3
        ls+PL8NTTF6sRNWphPax8QI=
X-Google-Smtp-Source: ABdhPJyE2qnopyFh2pGD0cv+oOqz2o83g/A6etvBO/k6+ogUGc65ozjueXdh5qNkO5p2SDDGW1vSIg==
X-Received: by 2002:a50:e8c4:: with SMTP id l4mr1315459edn.337.1607509856904;
        Wed, 09 Dec 2020 02:30:56 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id e3sm1074087ejq.96.2020.12.09.02.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 02:30:56 -0800 (PST)
Date:   Wed, 9 Dec 2020 12:30:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: dsa: simplify the return
 rtl8366_vlan_prepare()
Message-ID: <20201209103055.j5lpldjb3qyzvpjb@skbuf>
References: <20201209092621.20523-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201209092621.20523-1-zhengyongjun3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 05:26:21PM +0800, Zheng Yongjun wrote:
> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
