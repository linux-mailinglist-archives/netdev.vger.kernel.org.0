Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F55E3A3849
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 02:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhFKAL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 20:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbhFKAL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 20:11:29 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7B6C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 17:09:19 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id dj8so35137329edb.6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 17:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5Io23aHOAsO0qsWRnwgBTcaC4swbw8Zo1uCckqb0jNQ=;
        b=B//sZ/Xv7bUKAfJznqPVpP60eQGcF8hjOa6wMJQZLww94wLY3zOZA//N+lwiFKdwy7
         cP3N8bevFym8DgYOXab17zHkssPwIrBubOFfunkZWqAUpLEPWRjhv+taLJRo9YusYjOj
         2QedMIkNuqbw9RvMOl7TL0twPnPZ1WO/CMXBw1d/nUhgchfFqUUwK6uNywY4NBRs75FB
         m1L9r6kGjzEFEfrZlCHZbuYBTwqqFmqgZff9aTviLQyD+p3Bw7nKSXT3hkWnIeDee1wi
         wg/0DLHWmguJp0pib0VyjnFFhOpLR94I++02b1nZ2qGFh8K6DjzATHa5onJzQLvalK1X
         CsLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5Io23aHOAsO0qsWRnwgBTcaC4swbw8Zo1uCckqb0jNQ=;
        b=RmTqNbyD2juGOUTA5JHpwWbARz/aupql31QlgInhiE7q34tnTECl2rnngbvcPBpQuw
         jbT4lV3ueDfwO/glMKxInP7fTZLCOdCzH/NDt3zOr4la2f+oz+DIlWhh70PAjIceNa2W
         WpghwS2MZP2Rxo8jwrac1ZtlyJTG7NC0JRH84UOxYVAZofBYS0cmUaXdiSHYzLUciU2B
         ojRIpXeUJikMjs7lzsbyf+fH9MCSc8Ez6SQjK6PYA3oRsGtAE+Ia1yIvYOYg0mAna7h6
         mYPioi2JkCEluAZ+eGovEUoXiXZFz+cgdWPpF8TBLHISz9OpNOB97gbRHUoNIaNLgW6d
         zPVw==
X-Gm-Message-State: AOAM533DxYxxxURmhpUnmE5xLZNi4it89o7fuDMjqChJgAx3yrn2eRV+
        zIBgb2WmZfH6UDc9BUPqPzM=
X-Google-Smtp-Source: ABdhPJxz7UDUJIga6WQNfk8+VtkBmq29j8S8SGHzIpU3K3Ko3DAksGiDkx2GYbxaLPZVAL0LtbVpyw==
X-Received: by 2002:aa7:c2c7:: with SMTP id m7mr982256edp.156.1623370156685;
        Thu, 10 Jun 2021 17:09:16 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id p9sm2009754edh.61.2021.06.10.17.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 17:09:16 -0700 (PDT)
Date:   Fri, 11 Jun 2021 03:09:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, f.fainelli@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, richardcochran@gmail.com,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH v2 net-next 00/10] DSA tagging driver for NXP SJA1110
Message-ID: <20210611000915.ufp2db4qtv2vsjqb@skbuf>
References: <20210610232629.1948053-1-olteanv@gmail.com>
 <20210610.165050.1024675046668459735.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610.165050.1024675046668459735.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 04:50:50PM -0700, David Miller wrote:
> 
> Patch 9 no longer applies cleanly.
> 
> Thank you.

Ah, that is because I also have the "Port the SJA1105 DSA driver to XPCS"
patches in my tree, and they are photobombing this series. With git rebase -i
they apply both ways, but git rebase has more context when applying than
git am, so I'm not in fact surprised that it fails, now that you mention it.

I could probably dodge that by moving some lines of code here and there
so they aren't near the XPCS changes, but I think I'll choose to not do
that, and instead let the people breathe a little, maybe take a look at
the patches as they are - if they want to apply them to a tree, that's
possible as well, sure, just apply the other series first - and then
resend tomorrow, or after the other patches are accepted.

Thanks and sorry for the trouble.
