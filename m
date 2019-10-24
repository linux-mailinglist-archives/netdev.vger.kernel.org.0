Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CC1E3515
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 16:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391014AbfJXOLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 10:11:34 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41193 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390869AbfJXOLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 10:11:34 -0400
Received: by mail-pg1-f194.google.com with SMTP id l3so872241pgr.8
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 07:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zxpXTsLwkuzCL5aR9Cif4vYoVX5q107h8UO9YuD8cHY=;
        b=V02OTEk2/QkRIS+Kyqq4oEDt1kMw/YNoGq49TbR5aqCXI+GGmuu71ss22m3UazdlNF
         hRVwCmXtRxo7z9D/JOBKNlgcjBDVNv+775L223/KSnND33jm4fLOHntqgo1LWUyZK+5Y
         l1U286kHxYeMtRNyeMDOQaXTrvDgALQV1mq7fjdo0GAlzMO/FV2xbvPXpIeKMwm9n7sr
         utC7phqXJL2kX8//tjcBl9OnJ72PcVOckW+NWBvoOHXDm5EHzPTiHoGOdmFqE4zJqo2k
         9L2ydlkaG4+5m1m/Ukr5cn+P2/Bn+z5OMS9IJDaGKZOozz5hEOit7H+UIlrhicSosjBi
         BoaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zxpXTsLwkuzCL5aR9Cif4vYoVX5q107h8UO9YuD8cHY=;
        b=DLg6ykfenyUjFWQg4Z/DvF4CrSGEtXnnfSE6Be8JWjUmJJmswGo+5Lh1jRA/tQJXHe
         GonZ/T9yR1nKiCS1p66iMOQJp4fwYusD4doiKXoWulUb8L7yR7jmyb09UjPkl9ZFkDMs
         n1s2zfm50kAk+ASKs/Sd1JnatM5DGSCE283n5HiWIKrFO7IPUVXzKU1IJe6ls/cSy17e
         fCKpafQlYITNPT7D4/57IX/Qzcw9GGDjM0CMjXekJsXqv2vW5ejcuOSZjCwDGksY1Ejw
         cLpkAffIp09o0CxFOJN3N1o+u/8OqzB9aXrKJLjXjKOwdTl7KzqM+weuq/NbNe2ZOA+O
         w2uQ==
X-Gm-Message-State: APjAAAXOugzZV3oaCES7WwNxb8+V6volO5nrmY/IXwcozTCXEoBc4whc
        p1BmSYWHjtj/KjuMhEw7mTs=
X-Google-Smtp-Source: APXvYqzkC0SDKbYLxJBGIJD4CUPcae5ca8IVafaz5HMNZjTLAig+YRLW2AEboJ02zknst1nuC4cMiQ==
X-Received: by 2002:a17:90a:b003:: with SMTP id x3mr7443124pjq.101.1571926292443;
        Thu, 24 Oct 2019 07:11:32 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e9sm22064749pgs.86.2019.10.24.07.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 07:11:31 -0700 (PDT)
Date:   Thu, 24 Oct 2019 07:11:29 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Pavel Belous <Pavel.Belous@aquantia.com>
Subject: Re: [PATCH v3 net-next 11/12] net: aquantia: add support for PIN
 funcs
Message-ID: <20191024141129.GB1435@localhost>
References: <cover.1571737612.git.igor.russkikh@aquantia.com>
 <a2a6ecfb5580858c2a690fa0ed1c98cffc61c4b9.1571737612.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2a6ecfb5580858c2a690fa0ed1c98cffc61c4b9.1571737612.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 09:53:47AM +0000, Igor Russkikh wrote:
> Ext TS PIN functionality is implemented via periodic timestamps polling
> directly from PHY, because right now there is now way to receive the
                                                ^^^
                                       there is no way to receive the
                                                ^^
> PIN trigger interrupt from phy.

Thanks,
Richard
