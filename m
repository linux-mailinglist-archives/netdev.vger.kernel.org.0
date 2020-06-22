Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9AED203663
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgFVMFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbgFVMFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 08:05:35 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EACC061794;
        Mon, 22 Jun 2020 05:05:35 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jnLCf-000875-6N; Mon, 22 Jun 2020 14:05:33 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 9/9] dt-bindings: net: dsa: Add documentation for Hellcreek switches
In-Reply-To: <87wo43phk0.fsf@kurt>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-10-kurt@linutronix.de> <e8085c6a-0b61-60f9-f411-2540dec80926@gmail.com> <87wo43phk0.fsf@kurt>
Date:   Mon, 22 Jun 2020 14:05:26 +0200
Message-ID: <87ftantiex.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri Jun 19 2020, Kurt Kanzenbach wrote:
> On Thu Jun 18 2020, Florian Fainelli wrote:
>> On 6/17/2020 11:40 PM, Kurt Kanzenbach wrote:
>>> Add basic documentation and example.
>>>=20
>>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>>> ---
>>>  .../devicetree/bindings/net/dsa/hellcreek.txt | 72 +++++++++++++++++++
>>>  1 file changed, 72 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek=
.txt
>>>=20
>>> diff --git a/Documentation/devicetree/bindings/net/dsa/hellcreek.txt b/=
Documentation/devicetree/bindings/net/dsa/hellcreek.txt
>>> new file mode 100644
>>> index 000000000000..9ea6494dc554
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/dsa/hellcreek.txt
>>
>> This should be a YAML binding and we should also convert the DSA binding
>> to YAML one day.
>
> OK.

I converted it into a YAML binding. Should I provide the dsa.yaml as
well? Otherwise I have to define the DSA properties such as dsa,member
in the hellcreek.yaml file.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7wnoYACgkQeSpbgcuY
8KZx0g/7BDwrxEf4tPOoJOwHTWWNxvd3O5QGMGbfIND9QrcRwZjIsrUobuU+MVY5
fxOWBByWR5kUAPPJS6TceCULoyjEYuCiiCc1FsshL5gkRotTRteKp0uH6OKFf0oa
zvbrfvwugLtYV9j+JmZ6I78SpZTfzZ4XcRLXXmuplcjEs7tw4TMq2XiuKKOQh/kA
rjqg+T0UXtnpNE1V5+jMroGQrC2GJwN1DkarokZje+FOHzb9Cl+pTsiQA6WJFa37
KG9Apr8QTKXg6IAkkX6jMcZue1TqkfCHt0Ve2C1e7zVTaoqV67xX9xm3kyePYS1v
WQCxHr/Bn/BjVMahgsD/dHcIF18AnPIbVAc72a9v4HfZxrH/+qvLuNmkw/1cOXAx
GF+8lqm9UoZ8X6vgru7B/kBveFS5NycjfroQkBN0rztLYukrhbh9QbGe60Fp+49H
KsyvqqnDA2FhPXd6AfoJpK/6QTNRyUOu41/aUVCEdLH200Dz8VKoqR0O/D5nDr1Z
vFC1CSV/GuSGUPQE0GS/BAtpaVNKZBH99YrNBqqqZMa5pv54G51Plwvp7oBueh1W
7nW9FC/k3vYS6b+KGfyS6VZtPXEXZvDp/lEy+BUJ88a62dGrwXnfi6kI1RrfDQGu
295hxZOwwk/c/lAFhniHt87tESQdZQSPxkEQ38phogFnxhi2eug=
=ioWG
-----END PGP SIGNATURE-----
--=-=-=--
