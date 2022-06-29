Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D6B55FAA2
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiF2Iem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiF2Iel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:34:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAAFE0E8;
        Wed, 29 Jun 2022 01:34:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2701361D9C;
        Wed, 29 Jun 2022 08:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5E3C34114;
        Wed, 29 Jun 2022 08:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656491679;
        bh=SMibcKHmejQMaGMtAlC/Nipg6tudBRypeBB8W2Rzp7U=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=DyVu2wl+v8Y6B0cJ7WyzUXEJlcm53mO80NZvJl/RbqkF4KezQWXh5R+94iHf8tJ/6
         +xDqmU0sknExE5WIqFJ/dfQK8jspbNRrqIRMszRIiFNm7hILjXG2ZuMrQ5K7mFwo/V
         5R1WhWlnZe8hTVkAgWWLaVSxB1rH3eAkEuJUOCCJ2zcak4qHH++egUxnA1GGK/+viZ
         pRtq0KV+t01G9lrJNHcNifnz6uVwdMwhB/XgelpTJ3S4KOTroT42H7kQ5mNCfqGucH
         A0oC+AuyUKc9z5mvWdvHE7eE2SMYiDJjAljcVM79ftHYOKyhJCgf3etfLO6T3gqazx
         1RkPdSMgalevQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220626192444.29321-2-vfedorenko@novek.ru>
References: <20220626192444.29321-1-vfedorenko@novek.ru> <20220626192444.29321-2-vfedorenko@novek.ru>
Subject: Re: [RFC PATCH v2 1/3] dpll: Add DPLL framework base functions
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org
To:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Date:   Wed, 29 Jun 2022 01:34:37 -0700
User-Agent: alot/0.10
Message-Id: <20220629083439.6F5E3C34114@smtp.kernel.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Vadim Fedorenko (2022-06-26 12:24:42)
> From: Vadim Fedorenko <vadfed@fb.com>
>=20
> DPLL framework is used to represent and configure DPLL devices
> in systems. Each device that has DPLL and can configure sources
> and outputs can use this framework.

Please add more details to the commit text, and possibly introduce some
Documentation/ about this driver subsystem. I'm curious what is
different from drivers/clk/, is it super large frequencies that don't
fit into 32-bits when represented in Hz? Or PLL focused? Or is sub-Hz
required?

Details please!

Does DPLL stand for digital phase locked loop? Again, I have no idea! I
think you get my point.
