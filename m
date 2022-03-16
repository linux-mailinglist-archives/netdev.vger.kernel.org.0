Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8474DB92B
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242982AbiCPUIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357920AbiCPUH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:07:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F816E2B7
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:06:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D477161146
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66B7C340E9;
        Wed, 16 Mar 2022 20:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647461203;
        bh=blTMG73fDZVAA/WHDOCvuGoWiiI/nrDifyE0a/kd2qE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ML3hwPoJtenvqNr5itTJ8QomYzXhlytCK2cbL9awRcOtY70S5DY6mMBRGPrIBcDsz
         KWtpaCGqU+PPhPY7b8ezJ/RMCS0YMOV0NqmWRX7VrmMan2gZ4Crfr0LGJJp54uCYJO
         WF5pdV8knOUcw8IjGK2GgaZpzL1HCNipUFisYjHvqR8CJtm0ddZGCUbRYxi9wDNezY
         aMFkpr7jtx1kjKgfPI+deyUZCvu8Z3lSwIrmcZCeMBRit8PtydpL8h7X3mFHFCI2bV
         MreowffWNyIMN80eNIS6ANGzKnpm8pdgUJT5Jf0Oz5I7MMO0fzo0KeuGJEUzXLA0ZA
         dNkb+T8Oul6pg==
Date:   Wed, 16 Mar 2022 13:06:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>
Subject: Re: [PATCH v2 net-next 2/5] net: bridge: Implement bridge flood
 flag
Message-ID: <20220316130641.7f401711@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220316153059.2503153-3-mattias.forsblad+netdev@gmail.com>
References: <20220316153059.2503153-1-mattias.forsblad+netdev@gmail.com>
        <20220316153059.2503153-3-mattias.forsblad+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 16:30:56 +0100 Mattias Forsblad wrote:
> This patch implements the bridge flood flags. There are three different
> flags matching unicast, multicast and broadcast. When the corresponding
> flag is cleared packets received on bridge ports will not be flooded
> towards the bridge.
> This makes is possible to only forward selected traffic between the
> port members of the bridge.

net/bridge/br.c: In function =E2=80=98br_flood_toggle=E2=80=99:
net/bridge/br.c:347:33: warning: unused variable =E2=80=98bm=E2=80=99 [-Wun=
used-variable]
  347 |         struct br_boolopt_multi bm;
      |                                 ^~
