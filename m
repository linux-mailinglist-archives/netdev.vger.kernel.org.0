Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA09A42BD
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 08:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfHaGMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 02:12:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38989 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfHaGMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 02:12:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id a67so2660732pfa.6
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 23:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=OYGLxIKuHw7K/Y8mwdbskAt8yT1cmTnUwixVFEiawGM=;
        b=jOplZ52vBZ3/kgzf6GL13psoEoeT7LpPPJuv0rakAqsfJhTlmwxAyZ5MluAKM/GL4s
         aETF3+DIh8ZJd9BZ0lJn/mmMNtfZsTRk3Z38PiWh6d2/6ySpEFcOMJJnpHqL5Af+9Vpb
         2k2t2EkwSBKDHaOnlQA4WcQg1byHyHJmkcd3uwPKSEaUofySsWRda+sbfanbbivRSWuE
         3i0Jjs67ZstEPEmJn3N9iIj6bcPiB8SG43TpNqHUafwwxl3xmJMWY3iu2zBUTDrKFjgx
         gR6lkz7+zX8kh2l4akeF2q1ADGZXxd8YO8iyVhEKAdsPerkQjKKUw6BYyiFXMajgppmm
         u2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=OYGLxIKuHw7K/Y8mwdbskAt8yT1cmTnUwixVFEiawGM=;
        b=lLBm8NSH8ZVnkjoI7DU1nI5WklGhcE9YSqDVQwkfPcVeb/MrXahCwDXXv7WYFdeRjV
         Iru9PKrTYB5A9NlcRBRgzDgkKOowjK3d+odILEx6Yse3ciW/llt9e1Bt/nUplmt3752N
         MHGTWFe6glXpZraDCT1PXn65gdM3zSpP+KmJJ2jexTts5iQe/rNHNmRkyDgPVdEcbVDy
         Mm7MSrgnFojfw8/4bFRR4tiZ96GBEwoEgfK8sxZCSAdljIw3KfSPF+BeuOK+XjIwAEga
         qLerOrm6ZwiVhYeVB4I6WCe7iikLbJY0JXyuomL7yMXfD7hR9lvTW7w4OmCdRIAef07U
         6quw==
X-Gm-Message-State: APjAAAXPBTmI7lp1iOwHbQtpNFhZAxe7EPRlzsv3hVxi567+FfF23g8B
        QvCpdq/bt5fCs4L+/fo5G8RzdQ==
X-Google-Smtp-Source: APXvYqz5dWr8kdQl2NL3qTCRGSUuenXgttVl7/MCJJcE7f4ZjwQe0r+pMVGY1uLVb+MurXFmd19zRw==
X-Received: by 2002:a63:9e54:: with SMTP id r20mr16553506pgo.64.1567231963602;
        Fri, 30 Aug 2019 23:12:43 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id 69sm8033256pfb.145.2019.08.30.23.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 23:12:43 -0700 (PDT)
Date:   Fri, 30 Aug 2019 23:12:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next 0/3] dpaa2-eth: Add new statistics counters
Message-ID: <20190830231219.2363758a@cakuba.netronome.com>
In-Reply-To: <1567160443-31297-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1567160443-31297-1-git-send-email-ruxandra.radulescu@nxp.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 13:20:40 +0300, Ioana Radulescu wrote:
> Recent firmware versions offer access to more DPNI statistics
> counters. Add the relevant ones to ethtool interface stats.
> 
> Also we can now make use of a new counter for in flight egress frames
> to avoid sleeping an arbitrary amount of time in the ndo_stop routine.

A little messy there in the comment of patch 2, and IMHO if you're
expecting particular errors to be ignored it's better to write:

	if (err == -EOPNOTSUPP)
		/* still fine*/;
	else if (err)
		/* real err */

than assume any error is for unsupported and add a extra comment
explaining that things may be not supported.

Series LGTM tho.
