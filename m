Return-Path: <netdev+bounces-2887-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65FD17046D1
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 09:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6252A1C20D5C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B135A1DDD7;
	Tue, 16 May 2023 07:45:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57761DDD5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:45:53 +0000 (UTC)
Received: from mail.mahavavy.com (mail.mahavavy.com [92.222.170.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A90746BE
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 00:45:50 -0700 (PDT)
Received: by mail.mahavavy.com (Postfix, from userid 1002)
	id 503B5221BD; Tue, 16 May 2023 07:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mahavavy.com; s=mail;
	t=1684223148; bh=IfqQW79nVX/qUpmHcJiWDpV9BQnOf/s+Zcq9ON74QJY=;
	h=Date:From:To:Subject:From;
	b=d6MTug2pfTLkM+EqHR98R6W4qZ55w1xp5cjAtxgXpo2jbdWQIyR39oVm8+mefA+Wa
	 +apqWSb0SCxgUK43Pt+sZEllZs4a+hCvRqmNJ2CvDxct9718k8WD+SPnXrwloWR69P
	 v1q1rF8jh9pQh7Te/yZAMlXVfBRHKUk7nN8FCfIR55k3yKkkzu9B+92tvMznzrfPct
	 LemH99l5JUD/MmnUjSj4C17eSCjzouEOqt/1vfEigp8/nj87CTRsoSAzcRUiaSdl7m
	 o8bKt/kjoXT7hDkZuZ6rfIeT15Wv7t2ZsREabpuoftdIWgl8FyvPp5ahJUoh72BUg2
	 fYYI/g4AmJ98g==
Received: by mail.mahavavy.com for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:45:29 GMT
Message-ID: <20230516064500-0.1.2j.4lgn.0.1imdo6qt7x@mahavavy.com>
Date: Tue, 16 May 2023 07:45:29 GMT
From: =?UTF-8?Q?"Kristi=C3=A1n_Plet=C3=A1nek"?= <kristian.pletanek@mahavavy.com>
To: <netdev@vger.kernel.org>
Subject: =?UTF-8?Q?Tlakov=C4=9B_lit=C3=BD?=
X-Mailer: mail.mahavavy.com
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MIXED_ES,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dobr=C3=A9 r=C3=A1no,

zaji=C5=A1=C5=A5ujeme technologii tlakov=C3=A9ho lit=C3=AD hlin=C3=ADku.

M=C3=A1me v=C3=BDrobn=C3=AD z=C3=A1vody v Polsku, =C5=A0v=C3=A9dsku a =C4=
=8C=C3=ADn=C4=9B se schopnost=C3=AD flexibiln=C4=9B p=C5=99esouvat v=C3=BD=
robu mezi lokalitami.

Na=C5=A1e lic=C3=AD bu=C5=88ky jsou v=C4=9Bt=C5=A1inou automatick=C3=A9 n=
ebo poloautomatick=C3=A9, co=C5=BE umo=C5=BE=C5=88uje v=C3=BDrobu velk=C3=
=BDch v=C3=BDrobn=C3=ADch s=C3=A9ri=C3=AD s vysokou flexibilitou detail=C5=
=AF.
=20
Poskytujeme podporu v ka=C5=BEd=C3=A9 f=C3=A1zi v=C3=BDvoje projektu, vyv=
=C3=ADj=C3=ADme strukturu detailu.

Cht=C4=9Bli byste mluvit o spolupr=C3=A1ci v t=C3=A9to oblasti?

Pozdravy
Kristi=C3=A1n Plet=C3=A1nek

