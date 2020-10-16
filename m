Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC6B290A18
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 18:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436494AbgJPQ4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 12:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436470AbgJPQ4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 12:56:54 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F84C061755;
        Fri, 16 Oct 2020 09:56:54 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id c22so4217262ejx.0;
        Fri, 16 Oct 2020 09:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UgpEA1cQ9daiE5G04PqwvEH3uzNvOWykk3NbODww83k=;
        b=kQafq4KcmJLVYTE+BvIM4y2h6rH5EBuJYDZ0fYlmyx32GC+zKllq8vSdJJbCl0U+RN
         C6gFcYWnLARXWpaX4VZeCz0zqNCJVyfXvssRokLhm+NBieZvov0eTq8fZ/RxAZAZ+uaT
         IV+gjWbMETio5VjZTboJq7BwaJ3+a/0E9rU2AJGpq/PzvipeAuNjUJf1Q/tdMUpHhXa+
         qGHWp4U8tYq1mArutwrEDorQrG/oilhp4KSlJQ4+C2LxwYDKMOhxHoq/MnbADQbOZtpU
         eACv5XZe/GXcS85Zkddy7deK/k3uAgh0caNOfRvn5lyQ8VzcUDgzYsjFc1dEdUe0sBHP
         J3oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UgpEA1cQ9daiE5G04PqwvEH3uzNvOWykk3NbODww83k=;
        b=fA2QhrRHOpMQ6a03hY/cSYeY0ZG8VOFzFQKDjSZT8fotQohfqDPD2DZ4Z2DqxmPROI
         V+K55Hfh/swdYhPtmfrdEOfTT4tyME3OTpvGLDWg7C+19XZOLkLn0sXXJsQaY4OnJ8qi
         wZqHc608piV24Z2wiGzLNaYh/JqJHEJcU4dlh+eQ4LShqQekEGhz2yZ64zuOgY/tHsxk
         MuyXYbnayKjAWna8JYvqtYCIVuXJqN/BH8YnLZ+kdDZQOb/LJLOozCdecWlBK6MQA7e1
         LdujMpm58EjRLD8s5biFhMl6zyp9s1lcnoG9NiGo/A2yKDKhbUkWGvYjXzxN564Tv5N9
         O1PA==
X-Gm-Message-State: AOAM530CZGWA//xr8Ka3VcjqO1yygg3bcAiBZNbpgbREw+tjK+BxB9T6
        PotE9bbjVmK64wv8JbmpLVo=
X-Google-Smtp-Source: ABdhPJxq72/7v2kuLtcaS5dwhAHSOllfava0wgPhlLTbeMqnB2d54gmcJGFHO3d2BiERTPFyiY93ng==
X-Received: by 2002:a17:906:490e:: with SMTP id b14mr4681719ejq.268.1602867412968;
        Fri, 16 Oct 2020 09:56:52 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id i4sm2189033ejz.62.2020.10.16.09.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:56:52 -0700 (PDT)
Date:   Fri, 16 Oct 2020 19:56:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: point out the tail taggers
Message-ID: <20201016165651.mknc4djwhjg3t5gh@skbuf>
References: <20201016162800.7696-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016162800.7696-1-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

On Fri, Oct 16, 2020 at 06:28:00PM +0200, Christian Eggers wrote:
> From a  recent commit with the same summary:
> 
> "The Marvell 88E6060 uses tag_trailer.c and the KSZ8795, KSZ9477 and
> KSZ9893 switches also use tail tags."
> 
> Set "tail_tag" to true for KSZ8795 and KSZ9477 which were missing in the
> original commit.
> 
> Fixes: 7a6ffe764be3 [net] ("net: dsa: point out the tail taggers")
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

The idea is perfect but the commit isn't.

First of all, put this in your .gitconfig.

[core]
	abbrev = 12
[pretty]
	fixes = Fixes: %h (\"%s\")

Now if you run
"git show 7a6ffe764be35af0527d8cfd047945e8f8797ddf --pretty=fixes",
you'll see:

Fixes: 7a6ffe764be3 ("net: dsa: point out the tail taggers")

Notice how there's no [net] tag?
People complain when the format of the Fixes: tag is not standardized.

Secondly, can you please come up with a commit description that is
_different_ from the commit you're fixing? As a backporter I would hate
to have 2 commits with the same title, I would surely mess them up.

How about:
net: dsa: tag_ksz: KSZ8795 and KSZ9477 also use tail tags
