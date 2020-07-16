Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710C0222043
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 12:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgGPKGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 06:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgGPKGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 06:06:19 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C106C061755;
        Thu, 16 Jul 2020 03:06:19 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594893977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BMbqYGokbYrWYQCKCQhi6GP/hhiQLqCSaGXZcbfEaDQ=;
        b=xepg9aIwWA349TVA8NJuVWIT0sHXzOg3sRkcbaQNTPmfVVCHMdop/CsQCjlkKawPg7ULDV
        UYsvK1eXe2Iuao6kVxnrn+mTQ/lqFHAH83WMaVKfIW9Y3Q4z+jNV+veKVMQmM5EDPXiBkr
        2p61p9ZrliXW58aLNRevVTfMJn9ep4vq6n8DssOHtXZU3NSnTXggu0dypsC3KDaNYL+637
        pXpGl3+dkQn0os/ABP3gEUWtgDTOG8VqSYbOhqrhr6knDp91fW97E7gw6qvu/BmHMRMScH
        bH0bfj+74eZcs4AEq4BXOPhXdQ6PgUyoTZItZBICjRWzavdJzfc6SwINWYH+BA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594893977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BMbqYGokbYrWYQCKCQhi6GP/hhiQLqCSaGXZcbfEaDQ=;
        b=Uyl275Hwl9eTMks7AqpAcj7t5k4R+dDlGwFRfyLQD4rt40MhZsk8aFdfTL95Z2uuEsmhTN
        BY6QquKFw7MZXMAA==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v1 2/8] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20200716093924.ueszkwokaer42vjh@skbuf>
References: <20200710113611.3398-1-kurt@linutronix.de> <20200710113611.3398-3-kurt@linutronix.de> <def49ff6-72fe-7ca0-9e00-863c314c1c3d@gmail.com> <87v9islyf2.fsf@kurt> <20200716082935.snokd33kn52ixk5h@skbuf> <87h7u7x181.fsf@kurt> <20200716093924.ueszkwokaer42vjh@skbuf>
Date:   Thu, 16 Jul 2020 12:06:16 +0200
Message-ID: <87eepbwz8n.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Jul 16 2020, Vladimir Oltean wrote:
> On Thu, Jul 16, 2020 at 11:23:26AM +0200, Kurt Kanzenbach wrote:
>>=20
>> As far as I know there is no port forwarding matrix. Traffic is
>> forwarded between the ports when they're members of the same
>> vlan. That's why I created them by default.
>>=20
>
> And your hardware doesn't have ACL support, does it (from the fact
> that you're installing PTP traps via the FDB, I would say no)?  You
> could have added a match-all entry on all traffic coming from a
> certain source port, and a 'redirect-to-cpu' action. This would have
> also achieved port separation in standalone mode.

Yeah, that'd have worked. But, there is no ACL support.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl8QJpgACgkQeSpbgcuY
8KbvExAAoE5iqojJzMxtwV/XHHZQar9n10rmGjL27OcwRUVgYstNB3oloeLq9LK1
1NoUomRcOTtkrdRVJkOSe4PfSBw+YOOxlu4qkQjG3X9yaK0ggRrm0jRxGIWUHRi2
cpxpAsHmXLGSftql+nKG3o/tiHUCXA1n3c/ccfNMcw8DDgFwyArfWPkjx22ZNw7N
YXNinh0Fa/b23v5gJVnKyuQA0UWLdu04MWDq5W3apAJgGMwPJhOUErnr7+xOy6b8
0hFovUeM25pOEsgSVxFDWq41WhAODEo8NBNnDLXWPdWt0olb4Ef7Yxb4C0AFIgLm
9f4wA+Ha6Fs7cDOsqrUP3JyOtqgY/cRUFFrZuJGQFadGg5I052R9aeseqhBN9RGp
pyCtQrFgTqsxUusRe7YX+f3C5xvCcw2KFcOiCUVaoRP9Tdru5LTS9xjWJ0NgAzxg
M4BP0UhpuH2yjKxWDQGyvd2zVBcTzKhUeyuRrJU7k6TIUTi/mjNdaceQ1UVep5Jy
VUfF3G/JENp+Y5Ehz8BWPr7e2qlOtLe3rzMim0vuIBGdIicVH3iACbZPVKbwA1AJ
iDH/VIaoDCm1xcS3m6EXs9L+lG73YY23pLqMd7AX+fCgvNhqlT4Ic1iP1T4cMawr
liqKFVdjrujBGzXX4xyWjdWiDs94NpofjzRDo121SbiB1UZegpw=
=szY+
-----END PGP SIGNATURE-----
--=-=-=--
