Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04564DEA3A
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 20:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243948AbiCSTB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 15:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243950AbiCSTBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 15:01:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D8452E66;
        Sat, 19 Mar 2022 12:00:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EA48B80DB0;
        Sat, 19 Mar 2022 19:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F87C340F0;
        Sat, 19 Mar 2022 19:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647716430;
        bh=Wohgj1k+iPo/OG15eMtdqemqDsjWYgkXISOxUJl2ybQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YOZTtRqBg7wEYpBXOPT8Lpiv6nNLzBRH2bQhtpqI9y4Za3T9ADhfhFGJIWOLRNSCq
         B25VkmhYkDoMBIIUYIl7iByK9Yv14TRoTnzeflm3cqLy9rzXN/lleasvqMue65RQCi
         yuuP5zFi04ghA9QMTFJZAJAbEMqQ5Sb9q8I3wsGZwZh0/B6TGOWis+g89b3FeqbOHA
         +9qLUAkBO0k/2bsYdS8gj/tazSXDi1SoWZkMnfPggT2b1ERsjCvByxRZSbKfxlGIfE
         Yl9bw8AcF3ZcTYpvDmC2d8fZHA/oJRqyR9n15QgsUJV9vdE1XxpoILf4bvBv1tYPx5
         yCZzTjYqQHiag==
Date:   Sat, 19 Mar 2022 20:00:25 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Ensure STU support in
 VLAN MSTI callback
Message-ID: <20220319200025.5833b2ba@thinkpad>
In-Reply-To: <20220318201321.4010543-3-tobias@waldekranz.com>
References: <20220318201321.4010543-1-tobias@waldekranz.com>
        <20220318201321.4010543-3-tobias@waldekranz.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
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

On Fri, 18 Mar 2022 21:13:21 +0100
Tobias Waldekranz <tobias@waldekranz.com> wrote:

> In the same way that we check for STU support in the MST state
> callback, we should also verify it before trying to change a VLANs
> MSTI membership.
>=20
> Fixes: acaf4d2e36b3 ("net: dsa: mv88e6xxx: MST Offloading")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Tested-by: Marek Beh=C3=BAn <kabel@kernel.org>
