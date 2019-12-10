Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99D9118F55
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfLJRvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 12:51:39 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34814 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727587AbfLJRvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 12:51:38 -0500
Received: by mail-pf1-f193.google.com with SMTP id n13so213459pff.1
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 09:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fW3Ref0PHQ5io/FZ7XeWN9s3SNVfAIL+FiYKUeQn2KE=;
        b=mt115MN0ewRf9mbMFfp3Iuy2d9FfypEgxpQPsNISDAUH+rYzYYoVGNS6eQVx4xwi7P
         yTtaMc7LznoM3N9LJtFlmsznQ0SGCA7fpiGDFmINKs/wZ+ddeaDvS5XJj5isX8gCWPn+
         cfh+7/hpwkswXJwkPhciglEpdSvkWiZithOzgl+FdoDdWMXk1r1uRSPSvEi6e+dPZzuW
         M2SkMSiHHj2cbV6o06Ph2ggoSQQ6j1YB1OhHfP8YWBCLhnAcvJ3C7RwuftNOGuJE0E0w
         zGZV1mQY+gTcqgcLn4dgrucRHY4oamVhHdAXQH0goEO9cb2BEEs2PZNrayEg8nkaVLPv
         v1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fW3Ref0PHQ5io/FZ7XeWN9s3SNVfAIL+FiYKUeQn2KE=;
        b=NdxZqvWQMmZA8PIGYQVDlMMVK684ZCn8AlefaMvebWR9xpy/tmLcZDFBOwq9tFBwtb
         ZVYBMV5mwCdozysB2uhSKb+0NEnRzNPQhWiJ7TmqhjCUnL06UBMN0fZzRvim+GCGAZht
         iakMKTH3gg3D2F7qOQVUSH4cUJi6eiO50SOmpIQLv70xdIECL3OB8Pk8NGgdyxLeNhEh
         Y9HYlyYvqDA1JlBdaHlUydI60GP7CVoN9wMBD+WiSYMlW3IaEzMYeWjEjCCoC7bEyLhw
         crv2gq04IhA6GtK79xHxL3w1579uNljMJyQ4iDK09b7npMxXqrLK17W2toyZHEUGuoUA
         AWKw==
X-Gm-Message-State: APjAAAVgzcpgfWsuaypFaVAQxAG21gXWVXEsVlNgJSUnHci5eIHmsfO2
        UwYIfNBarZ2qfZ8GhOfWf742icCmwq4=
X-Google-Smtp-Source: APXvYqwcFHWWm9eTWrLu+KNteuLcuDUJ3dB0pTgi9WFTG+6hBnstYp4EgibKkKe5+8YCV2iFmQrQKg==
X-Received: by 2002:a65:5608:: with SMTP id l8mr26335894pgs.210.1576000298286;
        Tue, 10 Dec 2019 09:51:38 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::3])
        by smtp.gmail.com with ESMTPSA id y128sm4103464pfg.17.2019.12.10.09.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 09:51:38 -0800 (PST)
Date:   Tue, 10 Dec 2019 09:51:34 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/5] ethtool netlink interface, preliminary
 part
Message-ID: <20191210095134.27f46a81@cakuba.netronome.com>
In-Reply-To: <cover.1575982069.git.mkubecek@suse.cz>
References: <cover.1575982069.git.mkubecek@suse.cz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 14:07:48 +0100 (CET), Michal Kubecek wrote:
> As Jakub Kicinski suggested in ethtool netlink v7 discussion, this
> submission consists only of preliminary patches which raised no objections;
> first four patches already have Acked-by or Reviewed-by.
> 
> - patch 1 exposes permanent hardware address (as shown by "ethtool -P")
>   via rtnetlink
> - patch 2 is renames existing netlink helper to a better name
> - patch 3 and 4 reorganize existing ethtool code (no functional change)
> - patch 5 makes the table of link mode names available as an ethtool string
>   set (will be needed for the netlink interface) 
> 
> Once we get these out of the way, v8 of the first part of the ethtool
> netlink interface will follow.

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thank you!
