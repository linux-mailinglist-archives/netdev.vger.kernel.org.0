Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B88B626C0
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391616AbfGHQ6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:58:37 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33775 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGHQ6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:58:37 -0400
Received: by mail-qk1-f194.google.com with SMTP id r6so13878477qkc.0
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5Ebyoxq/yn+DRjEU74h3naMVVQ17vsFmrjVrB5vr7B8=;
        b=XcgeHnse3Si2wTlq+Rk3mfqIfyHt8lSo9WF3Ye21psC0X/7EtD5+fISJKFaCIrRXrZ
         w0bkWGw88++TnELZn3XBIQzzxeGJUZXGAh8r4AaQ/QJUzYX1r8oidbPjIWIMneQCV2KF
         flkRHhksUGDzwGFhv51tjd8chtsT9+ki1yC/tNV469Hr9qKcmv6tQG8sC1/JUVV8MUuZ
         u3J4gQd77DyRHuuE2XvRnZ5FVqW6FVIuuIw9k47ZzWQP9oMTzke0pzlKhKVPMs20EQy7
         NqhOj4Zsrcj7gSUj7A9bfNrYgNfKPPRZthnwhCehMQ0y6lwKuzbhjJFIJXJQvYY4SLLr
         i03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5Ebyoxq/yn+DRjEU74h3naMVVQ17vsFmrjVrB5vr7B8=;
        b=Kv4yiChNNvi2iV+kTS2OSvTNoskruwmcTIpj//BiRwbv6M5XpL5K2cGp0qXh6B9WuF
         mZSMBlVXDXvF+kbArBGuQqmVNwSkCwA6lrfMesEhHcIyUAKv0tk2r5blGa+tDKaXBZT9
         sv7HvybU1Bqws0TiIuelxxhjALSLC0D7NAviiPwg2yt2CjW42Yj10lAj464Wtm8DKCmP
         xn6OX6LAlV8j+34KYusbHjJUbpvj+gdEgWWuaY6nIMHjdLzA9cHJ3igplO8syPMHhSG1
         Qpho1ld+usQu/YoF4jWszR7bJyWUt5BWeQFDdlPoDtsT2RFWA3ionxBo8oJ5tMG1ahkf
         rdpA==
X-Gm-Message-State: APjAAAUOoR3OxTLpRaOAJuLTOvT8wedRJO2DNYflcsKaOpMhkr8EZP++
        f5+fJ4HQYd97JVrfz31yKrWr0W+l7YU4mQ==
X-Google-Smtp-Source: APXvYqwiVoKd8WgJppn59ELRHUHd8xrASKJL6VpsuG0lJoacQvAmtko2SeJ4vsGbFTqzqjUWBf8OwQ==
X-Received: by 2002:a05:620a:1107:: with SMTP id o7mr13470563qkk.324.1562605116461;
        Mon, 08 Jul 2019 09:58:36 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id h26sm8781298qta.58.2019.07.08.09.58.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Jul 2019 09:58:35 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hkWyJ-0004vs-F8; Mon, 08 Jul 2019 13:58:35 -0300
Date:   Mon, 8 Jul 2019 13:58:35 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/2] DEVX VHCA tunnel support
Message-ID: <20190708165835.GA18937@ziepe.ca>
References: <20190701181402.25286-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701181402.25286-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 09:14:00PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> Those two patches introduce VHCA tunnel mechanism to DEVX interface
> needed for Bluefield SOC. See extensive commit messages for more
> information.
> 
> Thanks
> 
> Max Gurtovoy (2):
>   net/mlx5: Introduce VHCA tunnel device capability
>   IB/mlx5: Implement VHCA tunnel mechanism in DEVX

Thanks, applied to for-next

Jason
