Return-Path: <netdev+bounces-1814-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B936FF336
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:40:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6E54281883
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E884F19BDA;
	Thu, 11 May 2023 13:40:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC37C1F920
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:40:54 +0000 (UTC)
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271BF12A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:40:23 -0700 (PDT)
Received: from theinternet.molgen.mpg.de (theinternet.molgen.mpg.de [141.14.31.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 300C361DFA925;
	Thu, 11 May 2023 15:39:18 +0200 (CEST)
To: Pablo Neira Ayuso <pablo@netfilter.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From: Donald Buczek <buczek@molgen.mpg.de>
Subject: Request "netfilter: nf_tables: deactivate anonymous set from
 preparation phase" for stable
Cc: "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com
Message-ID: <f9a4973e-a3fb-de6b-16c9-685a711f3942@molgen.mpg.de>
Date: Thu, 11 May 2023 15:39:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dear Pablo,

do you think, your patch c1592a89942e ("netfilter: nf_tables: deactivate anonymous set from preparation phase") should go into the stable kernels?

Except for 4.14, the patch can be automatically applied to all stable and longtime kernels.

I hope I didn't overlook, that this already is on its way by a procedure unknown to me.

Thanks
    Donald
-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433

