Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7910F13B015
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgANQya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:54:30 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37515 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbgANQy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:54:29 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so14577298wmf.2
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=edPnPB8C8Ktc3G7J2d1DSKckT4XxVvXzRg7KsA8hW3Q=;
        b=bB49UBIJMaoYi4wDBDKKqKpebTAUbZTw09KderopmK+8Fb0QYepTctwTPNR/6dCEdw
         DmZjHHzVymnrBpeaFU8RXSZympxCWjswTWr0gJ4x14iGBNgtLT5JWjpd5mO5KYLhiepu
         Fr+Dhhrs5izAELx5lv3b2qMcjG9hYUv+Om8CDBsqp0ZKTF4jazrh+IgjkvPaSPeqwkVJ
         vlTiCqv1HtjeJwjG+NXnXVkFZkjBR3nE30CYnE3t3uWNCOjU/3LQxL+MvHcTIOiJic8t
         N/N9l6OQ6LreSj1Hv+8K9z1vBHglQ5EEbeJC8xOdfHY1hV9mM7egzicTHpiqkyxIBK8Z
         E6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=edPnPB8C8Ktc3G7J2d1DSKckT4XxVvXzRg7KsA8hW3Q=;
        b=cQAQnwKy/l/fqYwOfm42Xt9VwNkq2a6lYq9mBBMwQPvUISQsSCGz2NhQ9HxVpneEIH
         RgJkCcoCjKCWdidMweibPMH7AzwZhN3PCUBTR10+38931RuMncY3efkz/20vre4SkLXE
         XF1nHZFT4Lbqyp05qb2+MCsHiG7sJqxby/ll1K/0z4srWtZy/i4SLvl3V8F+jub6ECGX
         D0pjncNvaPmt7Ug50AhiDoTnCAEX1ls+beeDwOupSeFir1+ebBklXvIM5exTPVGZxOrS
         M4IRNNmHkRnUxYgor4pRbza1d5TcoMe5HrkICPuE7dEZzbmR0aeZVnWJvI5ZfQ1Ter9P
         T8sw==
X-Gm-Message-State: APjAAAXeoTx+Vh/rdom66Wiw4J2HXCz2wzSgsOw2lQ16IFTReYlqeK8I
        MVA7pHNWCog/EZugpj6UA2EJPg==
X-Google-Smtp-Source: APXvYqygQZ12hVo7a0h1Du4OBfbasczmdBTH9qqxDBaCY1uBxKhNID6wi4WhQ1rBxjHil9RpyzcmrA==
X-Received: by 2002:a1c:5f06:: with SMTP id t6mr28560142wmb.32.1579020867896;
        Tue, 14 Jan 2020 08:54:27 -0800 (PST)
Received: from localhost (ip-78-102-249-43.net.upcbroadband.cz. [78.102.249.43])
        by smtp.gmail.com with ESMTPSA id t5sm20133520wrr.35.2020.01.14.08.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 08:54:27 -0800 (PST)
Date:   Tue, 14 Jan 2020 17:54:26 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 07/10] netdevsim: fib: Add dummy
 implementation for FIB offload
Message-ID: <20200114165426.GQ2131@nanopsycho>
References: <20200114112318.876378-1-idosch@idosch.org>
 <20200114112318.876378-8-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114112318.876378-8-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 14, 2020 at 12:23:15PM CET, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>Implement dummy IPv4 and IPv6 FIB "offload" in the driver by storing
>currently "programmed" routes in a hash table. Each route in the hash
>table is marked with "trap" indication. The indication is cleared when
>the route is replaced or when the netdevsim instance is deleted.
>
>This will later allow us to test the route offload API on top of
>netdevsim.
>
>v2:
>* Convert to new fib_alias_hw_flags_set() interface
>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
