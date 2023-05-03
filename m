Return-Path: <netdev+bounces-103-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D7B46F527F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA7BD28106C
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C025A4A1D;
	Wed,  3 May 2023 08:01:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6174E138F
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C04C433EF;
	Wed,  3 May 2023 08:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683100898;
	bh=XwF7xYpR3sNp+wK3vM5RDnSRLFQ9WPSCK+4xhwuojjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b7zyLeeFrpWIps3aOoN2v3RPZsRY9qePvHTnbqa70jVPYnXYctBXDK9hDMAdAIe4X
	 Zk4M6krh5M/yqNxufRgpSvlkqZC0UYeqbmUp19/m6/UuQ1OvCqvJq+zhnh6TzcmHh8
	 DVJV+xVZalhhAdQPIe1JySkYal6O9ojErhVu/qZhWMz/UMYYIMg+nG/uEvdbau1XBQ
	 r583SERTsGqez5dJa3RWeUxaxms0Grr9LyKWn7b0rJiUDCvQj47DA0q99+qJaetWZm
	 ht5xeTYUzikk7jsZLXl3iSI2881kgNud1uJh/NJ44272ggbxZCt6UnC2x5voFZ+AYu
	 81a191zhf/gNQ==
Date: Wed, 3 May 2023 11:01:33 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, netdev-driver-reviewers@vger.kernel.org
Subject: Re: [ANN] netdev development stats for 6.4
Message-ID: <20230503080133.GD525452@unreal>
References: <20230428135717.0ba5dc81@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428135717.0ba5dc81@kernel.org>

On Fri, Apr 28, 2023 at 01:57:17PM -0700, Jakub Kicinski wrote:
> Hi!
> 
> Stats for 6.4 are here! 

<...>

> Corigine takes #2 spot, thanks to impressive work from Simon,
> congrats! nVidia continues to slip for the second cycle in a row.

For every dark night, there's a brighter day.

> 
> Top authors (thr):                   Top authors (msg):                  
>    1 (   ) [19] RedHat                  1 ( +1) [79] RedHat              
>    2 ( +1) [13] Intel                   2 ( -1) [58] nVidia              
>    3 ( +2) [10] Meta                    3 (   ) [44] Intel               
>    4 ( -2) [10] nVidia                  4 ( +4) [39] AMD                 

Another way to present the same data can be:
3 ( -1) [10] nVidia
4 ( +1) [10] Meta

BTW, don't take it seriously :)

Thanks

