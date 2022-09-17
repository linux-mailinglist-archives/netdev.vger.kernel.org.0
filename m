Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BA05BB9D1
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 20:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiIQSEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 14:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiIQSEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 14:04:15 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EE72B250
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 11:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=W4jDjc74F1GvNI7LC5LjxqRCSTiRDGnvkTRAQGket3o=; b=MI49MrL5B++joLMwljld4ffsQg
        H/g0tVJJlz+9fkfD2x9jLbNTg6PkiVXlNyT8h3Id5unWNL3tmAcWpj7w4eluBu391rF97jcETXlDZ
        v92QbCmxLN9G1+pL8O7UsSot+PhLpFiw3lg/leewn1Z0DUAQxpE0bBzRa860dC1SF5kM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oZcAm-00GzzP-Ut; Sat, 17 Sep 2022 20:04:12 +0200
Date:   Sat, 17 Sep 2022 20:04:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        ansuelsmth@gmail.com
Subject: Re: [PATCH net-next v13 4/6] net: dsa: mv88e6xxxx: Add RMU
 functionality.
Message-ID: <YyYMHCbad0jqNB0b@lunn.ch>
References: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
 <20220916121817.4061532-5-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916121817.4061532-5-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline bool mv88e6xxx_rmu_available(struct mv88e6xxx_chip *chip)
> +{
> +	return chip->rmu.master_netdev ? 1 : 0;
> +}

I don't think this is needed any more?

  Andrew
