Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529F31D062D
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 07:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgEMFHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 01:07:45 -0400
Received: from mout.web.de ([212.227.15.3]:48043 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgEMFHn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 01:07:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1589346444;
        bh=awRnFdgBH3fX5PWX/umE3yv7RIh+nzXqsgwIaGT6ulw=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=W6XQSLOB1mCX9j+it33gw5mlecyj/ONRtcT2dbzMq4NF5I2kcFmTQBhhYHi9I50bk
         1gPuc2u9ytijSHLkj/iyT8ZIxsbigp347T3egI8s5TZeO0I3vB9ZukAWhKhv0Pkq7o
         +lLisu+KGOnnLbekqlffjJSc0lK0bzmwbtclwS4s=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.102.128]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LphiA-1ivZZy1EtK-00fPph; Wed, 13
 May 2020 07:07:24 +0200
Subject: Re: net/sonic: Software evolution around the application of coding
 standards
To:     Finn Thain <fthain@telegraphics.com.au>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>
References: <b7651b26-ac1e-6281-efb2-7eff0018b158@web.de>
 <alpine.LNX.2.22.394.2005100922240.11@nippy.intranet>
 <9d279f21-6172-5318-4e29-061277e82157@web.de>
 <alpine.LNX.2.22.394.2005101738510.11@nippy.intranet>
 <bc70e24c-dd31-75b7-6ece-2ad31982641e@web.de>
 <alpine.LNX.2.22.394.2005110845060.8@nippy.intranet>
 <9994a7de-0399-fb34-237a-a3c71b3cf568@web.de>
 <alpine.LNX.2.22.394.2005120905410.8@nippy.intranet>
 <3fabce05-7da9-7daa-d92c-411369f35b4a@web.de>
 <alpine.LNX.2.22.394.2005131028450.20@nippy.intranet>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <47b7cfc3-68a1-b1da-9761-ab27dc8118ad@web.de>
Date:   Wed, 13 May 2020 07:07:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.22.394.2005131028450.20@nippy.intranet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nDSkwFdULNgSxdqXss3zH8tCBNaOgcJ5bAlcdfp7TSYfAPJfKtm
 tfZGduWzX34YpsHFUt4YG541/KZ8CaK1zpoy661EcS9LeoErtwKoYgRB1jqOwSqZ6z2UhH4
 2wsGUMrcwYOyWqHLzKh3jRUw6s5A7XncohHykvu9F/zAYxU9YD4S2crD4C6Z1KRIPLSJJ+n
 FUgA+hE3DhyNMjJJFVUsw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:YZm/vBr9jNA=:zzQC/HQYfzs3Xa6ho18ODk
 qqm9IRTsTEt6BVRdUK0ldMjd9mQQLVAnV58s/fIiT57HJp/5//R6rOsXbo5cp5aZRwOlUmE0T
 1Rb0n8OWvXeddv3WgMB53Nyp5RyLcRrS2KOsTo/GRWnxQXv1Q5ALruw3dDhGw5Y5rZHLrExtX
 cgPuWZ2ph76NHRPpfcN08u6JFbRYMr19sLLF7Iir1EPgxyfNZt6fXLCvQcizUrJPWtIc8UJOQ
 n8cv8iHfZH9vW3pW7s9fSYOBhH/Xn6wBXXg0Gr87bC+239iXxz65s/HPqy5m6hruIE9Ks3dN8
 jNbNMHXSWuYDGnAbnj6mMdPf+BcbNbmauJA/LkboUF2zZygzv/pBLnVH3/871oDMQe43IANLq
 Rt/2CZVTo5V3Pf/MPbDsmfG3cVIeWOW7lF9oVgta63Goktb9SBY+85nCD4wcI7SIjnS5hB63E
 uCYRoF07Mey8+t6aI31LwRftUdFbPbYOJf0wsK2mmtPvk/wuraN8uOnJFhi5IeI7/wq55Xgtv
 IJbFQ3+sHqw4HayIjRkyH4egVzaBi1FRPIuYaSPNm2tRkG5xnvRV6umYStMLqBVboXFAaV+Sv
 YO6v5E5plFUK78ZfkC6ZRlInXnCgw4rR9CM0a3SQ05K/7HPTP9YXNo7HSQIgW3YodlHT4Dm5O
 097mdVGsxW+YfZX7sGVgD7muCObwtxe/uVzOfPP406fE1YUsyWZZPmBa7j99hNkIy6wuqnwG/
 UAu8aoHJAOglqm0SS9Ntwvs2kQrXXv8mK96ZE2YZhqylBev3o/L4+eoalTvDH6jJ9DfmhzwzQ
 hG1Ntd2ThleuvAsXMeGFGGjObBumj8redm/ISPEF1sUb7i5cPRcILVhsb9pFzJHR8m9pjVwXh
 IzJ5Li5qtW/vioaK3KS0mgQohW0QpRWsd25nZ/Nnqt18Krp9qllHuR2mROeMA28cWI4Qa7MC0
 NI/IV7Wbe7OcxkwAYqflkPNQnxDT4ewaIegOOImmAgxr85lNuuOe16KrN1cMS5vppmjuaRQH+
 KSxSdwZlgLT5CKszR22VoKxQ2CxLEyDpV79TnzKUzLQCGRtF8yC+vmLTlySjeDR/Uk+y6VXwi
 mWPGsmRkPb8FK1S9UcyQNJFq/5AUzpYYA5O8KyxwyoxiWkrUiVHKmLihfUm1y0NIx37Z77Agd
 CnTjL76siMfyHFX4x3q956giukO/O9UtnloaCm9qTjC441C7xYkVcjolUtTi0QuGLDw9gjsvu
 1qYcyfkQvs6rlFfrL
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When the people who write and review the coding standards are the same
> people who write and review the code, the standards devolve (given the
> prevailing incentives).

A coding style is applied also for Linux software. This coding style
supports some alternatives for implementation details.
Deviations from the recommended style are occasionally tolerated.
But some developers care to improve the compliance with the current standa=
rd
at various source code places, don't they?

Regards,
Markus
