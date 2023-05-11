Return-Path: <netdev+bounces-1816-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD0E96FF352
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:45:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89A2B2817AC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D2E219E63;
	Thu, 11 May 2023 13:45:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62538369
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:45:29 +0000 (UTC)
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F412134
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:45:23 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4QHCnp0fG5z9skk;
	Thu, 11 May 2023 15:45:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
	s=MBO0001; t=1683812718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F5N3e1T62YBqkTUiNwoKylsTSfgBKCkeSaR4uYSAyhA=;
	b=xo4OucOGGrs6UyysM6K1q1OID78aLeNpqitoVyqgPbKh/qgFe3BYnQprjR9HeHxWbjdTOb
	woIJAS+DoY5HdmyIj+x4bZ3LMbiCYz1r3kdnKLaQpFg0etS1TwqXWppeib2kB1/KdWmoGB
	y8r318ND5c780LBC0+A0zSUAqL2r9EtXI8p1KuFSPrTNSkyXUpbUMRswrSAbyU/V6Df/QM
	ukVFuCap4v1Tj6ODErLi90O3w8ntNtznv4gz3sVdETp4EQi+4lpK9ueWQ/bq5DNVCWtxew
	3oY8lgobr/6RsPE4jKveGdwbmfOcpoCqGyJrNUcRwBK3Jzd12bnyrSP1zUEf5g==
References: <20230510210040.42325-1-stephen@networkplumber.org>
From: Petr Machata <me@pmachata.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, jiri@resnulli.us, jmaloy@redhat.com,
 parav@nvidia.com, elic@nvidia.com, Nikolay Aleksandrov
 <razor@blackwall.org>
Subject: Re: [PATCH iproute2] Add MAINTAINERS file
Date: Thu, 11 May 2023 15:39:58 +0200
In-reply-to: <20230510210040.42325-1-stephen@networkplumber.org>
Message-ID: <87r0rn2d91.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Stephen Hemminger <stephen@networkplumber.org> writes:

> Record the maintainers of subsections of iproute2.
> The subtree maintainers are based off of most recent current
> patches and maintainer of kernel portion of that subsystem.
>
> Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

> +Data Center Bridging - dcb
> +M: Petr Machata <me@pmachata.org>
> +F: dcb/*

Acked-by: Petr Machata <me@pmachata.org> # For DCB

