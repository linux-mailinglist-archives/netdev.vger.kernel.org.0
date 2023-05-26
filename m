Return-Path: <netdev+bounces-5499-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B968711E81
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 05:43:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B34E128166F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 03:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DAF1C05;
	Fri, 26 May 2023 03:43:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0901C02
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE72C433D2;
	Fri, 26 May 2023 03:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685072620;
	bh=/L2ak1QSeM0cCjQ48lK1EVSqL+J/A7fobg5W3LOtywM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JO/UjNZpNTEYCO6E/ikfAgokVWP/FSDJVnYoVDsTwnx64cATbJdus3/6wL/S2oEl7
	 usQmN2PW4r6+7rT9/GdABsEtTrfqhCq/YvlMhMlDsWowGMnv4DzCv2507wdv1C10QE
	 hCGQtB2XmW63NMb+i7sKoK5O2gtUHtHUyWEzhjFK/lmMAADcWLUfZER+fqQlsibjFi
	 V2xKtH7tW/6i9tkuMIvFwfzcrkyE8fO6IYkPdKg3eW5yKNt+PKbcDNzvhuTVS8Vumc
	 e3h/W4azpOqY65fKQFUXH7keAveTzvzO8zIaND2WLdwK8N7HyfDNDu5u0nSXz0Rmto
	 Ied8XWvRqx/Yw==
Date: Thu, 25 May 2023 20:43:38 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli
 <f.fainelli@gmail.com>, Vladimir Oltean <olteanv@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, linux-leds@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 00/13] leds: introduce new LED hw control
 APIs
Message-ID: <20230525204338.3de1e95c@kernel.org>
In-Reply-To: <20230525145401.27007-1-ansuelsmth@gmail.com>
References: <20230525145401.27007-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 May 2023 16:53:48 +0200 Christian Marangi wrote:
> This is based on top of branch ib-leds-netdev-v6.5 present here [1].

I merged that PR now, but you'll need to repost.
Build bots don't read English (yet?) so posting patches which can't 
be immediately applied is basically an RFC (and should be marked as
such).

