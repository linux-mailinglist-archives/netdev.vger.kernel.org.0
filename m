Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7256A9D3B8
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbfHZQIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:08:37 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42786 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbfHZQIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:08:37 -0400
Received: by mail-qt1-f193.google.com with SMTP id t12so18390187qtp.9
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 09:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=eUuNXuoujBIeL6W4FXeZIkBlk6b/1G8fUzQkO+kQykU=;
        b=FuXep8vD2ClNJQt81b+MBUTTA+qk91CDIZDjgXDY/axK64smPtJXFyar+KjbKOgvzF
         YVlClG+ILgneRRswmvvp/y6hKPS6X65XJ1TvFkY3umCN71gXRpQoInCPNvSLPh/I7YaE
         KqQjWSnNT3E7aXLol/dCvS7oki5HYizPC/rX3NVCMZIvNBuBVHnW+TM/bytSkZzcBv7J
         3u62KQytEtEJd9k4TWv6r8zhxy9FqzDHTdISWeofRpzcifE3QCVZDh1gTEdraPvee562
         j7okj9N8JBL2/Oxl+OENPfofpS23iUSwL6Td6AMYMm/qvBnSr2ipWKi5UlnnxcyPZKLT
         7wrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=eUuNXuoujBIeL6W4FXeZIkBlk6b/1G8fUzQkO+kQykU=;
        b=nlxNtDbDZgTh2SS1oiqno1sbpdjRN3ynh96aXuk5TMY/F0tL3xv+7HlV04nBRB3HtY
         mVNHApKrIgeV02Y82FmetpgV3X5QnxOkSeSvBd8A1Yk5qYn9RBIJ0JBSUDam1oUG9Bei
         MnYEzWQL7Xx66T4oYyJ03Hxz8h5SSrlZ12TD2jIdLam4JCklAkcVq9NLzRL8WehEczKs
         lcJ27TWz1gLLYcJYwsXinQiJSodFfWuZ9OZ+CmkR5FlJpvNnU5Q4PAkmJr27guEfZC7g
         tQhptpME3ugM6020G015SHWTS9bOILZzxEnRZ1rOE/j9WCNUS0uVjaP4mZf2h8G11Qnl
         BCpQ==
X-Gm-Message-State: APjAAAU4unYGc/GbYcEW43/TBKmgUKVa6sDFyFkCnbZBLVxoLUFfOIrh
        VNMTWXXQdOLnEWPBdlAO895YGdSwTzQ=
X-Google-Smtp-Source: APXvYqxk8LHaAqt4LL8uh5VRTHkr08lpQnTRej0inJ8PGquME6hX5lA6IO4RqaQKV8v7LI/3cHtlUQ==
X-Received: by 2002:a0c:c548:: with SMTP id y8mr16167010qvi.68.1566835716190;
        Mon, 26 Aug 2019 09:08:36 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id r14sm8196964qtb.97.2019.08.26.09.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 09:08:35 -0700 (PDT)
Date:   Mon, 26 Aug 2019 12:08:34 -0400
Message-ID: <20190826120834.GB1341@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 4/6] net: dsa: mv88e6xxx: simplify SERDES code
 for Topaz and Peridot
In-Reply-To: <20190825183609.4a9cc0d7@nic.cz>
References: <20190825035915.13112-1-marek.behun@nic.cz>
 <20190825035915.13112-5-marek.behun@nic.cz>
 <20190825120232.GG6729@t480s.localdomain> <20190825183609.4a9cc0d7@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Sun, 25 Aug 2019 18:36:09 +0200, Marek Behun <marek.behun@nic.cz> wrote:
> > Aren't you relying on -ENODEV as well?
> 
> Vivien, I am not relying o -ENODEV. I changed the serdes_get_lane
> semantics:
>  - previously:
>    - if port has a lane for current cmode, return given lane number
>    - otherwise return -ENODEV
>    - if other error occured during serdes_get_lane, return that error
>      (this never happened, because all implementations only need port
>      number and cmode, and cmode is cached, so no function was called
>      that could err)
>  - after this commit:
>    - if port has a lane for current cmode, return 0 and put lane number
>      into *lane
>    - otherwise return 0 and put -1 into *lane
>    - if error occured, return that error number
> 
> I removed the -ENODEV semantics for "no lane on port" event.
> There are two reasons for this:
>   1. once you requested lane number to be put into a place pointed to
>      by a pointer, rather than the return value, the code seemed better
>      to me (you may of course disagree, this is a personal opinion) when
>      I did:
>        if (err)
>            return err;
>        if (lane < 0)
>            return 0;
>      rather than
>        if (err == -ENODEV)
>            return 0;
>        if (err)
>            return err;

A single return path for invalid queries, eventually checking a specific
error, is always more idiomatic and better than checking two places which
could lead in mistakes as your previous patch did. So this is more readable:

    if (err)
        return err;

or:

    if (err && err != -ENODEV)
        return err;

or:

    if (err) {
        if (err = -ENODEV)
            err = 0;
        return err;
    }

>   2. some future implementation may actually need to call some MDIO
>      read/write functions, which may or may not return -ENODEV. That
>      could conflict with the -ENODEV returned when there is no lane.

The current code is already using -ENODEV to inform about "no lane for port",
even if it can be used by lower level functions, same as -EINVAL. That is fine.

So if you have to respin the series again, I would really prefer to see an
unsigned lane parameter, otherwise, fine...


Thanks,

	Vivien
