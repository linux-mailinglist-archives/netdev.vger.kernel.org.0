Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF70C647AD
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 15:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbfGJN51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 09:57:27 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:36179 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfGJN50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 09:57:26 -0400
Received: by mail-wm1-f45.google.com with SMTP id g67so2391856wme.1
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 06:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=L9QYd0xkS8KyS5h8YvnclpWHjzklcYyQkP33UoM5dXY=;
        b=rXkU5pElqJwbUPxYRNab/cYqKKGcLp6ZSaRbbr4+kxqFNtrEX6svsyyx9HoGcYXnMM
         ZNJurp93TE5pC1RzcNWYSHsuIdxsTskxDf251zLVV6YlKkj7ZsD6thq5evIbCVomcvEK
         DoHko3TFQO4PJMH4WDPmf5eBuPa3sVmIXiErgzxQBoPykd49mg1wMFl+c9yVmEanXp34
         uS5W+o0FbUDSlGGi6Vjqm1kQxs4YsuA7ZuS5b6fmAZA8pgGodQfgChIq+cyzQ1h1nLWX
         RILhkHDgAiLV8ssw/zX9bryiZ5X8OAFYUk5RLM7sh1w8v1L5O/qIqnnPkZytslS4RHZ7
         20cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=L9QYd0xkS8KyS5h8YvnclpWHjzklcYyQkP33UoM5dXY=;
        b=m+zEtrGGQV9LBNz1XPyCgaG9yrwCNJ2FGWlS5JI7bGr0lM1glpydTNCkor8qOwmfRn
         /u2uB8atVxi/lGJwskqz3Trsgyfi66IVnltzN66qaCvpwM3t2x3soxXAhUvbdjeNZKMx
         1s0c14v8hNNgcr4gOQmGdbu+d7BJe46oVuvjwcKQGapKT/Tp5ZQAzqJlMrHNqRrL3sPA
         zAN3BGYw2VLnjcIpPSkRFvzcfoCUPMQYkTxoFem4mxW1QoiMsCSG4TCtjDEVQ4BzU6bm
         Js833LlpuGZYLD+Tm0ZxwPGVdFdFpW3lhrW8rHyLJ1RsDseH2LBD1KGo2kVWQhGHfvVM
         AbqA==
X-Gm-Message-State: APjAAAUJuJ5GFVkSpO+a/a4s7hNPPrZn+6v2+yhQSSy25UszzRLxdvjH
        Sb/lNnEoj2GGyzEc3Nf6eXU=
X-Google-Smtp-Source: APXvYqz2jIRAOT5uuVNEqDIMbfwBbOBwyNWvkG7OaOT+XyX6d/8AVGf5U5+5QQ32fK3zAho2S6WIqQ==
X-Received: by 2002:a1c:99ca:: with SMTP id b193mr5487685wme.31.1562767044886;
        Wed, 10 Jul 2019 06:57:24 -0700 (PDT)
Received: from localhost (ip-89-176-1-116.net.upcbroadband.cz. [89.176.1.116])
        by smtp.gmail.com with ESMTPSA id y12sm1367677wrm.79.2019.07.10.06.57.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 06:57:24 -0700 (PDT)
Date:   Wed, 10 Jul 2019 15:57:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@kernel.org, jiri@mellanox.com
Subject: Re: [PATCH net-next iproute2 v2 2/2] devlink: Introduce PCI PF and
 VF port flavour and attribute
Message-ID: <20190710135723.GD2291@nanopsycho>
References: <20190701183017.25407-1-parav@mellanox.com>
 <20190710123952.6877-1-parav@mellanox.com>
 <20190710123952.6877-2-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710123952.6877-2-parav@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 10, 2019 at 02:39:52PM CEST, parav@mellanox.com wrote:
>Introduce PCI PF and VF port flavour and port attributes such as PF
>number and VF number.
>
>$ devlink port show
>pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0
>pci/0000:05:00.0/1: type eth netdev eth1 flavour pcivf pfnum 0 vfnum 0
>pci/0000:05:00.0/2: type eth netdev eth2 flavour pcivf pfnum 0 vfnum 1
>
>Signed-off-by: Parav Pandit <parav@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
