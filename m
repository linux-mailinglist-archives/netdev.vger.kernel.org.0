Return-Path: <netdev+bounces-6538-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35314716DB8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:38:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D339128130B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E832A9D8;
	Tue, 30 May 2023 19:38:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F76C200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:38:44 +0000 (UTC)
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050:0:465::103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6845C9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:38:41 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4QW2kj23rVz9skv;
	Tue, 30 May 2023 21:38:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
	s=MBO0001; t=1685475517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NMucfYgD5mYuTqx5EBoQrmLUOxyqZckOO9SW0NI5Jq8=;
	b=rge5rrGuONG007L0LpDUwBGaPNgr1V4VsHVL4ApBQCe4uPO/HnConWmSWrwXQK3XN59KFw
	NCTGS19A1lwf3QWx40Ab/kNEmMR7AFQsW42kl4U0qPow+/GmqSwDZjA1GTYvC3y3GjcmlB
	Ia8xtW8VGAny11i+WqiOFpmoYJuGU8o8O3Hrr2waijKoSdqBQnoTwJ5ADWEZP1orC3CsxE
	qXcU8jv3kh4L3wFjSR0jnFgGgRClBBfrARcaNeEykloLe+FZEUatg5lke59Irw9hoONw4Q
	NfkcfzNetKBiz/uK91LhvXI5BseqtcUVn40ra1lb/6XtOmeFfKMCSScOsCU4ww==
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-8-9f38e688117e@microchip.com>
From: Petr Machata <me@pmachata.org>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org,
 petrm@nvidia.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH iproute2-next v2 8/8] man: dcb-app: clean up a few mistakes
Date: Tue, 30 May 2023 21:37:52 +0200
In-reply-to: <20230510-dcb-rewr-v2-8-9f38e688117e@microchip.com>
Message-ID: <87h6rt624k.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4QW2kj23rVz9skv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> While referencing the dcb-app manpage, I spotted a few mistakes. Lets
> fix them.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <me@pmachata.org>

