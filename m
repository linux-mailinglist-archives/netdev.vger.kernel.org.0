Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D48817A6
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 12:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbfHEK4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 06:56:34 -0400
Received: from mout.web.de ([212.227.17.12]:43833 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbfHEK4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 06:56:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1565002579;
        bh=ibIhC5TdU9NvBIHLlKUg8dkM6XZ2mlZ/1npQ9zYfPv4=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=kfheZN/PgJgKag8xNoTv614JXs4TGVMz+oTI06qdbcPtyJAn9ExfU6T/lTLVAqIDo
         upi5KpaayRJ5wdBJg5NhOSz6cVttlfzoiX/AtW/aP9qdku2mcRcU5n/KdD+e3H5aJx
         Pw/8geOpZglbPWrDwVyy88UNNo2UeH1j+l3dUjr4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.163.134]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M8Qpi-1iHMP32hLW-00vt1r; Mon, 05
 Aug 2019 12:56:19 +0200
To:     Mao Wenan <maowenan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190805012637.62314-1-maowenan@huawei.com>
Subject: Re: [v2] net: can: Fix compiling warning
From:   Markus Elfring <Markus.Elfring@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <6fd68e9b-a8ae-4e5e-9b23-c099b5ca9aa4@web.de>
Date:   Mon, 5 Aug 2019 12:56:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805012637.62314-1-maowenan@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2TFWNZSwQt0Tq4ZoU3im11KlrQg8sj6g8hCK0p83YyWKEreAjti
 8WgmE5wSJHVyn+5l3aAsTJiqTIVeK13/Gu9Ykk9azoUr4NoyXFIRbyqcPcV3QZ8Zfguuuy4
 NjR1S2GfM6c0BSkLYGgf9ccRo1K9xRXR4o6VaAsrDXXe91gGtxNWuXP6kU5uTEmqyz3Lwq6
 qJGCCpBSIZp/uHPjkjU/A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3Q5UT4ok0sY=:IziTGb3BEwEeVDU+quy0gw
 QJ3Dcb6T1N6ZQK427iyNY2CWfMPCCmFKVt58GglDx4jr6QODnDDq+v28ryQ1kReqvrNub6Nof
 zYdqJuh60z13V0GL/Hs3mFhQ0ihrzhij8CgwpTGGcSzsNUzguCRNHWrv4DimosSA67oUSudyD
 YzGdqjwW/CGbUNPu+cGmqAAEm13ekLBhC9e+4RTrtENIhE1ny1k9ycyZ2Utz62Hn0c9DlWKTA
 1RNWmZeJ0nDQ4fZM52mPf4vTUQfuqmJSvaFtUtYqCzm2xIVwbOeLU6SBqRqexZ/+VwoGec/my
 pXQw+mudAbVZz/WKcs3n0FvG+f2+ZBt7KJwPXrhDscvuECYeXiPeZGOGatSboMC2ydCuRDvXZ
 tCPlJHD8vsrXYU53qOrG985l/LoUuYPlN49Ze/RUWa2qydvlrBSTSY+xc5UktEPBAUX3YEfyd
 A6u5r+iNSP3yV5Y0r8tlU7z5m9ONOft3JEfdVb3hH0aFOeSS90czMuf84Q3cqDY+NnDGb/MZ9
 Zg6IleJ6X24SOlPFDuLs4T1e/Yz1MSKGbr0NbIFdkvdyluQcWWI5+o1MMA6FSiGh0Uikwbiwr
 Z0C0fG58O9xueHpJxKBAhiPA7BegdiCCnl/dBqjobLkn/27NAotuUY0VDw8JgUvpBVXNL0Dt5
 IvHO0cfNSFsvsRzivRecQ/2QZbZK5iXYSRc15UwxmcOrNCz7Xu4RQ5UlnR0hrWxZblCu75lF5
 ixeuCU9uBfiGwy6MoR6IxYk47r9sb8Moit4ZFL1ERuD5aYVqtVPhxuD9OmgR4FKDPS4b7duoO
 unoq6ZGt80f5TMszoFVTwUHYYX/X1yirhWuj25Vrmbk3rZpucELWSsSb/EG7bm3o/EZzKpUF0
 i86aH5kxh0DFHmJCT4FNmgOGg9bAZHDHqSzL8K5gY7g5EiN+Au7DNmlEyONFV6Z0Aq05tXM1S
 SFJL2F4J0Wt9stuYCs/CahAS8h0PIrwG05l30YdH5G7eVhueJDe2/w/9P2juTr/SjJcz8EzFv
 i8G2sS2FQ+nKud4UaYdFFdcQgXTwWLyCw67m8KpmHFgRRioymNEAOLSfUyVf3dr4nXsCG6sId
 ryAv9VXmsUJ05o/yHL6S7dp0KCnqVUX4OHy9pRV+o4TnhsKuPiQBgyVjnDldmfuIcaRl6W8z1
 hjp7k=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  v1->v2: change patch description typo error, =E2=80=A6

Will an other commit subject like =E2=80=9C[PATCH v3] net: can: Fix compil=
ation warnings
for two functions=E2=80=9D be more appropriate here?

Regards,
Markus
