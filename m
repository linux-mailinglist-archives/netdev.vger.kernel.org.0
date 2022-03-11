Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98FE14D59B6
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346349AbiCKEl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbiCKEl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:41:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945BD1A8070;
        Thu, 10 Mar 2022 20:40:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FEC4B82A77;
        Fri, 11 Mar 2022 04:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89448C340EC;
        Fri, 11 Mar 2022 04:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646973652;
        bh=IRqFVrpyUqt1gWh3UlejHjKKJ5lWo3XyNfF+ss8+feQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vJDhLDo3FNR21w4iHUox8q/APrfcRVEb5nH+UN4+VzcaO9RYqiOGt3vqla7yXSgIn
         7FvXJqOBccD+qOuDUM6nlE1PKFuwjSNhMuvsMNDeobgy6MLDjW18Lar0vWFESqlDgo
         uwe19sOWTWVuJC9DpnSWz/MlFKHk9QBh0sNZEJQ0BNEDdH3ne08Pt1rITBTdtXGZJE
         3gsm0lbovQuvU3nQC/TcEy8igB8z7KLNJGRvhA4jyZNOyz/fw3vnj+61PZ5+J4M253
         KATIwgsADjxt8yOQnW8ny+gsznhANiy/3BDrpXr1SYIfbqlRqqIoTjZMDeIoppTDjG
         N7S7eMMVQitYw==
Date:   Thu, 10 Mar 2022 20:40:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        ralf@linux-mips.org, jreuter@yaina.de
Subject: Re: [PATCH V2] ax25: Fix NULL pointer dereferences in ax25 timers
Message-ID: <20220310204051.44c9555d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310144347.102465-1-duoming@zju.edu.cn>
References: <20220310144347.102465-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 22:43:47 +0800 Duoming Zhou wrote:
> There are race conditions that may lead to null pointer dereferences in
> ax25_heartbeat_expiry(), ax25_t1timer_expiry(), ax25_t2timer_expiry(),
> ax25_t3timer_expiry() and ax25_idletimer_expiry(), when we use
> ax25_kill_by_device() to detach the ax25 device.

None of your last 4 patches applied to our trees.

If you're sending fixes for networking please base them on 
net/master and put [PATCH net] in the subject.
