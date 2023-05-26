Return-Path: <netdev+bounces-5525-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0C1C71200C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:35:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81A982816BA
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC65D523E;
	Fri, 26 May 2023 06:35:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E7D20E6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:35:29 +0000 (UTC)
X-Greylist: delayed 525 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 May 2023 23:35:26 PDT
Received: from umail2.aei.mpg.de (umail2.aei.mpg.de [194.94.224.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E978E19C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 23:35:26 -0700 (PDT)
Received: from arc.aei.uni-hannover.de (ahgate1.aei.uni-hannover.de [130.75.117.49])
	by umail2.aei.mpg.de (Postfix) with ESMTPS id D655F1BA0C3C
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:26:18 +0200 (CEST)
Date: Fri, 26 May 2023 08:26:18 +0200
From: Gerrit =?UTF-8?B?S8O8aG4=?= <gerrit.kuehn@aei.mpg.de>
To: netdev@vger.kernel.org
Subject: ip-link manpage improvement
Message-ID: <20230526082618.3b0f731d@arc.aei.uni-hannover.de>
Organization: MPG
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; amd64-portbld-freebsd13.0)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_20,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Note: Please cc: me for any answers as I am not subscribed to this mailing
list.


Dear all,

I came across an issue with the ip link command that in the end boiled
down to an incomplete manpage entry:

---
ip link set { DEVICE | group GROUP }
---

This is missing one option (the "dev" part) compared to the help page (ip
link help):

---
ip link set { DEVICE | dev DEVICE | group DEVGROUP }
---

I surely lost a few hairs the other day because my vpn features a tap
interface named "dev" (for the "development" network), and to my surprise
"ip link set dev up" complained about device "up" not being found as the
"dev" part got eaten away by the parser due to the extra syntax I didn't
know about. ;)
It would be great if this could be fixed in the manpage to avoid confusion.


cu
  Gerrit

