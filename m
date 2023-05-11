Return-Path: <netdev+bounces-1635-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91E806FE983
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:34:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E4DA281621
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C084C8F6D;
	Thu, 11 May 2023 01:34:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5209E8F63
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A9AC433D2;
	Thu, 11 May 2023 01:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683768839;
	bh=ehqsTiJeXFoWkUX5m5q0zk18w02eaYb37H/12j3Sn0o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IAhOu6LrMht7xbTJep54i6CMeulj3I6IaiVMsI/5MkwveegjGXHRYDTJX+0+mFQHv
	 zpi00o+jL4R/ExIKZ4pX96puTIutUnwczhPtBpsMilapsVzs1cUFBYluTXZMK6Innp
	 toc4yivNoAXKNC5RaBbS76xqCPAfJ8nyvTlKWnbSjNnBX1WgQQgH1D0avorewZOX4s
	 6sEAlYIduBkv3esrsb62oKZFan4AWeT6PD0tbTUcPagclZuikmOuF/IDIzMvFbzBsD
	 8Owff3bWC8iKsyHFCULBd/InX9Qjcxp19ty4naH8jDTAwBC193pISEU4M0H43J2wgc
	 vDL95Ri8C3eiQ==
Date: Wed, 10 May 2023 18:33:57 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Angus Chen <angus.chen@jaguarmicro.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Remove low_thresh in ip defrag
Message-ID: <20230510183357.1b8501fd@kernel.org>
In-Reply-To: <20230509071243.1572-1-angus.chen@jaguarmicro.com>
References: <20230509071243.1572-1-angus.chen@jaguarmicro.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  9 May 2023 15:12:43 +0800 Angus Chen wrote:
> As low_thresh has no work in fragment reassembles,del it.

You're not really deleting it. 
Please use spellcheck.
You also misspelled "unused" in the code.
-- 
pw-bot: cr

