Return-Path: <netdev+bounces-8392-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC105723E17
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:45:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FD361C20DBB
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AC9294F6;
	Tue,  6 Jun 2023 09:45:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C1D125AB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:45:55 +0000 (UTC)
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050:0:465::103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FF5126
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:45:54 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4Qb5FV5ccWz9smK;
	Tue,  6 Jun 2023 11:45:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
	s=MBO0001; t=1686044750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tN6jfeZq9SWyRxYkVKWba4cx+zXJX2OT3T9XQR9p+m0=;
	b=K7+/jU8enbT2OHgImOu2LoLpec0alvnkGGGsgU2TwK3W6IoFUQcPfuERJMfyEXHanErOaV
	iA6cjgKxcX6eJCWKjrv8VLDtz+NMWEdnhYSDfZhmvu4LURXomT5Agcy8XSwCjam2vybto6
	lU+AooAtbIzIAbaPvxw4udw8+HJ63Ckm7fRRhMOh1Tzdi3DWUC33ASS7Xc16HJlIyB5y/O
	K89fSXJmrGzbN2WO1GpCSGlcxv4mxRLlMaoDZdI3Og/Ccy58CAp7O3ZNmL/9pIlSnLNuiI
	wouPPaTrElQXz+P+7w6zxzbhfP6FhhB1C5EI6+Za/U3F6lfBS1P3NJ+W6DTq9g==
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
 <20230510-dcb-rewr-v3-4-60a766f72e61@microchip.com>
From: Petr Machata <me@pmachata.org>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org,
 petrm@nvidia.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH iproute2-next v3 04/12] dcb: app: rename
 dcb_app_print_key_*() functions
Date: Tue, 06 Jun 2023 11:34:04 +0200
In-reply-to: <20230510-dcb-rewr-v3-4-60a766f72e61@microchip.com>
Message-ID: <87a5xc7wl0.fsf@nvidia.com>
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
> rename the _print_key_*() functions to _print_pid_*(), as the protocol
> can both be key and value with the introduction of dcb-rewr.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <me@pmachata.org>

