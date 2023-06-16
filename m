Return-Path: <netdev+bounces-11281-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 775DB732672
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:01:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A37271C20F13
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2F6812;
	Fri, 16 Jun 2023 05:01:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6E67C
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 05:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15477C433C8;
	Fri, 16 Jun 2023 05:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686891659;
	bh=1NLRzcoTWYknb6o5aQswk0SIj/J+4fc5WMrmmbozYPk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pBv6btSDnSItXAwxyTIc8T9pJaJge5augEBT20Bmd53Cs3iyPl2MObhGocSdhzE+K
	 GVTzppKMTRSg/LQgC2BjD1ilgXPccUFPlL8ALAmUKgZ+gc7wq4bypET9rKLNRqP0i4
	 H9T+tnCCHhXobODU58zl168x1NLaEhlIH+uWP6R/EN5D4r+L6B307y/y4J+MB7xcAw
	 rvLsTdAOsKxMIWCtRmBmWS67XPYzoBaC9uGiSHz9fiRf/Qhr7AfpW2J4DHbC7eOycs
	 Rc6tJWm/d4SF2TKeyUDIrWBgO3YATgsNj3RcRqFwRrhar89KE/PmU4M28rPdb3JDoT
	 ZtewrjziGN+8Q==
Date: Thu, 15 Jun 2023 22:00:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Petr Oros <poros@redhat.com>
Cc: netdev@vger.kernel.org, jiri@resnulli.us, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: report devlink_port_type_warn source
 device
Message-ID: <20230615220058.0915a056@kernel.org>
In-Reply-To: <20230615095447.8259-1-poros@redhat.com>
References: <20230615095447.8259-1-poros@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 11:54:47 +0200 Petr Oros wrote:
> devlink_port_type_warn is scheduled for port devlink and warning
> when the port type is not set. But from this warning it is not easy
> found out which device (driver) has no devlink port set.

good idea

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

