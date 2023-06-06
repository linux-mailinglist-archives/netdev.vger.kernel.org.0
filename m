Return-Path: <netdev+bounces-8485-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CB41724416
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 724321C21001
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27AC417FE8;
	Tue,  6 Jun 2023 13:15:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C75115ACE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:15:12 +0000 (UTC)
X-Greylist: delayed 13334 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Jun 2023 06:15:11 PDT
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050:0:465::102])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477C112F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:15:10 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4Qb9tz5Sx0z9smk;
	Tue,  6 Jun 2023 15:15:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
	s=MBO0001; t=1686057307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uIBLETqhgW9c2LMa31rC088aNUhdmopnovpnxNZU2qg=;
	b=U2SkgPhmX+vJ4gWahRCMoDck+gPlltdNW896nxY3whyQj3Fhj3nQFhipaxBjNR/h/bWWYC
	MqgBorlTdoq2fX44olTHBRZX+xNMg1VKpy5nVE54LK9dmbrGzTiXPHHDK9S2PFnRfcBagz
	bTmUMbvDwy0hyng4subs3y8ZSRUK/2XQYavaQjbiw5A9FoXr3OSBsJE9/tuNgy8M88QdGq
	ul51gCrihYCEOcfCFTqLBLGLEygyIDBXc7duH11raiyYrdJ31nJJ2g4U0zf/GziKe7kO+o
	mGmWJ4tI0qcTmNgPy5oP5H00WpouQIkngQJXdB6BIOaAQESar8p8rLOuIr7QqQ==
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
 <20230510-dcb-rewr-v3-9-60a766f72e61@microchip.com>
From: Petr Machata <me@pmachata.org>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org,
 petrm@nvidia.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH iproute2-next v3 09/12] dcb: rewr: add symbol for max
 DSCP value
Date: Tue, 06 Jun 2023 15:14:22 +0200
In-reply-to: <20230510-dcb-rewr-v3-9-60a766f72e61@microchip.com>
Message-ID: <87wn0g68bp.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4Qb9tz5Sx0z9smk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> A symbol, DCB_APP_PCP_MAX, for maximum PCP value, already exists. Lets
> add a symbol DCB_APP_DSCP_MAX and update accordingly.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <me@pmachata.org>

