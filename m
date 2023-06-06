Return-Path: <netdev+bounces-8521-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 305DB724726
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63EB5281082
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA0AF23C72;
	Tue,  6 Jun 2023 15:01:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06D137B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:01:10 +0000 (UTC)
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050:0:465::201])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D6F10DF
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:00:50 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4QbDDv2nyMz9sq3;
	Tue,  6 Jun 2023 17:00:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
	s=MBO0001; t=1686063647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xEZNkj4eEFVqk30LZ5kudZsuu376FvQRvCQXB5PhLAw=;
	b=f5mbJs2VGtzl6O/DxpGUgfraO+QfMFpTHd/k8P+y5jj11uLGZTv4T5WW1BPQ1MVGjk0u/Z
	pDSQ4LCIAOfiba7AzhWuan4BEkX/OQcZrFoOMBucwnOvynVS96zzKCrWv9Mt+qT3zgSsyC
	0UbCUM4rLyIeX7+e7+POgdgEv4Td/uZEa+eb7dV6mOrpmDzgZre2Hlr9vSqYZUzuTsKWsd
	BP4qTfVEQou5WRjLi3kXlLFo4poIGB7708efUr6zQpOjI8Us8BYJ0x6N1XEuTIdD4VHzNH
	kQlrcYgPaVv62LNkJ8hsegdTEdR3ycRB7UUIyIuHq2G5LUef1XccVbXyK0yKeA==
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
 <20230510-dcb-rewr-v3-1-60a766f72e61@microchip.com>
From: Petr Machata <me@pmachata.org>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org,
 petrm@nvidia.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH iproute2-next v3 01/12] dcb: app: add new dcbnl
 attribute field
Date: Tue, 06 Jun 2023 17:00:36 +0200
In-reply-to: <20230510-dcb-rewr-v3-1-60a766f72e61@microchip.com>
Message-ID: <87fs7463fm.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4QbDDv2nyMz9sq3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> Add a new field 'attr' to the dcb_app_table struct, in order to inject
> different dcbnl get/set attributes for APP and rewrite.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <me@pmachata.org>

