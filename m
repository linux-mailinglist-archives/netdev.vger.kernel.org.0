Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7CD1C3088
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 02:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgEDAlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 20:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726842AbgEDAlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 20:41:45 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751BBC061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 17:41:44 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id b6so1615487qkh.11
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 17:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=U2svxoG8F7H5W8vbJHTsDdbd2fY1N1hmmmhtZ51CTEo=;
        b=vgnBIEidI4CqrfA5S/wuzWHVsMzU2bSAIRDbMvppDLMgH07pgVHIrHRNyt+rENlCm0
         7pnRXZLR9Xu2K59XrqjmrLJQDkn7quMmgGNWzOAYsEg2uOhG7hjS6ZezbTxahJ0hEmEf
         jlKCi3Mr0+BeDdI/mLd2lF9j0dDkdf2gLGV2lvw2tfQyvi5drNJcB6wz52ha/kurMHu7
         YrnF5ljke9756XA9pbFAr+DoqwU1SvF7cPOGyFMdra0KjTj75xyrkdoGO5hOJuO3HD7p
         Ne9o/j9UvDRtMX9RXoW534S45KARiZv9HEWeF6qCb298zzb4zRIf1WFV2TmKd/VvAWo/
         PiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=U2svxoG8F7H5W8vbJHTsDdbd2fY1N1hmmmhtZ51CTEo=;
        b=lSsGAcU1/WtXhF9bQFppCPnvWSty30A0NDmkXd7nhif/sDaty0wA1wofaRySoHCqKP
         2pf6zeVRMaOexhsVW14g2L+KtsMbom6adOhORYBtDAykMb008Dc7Rdo2ub/zzdD2kEJy
         s5geA58lsPjvrDSD7aUOciyWP/A2ftP8eSJd3bJBHcjusAK++Wp7RyWTgjmJmABOU8Gj
         Oyz0Jus7l2MkigcHlMQ9qhu4rPJxLwU1QY8o8uPBKyGB7H8u6prwVHqTRJvHTvFvv5sh
         mMQwGMWY2z/X5vK+q+FUhA10B6ztIgXr8S074s8uRQ9gEfugBFsmvOaj5WbU8vlfImF3
         ZzWw==
X-Gm-Message-State: AGi0PuYFj3xbL+okOByX5iOXu4mX9ShH3+rzEcp5mQkADGSv6HAvWlRD
        t6yg0R0sNd1G1VEwzsdR+fex0zTm
X-Google-Smtp-Source: APiQypIl0BlXOMThGIjHltnoQiwIwskbbhUVBzBjqxI3Y8YDPHcfaGnKA751K1HFZ/2ifgWq08DWMg==
X-Received: by 2002:a05:620a:1647:: with SMTP id c7mr14046067qko.473.1588552902794;
        Sun, 03 May 2020 17:41:42 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4fe:5250:d314:f77b? ([2601:282:803:7700:4fe:5250:d314:f77b])
        by smtp.googlemail.com with ESMTPSA id n31sm9707415qtc.36.2020.05.03.17.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 17:41:42 -0700 (PDT)
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   David Ahern <dsahern@gmail.com>
Subject: max channels for mlx5
Message-ID: <198081c2-cb0d-e1d5-901c-446b63c36706@gmail.com>
Date:   Sun, 3 May 2020 18:41:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed:

When I saw this commit last year:

commit 57c7fce14b1ad512a42abe33cb721a2ea3520d4b
Author: Fan Li <fanl@mellanox.com>
Date:   Mon Dec 16 14:46:15 2019 +0200

    net/mlx5: Increase the max number of channels to 128

I was expecting to be able to increase the number of channels on larger
systems (e.g., 96 cpus), but that is not working as I expected.

This is on net-next as of today:
    60bcbc41ffb3 ("Merge branch 'net-smc-add-and-delete-link-processing'")

$ sudo ethtool -L eth0 combined 95
Cannot set device channel parameters: Invalid argument

As it stands the maximum is 63 (or is it 64 and cpus 0-63?):
$ sudo ethtool -l eth0
Channel parameters for eth0:
Pre-set maximums:
RX:		0
TX:		0
Other:		0
Combined:	63
Current hardware settings:
RX:		0
TX:		0
Other:		0
Combined:	63

A side effect of this limit is XDP_REDIRECT drops packets if a vhost
thread gets scheduled on cpus 64 and up since the tx queue is based on
processor id:

int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
                   u32 flags)
{
	...
        sq_num = smp_processor_id();
        if (unlikely(sq_num >= priv->channels.num))
                return -ENXIO;

So in my example if the redirect happens on cpus 64-95, which is 1/3 of
my hardware threads, the packet is just dropped.

Am I missing something about how to use the expanded maximum?

David
