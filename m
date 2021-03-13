Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2C2339DEE
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 12:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhCMLjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 06:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbhCMLjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 06:39:15 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA7AC061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 03:39:15 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id mj10so58320527ejb.5
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 03:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=brVJ1aGHV2ZvOeIV9TMslHL8T1K0gzl+O5sXc2bujoo=;
        b=sRFxbquCYA+ALEXQnXFOCDSgj9bGwy9S3C6rD1zfXn7sr5VKdQ1NwonTiD41lolex6
         w4JZnkwup2DV09emppc0y5VOQt3c71VRYLl61Lgqp400cBSQaPOUob8wbuyQXm2B05JA
         48seVd8/mErvrJajvBQf2i2Iw9w4FnkU3cBMC2a+UapiXHP85+cbIySosS4xHNTBEAYS
         U2m7WfrfKQiwttbMTyUAS8PSZnpzfaFYkNXe6l2mbzP9gFwEKAEY1re/uj6QqMDR2+7f
         AP245SQVc0rEBp1LKmbALYNyiHoGWJn3l7gbsK50+1vBfMJVW1JdkdlweII2eKhsDxaH
         XbJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=brVJ1aGHV2ZvOeIV9TMslHL8T1K0gzl+O5sXc2bujoo=;
        b=H5D53TwYMjPHcsQ6lacbhNrWBKKRFlmLJusWSeiXr9Y2RHo9xo1/+QFw4ar8qcs59y
         AliCvsAl9ODFaTWEIA8q9g3bw1Vim8xidF3ooHCvVghRJKVg+fmPa6y+jyiIgFN8ia4D
         oU3eyoh6B1/i+OpzYBoTUJZv/QDuqDLZuI58KcbC7/oVojlvl1kO3IpPVeWbx+9Iv6QX
         dDM+2dXsBW6efH3u+hVFQeTvbYgrIbC6xUunRrCxaiJFIQcAsCc2Eobz9AToDv7bP8kj
         J4P9GuIsPIXXkoeVi6lJFP0wU2gGomeIlSR+sb82bHXftm4ILnoT9CfICO5OXlMfFBRw
         HzjQ==
X-Gm-Message-State: AOAM531OGbdpwpx+9tIehpZWYrbVOT9kceoLY1SpY66FtLj5RKWZmxed
        lS7SI7DljyiFsmE9fOQy2yI=
X-Google-Smtp-Source: ABdhPJw1y43jEaRgDuqrMWj8qHipb2BCUjddep8QBb5Tr4BkB2Rz4Wm0sqEbY+BDWLlvONvgwpDQyA==
X-Received: by 2002:a17:906:da0e:: with SMTP id fi14mr14020965ejb.188.1615635553913;
        Sat, 13 Mar 2021 03:39:13 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id a12sm4380228edx.91.2021.03.13.03.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 03:39:13 -0800 (PST)
Date:   Sat, 13 Mar 2021 13:39:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/4] net: dsa: hellcreek: Use boolean value
Message-ID: <20210313113912.ah7gldgpp5cpcbty@skbuf>
References: <20210313093939.15179-1-kurt@kmk-computers.de>
 <20210313093939.15179-3-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210313093939.15179-3-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 13, 2021 at 10:39:37AM +0100, Kurt Kanzenbach wrote:
> hellcreek_select_vlan() takes a boolean instead of an integer.
> So, use false accordingly.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
