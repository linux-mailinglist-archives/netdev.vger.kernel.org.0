Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5233D394F
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhGWKiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhGWKiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 06:38:17 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DFFC061575;
        Fri, 23 Jul 2021 04:18:50 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id nd39so3176872ejc.5;
        Fri, 23 Jul 2021 04:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oDJQ5po8L/tFYjc6zc6xLwbvrSoczZm9yJe1oK1FQPg=;
        b=fWSgPaG2QdOS13RybW9Nw+nseh74a+r45w+71Ul+2swsEr1yatzjH6N/MHPSflO9uJ
         1UPn/0XQ5dAuKh/RdS5KAwfsx/Ll9aV2uGtzrYiW+4o3+4MDXdE/xKvVwlcHV4ZMtJqV
         ONgduGgsgBxkVVdV0pa413Cktw+qdK4t3s+gIiw9NbqEEkQYxIXsWi2fnEyXZF0OJL65
         sdq4bF6+YgAI3uBiOVi9gzmnbfOwQyqVtVloRiXzbjFzNBBhSuK6OG5/Wxzrck+Ryktl
         iRFMUTD3Boprperid9KGgBJN7b4UH3DAbW8OsS+UqMOaMn5pYYrj5wa8Rrwo+9o0cS0Y
         6zZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oDJQ5po8L/tFYjc6zc6xLwbvrSoczZm9yJe1oK1FQPg=;
        b=DoNh4B1uQD++M02H3XwvqtAwoEydQLPvYhUc7wZNO9u0Hm7TLuDB19obZXeYxTsxIl
         H7s1N7wPxt7mN+GLyRfy4I6mgGOSCZfOVhkZVBf0Ub+LnAPwPVEaQh9khTriL5MK/z3c
         0IywOV0ErLP0WiEFOBQHqIXNGUPBJ8Od5CXGsixXDSySPPWcMXdvUDfPWvsZQaYlaR6i
         zk+XnILzDsM3gi9AwSjqfwU9D3qChg2lErMeU9Klp8iwSklEOvLsoM5VqE/OOJoMB/Uz
         I0KE/DhEFlV8z2KxqYkUYQIj46RuB+R+7BHNuzJKQVwBrt2LAkjFYDPKNQkbX4K8DctC
         aoAQ==
X-Gm-Message-State: AOAM5324A37MVuD/8WumdDbjDE7d14iIxkBfStqwRySNCVo3rzzhMcNY
        onRxkkZW52nVWNjsV2Fnhlc=
X-Google-Smtp-Source: ABdhPJxfsrjGmgmZC31XDyxwkE/XQDH3l04dOJM07bfbK79oQKgtgW27pnxQoDhecMcgvoXVzGTwQQ==
X-Received: by 2002:a17:907:397:: with SMTP id ss23mr4078514ejb.470.1627039128890;
        Fri, 23 Jul 2021 04:18:48 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-79-26-254-101.retail.telecomitalia.it. [79.26.254.101])
        by smtp.gmail.com with ESMTPSA id gh15sm10473507ejb.46.2021.07.23.04.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 04:18:48 -0700 (PDT)
Date:   Fri, 23 Jul 2021 13:18:51 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, davem@davemloft.net, f.fainelli@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, olteanv@gmail.com, vivien.didelot@gmail.com
Subject: Re: [RFC] dsa: register every port with of_platform
Message-ID: <YPqlmyvU2IjPFkXC@Ansuel-xps.localdomain>
References: <20210723110505.9872-1-ansuelsmth@gmail.com>
 <20210723111328.20949-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723111328.20949-1-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 01:13:28PM +0200, Michael Walle wrote:
> > The declaration of a different mac-addr using the nvmem framework is
> > currently broken. The dsa code uses the generic of_get_mac_address where
> > the nvmem function requires the device node to be registered in the
> > of_platform to be found by of_find_device_by_node. Register every port
> 
> Which tree are you on? This should be fixed with
> 
> f10843e04a07  of: net: fix of_get_mac_addr_nvmem() for non-platform devices
> 
> -michael

Thx a lot for the hint. So yes I missed that the problem was already
fixed. Sorry for the mess. Any idea if that will be backported?

