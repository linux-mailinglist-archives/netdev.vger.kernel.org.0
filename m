Return-Path: <netdev+bounces-6545-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26052716DEA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:47:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9AC71C20D47
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3DA2D274;
	Tue, 30 May 2023 19:47:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B11200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:47:47 +0000 (UTC)
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DD510B
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:47:36 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4QW2x13D8qz9sp7;
	Tue, 30 May 2023 21:47:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
	s=MBO0001; t=1685476053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xxg8ocdIBhXoEK3jhvE7fjCdW76/yynt3e5U/DxzxKA=;
	b=eYX86JpvcVP4l8NVMivppWZjToE8JlqQL6OL60ctVtiQjlB1ovQuriZsSNyRetR0kQjQXd
	szCuTHbKmT1UUmAPIhetUQwW1nFj9Vn8w9n8SHY7vGK8wMaY5PEq3fyy0z+0aSEu/3qRgh
	WSqzzvbEx9yYxcjEzW0HmBkT/wJE98LInC4z4OiKdmM1DwPQvJPuMsFeHE95vPg+MnG0yd
	XjJSfG+ILNy3P84oqtXcgD0E00K9S7Ud8bqcxMZV1dHYDEkrUrqHuNSEPRaaJnC6fyVVAn
	z1zLdlPLjQLkJHD05pduWL+2Q+gmrN46gV8sprgEffxJ+S5O3c6w50R4WDcQiw==
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
 <20230510-dcb-rewr-v2-6-9f38e688117e@microchip.com>
From: Petr Machata <me@pmachata.org>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org,
 petrm@nvidia.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH iproute2-next v2 6/8] man: dcb-rewr: add new manpage for
 dcb-rewr
Date: Tue, 30 May 2023 21:47:17 +0200
In-reply-to: <20230510-dcb-rewr-v2-6-9f38e688117e@microchip.com>
Message-ID: <878rd561po.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4QW2x13D8qz9sp7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> Add a new manpage for dcb-rewr. Most of the content is copied over from
> dcb-app, as the same set of commands and parameters (in reverse) applies
> to dcb-rewr.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <me@pmachata.org>

