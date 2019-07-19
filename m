Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A8C6E8C9
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbfGSQ3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:29:44 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45179 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbfGSQ3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 12:29:44 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so14677576pgp.12
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 09:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=npaJxZXhhR2DqOaeZZ+R6c0pjHPWaBbQiz7oDQiNNVQ=;
        b=nESoJDJQAivPsXQG5p/hv4CB3+x9DxYVGfs1bqV0jhCICwh7+226JF4DVHFqlUQlWD
         eGis8Za79i8xkhNYOy8oVkI7qWz0PXXBOPJuhzfv/RBJsccFjoyKHKS80E3MLs0L9dxN
         2SILnNwvaJGC5BajkiyGNQOPUy2TVzQmbvgVn/k1Ulyf7VTqn3sG8rM5vcwGzm2tHjtW
         WNLJpTEUvsDCn9S63/r1PL4PcVijohl7uKpIcJeE3poxZGCLyeEp/JA+Amcwg4BJRK2V
         eYP1kvbLO59xjQyTRC8CA3Jfp3ffvroniehm7ccNj5pt4o9AbiRCq/RxwK/sjP+yz/co
         c46Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=npaJxZXhhR2DqOaeZZ+R6c0pjHPWaBbQiz7oDQiNNVQ=;
        b=nb88s9HDecNR2yd4VUFGUwnyswKYCe6HyZ7qPS2Ggalmvsiy3jY1mGBjpvT78VCLB/
         9I2+geRNWvUwk5siHEcwpzNboRczeiI3LaUO6prt6xXoOmo63Ym5mJ777BZwdxbfypne
         Z7NS50OVy+AC+LLaTayML02FHyyysbLt53EZryKUBWoSqYr+MXjMmqqZXEwWNKc4+ehF
         xny2eSo8/DNxzg8GFEORZCU6z/K9wAV9cwgApp4DZYhjJIs1QNlhedq2y+x/Cf3Pucc6
         7AFNMPd7rwfw7FqiVaJHhO6rYo4mIUj9PSSlxUq5EPVEpiUyXeImAfBvfo+Tmr5jl5m4
         qj7A==
X-Gm-Message-State: APjAAAV6O3sg4CfrJZrS+L/+TYKOYnwBrlZ12otnv2VCykTBgJkNNWXQ
        0eT4fZc8y2q9m7g3TGYfPjw=
X-Google-Smtp-Source: APXvYqwMMKj/QZC3hfXvu7VM/uBwNiZh1knGJemh+TOn91SbnNPrxylDkNElzIgjn7AJ1W12iY8Oew==
X-Received: by 2002:a17:90a:2008:: with SMTP id n8mr57870571pjc.4.1563553783705;
        Fri, 19 Jul 2019 09:29:43 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p27sm48903445pfq.136.2019.07.19.09.29.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 09:29:43 -0700 (PDT)
Date:   Fri, 19 Jul 2019 09:29:36 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, dcbw@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 2/7] net: introduce name_node struct to be
 used in hashlist
Message-ID: <20190719092936.60c2d925@hermes.lan>
In-Reply-To: <20190719110029.29466-3-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
        <20190719110029.29466-3-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jul 2019 13:00:24 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/linux/netdevice.h | 10 +++-
>  net/core/dev.c            | 96 +++++++++++++++++++++++++++++++--------
>  2 files changed, 86 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 88292953aa6f..74f99f127b0e 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -918,6 +918,12 @@ struct dev_ifalias {
>  struct devlink;
>  struct tlsdev_ops;
>  
> +struct netdev_name_node {
> +	struct hlist_node hlist;
> +	struct net_device *dev;
> +	char *name

You probably can make this const char *

Do you want to add __rcu to this list?
