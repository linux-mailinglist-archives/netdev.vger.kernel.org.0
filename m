Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AEB2C6D9C
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 00:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731582AbgK0XXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 18:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731432AbgK0XVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 18:21:44 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5C3C0613D1;
        Fri, 27 Nov 2020 15:21:43 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id d17so7789354ejy.9;
        Fri, 27 Nov 2020 15:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RzsSMH+hukhX+jVFkmT3ne6jmwQz5buCyk3OVQ1T7pQ=;
        b=ld9Rd0DgQ9RYr32MY2YpGhsiceREihp4mPWaIvlQAVQwtZHPmkMOsV0MlrUNQ16kuE
         UFu+YcIP4zkOWtaMsol6e0a8DEsi+QIW5dauppW0rULoywlsPI7bOIvO4e5JffGvMmHz
         I/Evef1PTboLamyDfu5txzEhxS5s0sfd38rXn9f6CWIo3matGEvT+eNtRwcQRZpau75k
         MERNQvoRy9q3VvbLcL4K5jj6+OmfrYIqD5bLdVNufgmvZPe6QaygPtYqDtwdmMFC6nZj
         3yIW9ag+1WqCAuysJFJCOA73N/SDi/jUm3vGszCPDXwDotjJENGGjm2cNN5IgzMENfjY
         QnLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RzsSMH+hukhX+jVFkmT3ne6jmwQz5buCyk3OVQ1T7pQ=;
        b=j9SN9yoSIj7UT3MLTdk6PrB/iSU2l1TMvnRn0XqYD7oKRldYYXVF6bDdoDO+pzA1U2
         SS9MuaacTYCi4XZscvAPlZZGgbHJlOdw7WOvH01Wh9u/f5Ren5eh9M30SMxau8ZVtYr7
         gOoKrnK30qAZsqjV1bEU+HUzXQDJMTbSU+KhDKb9xJJZscl5pfPgTpFiW6AY9BwbSPF0
         EsTHxNaCk6/ADpI8LCcbxMevMh5ayLP9t/KppPCfAO5L/TJtXio+6jMV4i9xsZSmL1oV
         TnbfoKlcbG3D3waeimtr/qW0rPI8CYCTWq+5npwy9KIGUzAngpWpy0PTE3I+nCxWtWNy
         Lovw==
X-Gm-Message-State: AOAM530P3tCkiMw+9heZeZQuwF2sdQuCjhxX+wXUhxOqMtdREZvN2FDQ
        FmfX3bNQT7bfcOWkMG6l2ow=
X-Google-Smtp-Source: ABdhPJzP6c/92Eega1if760CFgXx2nCAU15M+gMNrfWXWP+GmabuOn3SRI1MmP87/hc/OmYFIaHNSA==
X-Received: by 2002:a17:906:9816:: with SMTP id lm22mr10021265ejb.313.1606519302531;
        Fri, 27 Nov 2020 15:21:42 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id f24sm5204428ejf.117.2020.11.27.15.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 15:21:41 -0800 (PST)
Date:   Sat, 28 Nov 2020 01:21:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127232140.g6ylpsovaj2tcutr@skbuf>
References: <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
 <20201126132418.zigx6c2iuc4kmlvy@skbuf>
 <20201126175607.bqmpwbdqbsahtjn2@skbuf>
 <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAFSKS=MAdnR2jzmkQfTnSQZ7GY5x5KJE=oeqPCQdbZdf5n=4ZQ@mail.gmail.com>
 <20201127195057.ac56bimc6z3kpygs@skbuf>
 <CAFSKS=Pf6zqQbNhaY=A_Da9iz9hcyxQ8E1FBp2o7a_KLBbopYw@mail.gmail.com>
 <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127133753.4cf108cb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 01:37:53PM -0800, Jakub Kicinski wrote:
> High speed systems are often eventually consistent. Either because
> stats are gathered from HW periodically by the FW, or RCU grace period
> has to expire, or workqueue has to run, etc. etc. I know it's annoying
> for writing tests but it's manageable.

Out of curiosity, what does a test writer need to do to get out of the
"eventual consistency" conundrum in a portable way and answer the
question "has my packet not been received by the interface or has the
counter just not updated"?
