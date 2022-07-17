Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8D9577722
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 17:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiGQPqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 11:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiGQPqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 11:46:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6809D96
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 08:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=K1sftOS1nhzbX6YbNI1mmHbKZdV2JaRZ4hY8yhCDZ1A=; b=SzsckxNbdR4r0bdYVP2FsEG9KP
        O3TatsXdZ3U/QbGkCb4XSHhs0Supt4X0TIkYSiF7zJYmN2QBZ6ezK1iZdcNe5lWqZjxDpX40rxAZB
        PY8aXWOvmpj/RxRBpSWvgyJqGlWIKk4A81Sy1l2jQrx5YUgzN2uSgeJSun4V7P9CXUd4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oD6TS-00Ad7q-A1; Sun, 17 Jul 2022 17:46:26 +0200
Date:   Sun, 17 Jul 2022 17:46:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net 12/15] docs: net: dsa: add a section for address
 databases
Message-ID: <YtQu0kx/qaynrD6R@lunn.ch>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-13-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716185344.1212091-13-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 09:53:41PM +0300, Vladimir Oltean wrote:
> The given definition for what VID 0 represents in the current
> port_fdb_add and port_mdb_add is blatantly wrong. Delete it and explain
> the concepts surrounding DSA's understanding of FDB isolation.
> 
> Fixes: c26933639b54 ("net: dsa: request drivers to perform FDB isolation")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
