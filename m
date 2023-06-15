Return-Path: <netdev+bounces-10997-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 325E8731027
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBE11280F29
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E731A5B;
	Thu, 15 Jun 2023 07:07:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5253CA45
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:07:33 +0000 (UTC)
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CAE19B5
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 00:07:31 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-oWywjiogNEqfBUu3vDnHqA-1; Thu, 15 Jun 2023 03:07:27 -0400
X-MC-Unique: oWywjiogNEqfBUu3vDnHqA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2ABC33849534;
	Thu, 15 Jun 2023 07:07:22 +0000 (UTC)
Received: from hog (unknown [10.45.224.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11D322026D49;
	Thu, 15 Jun 2023 07:07:19 +0000 (UTC)
Date: Thu, 15 Jun 2023 09:07:18 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Raed Salem <raeds@nvidia.com>, Lior Nahmanson <liorna@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: macsec: fix double free of percpu stats
Message-ID: <ZIq4prrdiXN77Y9N@hog>
References: <20230613192220.159407-1-pchelkin@ispras.ru>
 <20230613200150.361bc462@kernel.org>
 <ZImx5pp98OSNnv4I@hog>
 <20230614090126.149049b1@kernel.org>
 <20230614201714.lgwpk4wyojribbyj@fpc>
 <ZIot16xcgb7l8wer@hog>
 <20230614230239.02c388a8@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230614230239.02c388a8@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

2023-06-14, 23:02:39 -0700, Jakub Kicinski wrote:
> On Wed, 14 Jun 2023 23:15:03 +0200 Sabrina Dubroca wrote:
> > It's been 7 years... your guess is about as good as mine :/
> > 
> > I wouldn't bother reshuffling the device creation code just to make
> > the handling of rare failures a bit nicer.
> 
> Would you be willing to venture a review tag?

Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>

-- 
Sabrina


