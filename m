Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CD3A7CCF
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 09:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbfIDHcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 03:32:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36323 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfIDHcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 03:32:00 -0400
Received: from [5.158.153.52] (helo=linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt.kanzenbach@linutronix.de>)
        id 1i5PlX-0007CC-1C; Wed, 04 Sep 2019 09:31:43 +0200
Date:   Wed, 4 Sep 2019 09:31:42 +0200
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        vedang.patel@intel.com, Richard Cochran <richardcochran@gmail.com>,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        xiyou.wangcong@gmail.com, netdev <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH v2 net-next 10/15] net: dsa: Pass ndo_setup_tc slave
 callback to drivers
Message-ID: <20190904073142.GB8133@linutronix.de>
References: <20190830004635.24863-1-olteanv@gmail.com>
 <20190830004635.24863-11-olteanv@gmail.com>
 <20190902075209.GC3343@linutronix.de>
 <CA+h21hoVv0SwFf8=MS_SZf85QsObrNKQf_w_p=j_97i16psjDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <CA+h21hoVv0SwFf8=MS_SZf85QsObrNKQf_w_p=j_97i16psjDQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Vladimir,

On Mon, Sep 02, 2019 at 11:49:30AM +0300, Vladimir Oltean wrote:
> I did something similar in v1 with a .port_setup_taprio in "[RFC PATCH
> net-next 3/6] net: dsa: Pass tc-taprio offload to drivers".

Okay, didn't see that one.

> Would this address Ilias's comment about DSA not really needing to
> have this level of awareness into the qdisc offload type? Rightfully I
> can agree that the added-value of making a .port_set_schedule and
> .port_del_schedule in DSA compared to simply passing the ndo_setup_tc
> is not that great.

I wanted to avoid that drivers have to the same kind of work, and it put
it therefore into the core part. However, I agree that the added-value
is not that high for TAPRIO.

>
> By the way, thanks for the iproute2 patch for parsing 64-bit base time
> on ARM 32, saved me a bit of debugging time :)

No problem :). That cost me a bit of time.

> Regards,
> -Vladimir

Thanks,
Kurt

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl1vaF4ACgkQeSpbgcuY
8KbU/g//YlZxyN0osVyXXOfrLsOUmd5JJGptlEGa4twAqZxKQbhu5TD2l0kEf8fn
z7gXfkAyvH/bvo7ufT10PeSQJ4eB+iqsWhxnwfqCuNQMstrkils/qq4A5pMWoVTi
69jEF+lWBwTcOKOVCLF5p16BvydbaDuDLMH3tN5HOs5cpaOHb/0Dw7U7vs0YmYjJ
veZo+iDZmwVMjGP99uTGf1JztLoi5Uv0ML9etnuaO6R4j/liUEKYAgjKO7YNTAQ9
JZJW2G6SvHkO+otFDT31KgK9IZFIhiK0JM+NKEu7yq2jS713ZXX29Z51RRMeCgBH
OS5NNJHNIJb3uETe3MUVu8JoR3KmEVkNT85riMIsAyXRBmwJ4mIFTXcZCg+9DuqP
ykzxXJXRo8+RjCoG6SB3sCpjtnp2dAQ0FEwvcNaqxG61qT/ZuBwqH8vBOo1AZRqC
Mf0Vd/5hC1pLmRz2wnMGRMDFtx6oEAadmqir0TastMVf0inEFbxvrUhzfWApVep4
w1Ts02o6RF8QDcCYfnsc+y+cqABnqZsgcrX1gB/zNJG9T2mjj4u3z+FHwRH2i3dv
mkTXuvliP2lPgWlO5Ig8i4lgSriwXyeZ/HcrFHYJNZ+i0198F8mQoA0ZiCnBY1Yf
Je8WE21MbZESy95TefIwKYaHrw+mGO48KV8ktrd/vWUk7W0GqaU=
=Hk2+
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
