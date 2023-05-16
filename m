Return-Path: <netdev+bounces-2857-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 361027044BD
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:35:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F4D72812AE
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 05:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C4A1B903;
	Tue, 16 May 2023 05:35:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8F9A923
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 05:35:08 +0000 (UTC)
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E3A3A9D;
	Mon, 15 May 2023 22:35:07 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
	by mg.bb.i.ssi.bg (Proxmox) with ESMTP id A83DACECD;
	Tue, 16 May 2023 08:35:05 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
	by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id 8F0CCCECC;
	Tue, 16 May 2023 08:35:05 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
	by ink.ssi.bg (Postfix) with ESMTPS id 35C533C080D;
	Tue, 16 May 2023 08:35:03 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 34G5Z1sr009900;
	Tue, 16 May 2023 08:35:02 +0300
Date: Tue, 16 May 2023 08:35:01 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Abhijeet Rastogi <abhijeet.1989@gmail.com>
cc: Simon Horman <horms@verge.net.au>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ipvs: increase ip_vs_conn_tab_bits range for 64BIT
In-Reply-To: <CACXxYfy+yoLLFr0W9HYuM78GjzJsQvbHnm43uRQbor_ncQdMgw@mail.gmail.com>
Message-ID: <02f51077-3cda-b4aa-a060-3c420cc72942@ssi.bg>
References: <20230412-increase_ipvs_conn_tab_bits-v2-1-994c0df018e6@gmail.com> <56b88a99-db88-36e4-9ff1-a5d940578108@ssi.bg> <CACXxYfy+yoLLFr0W9HYuM78GjzJsQvbHnm43uRQbor_ncQdMgw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


	Hello,

On Mon, 15 May 2023, Abhijeet Rastogi wrote:

> Hi Julian Anastasov,
> 
> >Can you keep the previous line width of the above help
> because on standard 80-width window the help now gets truncated in
> make menuconfig.
> 
> Refer this screenshot: https://i.imgur.com/9LgttpC.png
> 
> Sorry for the confusion, I was already expecting this comment. The
> patch had a few words added, hence it feels like many lines have
> changed. However, no line actually exceeds 80 width.
> 
> Longest line is still 80-width max. Do you prefer I reduce it to a
> lower number like 70?

	I'm checking in menuconfig where the help text is displayed.
The word "lasting" is visible up to "last". So, 3 columns are not
visible. In editor, this line is 84, may be up to 80 should be good.
You are using editor that represents Tabs as 4 spaces, that is why
it looks like it fits in 80. Open Kconfig in less. But in editor/less
does not matter because menuconfig simply ignores the leading spaces
in Kconfig and considers the text length which should be no more
than 70.

Regards

--
Julian Anastasov <ja@ssi.bg>


