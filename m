Return-Path: <netdev+bounces-8376-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C13723D66
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08CE71C20E78
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F348294C5;
	Tue,  6 Jun 2023 09:30:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94693125AB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:30:12 +0000 (UTC)
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050:0:465::201])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6EFE49
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:30:10 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4Qb4vJ62Jhz9sQ3;
	Tue,  6 Jun 2023 11:30:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
	s=MBO0001; t=1686043804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=akkbWAWB7SpqtS7v/+aPGPtoEOIQi/+kc++I4/cjQOI=;
	b=rMkMi1f7/8XPS0olF3r2WThYFAVfn1OYcMYylce+FPQdTyWr/2XSZXxIxf6/tIxB+6gOm3
	uH/wvHQX25mfCxO9LyF+c5CbTm47EVpvYAmQgFjylZX69RMaXeAXKp9965X2ijZjxMqRTq
	j1nMdsSQGJxi09trFMrVIVHP8YJRQxeJaEPt+0Gdel8Xbqp4tQ43MOp4rF+MleJmaGfE8e
	nBz0lcXO+oxO6P+QQ9iHbbk6YXfQIiv8oQD6c1l+6w8xUzbhVoC3iMlXciB3k/6Z3Cu7ff
	WnU5nccYUtYEIZGtSb05SMFas31++fI1iDuxEmNUPxa4MGBc0HxSdQPX6qdp8Q==
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
 <20230510-dcb-rewr-v3-2-60a766f72e61@microchip.com>
From: Petr Machata <me@pmachata.org>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org,
 petrm@nvidia.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH iproute2-next v3 02/12] dcb: app: replace occurrences of
 %d with %u for printing unsigned int
Date: Tue, 06 Jun 2023 11:29:18 +0200
In-reply-to: <20230510-dcb-rewr-v3-2-60a766f72e61@microchip.com>
Message-ID: <87ilc16iqt.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> In preparation for changing the prototype of dcb_app_print_filtered(),
> replace occurrences of %d for printing unsigned integer, with %u as it
> ought to be.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Nice, thanks!

Reviewed-by: Petr Machata <me@pmachata.org>

