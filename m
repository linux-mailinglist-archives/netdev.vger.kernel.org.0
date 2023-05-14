Return-Path: <netdev+bounces-2431-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B70BC701E9F
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 19:12:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A2C7280F4B
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 17:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DF2979C3;
	Sun, 14 May 2023 17:12:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4F9749C
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 17:12:31 +0000 (UTC)
X-Greylist: delayed 435 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 May 2023 10:12:29 PDT
Received: from mail.rdts.de (mail.rdts.de [195.243.153.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183B840C0;
	Sun, 14 May 2023 10:12:28 -0700 (PDT)
Received: from webmail.rdts.de (php1.rdts.de [82.223.13.20])
	by mail.rdts.de (Postfix) with ESMTPSA id A06F1BABA4;
	Sun, 14 May 2023 19:05:08 +0200 (CEST)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Sun, 14 May 2023 19:05:08 +0200
From: Gerhard Bertelsmann <info@gerhard-bertelsmann.de>
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Wolfgang Grandegger <wg@grandegger.com>, Marc Kleine-Budde
 <mkl@pengutronix.de>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Chen-Yu Tsai <wens@csie.org>, Jernej Skrabec
 <jernej.skrabec@gmail.com>, Samuel Holland <samuel@sholland.org>,
 linux-can@vger.kernel.org, netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
 kernel@pengutronix.de
Subject: Re: [PATCH 17/19] can: sun4i_can: Convert to platform remove callback
 returning void
In-Reply-To: <20230512212725.143824-18-u.kleine-koenig@pengutronix.de>
References: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
 <20230512212725.143824-18-u.kleine-koenig@pengutronix.de>
Message-ID: <e8d411e1e01f3c7ae8bf97f2f1700e3d@gerhard-bertelsmann.de>
X-Sender: info@gerhard-bertelsmann.de
User-Agent: Roundcube Webmail/1.2.3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Am 2023-05-12 23:27, schrieb Uwe Kleine-König:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling 
> by
> returning an error code. However the value returned is ignored (apart 
> from
> emitting a warning) and this typically results in resource leaks. To 
> improve
> here there is a quest to make the remove callback return void. In the 
> first
> step of this quest all drivers are converted to .remove_new() which 
> already
> returns void. Eventually after all drivers are converted, .remove_new() 
> is
> renamed to .remove().
> 
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Gerhard Bertelsmann <info@gerhard-bertelsmann.de>

Thanks Uwe :-)

