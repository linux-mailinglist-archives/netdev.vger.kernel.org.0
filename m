Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62614B1C1E
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 03:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347247AbiBKCU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 21:20:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238163AbiBKCU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 21:20:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B59B30;
        Thu, 10 Feb 2022 18:20:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55DF060F95;
        Fri, 11 Feb 2022 02:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42180C004E1;
        Fri, 11 Feb 2022 02:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644546057;
        bh=+FnvOS9moFd3rgdNWficw5UDXxuDO088ELw6a4A8IrE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hbXxrU39WoVx22J2ACoBBqN0D4fNQlo5THbYeZchIBsfxvhO8rp8l3csOX2QYlrrQ
         Cs+y5Ijn0ZAKjjnHKElDvvLZD1vdPDt3Pvaz8MZgQFRaU1YhTUwzkQ/xobsqTqk1Kj
         3OlCci0KlBM1wRqqop6IOHUiARs0mEvwZYZORICTIsvRu/4eA54TTvVXDrR1X3sH6m
         RB+9pF1PDQX5WH63N7okw8XPRoOzY4jwYrAfjyYrBW8GAxk9MOj/4INu674beYQ+sb
         W4bpasyzBkzhUOTjy9TlQ5orNUEFYXZJdWz21SmJ330s1wuY4PoeH+cd3XOu/VJqk4
         JtApKqhozjknA==
Date:   Thu, 10 Feb 2022 18:20:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gatis Peisenieks <gatis@mikrotik.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, hkallweit1@gmail.com,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, antons@mikrotik.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] atl1c: fix tx timeout after link flap on Mikrotik
 10/25G NIC
Message-ID: <20220210182056.0a990e67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220210081201.4184834-1-gatis@mikrotik.com>
References: <20220210081201.4184834-1-gatis@mikrotik.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 10:12:01 +0200 Gatis Peisenieks wrote:
> If NIC had packets in tx queue at the moment link down event
> happened, it could result in tx timeout when link got back up.
> 
> Since device has more than one tx queue we need to reset them
> accordingly.
> 
> Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>

Fixes: 057f4af2b171 ("atl1c: add 4 RX/TX queue support for Mikrotik 10/25G NIC")

?
