Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69894DEA39
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 20:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239554AbiCSTBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 15:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiCSTBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 15:01:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8BA63A8;
        Sat, 19 Mar 2022 12:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEDA3B80DB0;
        Sat, 19 Mar 2022 19:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E319C340EC;
        Sat, 19 Mar 2022 19:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647716419;
        bh=rK/W7B6qA6hkhXjceaXoygpGi+oPM9cFjZ5zUmzJixg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cZb64MjVoSPUFbV5un7aViSNZcEhQ2NKsR/wZVTs07irHDafwATv8LUpcUEm0zQpP
         BdfXcelt1rFK2V6VUuHLjbgAv4i/IDyflupeHbbU+M4rcrIB72LE07Doi0T+BmB+ug
         nmiYaK1sjgueu3ojl+Uj3RPvVyYZ9ng4VeVkMDIjlUt0v8pZnNWo1ya/hqrKOhL6HT
         6BR5YdymmqfNuN7TLMOYtNhuF2btkYoOKM281pXyXy8QQFKivcYQCaykG/NBysApeT
         2NbhyBa/bVAVNMvX7Aox45dd5FEY4uDF9X23mySjckfDNIEpdo2iB8gYAgFUoj40hq
         lwS5Tdbxdyj6w==
Date:   Sat, 19 Mar 2022 20:00:13 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Require ops be
 implemented to claim STU support
Message-ID: <20220319200013.7fcdf637@thinkpad>
In-Reply-To: <20220318201321.4010543-2-tobias@waldekranz.com>
References: <20220318201321.4010543-1-tobias@waldekranz.com>
        <20220318201321.4010543-2-tobias@waldekranz.com>
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

On Fri, 18 Mar 2022 21:13:20 +0100
Tobias Waldekranz <tobias@waldekranz.com> wrote:

> Simply having a physical STU table in the device doesn't do us any
> good if there's no implementation of the relevant ops to access that
> table. So ensure that chips that claim STU support can also talk to
> the hardware.
>=20
> This fixes an issue where chips that had a their ->info->max_sid
> set (due to their family membership), but no implementation (due to
> their chip-specific ops struct) would fail to probe.
>=20
> Fixes: 49c98c1dc7d9 ("net: dsa: mv88e6xxx: Disentangle STU from VTU")
> Reported-by: Marek Beh=C3=BAn <kabel@kernel.org>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Tested-by: Marek Beh=C3=BAn <kabel@kernel.org>
