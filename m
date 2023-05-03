Return-Path: <netdev+bounces-177-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0336F5A61
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 16:47:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 897032815F1
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 14:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72CF910794;
	Wed,  3 May 2023 14:47:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000E8D521
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 14:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE12C433EF;
	Wed,  3 May 2023 14:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683125262;
	bh=4n2Au5KBs2aRk9Y60d18P0LDoCUB/8Ll7w+Wy+TD2Ek=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=B5oudksVfbmhVgVQyQZ72SmOENo4PM/3p6ROaRThXzEozau2Bvtc8e9qHIaLDpK/P
	 58Z4D08z6N4bAYS0IAN4OOejTS2zcJFUzyXr9YI1HfqDYevioSAG1GvR6KVmW6SJ7L
	 sw4ftAEluOpHLYSTapOnTSHn2ZxFQM0CWyLQt1gfiIPg+tKIEh/H9du5c5mZ/0HOMk
	 fJDpAJmgERgUsrJy3wgwd1DYph0+m4mjWhOek8tjMNUvfABVDAy9bcyu+Z7zZKDzP8
	 aQtrV2U/2QoaHyKRQuasXdrJ0YKr8K/AeMObYaUBm4CMmUCBwWEgiiG4Ci6fGpEcwQ
	 y4l/f1kL2Grlw==
Date: Wed, 3 May 2023 07:47:41 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: netdev@vger.kernel.org, netdev-driver-reviewers@vger.kernel.org
Subject: Re: [ANN] netdev development stats for 6.4
Message-ID: <20230503074741.77655604@kernel.org>
In-Reply-To: <20230503080133.GD525452@unreal>
References: <20230428135717.0ba5dc81@kernel.org>
	<20230503080133.GD525452@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 May 2023 11:01:33 +0300 Leon Romanovsky wrote:
> > Corigine takes #2 spot, thanks to impressive work from Simon,
> > congrats! nVidia continues to slip for the second cycle in a row.  
> 
> For every dark night, there's a brighter day.

Looking forward to it :)

> > Top authors (thr):                   Top authors (msg):                  
> >    1 (   ) [19] RedHat                  1 ( +1) [79] RedHat              
> >    2 ( +1) [13] Intel                   2 ( -1) [58] nVidia              
> >    3 ( +2) [10] Meta                    3 (   ) [44] Intel               
> >    4 ( -2) [10] nVidia                  4 ( +4) [39] AMD                   
> 
> Another way to present the same data can be:
> 3 ( -1) [10] nVidia
> 4 ( +1) [10] Meta
> 
> BTW, don't take it seriously :)

these are sorted before rounding ;)

