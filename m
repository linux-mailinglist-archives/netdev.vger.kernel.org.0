Return-Path: <netdev+bounces-11828-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB18B734B6B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 07:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D99DB1C20915
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 05:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A983423C7;
	Mon, 19 Jun 2023 05:41:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BD9185F
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 05:41:50 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347E6188;
	Sun, 18 Jun 2023 22:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1687153310; x=1718689310;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=CZx7GIQQLy+OCq7YmHISPmUrUL3enkw6RnhnSLYyqs0=;
  b=q0K/Yuy5QGOj0C+d6ANyGRlXgQUsvc6QxqPYEjUE4ZlZmcbTSAhvDdnW
   c+08K7yPYYJySDH4xswK2oSmhRyFuN6XBx50kByZ4YaFX+2S+5wjUkbqR
   CyXEVwgGqhcVrVm+yfCfQ22WC75cJq9ISpt/MYEFjBtMq7dIAZHE2KbgG
   k=;
X-IronPort-AV: E=Sophos;i="6.00,254,1681171200"; 
   d="scan'208";a="339593627"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 05:41:47 +0000
Received: from EX19D019EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com (Postfix) with ESMTPS id 129B145EDA;
	Mon, 19 Jun 2023 05:41:44 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D019EUA003.ant.amazon.com (10.252.50.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 19 Jun 2023 05:41:44 +0000
Received: from EX19D047EUB004.ant.amazon.com (10.252.61.5) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 19 Jun 2023 05:41:43 +0000
Received: from EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20]) by
 EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20%3]) with mapi id
 15.02.1118.026; Mon, 19 Jun 2023 05:41:43 +0000
From: "Arinzon, David" <darinzon@amazon.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, David Miller
	<davem@davemloft.net>
CC: Networking <netdev@vger.kernel.org>, "Kiyanovski, Arthur"
	<akiyano@amazon.com>, Jakub Kicinski <kuba@kernel.org>, "Agroskin, Shay"
	<shayagr@amazon.com>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Linux Next Mailing List
	<linux-next@vger.kernel.org>
Subject: RE: linux-next: build warning after merge of the net-next tree
Thread-Topic: linux-next: build warning after merge of the net-next tree
Thread-Index: AdmicJQL8/ZDcnnqQZGJBpGhxox0zg==
Date: Mon, 19 Jun 2023 05:41:43 +0000
Message-ID: <bbf3cbd1080840178da676c4241ee0ef@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.85.143.179]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Precedence: Bulk
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Hi all,
>=20
> After merging the net-next tree, today's linux-next build (htmldocs)
> produced this warning:
>=20
> Documentation/networking/device_drivers/ethernet/amazon/ena.rst:209:
> WARNING: Explicit markup ends without a blank line; unexpected unindent.
>=20
> Introduced by commit
>=20
>   f7d625adeb7b ("net: ena: Add dynamic recycling mechanism for rx buffers=
")
>=20
> --
> Cheers,
> Stephen Rothwell

Thank you for highlighting this, we're working on a patch to resolve the wa=
rning.

Thanks,
David

