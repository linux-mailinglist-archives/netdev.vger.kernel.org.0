Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A08D122512
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfLQGzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:55:21 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:37728 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfLQGzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 01:55:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576565719; x=1608101719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T9K3lKhMfSN5B7d68XGv/PcvnlA/60URcRUENSGixLQ=;
  b=PK58Xwfjmo6NIrN7BymuOHoq3as4F7hlZDQ+97/mrsmi4ytpXWO3elwz
   BoKBnMNBDC5xEleyrfups1FGvKB5QOtxz+xoO04JLp6cwgqvCG6OIdaW5
   R2vmu2bz2BRudg77mGhoYaHRaZQOazGoQkN8zIZ9G5ncQ2Tov25QUWvTE
   E=;
IronPort-SDR: rNnwRIUsCfyGZDs3c0A73mBnWIKyIxTRSURqOA14JXu1aDa5YpMgUeJ8O5Xegn4At2JfEXTgKr
 Ng2MSyrGZnAw==
X-IronPort-AV: E=Sophos;i="5.69,324,1571702400"; 
   d="scan'208";a="13948926"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-168cbb73.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 17 Dec 2019 06:55:07 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-168cbb73.us-west-2.amazon.com (Postfix) with ESMTPS id 82AE6A2373;
        Tue, 17 Dec 2019 06:55:07 +0000 (UTC)
Received: from EX13D06EUC002.ant.amazon.com (10.43.164.186) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Tue, 17 Dec 2019 06:55:07 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D06EUC002.ant.amazon.com (10.43.164.186) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Dec 2019 06:55:06 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1367.000;
 Tue, 17 Dec 2019 06:55:05 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
CC:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Belgazal, Netanel" <netanel@amazon.com>
Subject: RE: linux-next: manual merge of the net-next tree with the net tree
Thread-Topic: linux-next: manual merge of the net-next tree with the net tree
Thread-Index: AQHVs5wu+ZmsiIcfoUW6P1PgUrQTwae95g1A
Date:   Tue, 17 Dec 2019 06:55:05 +0000
Message-ID: <56c41d0552944b1fb62b466aea6c79ee@EX13D11EUB003.ant.amazon.com>
References: <20191216100516.22d2d85f@canb.auug.org.au>
In-Reply-To: <20191216100516.22d2d85f@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.68]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Sent: Monday, December 16, 2019 1:05 AM
> To: David Miller <davem@davemloft.net>; Networking
> <netdev@vger.kernel.org>
> Cc: Linux Next Mailing List <linux-next@vger.kernel.org>; Linux Kernel
> Mailing List <linux-kernel@vger.kernel.org>; Belgazal, Netanel
> <netanel@amazon.com>; Jubran, Samih <sameehj@amazon.com>
> Subject: linux-next: manual merge of the net-next tree with the net tree
>=20
> Hi all,
>=20
> Today's linux-next merge of the net-next tree got a conflict in:
>=20
>   drivers/net/ethernet/amazon/ena/ena_netdev.c
>=20
> between commit:
>=20
>   24dee0c7478d ("net: ena: fix napi handler misbehavior when the napi
> budget is zero")
>=20
> from the net tree and commit:
>=20
>   548c4940b9f1 ("net: ena: Implement XDP_TX action")
>=20
> from the net-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This is now=
 fixed
> as far as linux-next is concerned, but any non trivial conflicts should b=
e
> mentioned to your upstream maintainer when your tree is submitted for
> merging.  You may also want to consider cooperating with the maintainer o=
f
> the conflicting tree to minimise any particularly complex conflicts.
>=20
> --
> Cheers,
> Stephen Rothwell
>=20
> diff --cc drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 948583fdcc28,26954fde4766..000000000000
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@@ -1237,9 -1861,8 +1861,8 @@@ static int ena_io_poll(struct napi_stru
>   {
>   	struct ena_napi *ena_napi =3D container_of(napi, struct ena_napi,
> napi);
>   	struct ena_ring *tx_ring, *rx_ring;
> -
>  -	u32 tx_work_done;
>  -	u32 rx_work_done;
>  +	int tx_work_done;
>  +	int rx_work_done =3D 0;
>   	int tx_budget;
>   	int napi_comp_call =3D 0;
>   	int ret;

Thanks, looks good to me. Sorry for the inconvenience.
