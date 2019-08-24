Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92C129BD86
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 14:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfHXMFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 08:05:43 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38488 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbfHXMFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 08:05:43 -0400
Received: by mail-io1-f65.google.com with SMTP id p12so26430202iog.5
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 05:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0hvg8EcOFy1hV2UV4sVHiLXXFhFD6hDENq5iidN2YYU=;
        b=qSY3vN9kfRyMrR0s+KtgMC54iFwLVcFRzH9+NcDJCePlL2a8xUzCkuImtzreATJyvq
         VihcLboVrvBQOosXlNGS6P7BXq2Gk+Ex82CskP8ZyojkWoR2uLDDKGgbHphzjV/80Yxe
         AhGH/HKzjwSR/aJx8544cJIpvmePOx+WDhSBkvVL4mGJeNyk3VsmcLwvtaP8ftry8HDK
         42/Ppc2RMtFvE2Xkh55152WJnXm6Z88+JqmnNU7Am+AaErt7G1yd/1EMiJJtUlOvXmNX
         eiEmzTVNUC7P4yvfpA89otsB11yyAPDnF6ueut9V7AROStf57qPAOonQfx8vP7PHsNdf
         gHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0hvg8EcOFy1hV2UV4sVHiLXXFhFD6hDENq5iidN2YYU=;
        b=RhRlLvy7S0kk6YeZ7FIb6AvBY34z3iNm7+1VeGgBv2GQILjl8IvC4tZvab5b4sROq8
         FXUJqY6Qi56Zb991W+EuyJFZFO2De8r+f4WAnwFfLrfZAu6Tea9cN2TIGD0IpcrlPZTm
         13ULY6SXqeK1UDky7UK1/PJ9nNJgRoYj/ECLFQCv1OdIuEEgf/5qdT2j9234KynvZKUp
         dt9ZO7lNsFuqeVZXlBr3tmhxhGC1j4HsBiy7coEwgfcxQDXlUAKcqngHJG0Xffbx8G9V
         6MF+G9lqogabmI5m/+Dk3gq1KvEeUExUKd1TdSw3oBCwCyLfsqXdVhc1KX8fsP5CI5wF
         MrSQ==
X-Gm-Message-State: APjAAAVGZrBFFPhfTbsuXUVBrhr6N6NZaGwRzm208iDGhy5vinaVskVZ
        pQ6QxG28zpAiPX4wVv/VJFM9IMZF8iM=
X-Google-Smtp-Source: APXvYqyIK4zLPXbh2ON1KZJES4TjV79eN/AeszSh3JNwvu8Vi9/CICCb8AZZeFzPLyPUFQ6pt2GEbg==
X-Received: by 2002:a6b:5116:: with SMTP id f22mr4074585iob.108.1566648342297;
        Sat, 24 Aug 2019 05:05:42 -0700 (PDT)
Received: from xps13.local.tld (cpe-67-255-90-149.maine.res.rr.com. [67.255.90.149])
        by smtp.gmail.com with ESMTPSA id k7sm4651829iop.88.2019.08.24.05.05.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 24 Aug 2019 05:05:42 -0700 (PDT)
Date:   Sat, 24 Aug 2019 08:05:37 -0400
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <davem@davemloft.net>, <UNGLinuxDriver@microchip.com>,
        <alexandre.belloni@bootlin.com>, <allan.nielsen@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
Subject: Re: [Bridge] [PATCH 0/3] Add NETIF_F_HW_BRIDGE feature
Message-ID: <20190824080537.5ce7083d@xps13.local.tld>
In-Reply-To: <1566500850-6247-1-git-send-email-horatiu.vultur@microchip.com>
References: <1566500850-6247-1-git-send-email-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 21:07:27 +0200
Horatiu Vultur <horatiu.vultur@microchip.com> wrote:

> Current implementation of the SW bridge is setting the interfaces in
> promisc mode when they are added to bridge if learning of the frames is
> enabled.
> In case of Ocelot which has HW capabilities to switch frames, it is not
> needed to set the ports in promisc mode because the HW already capable of
> doing that. Therefore add NETIF_F_HW_BRIDGE feature to indicate that the
> HW has bridge capabilities. Therefore the SW bridge doesn't need to set
> the ports in promisc mode to do the switching.
> This optimization takes places only if all the interfaces that are part
> of the bridge have this flag and have the same network driver.
> 
> If the bridge interfaces is added in promisc mode then also the ports part
> of the bridge are set in promisc mode.
> 
> Horatiu Vultur (3):
>   net: Add HW_BRIDGE offload feature
>   net: mscc: Use NETIF_F_HW_BRIDGE
>   net: mscc: Implement promisc mode.
> 
>  drivers/net/ethernet/mscc/ocelot.c | 26 ++++++++++++++++++++++++--
>  include/linux/netdev_features.h    |  3 +++
>  net/bridge/br_if.c                 | 29 ++++++++++++++++++++++++++++-
>  net/core/ethtool.c                 |  1 +
>  4 files changed, 56 insertions(+), 3 deletions(-)
> 

IMHO there are already enough nerd knobs in bridge to support this.
If you hardware can't do real bridging, it is only doing MACVLAN so that
is what you should support instead.
