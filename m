Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE45863B5D8
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiK1X3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiK1X3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:29:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E40303FD
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kC6pnBWOGreiyjfkHaB8DmewKznLzGQDHHEYlft9qEY=; b=mld/RygIdFIktFYpfgzY/sxnJZ
        K97NzztHKPhQWjRhfCcChYNyIpGeQmLob2BtDfGyRJppvznwX4jw2u5pAqL7GdmUnXGwPQrI0LQy/
        4KQkJM3ZpUbQp/3h0m+xef309/UEva1PefEdym7N+PG4K/C9VvRkGnzMgJP81LCJRC2s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oznZG-003o3J-Bs; Tue, 29 Nov 2022 00:29:42 +0100
Date:   Tue, 29 Nov 2022 00:29:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
Subject: Re: [RFC PATCH net-next 10/19] pds_core: devlink params for enabling
 VIF support
Message-ID: <Y4VEZj7KQG+zSjlh@lunn.ch>
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-11-snelson@pensando.io>
 <20221128102953.2a61e246@kernel.org>
 <f7457718-cff6-e5e1-242e-89b0e118ec3f@amd.com>
 <Y4U8wIXSM2kESQIr@lunn.ch>
 <43eebffe-7ac1-6311-6973-c7a53935e42d@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43eebffe-7ac1-6311-6973-c7a53935e42d@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I know we are running short of short acronyms and we have to recycle
> > them, rfc5513 and all, so could you actually use
> > DEVLINK_PARAM_GENERIC_ID_ENABLE_LIST_MANAGER making it clear your
> > Smart NIC is running majordomo and will soon replace vger.
> > 
> >        Andrew
> 
> Oh, hush, someone might hear you speak of our plan to take over the email
> world!

It seems like something a Smart NIC would be ideal to do. Here is an
email body and 10,000 email addresses i recently acquired, go send
spam to them at line rate.

> How about:
> 	DEVLINK_PARAM_GENERIC_ID_ENABLE_LIVE_MIGRATION

Much better.

     Andrew
