Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAFA67A8A8
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjAYCQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjAYCQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:16:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3AA4391A;
        Tue, 24 Jan 2023 18:16:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93039B81719;
        Wed, 25 Jan 2023 02:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4866C4339B;
        Wed, 25 Jan 2023 02:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674613012;
        bh=gRbl4mXmrNt9ibqLwpG8D2TXF8q2oLpZtPdJWLe7ZGA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W+fvTo8OY+CLoDoL5YlJ7lPksr6GfqoCFm92o68QXy9/hxeWP1iMZSOBPHhIIq2eB
         7GRjjhFm/QS+6qWxflAoJU9aTSi7uW1jfHWd5HkEUMDgEJyzJfEEoBdfZlmBEbIE1g
         vGI/DCxsP0Yo349mdmcV/lH6xEHOFB6XbTRBKzlXuBstiQ35U1Y57sW7K5K0kqQs+A
         N4QU83AGiGky+sKv/1rRxEElCemY35RJNlJ9TZ88kjNrMOVicsfNijRTbmOsbhxp1q
         NSi67p9PAUAAMbcSqmba1T5McYn9oktIGdCUBiPcBb4iNNhB84KNf9CvbWk3FAu2+p
         g/1D8Gm8Hcqjg==
Date:   Tue, 24 Jan 2023 18:16:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, erkin.bozoglu@xeront.com
Subject: Re: [PATCH] net: dsa: mt7530: fix tristate and help description
Message-ID: <20230124181650.6f2c28c0@kernel.org>
In-Reply-To: <20230123170853.400977-1-arinc.unal@arinc9.com>
References: <20230123170853.400977-1-arinc.unal@arinc9.com>
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

On Mon, 23 Jan 2023 20:08:53 +0300 Ar=C4=B1n=C3=A7 =C3=9CNAL wrote:
> Fix description for tristate and help sections which include inaccurate
> information.
>=20
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>

The patch didn't make it to patchwork or lore for some reason :(
Could you repost? And when you do - add the tree name in the subject?
If the chips you're listing are supported in Linus's tree then=20
[PATCH net] ?
