Return-Path: <netdev+bounces-11523-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 19387733771
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3B991C20D23
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07DEE1C774;
	Fri, 16 Jun 2023 17:31:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F140379F7
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 17:31:49 +0000 (UTC)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F1526A1
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:31:43 -0700 (PDT)
Received: from mail.qult.net ([78.193.33.39]) by mrelayeu.kundenserver.de
 (mreue108 [213.165.67.119]) with ESMTPSA (Nemesis) id
 1N2E5Q-1pycS00fYE-013bz5 for <netdev@vger.kernel.org>; Fri, 16 Jun 2023
 19:31:42 +0200
Received: from zenon.in.qult.net ([192.168.64.1])
	by mail.qult.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.90_1)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1qADIT-0000pD-K1
	for netdev@vger.kernel.org; Fri, 16 Jun 2023 19:31:41 +0200
Received: from ig by zenon.in.qult.net with local (Exim 4.96)
	(envelope-from <ignacy.gawedzki@green-communications.fr>)
	id 1qADIQ-009stD-21
	for netdev@vger.kernel.org;
	Fri, 16 Jun 2023 19:31:38 +0200
Date: Fri, 16 Jun 2023 19:31:38 +0200
From: Ignacy Gawedzki <ignacy.gawedzki@green-communications.fr>
To: netdev@vger.kernel.org
Subject: Is EDT now expected to work with any qdisc?
Message-ID: <20230616173138.dcbdenbpvba7cf3k@zenon.in.qult.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:UMwl8qtRuYg9t/GeC2HZe89m1Hnn4t5lSppCT+b37aJO331RUHT
 jUUOM7Dl0MNW00MV3t5GBlYKKNuZ3sq0Vv/l4nwkkHtFjIRi8VNqHshbCqZnlRVPVuLHYuc
 LDJmyphQ2Pjs4ubFqV+B73SrCWPtWyY9sOLZJrAl5a7vpmNSeoWRneiP1R980+lsaM/PXez
 gI4OzxYJauEKpV5FubJBg==
UI-OutboundReport: notjunk:1;M01:P0:salCeA0pDD8=;Vtt1jenob2NOBF5v4r5ihdaCDr6
 eyMAmeWJ/ziZSr8e5txbyIslXwg4ScIlLyHobGQqcoawi01IDRWGH9jsgDx4wzZmJKmj3QWkw
 VzwoqZ3MMpBOZek3vXGXjla/aTN2jifKU/CS+Y2z9w9HYLbtoDzx4+SWsYVgzL419289GPNbx
 kLeMYeyQcPR9lFGb0nOkk0UIEm+Z8RHtOZEzDU7QzwT9qKbckQ9Q3ee7jpfY4FGnj+rInC7Rp
 +NA95aCMaDE+BRSquaSZOweJRWzmd500rkvQVuEWeYOPJcq+1v8XfAnWAkDgV5CQhLXXsR6yg
 CLIIwD5eUR1MzHZ1TSBOTu56ab9nkgyyM47liroXQ90htke9SHHKNQgnXMYx9eNSH81Gbrq5L
 YnZd7d+NTcALsDoy/fcYl4DNy7nIraYFJVihv4H5nAusnubAdf+0VElIChvXGlWWRF1KKOCOT
 E2J8XQjCCtT1nQX6In1WpYt6MfV1nJGIZwkN5D23ZH0L2/Vn5yY5bkthl9h0oiWHm1N2D7XhJ
 v/nc0Nm+ch9mxxOJ+HAHifwLldrgfDawln+Wp8XsNCzcUq/m76b0N91UMeGDcFXOgPYwMRxht
 6m25VxDMw54jdMMQp+xpJnpDC8n0dJgf6/jRDF1pMoB9X+B03SSilN4CzDlGIBHiHrqtMbyBh
 BYZF1IOt1ExT6IQiW+X0sIqxZASXI8vz5zVXdRsENw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

I've been lately playing around with setting tstamp in BPF in clsact,
in order to pace some traffic, both locally generated and forwarded.

All the code examples I could find suggest that this mangling of tstamp
will only work if the fq qdisc is set on the network interface.  But
my experiments seem to indicate that regardless of the actual qdisc,
be it fq, fq_codel, pfifo_fast, or even noqueue, the delivery time set
in tstamp is always honored, both in sending (output) and forwarding,
with any actual network interface driver I tried.

I tried very hard to find a confirmation of my hypothesis in the
kernel sources, but after three days of continuous searching for
answers, I'm starting to feel I'm missing something here.

So is it so that this requested delivery time is honored before the
packet is handed over to the qdisc or the driver?  Or maybe nowadays
pretty much every driver (including veth) honors that delivery time
itself?

I would be very grateful if someone knowledgeable could enlighten me.

Thanks in advance for your help.

Cheers,

Ignacy


