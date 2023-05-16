Return-Path: <netdev+bounces-2823-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41F14704362
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 04:23:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F151728149A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 02:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17FC623C1;
	Tue, 16 May 2023 02:23:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8C223A2
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:23:27 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C339AB8;
	Mon, 15 May 2023 19:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=OUqbepUxZ6cBSoXVCpOctGyinqNw5foAduLex2Z3q0s=; b=1AggPCNldVfjBGC7jZHc3KpvuR
	mASQoYsCAryZpbyDxxNG87gASEpiLVYzNcbETBggElOEPSSAx1WpBzsMY+1rZyu58qxes0d11yF0D
	uDIr+R9H067t0cbNADthU9mXpT34OekC24fFn2dcmWCbirmMy3Tq8v4AKIj4IQ6nmPvjb/1yb2ZlR
	JV6ODDY6p79RmmBeiM7358rKXnyUewpdoZOoBNLCfAOsR7UDsrfps3ZE00jOJ257JMe3enWQR+lGT
	Of5f34wozb/lzrTASTH7OPVErncaGmuKN18quyETcuPP4iIu6JYXQEnA83cV0rnvvKGYh9E/Chmbw
	LVgAv+MA==;
Received: from [2601:1c2:980:9ec0::2764]
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1pykLV-00481z-1N;
	Tue, 16 May 2023 02:23:25 +0000
Message-ID: <81d74a8e-6bfb-5ed6-9851-faf120a6e9f8@infradead.org>
Date: Mon, 15 May 2023 19:23:24 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: linux-next: Tree for May 15 (net/ipv4/ipconfig.c:)
Content-Language: en-US
To: Stephen Rothwell <sfr@canb.auug.org.au>,
 Linux Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Network Development <netdev@vger.kernel.org>,
 David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Martin Wetterwald <martin@wetterwald.eu>
References: <20230515141235.0777c631@canb.auug.org.au>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230515141235.0777c631@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/14/23 21:12, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20230512:

../net/ipv4/ipconfig.c:177:12: warning: 'ic_nameservers_fallback' defined but not used [-Wunused-variable]
  177 | static int ic_nameservers_fallback __initdata;
      |            ^~~~~~~~~~~~~~~~~~~~~~~

-- 
~Randy

