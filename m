Return-Path: <netdev+bounces-5852-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA576713279
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 06:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 94C501C21101
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 04:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B07A5A20;
	Sat, 27 May 2023 04:08:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4803646
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 04:08:24 +0000 (UTC)
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3686719C;
	Fri, 26 May 2023 21:08:16 -0700 (PDT)
Date: Sat, 27 May 2023 04:07:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=jszrlxa4gzh5bnhkd22xh7nmpi.protonmail; t=1685160491; x=1685419691;
	bh=xmCBZKa3oW/2MDrSFjMmMw1tLSxZ4M52/i7LPIG8qlY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=eAxamXziwf1i2MmtvkA3Y+EBp9goOjRkfFNG7Io8CN16Ak2ZAr7YY55QliuEU9+nl
	 auc7vbfWAoFKxXrKhWaVts6xa/2UJm9KETSMYDAmd6PNGA8OH8U6G57XdEr4ZHLxNh
	 tDlx6bcQr1qw37hIMQo+t+OC7wXQXRVRi1nxsvAJ/QxvGwWACxTtKROj6DZCjw+U9J
	 g15RWUl7Y0VOEAL3LBbVJMj97Tih4fCyL62uUHuSDCULg2B7th97JilMF8b8pq4b7d
	 WpVgxhxJQwScJwk1nyjnEHtEjiC2/sJf0Ma5R3okXBG1MwlEwTPvpAwyP6RDHwHdh1
	 E36a8gy2dPrQw==
To: Bagas Sanjaya <bagasdotme@gmail.com>
From: Sami Korkalainen <sami.korkalainen@proton.me>
Cc: Linux Stable <stable@vger.kernel.org>, Linux Regressions <regressions@lists.linux.dev>, Linux Networking <netdev@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [REGRESSION][BISECTED] Boot stall from merge tag 'net-next-6.2'
Message-ID: <NVN-hJsvHwaHe6R-y6XIYJp0FV7sCavgMjobFnseULT1wjgkOFNXbGBGT5iVjCfbtU7dW5xy2hIDoq0ASeNaXhvSY-g2Df4aHWVIMQ2c3TQ=@proton.me>
In-Reply-To: <ZHFaFosKY24-L7tQ@debian.me>
References: <GQUnKz2al3yke5mB2i1kp3SzNHjK8vi6KJEh7rnLrOQ24OrlljeCyeWveLW9pICEmB9Qc8PKdNt3w1t_g3-Uvxq1l8Wj67PpoMeWDoH8PKk=@proton.me> <ZHFaFosKY24-L7tQ@debian.me>
Feedback-ID: 45678890:user:proton
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>Where is SCSI info?

Right there, under the text (It was so short, that I thought to put it in t=
he message. Maybe I should have put that also in pastebin for consistency a=
nd clarity):

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
Vendor: ATA      Model: KINGSTON SVP200S Rev: C4
Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
Vendor: hp       Model: CDDVDW TS-L633M  Rev: 0301
Type:   CD-ROM                           ANSI  SCSI revision: 05

>I think networking changes shouldn't cause this ACPI regression, right?
Yeah, beats me, but that's what I got by bisecting. My expertise ends about=
 here.

