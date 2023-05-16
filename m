Return-Path: <netdev+bounces-3027-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE037051B4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BD011C20E78
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3656728C1C;
	Tue, 16 May 2023 15:11:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC3D34CEC
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 15:11:37 +0000 (UTC)
Received: from sv3.telemetry-investments.com (gw3a.telemetry-investments.com [38.76.0.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id CEABF1721
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:11:35 -0700 (PDT)
Received: from ti139.telemetry-investments.com (ti139 [192.168.53.139])
	by sv3.telemetry-investments.com (Postfix) with ESMTP id 3E3C8216;
	Tue, 16 May 2023 11:11:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=telemetry-investments.com; s=tele1409; t=1684249894;
	bh=f7cdX0t8JOWxbHtSX99OCBc+rOnkNjrkZecCj8JRIn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PURuYDAyqqQdlSau9MOQ2qiLilkLpOcOsxmUmJD/TSftfvhUJnH9sc1o8q3q9FpGC
	 Rz7SpJPFczLdDkSkB8VX8D6XiHvz/FzqVIIV+4fZsc62oiccaNEtvkJTx8bOQW9gDU
	 oYDRyFDi32A1GVvI1drSZtVH2wc9cFG19q0lCkUg=
Received: by ti139.telemetry-investments.com (Postfix, from userid 300)
	id 24222886; Tue, 16 May 2023 11:11:34 -0400 (EDT)
Date: Tue, 16 May 2023 11:11:34 -0400
From: "Andrew J. Schorr" <aschorr@telemetry-investments.com>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Subject: Re: [Issue] Bonding can't show correct speed if lower interface is
 bond 802.3ad
Message-ID: <20230516151134.GA16113@ti139.telemetry-investments.com>
References: <ZEt3hvyREPVdbesO@Laptop-X1>
 <15524.1682698000@famine>
 <ZFjAPRQNYRgYWsD+@Laptop-X1>
 <84548.1683570736@vermin>
 <ZFtMyi9wssslDuD0@Laptop-X1>
 <20230510165738.GA23309@ti139.telemetry-investments.com>
 <20230510171436.GA27945@ti139.telemetry-investments.com>
 <13565.1683855528@famine>
 <20230512144401.GA10864@ti139.telemetry-investments.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512144401.GA10864@ti139.telemetry-investments.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Fri, May 12, 2023 at 10:44:01AM -0400, Andrew J. Schorr wrote:
> OK. So it sounds like this should just work automatically with no
> configuration required to identify which slaves are running in individual
> mode. Thanks for clarifying.

Just to follow up on this -- for test purposes, I booted the system with the 
802.3ad bond containing both the 20 Gbps port-channel and the individual
1 Gbps port on the other switch, and it worked as expected. The only
drawback to this configuration is the lack of ARP monitoring, so I will
stick with the active-backup bond on top of the 802.3ad bond.

Regards,
Andy

