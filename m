Return-Path: <netdev+bounces-7894-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7895E721FC8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:40:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A75921C20B38
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F09E11C99;
	Mon,  5 Jun 2023 07:40:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640F4194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:40:00 +0000 (UTC)
X-Greylist: delayed 529 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Jun 2023 00:39:57 PDT
Received: from mail.paretdee.com (mail.paretdee.com [141.95.17.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEBEBD
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 00:39:57 -0700 (PDT)
Received: by mail.paretdee.com (Postfix, from userid 1002)
	id 7C725A22AA; Mon,  5 Jun 2023 07:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=paretdee.com; s=mail;
	t=1685950267; bh=YtPWhpqttWkror/OXW+RT7d5qvBhyF8jxaFrqRhKfz8=;
	h=Date:From:To:Subject:From;
	b=mk3rUAT3PBuI/96uxo3Du+riPkFnKu8RFowCxng8FOftGk3l7/PrBtIkjIsYvS8yV
	 AD2Tx+pZh+OyMqDuuaRPLVH7a9KR9J71re32N6ZG0wUuYCs/IZ7Z8k1IC3nRHY9A+f
	 krce8EBN/pVmv26JkemIGljXz1SXmyITJzxha4h2A3BBZ7KF32YLVoeF9mRergkStE
	 F+exZvaF48QTyJkJmJIwpDpV2EJsPF/pHm/AROR3vkGSRBgcChw8ICqK38uedcB/wn
	 x3XGkKF1vnEzgHWJHmf7cG1jSq8QV6X2AV/c4SqYGkK2y91KIw4TQqoGmzM3VDirQM
	 S1kMCgY69DHMg==
Received: by paretdee.com for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:30:43 GMT
Message-ID: <20230605064520-0.1.6h.d8jj.0.0l3l9y71fj@paretdee.com>
Date: Mon,  5 Jun 2023 07:30:43 GMT
From: "Leos Sladek" <leos.sladek@paretdee.com>
To: <netdev@vger.kernel.org>
Subject: =?UTF-8?Q?Fotovoltaick=C3=A9_rozvodnice?=
X-Mailer: mail.paretdee.com
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dobr=C3=BD den,

obrac=C3=ADm se na V=C3=A1s jm=C3=A9nem dlouholet=C3=A9ho v=C3=BDrobce fo=
tovoltaick=C3=BDch rozvodnic ur=C4=8Den=C3=BDch pro
soukrom=C3=A9 i pr=C5=AFmyslov=C3=A9 pou=C5=BEit=C3=AD.

Dod=C3=A1v=C3=A1me fotovoltaick=C3=A9 rozvodnice na zak=C3=A1zku a jsme s=
chopni realizovat i ty nejn=C3=A1ro=C4=8Dn=C4=9Bj=C5=A1=C3=AD
po=C5=BEadavky instala=C4=8Dn=C3=ADch firem, velkoobchod=C5=AF a distribu=
tor=C5=AF.

Vyu=C5=BE=C3=ADv=C3=A1me nejkvalitn=C4=9Bj=C5=A1=C3=AD komponenty a mater=
i=C3=A1ly, =C4=8D=C3=ADm=C5=BE dosahujeme vy=C5=A1=C5=A1=C3=AD odolnost, =
stabilitu
provozu a ochranu proti vod=C4=9B, vlku, prachu a n=C3=A1raz=C5=AFm.

V na=C5=A1em sortimentu jsou tak=C3=A9 omezova=C4=8De p=C5=99ep=C4=9Bt=C3=
=AD AC/DC, kter=C3=A9 zaji=C5=A1=C5=A5uj=C3=AD ochranu
fotovoltaick=C3=BDch nap=C3=A1jec=C3=ADch instalac=C3=AD p=C5=99ed negati=
vn=C3=ADmi efekty p=C5=99ep=C4=9Bt=C3=AD a chr=C3=A1n=C3=AD za=C5=99=C3=AD=
zen=C3=AD p=C5=99ed
efekty p=C5=AFsoben=C3=AD p=C5=99ep=C4=9Bt=C3=AD a bleskov=C3=BDch proud=C5=
=AF.

Chcete si vyzkou=C5=A1et na=C5=A1e =C5=99e=C5=A1en=C3=AD?


S pozdravem
Leos Sladek

