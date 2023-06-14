Return-Path: <netdev+bounces-10623-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA90872F6F5
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 09:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7D591C20A84
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 07:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9C8B3D9E;
	Wed, 14 Jun 2023 07:53:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E0A7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:53:13 +0000 (UTC)
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD821FEE;
	Wed, 14 Jun 2023 00:52:54 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0Vl5j8IK_1686729132;
Received: from 30.221.151.14(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Vl5j8IK_1686729132)
          by smtp.aliyun-inc.com;
          Wed, 14 Jun 2023 15:52:17 +0800
Message-ID: <0bea9ac1-dd44-353b-63dd-a3dd45b588e1@linux.alibaba.com>
Date: Wed, 14 Jun 2023 15:52:10 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [PATCH] MAINTAINERS: add reviewers for SMC Sockets
Content-Language: en-US
To: Jan Karcher <jaka@linux.ibm.com>, David Miller <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>, Alexandra Winter
 <wintera@linux.ibm.com>, Wenjia Zhang <wenjia@linux.ibm.com>,
 Thorsten Winkler <twinkler@linux.ibm.com>, Stefan Raspl
 <raspl@linux.ibm.com>, Karsten Graul <kgraul@linux.ibm.com>,
 Nils Hoppmann <niho@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
 Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>
References: <20230614065456.2724-1-jaka@linux.ibm.com>
From: "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <20230614065456.2724-1-jaka@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 6/14/23 2:54 PM, Jan Karcher wrote:
> adding three people from Alibaba as reviewers for SMC.
> They are currently working on improving SMC on other architectures than
> s390 and help with reviewing patches on top.
>
> Thank you D. Wythe, Tony Lu and Wen Gu for your contributions and
> collaboration and welcome on board as reviewers!

Thanks for inviting me. I'm happy to become a reviewer for SMC .
I will do my best to provide the best help and support. 😁

Acked-by: D. Wythe <alibuda@linux.alibaba.com>

> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
> Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
> ---
>   MAINTAINERS | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f794002a192e..6992b7cc7095 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19140,6 +19140,9 @@ SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
>   M:	Karsten Graul <kgraul@linux.ibm.com>
>   M:	Wenjia Zhang <wenjia@linux.ibm.com>
>   M:	Jan Karcher <jaka@linux.ibm.com>
> +R:	D. Wythe <alibuda@linux.alibaba.com>
> +R:	Tony Lu <tonylu@linux.alibaba.com>
> +R:	Wen Gu <guwen@linux.alibaba.com>
>   L:	linux-s390@vger.kernel.org
>   S:	Supported
>   F:	net/smc/


