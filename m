Return-Path: <netdev+bounces-1863-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A8F6FF599
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:13:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 307781C20F93
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1785F62A;
	Thu, 11 May 2023 15:13:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E66629
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:13:24 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45E5712A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:13:23 -0700 (PDT)
Date: Thu, 11 May 2023 17:13:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Donald Buczek <buczek@molgen.mpg.de>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com
Subject: Re: Request "netfilter: nf_tables: deactivate anonymous set from
 preparation phase" for stable
Message-ID: <ZF0GDNRop0qi3ech@calendula>
References: <f9a4973e-a3fb-de6b-16c9-685a711f3942@molgen.mpg.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f9a4973e-a3fb-de6b-16c9-685a711f3942@molgen.mpg.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 03:39:17PM +0200, Donald Buczek wrote:
> Dear Pablo,
> 
> do you think, your patch c1592a89942e ("netfilter: nf_tables: deactivate anonymous set from preparation phase") should go into the stable kernels?
> 
> Except for 4.14, the patch can be automatically applied to all stable and longtime kernels.
> 
> I hope I didn't overlook, that this already is on its way by a procedure unknown to me.

I am working on this.

