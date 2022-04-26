Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DBC50FCFD
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 14:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345419AbiDZMbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 08:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349943AbiDZMbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 08:31:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AC969CCC
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 05:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=oZJisKJ/2B7D/hmGjA7F8LXAu50UlJNDfPFwDTg8tbY=; b=wzPSdlB8996D05rXtgAO6Qztoz
        kprwJ6Xpz9L5i42VV+E5ehtI0b8ZNvCIqUjwlzAgzTfehnvc+53Jyfe4ut3MMRLvnu9q7laNEHNZG
        RKqbmKa+fApkHwB4BXOp95mu8IO16/faNCupnHnCEZswkSxQJHcOopf4cCE3s70WDsPM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njKIM-00HY3O-Vy; Tue, 26 Apr 2022 14:27:54 +0200
Date:   Tue, 26 Apr 2022 14:27:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YmflStBQCrzP8E6t@lunn.ch>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <YmeViVZ1XhCBCFLN@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmeViVZ1XhCBCFLN@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It is not a separate devlink device, not removetely. A devlink device is
> attached to some bus on the host, it contains entities like netdevices,
> etc.
> 
> Line card devices, on contrary, are accessible over ASIC FW interface,
> they reside on line cards. ASIC FW is using build-in SDK to communicate
> with them. There is really nothing to expose, except for the face they
> are there, with some FW version and later on (follow-up patchset) to be
> able to flash FW on them.

But isn't this just an implementation detail?

Say the flash was directly accessible to the host? It is just another
mtd devices? The gearbox is just another bunch of MMIO registers. You
can access the SFP socket via a host i2c bus, etc. More of a SoC like
implementation, which the enterprise routers are like.

This is a completely different set of implementation details, but i
still have the same basic building blocks. Should it look the same,
and the implementation details are hidden, or do you want to expose
your implementation details?

	Andrew
