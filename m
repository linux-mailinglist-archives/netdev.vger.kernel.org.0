Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13AD85FDCD3
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiJMPFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiJMPFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:05:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58AD753A4;
        Thu, 13 Oct 2022 08:05:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72E5961812;
        Thu, 13 Oct 2022 15:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0933C433D7;
        Thu, 13 Oct 2022 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665673518;
        bh=O2g2R3Ut6pdJ+MDwDDSWp9uA8764zR/Z3dNPciPabuY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FjJq/xxQDAsZkYynj+yJJ4ZueU3IwZxchEgxgGxGEX+He7k8yezJ4UYgaGQhnlRAr
         PwTDpPqlBRwPWNyjglmeIYjZ2jY+Oao4k6hhxOzGKwH8mOAzN1XCMxb0iv3Wmx5eYD
         hoSVmSfmGGOPGEsRu5FogDjJIYBKFS/MM2dVMVvOSv1GJqYhT4wi2EJ2bsU/Y8hUSG
         z1zryNQM5FmjksJOtrfZvGc4EqSoID1bcZApwNcH+bRzkhLuWeGJems/GzGob3Yxlb
         zgPLvK3GTy69BtGYf06u4sn10Yny7+rnFLIGkRWHDy6U6DDSx922L7cTjA7nL4Vid1
         qKfHEEHEVHiLw==
Date:   Thu, 13 Oct 2022 08:05:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@kernel.org>, bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
Message-ID: <20221013080517.621b8d83@kernel.org>
In-Reply-To: <Yz3kHX4hh8soRjGE@krava>
References: <20221003190545.6b7c7aba@kernel.org>
        <20221003214941.6f6ea10d@kernel.org>
        <YzvV0CFSi9KvXVlG@krava>
        <20221004072522.319cd826@kernel.org>
        <Yz1SSlzZQhVtl1oS@krava>
        <20221005084442.48cb27f1@kernel.org>
        <20221005091801.38cc8732@kernel.org>
        <Yz3kHX4hh8soRjGE@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Oct 2022 22:07:57 +0200 Jiri Olsa wrote:
> > Yeah, it's there on linux-next, too.
> > 
> > Let me grab a fresh VM and try there. Maybe it's my system. Somehow.  
> 
> ok, I will look around what's the way to install that centos 8 thing

Any luck?
