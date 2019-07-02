Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564955CEF4
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfGBL5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:57:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44538 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfGBL5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 07:57:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id e3so7935516wrs.11
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 04:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=twoed304bVANHmzTBGu83qACybedl04wF9pEcLlsQ7g=;
        b=p5+MgVUg30QZOEvU3DNgmUA3aC46BhnbMqOeupqqsWTqAXZSMCgbzOB+jammgHIiJe
         SBoanEe6kV+few/FCFhJv+wqst9rDwGhBbeUIzciEytg9mjufMW+0tBNnYkR+p4e2z57
         tnu7X4hXVAJBD0WhvyRUp0o1AQsHAkD5OYlstXyB0waLFkOIQbf/FJTZ7r+WJfR83aGJ
         R+VSjJugI22/GaEC5k4W7PM5UofS0vjDOqMmRKV2dTa/HOdFJEivTSQhFP7tNYSmUIRh
         IqxjP0KexxLnKoiUM8NBQnyQcll7Swi8PFRr+AqR5vvBmJStxGkIk7jh+i//oOOrLy8B
         8C1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=twoed304bVANHmzTBGu83qACybedl04wF9pEcLlsQ7g=;
        b=CT0J33gRLgF+UJnr2I9PJ63cs3+dtvBpsoSCtt9z21arhST9UXG/5aEdFpdxGok/IS
         Aczm/Pwc7GakjOjKKxhDoSi1RAV4FkwGCCrwvj7/4dbJLnwbSm7hIvAQap+M1i5V6784
         cXfgSs7+Npj3o3WLFn3IMRfJUUmiVf1b88A3DYnOi8hXDPvAA8dY+FAcdMJ49ibrESh6
         WaLtWUDoaBcVEFBd4AuL9q1Aqs7Cl+5HhtqwGx/Ds2mXBsdb6W0dUvDeAOetWqEJJud1
         ni16oI/W1LZoPa6pK/5aeuwo0fTjleRZyTb35b1+SxoatZ4s46aS906RpQcK4/RMu+nL
         1ZbA==
X-Gm-Message-State: APjAAAUqskTAIgnEiqmPnekTk8pe7zNT5hyoEJ0qWP8/y4nUyfglOzJV
        pvj8hSzl0cthq6BoJw+F+UbF/g==
X-Google-Smtp-Source: APXvYqwikzNFnHZpdxrcgln2rDmWrFAF+J4y5fKblz1UG9SGZcsUr6O6KdmPdmTb/GLXfW8cLJTRmw==
X-Received: by 2002:a5d:618d:: with SMTP id j13mr23127089wru.195.1562068671649;
        Tue, 02 Jul 2019 04:57:51 -0700 (PDT)
Received: from localhost (ip-213-220-235-213.net.upcbroadband.cz. [213.220.235.213])
        by smtp.gmail.com with ESMTPSA id e20sm20148618wrc.9.2019.07.02.04.57.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 04:57:51 -0700 (PDT)
Date:   Tue, 2 Jul 2019 13:57:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 01/15] rtnetlink: provide permanent hardware
 address in RTM_NEWLINK
Message-ID: <20190702115750.GL2250@nanopsycho>
References: <cover.1562067622.git.mkubecek@suse.cz>
 <b6e0aefbcb58297b3ec0a12ee4be8e5194eee61a.1562067622.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6e0aefbcb58297b3ec0a12ee4be8e5194eee61a.1562067622.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 02, 2019 at 01:49:44PM CEST, mkubecek@suse.cz wrote:
>Permanent hardware address of a network device was traditionally provided
>via ethtool ioctl interface but as Jiri Pirko pointed out in a review of
>ethtool netlink interface, rtnetlink is much more suitable for it so let's
>add it to the RTM_NEWLINK message.
>
>Add IFLA_PERM_ADDRESS attribute to RTM_NEWLINK messages unless the
>permanent address is all zeros (i.e. device driver did not fill it). As
>permanent address is not modifiable, reject userspace requests containing
>IFLA_PERM_ADDRESS attribute.
>
>Note: we already provide permanent hardware address for bond slaves;
>unfortunately we cannot drop that attribute for backward compatibility
>reasons.
>
>v5 -> v6: only add the attribute if permanent address is not zero
>
>Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Acked-by: Jiri Pirko <jiri@mellanox.com>
