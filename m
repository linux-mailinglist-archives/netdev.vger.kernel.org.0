Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEE4E12A176
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 13:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfLXM4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 07:56:37 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:20291 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfLXM4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 07:56:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1577192197; x=1608728197;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yEtwKrmSm2nBDgX8plaJXUjABbI45dTZe5dZwGG7xpo=;
  b=sLsvDXuupv64+3ogGbQng97DKJnlwrqyPewuUMo0AxR0F9770UmYqwlu
   rcs/UQomvxgrEb3dMVu+psW5Pfcmu8jpQGhYTiQ7d7Tav6Lv5oI09CFIv
   5clhuPA2bfiUA9nObf5nV/051EEh9ySqaUE3gqfoINNbcX6AiqLKxC9XH
   Y=;
IronPort-SDR: hvsLMFnd7tHrJiqSfM+1rOSWUxtnpZpvdXzATacCljDV4MUroG8S1KJcgxeddapq60ob1vzTV2
 HeObGvetGmWw==
X-IronPort-AV: E=Sophos;i="5.69,351,1571702400"; 
   d="scan'208";a="9012568"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 24 Dec 2019 12:56:36 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id E47E9A1D17;
        Tue, 24 Dec 2019 12:56:33 +0000 (UTC)
Received: from EX13D11EUB002.ant.amazon.com (10.43.166.13) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Tue, 24 Dec 2019 12:56:33 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D11EUB002.ant.amazon.com (10.43.166.13) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 24 Dec 2019 12:56:32 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1367.000;
 Tue, 24 Dec 2019 12:56:32 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: ena: remove set but not used variable
 'rx_ring'
Thread-Topic: [PATCH net-next] net: ena: remove set but not used variable
 'rx_ring'
Thread-Index: AQHVulkN8QLfJfz+AUa2ZbHSPtnTmKfJPixA
Date:   Tue, 24 Dec 2019 12:56:32 +0000
Message-ID: <64328693e17744688e90e49cecd11aeb@EX13D11EUB003.ant.amazon.com>
References: <20191224125128.36680-1-yuehaibing@huawei.com>
In-Reply-To: <20191224125128.36680-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.197]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good catch, looks good.
Ack, thanks!

> -----Original Message-----
> From: YueHaibing <yuehaibing@huawei.com>
> Sent: Tuesday, December 24, 2019 2:51 PM
> To: davem@davemloft.net; Jubran, Samih <sameehj@amazon.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; YueHaibing
> <yuehaibing@huawei.com>
> Subject: [PATCH net-next] net: ena: remove set but not used variable
> 'rx_ring'
>=20
> drivers/net/ethernet/amazon/ena/ena_netdev.c: In function
> ena_xdp_xmit_buff:
> drivers/net/ethernet/amazon/ena/ena_netdev.c:316:19: warning:
>  variable rx_ring set but not used [-Wunused-but-set-variable]
>=20
> commit 548c4940b9f1 ("net: ena: Implement XDP_TX action") left behind thi=
s
> unused variable.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 081acf0..894e8c1 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -313,7 +313,6 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
>  	struct ena_com_tx_ctx ena_tx_ctx =3D {0};
>  	struct ena_tx_buffer *tx_info;
>  	struct ena_ring *xdp_ring;
> -	struct ena_ring *rx_ring;
>  	u16 next_to_use, req_id;
>  	int rc;
>  	void *push_hdr;
> @@ -324,8 +323,6 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
>  	req_id =3D xdp_ring->free_ids[next_to_use];
>  	tx_info =3D &xdp_ring->tx_buffer_info[req_id];
>  	tx_info->num_of_bufs =3D 0;
> -	rx_ring =3D &xdp_ring->adapter->rx_ring[qid -
> -		  xdp_ring->adapter->xdp_first_ring];
>  	page_ref_inc(rx_info->page);
>  	tx_info->xdp_rx_page =3D rx_info->page;
>=20
> --
> 2.7.4
>=20

