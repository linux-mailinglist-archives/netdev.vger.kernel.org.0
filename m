Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99FACA4395
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 11:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbfHaJQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 05:16:24 -0400
Received: from mout.web.de ([212.227.15.3]:54289 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbfHaJQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 05:16:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1567242926;
        bh=W42yxbYmQCv9tl6YPZs0YFC5fDpZrDuUEO40d5+J5IY=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=Rb418DWmi/RVbd8sECvNY7M6am3zzXtvu6Z8MKvDEcaqy80J5NzEeIsZquRc+o3+K
         RcMPUbulCWil2CYSmPwWqfOWbsvJq8lYGIRKuYobskoTbIVH51G/a5nLZzGK7B0dUo
         Ub/VAcIMteSPNk9yZ43wLPYl/AxtOIz+Ty7w1ZYE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.129.60]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MXHt7-1hjODj0cab-00WIUk; Sat, 31
 Aug 2019 11:15:26 +0200
To:     Denis Efremov <efremov@linux.com>, Joe Perches <joe@perches.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Anton Altaparmakov <anton@tuxera.com>,
        Andy Whitcroft <apw@canonical.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        dri-devel@lists.freedesktop.org,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        Leon Romanovsky <leon@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, linux-rdma@vger.kernel.org,
        linux-wimax@intel.com, linux-xfs@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        netdev@vger.kernel.org,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sean Paul <sean@poorly.run>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        xen-devel@lists.xenproject.org, Enrico Weigelt <lkml@metux.net>
References: <20190829165025.15750-1-efremov@linux.com>
Subject: Re: [PATCH v3 01/11] checkpatch: check for nested (un)?likely() calls
From:   Markus Elfring <Markus.Elfring@web.de>
Message-ID: <0d9345ed-f16a-de0b-6125-1f663765eb46@web.de>
Date:   Sat, 31 Aug 2019 11:15:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <20190829165025.15750-1-efremov@linux.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qKSdXHHLYLKjlRCvxxm0CG4/ObWxvY7GHVNBMu8mxxGycRrayx8
 4PbzO2dvqjNnF+AFg4bA1W4zmeQSpNZ7vt9DbPnL5lk34WKJYWD9NUPM0PlrCLMjYkm1F6U
 BXfMva6PP5qxs+6jegtT9nR1r+jzSjNeTTC2AqMHglXEtSWbQLq9Fa4eMsUVMGo2eepnDXr
 VwnOxGgwPijQTQTX/f+uw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nkNVUAuCw5k=:pAP5U5L7C1x2boPp1IRXmn
 D13IzlXT/kI0Odb0OEskHBv1fRCMj7J727enJOB+vAgZd2n6ZXAAaWlSqHLVcohKzncPx6QpO
 Jkkz3w/W/rmQNzfpoIhIUW3Uccf/fl14QBw5X5i4PyFGDK9jzI0Phtg8JML9FgdHalKCIpNWP
 o213QJNReSqJUzIClMxbcGq2voyTmxMmGEwBIXqC58OGwigFy7zuu2Fy5ondTj8F6i3gbb38h
 c6JrfIYpAxvFnO9nRMcO25oqflwZdAfHvFzJ2iu+3r8XsTgWukdxyVbMiL8ftz50QxC2DJqzq
 Ayqcpn0a9Y7cTytKg/qxVHdxdOIF48+PWbHaSEgzP4SLLOPElveDdWhJEc0vM5xdTU1Dqb7hM
 NcCaA0zHOKUIDqcYJ6jN44G6CZgVS/MFofCq8QcCo4GFiBNWMHS4cmZtOpUQJMXQuRbrwvm5s
 QLUFHQhzpAX2K0Aj8VIVILu1mHvF1oeAJg0lG6KqkOeZEm+Unicxfz9HErsixNGFodYh0D3/K
 Pus4ocado7zBlJoZThrgPZ8TvIHn8mX0WI7LW+JhXvD1rFkJmT4VMVuezkSvp3NJ9GaBnkiEN
 2DsKyjBxY/6mcp9cg5MLZTh0zU4f7ZpgvIRT7mBBrJ5TGKKmZLH7U/Z5qQmwJz28iIVaVlH4p
 wK8w2niZej5noXMTOemcJJnIR+evko7BhWXbZHiUAALjl38emkz357bvLjEkVGm7h8qIAQyjv
 9Ffe8YuiaY+tWayyEFK6qfYIHwGdEZNrYmIuX9tupSwJCJ8bCFsx9n7SNCZvSRm61MjQsWB76
 icYRtytGOYmCsolycXG6KEM734RMbdaPv2pCjSKPk80uNsPY10n0pxzKUpdSnG1O5lboelK/K
 +pQTb7oUbCkyxCvKMOBAo+HHvPT1QQcSGkQreepWbCChdY7O5TxdjvwnEYYPBYSyBIKA4j2t6
 gmzI4FQ5Tbv5lKlap9HBlQSeD5ynZnaeINJfHFu/XpQei9uMkeptC8IYqtcno5/KHj4gVLoN6
 dvIF455p6LB73n4l5ci1UNJB4L7BiFhMmqFWnfszzCVLZrOOA94053rwKZECu2B8PgnRB8RwQ
 RHR8X1QZRRFkw/YnadMqgavlvTg6QJ2wAh3pxzJ+iXjpxC1IgfnMhR3w1p3UqTC4whz3ngKbv
 qqUbKY+8ilN57KkwviQJZULRks7t3CtGMgptQJeouQnu6rZg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +# nested likely/unlikely calls
> +		if ($line =3D~ /\b(?:(?:un)?likely)\s*\(\s*!?\s*(IS_ERR(?:_OR_NULL|_V=
ALUE)?|WARN)/) {
> +			WARN("LIKELY_MISUSE",

How do you think about to use the specification =E2=80=9C(?:IS_ERR(?:_(?:O=
R_NULL|VALUE))?|WARN)=E2=80=9D
in this regular expression?

Regards,
Markus
