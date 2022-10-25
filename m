Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CCB60C1B4
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 04:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiJYC2p convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 24 Oct 2022 22:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiJYC2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 22:28:43 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50494102DDE;
        Mon, 24 Oct 2022 19:28:42 -0700 (PDT)
Received: from smtpclient.apple ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=PLAIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 29P2RCr3017668-29P2RCr5017668
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 25 Oct 2022 10:27:12 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH] can: usb: ucan: modify unregister_netdev to
 unregister_candev
From:   Dongliang Mu <dzm91@hust.edu.cn>
In-Reply-To: <20221024135422.egkcbxvudtj7z3ie@pengutronix.de>
Date:   Tue, 25 Oct 2022 10:27:12 +0800
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?utf-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <43C42E60-73A1-4F8A-A587-588B0E76F654@hust.edu.cn>
References: <20221024110033.727542-1-dzm91@hust.edu.cn>
 <20221024135422.egkcbxvudtj7z3ie@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 24, 2022, at 21:54, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> 
> On 24.10.2022 19:00:30, Dongliang Mu wrote:
>> From API pairing, modify unregister_netdev to unregister_candev since
>> the registeration function is register_candev. Actually, they are the
>            ^ typo

:(

>> same.
>> 
>> Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
> 
> Fixed while applying.

You mean it is already done in your own tree? If yes, that’s fine.

> 
> Thanks,
> Marc
> 
> -- 
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

