Return-Path: <netdev+bounces-8483-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90EBE72440A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:13:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 029511C21013
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2799117739;
	Tue,  6 Jun 2023 13:13:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D35D37B6F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:13:29 +0000 (UTC)
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050:0:465::103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C9F198A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:13:00 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4Qb9rS0jNgz9slG;
	Tue,  6 Jun 2023 15:12:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
	s=MBO0001; t=1686057176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lHNWkVFE1zs0rYNn5vwAY1igoTvk5o8551XZLPR3/yY=;
	b=oUbvBl9ELfCPDo4YbkNa1Au+q6sbJ1ZTNunPzkZTOLwfslk1ChYMMnVY/6yiYcSIqy/B+5
	SRWgU53eQvcRiP2fmDHi68COR8kR1fRJcB4llHSCaOrjsNxH/oUT+2w9BPpnlEU7Kub+Pa
	2GJr6xZDz0RGDiMdq6NvjeoeecbOW+QHbIbR4J0vcHWUzBB0surQ7vLTLx446pvA6Y/Jna
	KrgF8dVqqmNw24OUWXYkBExh707Yhow2SxlGv0L3yoc86M0Cnfibyqx0WYwNb9cY0LLLuy
	ZcrQeu94jvDOOaB+uCSbCknl8N9xWIpx8vBbsaK2qBYbnRzX0wcSDipe3y1caA==
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
 <20230510-dcb-rewr-v3-7-60a766f72e61@microchip.com>
From: Petr Machata <me@pmachata.org>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org,
 petrm@nvidia.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH iproute2-next v3 07/12] dcb: app: expose functions
 required by dcb-rewr
Date: Tue, 06 Jun 2023 15:11:45 +0200
In-reply-to: <20230510-dcb-rewr-v3-7-60a766f72e61@microchip.com>
Message-ID: <871qio7mzv.fsf@nvidia.com>
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

> In preparation for the dcb-rewr implementation, expose required
> functions, and structs.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <me@pmachata.org>

