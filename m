Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBBB68D54E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 12:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjBGLUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 06:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjBGLUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 06:20:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06FBEFAA
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 03:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54163611B5
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 11:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225E5C433D2;
        Tue,  7 Feb 2023 11:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675768813;
        bh=6f3B48rxmBQjdRWhohv4VFKJPegEtPUeHZvgP80nCeg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M5QmM7O0O0esedqalWyLlFR3hQl6ia6SGe72stnwL6n7iqwmgN35D0ul1EyCeGnS2
         8TCxipSWSl+0D687TcK9FlBSC9pxuiZC6ERD7EV2B/gqprZxLGZ0jAPtMITYMdPLWG
         9c4P9r8hrJsUbJuj3Es48TXXlHWFiSO/bzxowJDarLQohS52YsVQnDNrtyZt4cF2gr
         p//VZQnLd1i+00whdGxTafsB95SdlPUKuSMGYUhTmbM5BNVg5h9Rm31r59kzgb1n3z
         YqJE/24yxIoTk+e/po+UdX6JWMa4BkQjGGbJFvEEvbAhLdogQ0ZIErdghQccgQovAd
         s4phmzNerUNeQ==
Date:   Tue, 7 Feb 2023 13:20:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     b.a.t.m.a.n@lists.open-mesh.org, Jiri Pirko <jiri@resnulli.us>,
        Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
Message-ID: <Y+Iz6dYsiwXnPCUw@unreal>
References: <20230127102133.700173-1-sw@simonwunderlich.de>
 <4503106.V25eIC5XRa@ripper>
 <Y+Iq8dv0QZGebBFU@unreal>
 <3940036.VdNmn5OnKV@ripper>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3940036.VdNmn5OnKV@ripper>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 11:57:41AM +0100, Sven Eckelmann wrote:
> On Tuesday, 7 February 2023 11:41:53 CET Leon Romanovsky wrote:
> > Once you stop to update version, you will push users to look on the real
> > version (kernel) which really matters.
> 
> I would have understood if you say "let us use a magic value like 'in-tree' or 
> 'linux'" but setting it to an old (existing) version number - I don't want to 
> live with the headaches it creates. Because this is what users often don't 
> (want) to understand: if it looks like a valid version number, why isn't it 
> the valid version number? So I have to do a lot of pushing - without any 
> rewards because it is necessary to push every new "user".

I'm not sharing your view about users and think they need to be educated,
even it is hard and non-rewarding job.

Thanks

> 
> Kind regards,
> 	Sven


