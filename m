Return-Path: <netdev+bounces-4943-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB9CF70F4D9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A3FB2812AA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA66174C7;
	Wed, 24 May 2023 11:13:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECEAC8FB
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:13:07 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B00FB7
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:13:06 -0700 (PDT)
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1684926784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=il1xYPVnppsXmY1ZMGS9i+q6tyhzFNtN/cHjUYrBJG4=;
	b=EtyOYWnzrY2yCXJEJCXaCi6BQ1czg8vLXHPND57TdW+t5+EKCpeXnX3qSFNKaSXJQBNuEn
	svwHL9WYa90GMJa6aQ/BrXzeodFE0PGsgMozJywsH79m72f8FfNbjwDJob97uV6rUqkh0Q
	zhfvW0o6j4HMCWg3LJligEvfKhmR37PR9KeJjn5f+lXGbbeeq6O18fp/q/3himBcJanZnM
	2F0vfnV8Lk71LfHwSuK1v++xoE7y9kX3G0HYXESJui75hVgbSdDyDcovEq+utzw1jMX8q9
	61+1eZsEE4aS/ERv/fuzPl3anjhntTvWA3qmT0mEXDQJISGHsXYTCsurUvmdZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1684926784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=il1xYPVnppsXmY1ZMGS9i+q6tyhzFNtN/cHjUYrBJG4=;
	b=7uYUUKiru+lzNwMFpgkyNrOXMRrVHEGQGXNSEIt+zOjW/6Li/tFc2hD2PZSHtrXD7Aw+lL
	ri58m/J859SB2XDQ==
To: netdev@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 0/2] net: Add sysfs files for threaded NAPI.
Date: Wed, 24 May 2023 13:12:57 +0200
Message-Id: <20230524111259.1323415-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

small patch to make the threaded NAPI setup easiert. Patch #1 provides
the details.

Sebastian


