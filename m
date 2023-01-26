Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0DCE67C487
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 07:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjAZGoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 01:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjAZGoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 01:44:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B9D3CE01;
        Wed, 25 Jan 2023 22:44:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B56AB81CFF;
        Thu, 26 Jan 2023 06:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86912C433D2;
        Thu, 26 Jan 2023 06:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674715453;
        bh=oSASZYw285oCDWdMnzzDQlAN8ZvzQ9nHMu+oU6hhVqc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uvZM+kj1HL2TO/LWZZlKEnWJloTYJKFVA7qAPp8Ll3xPIQlGyxY2W/URylN8xcJMy
         4fYSFuHhbZuRjSdK/kbNuzq3KDBGHkIt53GJkUfMDDqsKbJfsNpqV2JSw56Lg3xCV2
         VbcKGqiI6mag/q3Bd5eLn7PWhiFuFqbHbOL9RFaZDveD1gz2QKSPoJrTr970UTe2HX
         WgHPdkmd6QYtOl8YeXOrqLNKZ3J0fPn+PgjIu9Lk5kMFWbsOuDwU4vb4ysb4kElYDP
         V3NX3EGZ3NN7mrEXlTJjPgc9fxNkTLFqVADt3JwmbfBse3wDaRaYfmSj0mRl3RtppO
         UCZDawujXVOWA==
Date:   Wed, 25 Jan 2023 22:44:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, erkin.bozoglu@xeront.com,
        John 'Warthog9' Hawley <warthog9@kernel.org>
Subject: Re: [PATCH net] net: dsa: mt7530: fix tristate and help description
Message-ID: <20230125224411.5a535817@kernel.org>
In-Reply-To: <20230125053653.6316-1-arinc.unal@arinc9.com>
References: <20230125053653.6316-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Jan 2023 08:36:53 +0300 Ar=C4=B1n=C3=A7 =C3=9CNAL wrote:
> Fix description for tristate and help sections which include inaccurate
> information.
>=20
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>

Didn't make it thru to the list again :(
Double check that none of the addresses in To: or Cc: are missing
spaces between name and email or after a dot. That seems to be the most
common cause of trouble. Or try to resend using just emails, no names.
