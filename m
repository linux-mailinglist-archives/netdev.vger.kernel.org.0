Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DAB2411FD
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 23:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgHJVBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 17:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgHJVBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 17:01:12 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFD9C061756;
        Mon, 10 Aug 2020 14:01:12 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id f24so10820176ejx.6;
        Mon, 10 Aug 2020 14:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kZV6bGMnFRnrq6awOAaMSY2e30ls2hMzYSKPF5lCwco=;
        b=HRjs9aREtAntyg4GqciKpndEpWsARkaC7dDydsKhlctnpTnTRTNeOF3Up8j1kN4DUF
         cEZ+smciWZ2F3S8Sd61Y+99pMrJpPbXnmBgY6poR9bOCt1rtubnx9aF4BNDC67qk9U9Q
         7QHegpaEHT7ofoXyj5JhNOi+YfttJYAejA0voW7tWh66Z6ZRTXcPQ2+IdtvVLwMCVp2l
         G9KYDA2abpN+yB9VBB4Jm/Z0neY6h4S8emT12USfuWpz5coeO1P1pwA35thBYaKdNLmJ
         9XeSlYQiHEHrDK9DS/BavI8jtk4EQ673TCApP3AkPwcg6i+5CCehtrJvZzry7WBjuzjA
         FkjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kZV6bGMnFRnrq6awOAaMSY2e30ls2hMzYSKPF5lCwco=;
        b=XeKuDCbmhxraP1iK9adqUIxPMajRHiIgL/cNOnZvgf4lbKrf4ibwR5Dt/93E++et2h
         rhteQ2VQyVDhtaR/8qE5Gb9DhllSURS4/g1L206me2dnRDIaUJqeoTf02AghHcWB/Owh
         hidB9V2uecSngEt1AYPOQC4tcqrfGrSA89fJ1jiyjaV0EK3Z4thFWVLUlS5cZGrWfYrg
         IG9972KrbxWS6W+6ilD5elVCZdTjHvreAh3l+o412w4w+I2FTMao7A7jNYvB52RN3Z+B
         SIoyOOWuVksFU+nJ27qoYI53q+rQEKvnV7D7WSW3Evz98EqLFt6CEHn+N+g3FCOfPRAd
         juoA==
X-Gm-Message-State: AOAM530aEv956FqHTWDnmbu8zlSzRoZfDT+f1EsZ26v6rbcoNnJQOAtE
        SKzAiUm/Wsv22Pj0Icfk9sQMOuEz
X-Google-Smtp-Source: ABdhPJwPdRlGb+eBi6Cmds3+VrJd/bOoHNKk9G6ECH60Dx+BX7NZQ5jb2vI7+BoVAA0Om5WDBykP9g==
X-Received: by 2002:a17:906:eb90:: with SMTP id mh16mr22574283ejb.10.1597093270829;
        Mon, 10 Aug 2020 14:01:10 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id e6sm13928333ejd.14.2020.08.10.14.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 14:01:10 -0700 (PDT)
Date:   Tue, 11 Aug 2020 00:01:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 03/60] net: mscc: ocelot: fix encoding
 destination ports into multicast IPv4 address
Message-ID: <20200810210108.ystlnglj4atyfrfh@skbuf>
References: <20200810191028.3793884-1-sashal@kernel.org>
 <20200810191028.3793884-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810191028.3793884-3-sashal@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sasha,

On Mon, Aug 10, 2020 at 03:09:31PM -0400, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [ Upstream commit 0897ecf7532577bda3dbcb043ce046a96948889d ]
> 
> The ocelot hardware designers have made some hacks to support multicast
> IPv4 and IPv6 addresses. Normally, the MAC table matches on MAC
> addresses and the destination ports are selected through the DEST_IDX
> field of the respective MAC table entry. The DEST_IDX points to a Port
> Group ID (PGID) which contains the bit mask of ports that frames should
> be forwarded to. But there aren't a lot of PGIDs (only 80 or so) and
> there are clearly many more IP multicast addresses than that, so it
> doesn't scale to use this PGID mechanism, so something else was done.
> Since the first portion of the MAC address is known, the hack they did
> was to use a single PGID for _flooding_ unknown IPv4 multicast
> (PGID_MCIPV4 == 62), but for known IP multicast, embed the destination
> ports into the first 3 bytes of the MAC address recorded in the MAC
> table.
> 
> The VSC7514 datasheet explains it like this:
> 
>     3.9.1.5 IPv4 Multicast Entries
> 
>     MAC table entries with the ENTRY_TYPE = 2 settings are interpreted
>     as IPv4 multicast entries.
>     IPv4 multicasts entries match IPv4 frames, which are classified to
>     the specified VID, and which have DMAC = 0x01005Exxxxxx, where
>     xxxxxx is the lower 24 bits of the MAC address in the entry.
>     Instead of a lookup in the destination mask table (PGID), the
>     destination set is programmed as part of the entry MAC address. This
>     is shown in the following table.
> 
>     Table 78: IPv4 Multicast Destination Mask
> 
>         Destination Ports            Record Bit Field
>         ---------------------------------------------
>         Ports 10-0                   MAC[34-24]
> 
>     Example: All IPv4 multicast frames in VLAN 12 with MAC 01005E112233 are
>     to be forwarded to ports 3, 8, and 9. This is done by inserting the
>     following entry in the MAC table entry:
>     VALID = 1
>     VID = 12
>     MAC = 0x000308112233
>     ENTRY_TYPE = 2
>     DEST_IDX = 0
> 
> But this procedure is not at all what's going on in the driver. In fact,
> the code that embeds the ports into the MAC address looks like it hasn't
> actually been tested. This patch applies the procedure described in the
> datasheet.
> 
> Since there are many other fixes to be made around multicast forwarding
> until it works properly, there is no real reason for this patch to be
> backported to stable trees, or considered a real fix of something that
> should have worked.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Could you please drop this patch from the 'stable' queues for 5.7 and
5.8? I haven't tested it on older kernels and without the other patches
sent in that series. I would like to avoid unexpected regressions if
possible.

Thanks,
-Vladimir
