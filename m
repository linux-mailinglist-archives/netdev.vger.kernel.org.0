Return-Path: <netdev+bounces-8381-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6635723D91
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:33:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49D221C20B1F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3CE294D3;
	Tue,  6 Jun 2023 09:33:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F120F125AB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:33:21 +0000 (UTC)
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EF81703
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:32:58 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4Qb4yY43ZRz9sc6;
	Tue,  6 Jun 2023 11:32:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
	s=MBO0001; t=1686043973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yv5ztYAUAaF5I4kzRmFH08SDBTYyXLD3fv5VBwS+7DA=;
	b=WxoNJgEvTfMvzJa0RzWsH38qNZGn0b/wBznt2ZlKWgHIWG35KlFnjWZuPD3AO2oUpDwsAb
	cEMmNxGflzVRsibs1rGHuehmtubs3y7wJCGOFSG3MV36CnQ2rpBOhTrat1BWLDiP1PaOQg
	QBVLALxupt3moZLI183S0zqFNYiBoe3oWtnJ7he2+QgHHre91h5kvTVbPpaX+1vCsXMwXh
	Y72wfZ7/nQ0wZrLGP5QND7Mw9bZwVRPs2Xs2GjGQS5cLZ1VVoHfPIBv536nWjq2gP17MIL
	wAKIwEBf35BaIp9RsBadqtAFj6SuM8F60pPhSQ6qd+etZdW8cNfSLynDBhARcw==
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
 <20230510-dcb-rewr-v3-3-60a766f72e61@microchip.com>
From: Petr Machata <me@pmachata.org>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org,
 petrm@nvidia.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH iproute2-next v3 03/12] dcb: app: move colon printing
 out of callbacks
Date: Tue, 06 Jun 2023 11:32:34 +0200
In-reply-to: <20230510-dcb-rewr-v3-3-60a766f72e61@microchip.com>
Message-ID: <87edmp6im3.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4Qb4yY43ZRz9sc6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> In preparation for changing the prototype of dcb_app_print_filtered(),
> move the colon printing out of the callbacks, and into
> dcb_app_print_filtered().
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <me@pmachata.org>

