Return-Path: <netdev+bounces-11974-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBCCE7358EA
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 883C92810F9
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58CC11119D;
	Mon, 19 Jun 2023 13:48:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484D91118B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 13:48:04 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E51BD
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 06:47:52 -0700 (PDT)
Received: from mail.qult.net ([78.193.33.39]) by mrelayeu.kundenserver.de
 (mreue109 [213.165.67.119]) with ESMTPSA (Nemesis) id
 1MxDgs-1prUMf3isi-00xfDK; Mon, 19 Jun 2023 15:47:49 +0200
Received: from zenon.in.qult.net ([192.168.64.1])
	by mail.qult.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.90_1)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1qBFET-0006K4-9U; Mon, 19 Jun 2023 15:47:49 +0200
Received: from ig by zenon.in.qult.net with local (Exim 4.96)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1qBFEQ-00AqKn-0J;
	Mon, 19 Jun 2023 15:47:46 +0200
Date: Mon, 19 Jun 2023 15:47:46 +0200
From: Ignacy Gawedzki <ignacy.gawedzki@green-communications.fr>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: netdev@vger.kernel.org
Subject: Re: Is EDT now expected to work with any qdisc?
Message-ID: <20230619134746.vthfosooxoqwuwil@zenon.in.qult.net>
References: <20230616173138.dcbdenbpvba7cf3k@zenon.in.qult.net>
 <ZI+Ks1imeX3VvuTv@pop-os.localdomain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZI+Ks1imeX3VvuTv@pop-os.localdomain>
X-Provags-ID: V03:K1:zIQYzAnh94aB41HI/KIA5vwBM3LVg5OpMLmpPg7hOFpLFr7HqIN
 b1IWYR7ivriKjFpRGtlLRZv63wYF4aBCiiUdV1MNsatmqTiBtF5icFG8KEDaZ/VH7BU5odm
 SD9nr0mCNCylyxyb4NvZtOPSjDXMme2AO3M5YX/vas8NfOhLprvlIFai054tQy2h6/mojwD
 IvdB0LtTkcC23BAO+jPPQ==
UI-OutboundReport: notjunk:1;M01:P0:65Zbhx/bruc=;nPl3C9+c1IPnG0OtDO/ICXQlofL
 Gw+N9XZH4FTBpEwxUL/YWnsXqW+6lsDKr6zPyhUsBUADZ2So37ShiHzUMB6GxcUbbWeJu3I9p
 59SBacaKZXdYrC9HnWdHE3+zBCpeGAF3WerZyG15Izi0OzXnssr7Reat4Kj9xOJkdGPycLItv
 N1gl3Sj99MWxNUrfM4X4s3w8ilmAiU+xmVcVpNHpOxyYVsdsedIS6XqSLs3TJ9p9FgrjnJ7er
 H8+q2niMdkO5Md+B+AwBVagud/tRdT4FbwHl7TmWUAOCukbhcySvZgg2Zym2bcW3RMHZPoysy
 nkUb6CHH4qUeAEA8CbgJBL2JZ113KoahQf0hQ7goQDg0XhDFr1VbCNx2VTRfjl3fUQB8itXba
 q0TV2xi9Iu2fuC2nxXlx3NQjuV18ONLKTJMt59NFFg9BfjgXbI6j6ZzBfB4L1ae6WoS16jjTR
 d04IA4Fu/YArFLcqI2TrgXFCUthimfgNPih2sOfDUDA86a+CMPJuhjHcYnTyM05FD4MuyMm3o
 fTaPhHg5xNOutnxMsoxkhMYMUk9JvmhPnDEOednom9lWpr6VWF0zLEGuylb5y4WRebJwYhAuL
 l+ifYat9bvU6UqQhmKygTgLIkSYWL7yhcdRqk/ksHY/QZy7JcAtcxaxY8Z9NTa7sbmw6byGY1
 LcEgyzeVYhbk+cHZ+5NQ1ZRh0lvFuLj7Cqaeczwl3g==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NO_DNS_FOR_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 18, 2023 at 03:52:35PM -0700, thus spake Cong Wang:
> On Fri, Jun 16, 2023 at 07:31:38PM +0200, Ignacy Gawedzki wrote:
> > I tried very hard to find a confirmation of my hypothesis in the
> > kernel sources, but after three days of continuous searching for
> > answers, I'm starting to feel I'm missing something here.
> > 
> > So is it so that this requested delivery time is honored before the
> > packet is handed over to the qdisc or the driver?  Or maybe nowadays
> > pretty much every driver (including veth) honors that delivery time
> > itself?
> 
> It depends. Some NIC (and its driver) can schedule packets based on
> tstamp too, otherwise we have to rely on the software layer (Qdisc
> layer) to do so.
> 
> Different Qdisc's have different logics to schedule packets, not all
> of them use tstamp to order and schedule packets. This is why you have
> to pick a particular one, like fq, to get the logic you expect.

This is what I understand from reading both the sources and any
documentation I can get hold of.  But empirical tests seem to suggest
otherwise, as I have yet to find a driver where this
scheduling-according-to-tstamp doesn't actually happen.  I've even
tested with both a tun and a tap device, with noqueue on root and
clsact and by BPF code as a filter.  Here again, the packets are
getting through to the userspace fd according to the pacing enforced
by setting the tstamp in the BPF filter code.

I suspect that pacing is happening somewhere around the clsact
mini-qdisc, before the packet is handed over to the actual qdisc, but
I'd rather have a confirmation from the actual code, before I can rely
on that feature.

Thanks anyway,

Ignacy


