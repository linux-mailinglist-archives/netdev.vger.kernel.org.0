Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA3F4AD9BA
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349947AbiBHNZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349943AbiBHNX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:23:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20116C02B5DB
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 05:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jRudipyE10dcGn/aOb1fArEYEocq3GAC+ldhyHz4Eo0=; b=iQHlvyHCUIDcTst7MUmoePhuCI
        WB1m8u0Z33BIqDZ+Y780zpacShHdLQ9r9WVXc9bH25e4j1xmlJXczb87xS1r30vS0VJQdq5dY5eOc
        8Q5hezFGLFo4ukSR8x3FhBWMn72vS6M1DwLBVi6ECLgZ0Hiz8eRzf1Zzl2PQJgj9biJw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHQNz-004rW7-NK; Tue, 08 Feb 2022 14:18:23 +0100
Date:   Tue, 8 Feb 2022 14:18:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, trivial@kernel.org
Subject: Re: [PATCH net-next] net: dsa: typo in comment
Message-ID: <YgJtnwhd2k4HrgxZ@lunn.ch>
References: <20220208053210.14831-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208053210.14831-1-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 02:32:10AM -0300, Luiz Angelo Daros de Luca wrote:
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
