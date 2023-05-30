Return-Path: <netdev+bounces-6542-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1B2716DC4
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:40:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC269280D07
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45C5C2D26C;
	Tue, 30 May 2023 19:40:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5F1200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:40:46 +0000 (UTC)
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E14F3
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:40:44 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4QW2n55Px3z9sRC;
	Tue, 30 May 2023 21:40:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
	s=MBO0001; t=1685475641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TZOTQPyGi7K+4/pPb4WhF5tZFuWavKtFD0yanfk5KZA=;
	b=DjIcnlyTIBE5l3XXdCHWW9lTxDFc0chpN6S/PVZcQSZ/yJv+pVh+miDJsuG9XBDyU65SaU
	dGYi/mkltKmoHeYPfh/dQXgZkU7M9AlGWd1rikvo2T4AljEoUwXIrwLxX5bsBt3ltJ3LPq
	c3t9aWnd4peeN5y+mjRDLfNPSAZsTu40P4v88utBeSJA/ddmkupDj1/Ty07GND3sT2BMt2
	KyumSOXxwsWuzT+RCkBoEM587lpAuMEsc2KaJXfbor+G+3slTcDVA64UA6ImTK2N/9jEsy
	WIgx0/QRl8FFFvRGT9Gd7aqCsKkia4+JBlulzCKJmFI7vlMF5tuxLLuOeVzRig==
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-7-9f38e688117e@microchip.com>
From: Petr Machata <me@pmachata.org>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org,
 petrm@nvidia.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH iproute2-next v2 7/8] man: dcb: add additional
 references under 'SEE ALSO'
Date: Tue, 30 May 2023 21:39:43 +0200
In-reply-to: <20230510-dcb-rewr-v2-7-9f38e688117e@microchip.com>
Message-ID: <87cz2h6214.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4QW2n55Px3z9sRC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> Add dcb-apptrust and dcb-rewr to the 'SEE ALSO' section of the dcb
> manpage.

Hmm, yeah, apptrust was left behind the last time around.

> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <me@pmachata.org>

