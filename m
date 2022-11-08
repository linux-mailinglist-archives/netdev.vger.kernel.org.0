Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A65D621361
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbiKHNtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234610AbiKHNtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:49:46 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D5863F0
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OWDX5nVv0o64TZYWhAgdGGW/lsCctvyDKVYfZPgJQwU=; b=FjENQv316Spet2dqzpEep/5PkM
        VwrzU4EN+0yfkxWm0ji/CEFoqPDzGMItnxGtBpGTYLjS4toMXie8lFILLjtRAoY6wYgLS2znNcK3C
        qgFtuuG19FfBorGvX0YODaoaJuKCx5PbNJFgshAaiLi1/9uRzeobwtJBRMRbxMAx9BTo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osOyv-001p7e-UV; Tue, 08 Nov 2022 14:49:37 +0100
Date:   Tue, 8 Nov 2022 14:49:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 7/9] net: dsa: mv88e6071: Define max frame size (2048
 bytes)
Message-ID: <Y2pecZmradpWbtOn@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-8-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108082330.2086671-8-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 09:23:28AM +0100, Lukasz Majewski wrote:
> Accroding to the documentation - the mv88e6071 can support
> frame size up to 2048 bytes.

Since the mv88e6020 is in the same family, it probably is the same?
And what about the mv88e66220?

    Andrew
