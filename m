Return-Path: <netdev+bounces-6308-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F478715A28
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:30:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFA981C20BD8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AE0414A8E;
	Tue, 30 May 2023 09:30:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251E41426D;
	Tue, 30 May 2023 09:30:06 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03B9130;
	Tue, 30 May 2023 02:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=wy+LxcoyQ9k+5pSYSWu73ome4mN4pgQvZZQDQ3xRVR0=; b=ZR+7tVCErDha7TenpU3luyqFqB
	UNMMuyJdQwZ4LuNR6Ymr9ipQJoRHPgeIkm+8bNGx2RBPDsR3Xh5KWQN4xzD54KWLSOQAk1l2rQxTO
	NggFEHyyzWBItAi4oQIAJprRLVCd2LEZk+oJwtsHUvoHr5/44puMPuRZ16fzXasUtNboKnFwddht2
	wGMiQgoMxLV5MjMxXgArU+9eNKdbIE/mDIaSq383SFfQ26jeN8mxFQQbHIiVEF84pa2GJ1bDwAo20
	o7boWi6VoQ5+TKzk85FFQYnx4VTFLKQ7Di8BXuTXd16KnzkeHoGoYobHaFItug1MiCONDPm953SiL
	QJcr22rw==;
Received: from sslproxy01.your-server.de ([78.46.139.224])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1q3vfr-000Es5-ML; Tue, 30 May 2023 11:29:51 +0200
Received: from [85.1.206.226] (helo=linux.home)
	by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1q3vfr-000I7I-26; Tue, 30 May 2023 11:29:51 +0200
Subject: Re: pull-request: bpf-next 2023-05-26
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
 netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20230526222747.17775-1-daniel@iogearbox.net>
 <20230526173003.55cad641@kernel.org>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <484ffbc6-69e8-864e-35c5-61c38fd0c116@iogearbox.net>
Date: Tue, 30 May 2023 11:29:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230526173003.55cad641@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26923/Tue May 30 09:22:21 2023)
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/27/23 2:30 AM, Jakub Kicinski wrote:
> On Sat, 27 May 2023 00:27:47 +0200 Daniel Borkmann wrote:
>> 1) Add the capability to destroy sockets in BPF through a new kfunc, from Aditi Ghag.
> 
> Is there a reason this wasn't CCed to netdev?

Hm, good point. I think this was oversight as this was submitter's first patch series
for upstream. I did see Paolo reviewing one of the revisions, but yes netdev should have
been in Cc throughout all the revisions. Sorry about that, we'll watch out the Cc list
more closely and point this out if this happens again in future.

Thanks,
Daniel

