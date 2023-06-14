Return-Path: <netdev+bounces-10622-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A537F72F693
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:42:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDE6828134B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E120C210B;
	Wed, 14 Jun 2023 07:42:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B707F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:42:32 +0000 (UTC)
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C0A19B3;
	Wed, 14 Jun 2023 00:42:30 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0Vl5dXXb_1686728545;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Vl5dXXb_1686728545)
          by smtp.aliyun-inc.com;
          Wed, 14 Jun 2023 15:42:26 +0800
Date: Wed, 14 Jun 2023 15:42:22 +0800
From: Tony Lu <tonylu@linux.alibaba.com>
To: Jan Karcher <jaka@linux.ibm.com>
Cc: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Thorsten Winkler <twinkler@linux.ibm.com>,
	Stefan Raspl <raspl@linux.ibm.com>,
	Karsten Graul <kgraul@linux.ibm.com>,
	Nils Hoppmann <niho@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>, Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>
Subject: Re: [PATCH] MAINTAINERS: add reviewers for SMC Sockets
Message-ID: <ZIlvXtSHyqGcjqeh@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20230614065456.2724-1-jaka@linux.ibm.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614065456.2724-1-jaka@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 08:54:56AM +0200, Jan Karcher wrote:
> adding three people from Alibaba as reviewers for SMC.
> They are currently working on improving SMC on other architectures than
> s390 and help with reviewing patches on top.
> 
> Thank you D. Wythe, Tony Lu and Wen Gu for your contributions and
> collaboration and welcome on board as reviewers!
> 
> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
> Signed-off-by: Jan Karcher <jaka@linux.ibm.com>

Thanks Jan. It's my honor to be a reviewer, and I will continue on it.

Acked-by: Tony Lu <tonylu@linux.alibaba.com>

> ---
>  MAINTAINERS | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f794002a192e..6992b7cc7095 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19140,6 +19140,9 @@ SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
>  M:	Karsten Graul <kgraul@linux.ibm.com>
>  M:	Wenjia Zhang <wenjia@linux.ibm.com>
>  M:	Jan Karcher <jaka@linux.ibm.com>
> +R:	D. Wythe <alibuda@linux.alibaba.com>
> +R:	Tony Lu <tonylu@linux.alibaba.com>
> +R:	Wen Gu <guwen@linux.alibaba.com>
>  L:	linux-s390@vger.kernel.org
>  S:	Supported
>  F:	net/smc/
> -- 
> 2.39.2

