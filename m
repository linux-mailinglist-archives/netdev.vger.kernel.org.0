Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B39F610C48
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 10:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiJ1Idr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 04:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiJ1Idl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 04:33:41 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494BE1C4924
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 01:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666946020; x=1698482020;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=kbF8Ifln1vfJ7oi0pXdVpnSYpDhIbD9zjTUx+RWV/dQ=;
  b=T2BiytXFta9lcZDa3DrTGGcpunPWsZrGX7P4A6fVi1NmrQlAiymGYJSr
   jV8c7Q3xuJZcaqmYwnys3Tecm7MBJCJhzEW9G3agkf0LClYGh4MJoDK5a
   7bmzj/liWEC4d8EhgJk9rJf9so5ffJumBUkp6sfDIKEvs9WwsrA7RXN8I
   Jep9kyeRWHYVfS3BjbWNGJRXOM2VFX7sGGgx8tNDP4vhA1E6Q4MDlf+sR
   POZNhvBpCdGBG4LNhI/RreAoCEbiHcIHQ5FA1558fUe5PjtEsjgChFN4Y
   BOgT/VjZoA0mjI3uFs8fte9o1ji1w0r8fJutHtOnv8I00+BBRkA7nRaJW
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,220,1661842800"; 
   d="scan'208";a="186667127"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2022 01:33:40 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 28 Oct 2022 01:33:39 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 28 Oct 2022 01:33:38 -0700
Message-ID: <62c4839f3d2fe01eb3b02ac0d38e3415c6d73cdb.camel@microchip.com>
Subject: Re: [PATCH net-next] net: microchip: sparx5: kunit test: change
 test_callbacks and test_vctrl to static
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Yang Yingliang <yangyingliang@huawei.com>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>
Date:   Fri, 28 Oct 2022 10:33:37 +0200
In-Reply-To: <20221028081106.3595875-1-yangyingliang@huawei.com>
References: <20221028081106.3595875-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yang,

On Fri, 2022-10-28 at 16:11 +0800, Yang Yingliang wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> test_callbacks and test_vctrl are only used in vcap_api_kunit.c now,
> change them to static.

Correct, they should have been static.
>=20
> Fixes: 67d637516fa9 ("net: microchip: sparx5: Adding KUNIT test for the V=
CAP API")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> =C2=A0drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> index b01a6e5039b0..d142ed660338 100644
> --- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> +++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
> @@ -204,7 +204,7 @@ static int vcap_test_port_info(struct net_device *nde=
v, enum vcap_type vtype,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
> =C2=A0}
>=20
> -struct vcap_operations test_callbacks =3D {
> +static struct vcap_operations test_callbacks =3D {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .validate_keyset =3D test_val_=
keyset,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .add_default_fields =3D test_a=
dd_def_fields,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .cache_erase =3D test_cache_er=
ase,
> @@ -216,7 +216,7 @@ struct vcap_operations test_callbacks =3D {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .port_info =3D vcap_test_port_=
info,
> =C2=A0};
>=20
> -struct vcap_control test_vctrl =3D {
> +static struct vcap_control test_vctrl =3D {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .vcaps =3D kunit_test_vcaps,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .stats =3D &kunit_test_vcap_st=
ats,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .ops =3D &test_callbacks,
> --
> 2.25.1
>=20
Thanks for providing this fix
BR
Steen

Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>


