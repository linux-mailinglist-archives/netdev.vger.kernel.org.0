Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD98F5F0EAE
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 17:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiI3PTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 11:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiI3PTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 11:19:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6AE15D981
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 08:19:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5099A62393
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 15:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C74C433B5;
        Fri, 30 Sep 2022 15:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664551140;
        bh=PQdOm9OXxxOtiMHQCADH0GQqPKkZ3cX9rxS541ZZi4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MV6MsdJ+5MoYaVLPu4FxweoWochAM+rSs+6/ev+/fsp1Ht6z9fMjAoGQgoKgOhlZW
         jQU4ch7Iz0q+OHiMGALXGajiEKD5Nk3wezsfZ82Ou9evcepPhaGsC4KG15iNWIc67l
         beAjEeRgDjpX8wAdH73+E4EiYWipVSJi0Dlfu7PaLAVQT+qNuQ0yGF5F1f9Uc8lkux
         WNvTwsYkcW+Kwkh2v1Qo5cKHDGdaHYwQKDw2AsvMI7oVsezygtROXCEsnErI1Ylf/9
         tmMl56vFEH6cCMaVKFR+fyAGdIOfpI5x7WAdjtql1iULJ5JXVLNlHV2/JqyzulyFfu
         qa3yDXQCjdBzQ==
Date:   Fri, 30 Sep 2022 08:18:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv5 net-next 2/4] net: add new helper
 unregister_netdevice_many_notify
Message-ID: <20220930081859.5f1e4ad3@kernel.org>
In-Reply-To: <20220930142910.GB10057@localhost.localdomain>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
        <20220930094506.712538-3-liuhangbin@gmail.com>
        <aae1926b-fbc3-41ff-aa80-a1196599eacb@6wind.com>
        <20220930142910.GB10057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 16:29:10 +0200 Guillaume Nault wrote:
> Declaring it in net/core/dev.h should be enough.

Yes, please. And while you're touching __dev_notify_flags()
its declaration can be moved to dev.h, too.
