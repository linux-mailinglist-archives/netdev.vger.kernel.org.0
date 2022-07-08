Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEB256AFB3
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbiGHBAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236735AbiGHBAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:00:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E105183A3;
        Thu,  7 Jul 2022 18:00:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DBC361721;
        Fri,  8 Jul 2022 01:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39325C3411E;
        Fri,  8 Jul 2022 01:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657242035;
        bh=70o+V3ET76drXM83rOdHEUsJuE2jU9gz82CTfzhNP0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jkUoycSRQnG2Kh4/DvYw/ce+0v3+iNaW8HRBzoeSHYwm1RYucKZ+ua6u4dXGjwTlr
         N5QDKSvQp6sHnUky/qoZPZSc5HAOGW7dOQ1TomiH/VjTogx/SdP14x+HBv39VgFzqb
         /r0TSeUTNMUo3nM4JAOhRo8M0Pba0pt0p/CohpCNxX22CQKUk9qc7U06rC1ctRw63I
         tTyaoNhBA9FFU+KaMOM0TE7IKo2fZ7qMOSlMNLWPNM2feeVhgVZpkmFS+nEWr/bOKB
         7LArADuTVJJxzG+/4Cu/N6foNVlAKq4B5Il6lXh354DLiCM9OC0mdpPMnJ+b86s6qo
         HUsAIqvrKEphg==
Date:   Thu, 7 Jul 2022 18:00:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/6] Extend locked port feature with FDB
 locked flag (MAC-Auth/MAB)
Message-ID: <20220707180025.42cc41d8@kernel.org>
In-Reply-To: <20220707152930.1789437-1-netdev@kapio-technology.com>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jul 2022 17:29:24 +0200 Hans Schultz wrote:
>  [PATCH v4 net-next 0/6] Extend locked port feature with FDB locked flag (MAC-Auth/MAB)

Let's give it a day or two for feedback but the series does not apply
cleanly to net-next so a rebase & repost will be needed even if it's
otherwise perfect.
