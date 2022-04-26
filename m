Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5848F50FF70
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240427AbiDZNtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 09:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351169AbiDZNtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 09:49:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF1F1CB28
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 06:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xQLuVgQYdDuWyhv+8aLaAXaQS6tJLEUErxk4FBGvAqk=; b=0TiPF6h8C4xoI5wP8zFAMk/gFS
        EEdnjoy6qP5CKSCMSALTiLCI1eTlCfb8LDM/H1Tu2/tbNzDw0qowqoL3xCAAEfDFY/Mg0WmThLDWf
        p+zPQcFd1tdo82uPAGjlF3FqmGllcv+KcWun3euRCtXurflyqZzAnNaHdukuY2Gss2tw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njLVk-00HYls-1R; Tue, 26 Apr 2022 15:45:48 +0200
Date:   Tue, 26 Apr 2022 15:45:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <Ymf3jKNeyuYHzsBC@lunn.ch>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <YmeViVZ1XhCBCFLN@nanopsycho>
 <YmflStBQCrzP8E6t@lunn.ch>
 <YmfoXsw+o9LE9dF3@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmfoXsw+o9LE9dF3@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Well, I got your point. If the HW would be designed in the way the
> building blocks are exposed to the host, that would work. However, that
> is not the case here, unfortunatelly.

I'm with Jakub. It is the uAPI which matters here. It should look the
same for a SoC style enterprise router and your discombobulated TOR
router. How you talk to the different building blocks is an
implementation detail.

	Andrew
