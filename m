Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD43659C19
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfF1MzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:55:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35897 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726660AbfF1MzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 08:55:17 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190628125514euoutp014edf00165e92c79c70efc940b797771c~sXf2Vz_jf3234532345euoutp013;
        Fri, 28 Jun 2019 12:55:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190628125514euoutp014edf00165e92c79c70efc940b797771c~sXf2Vz_jf3234532345euoutp013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1561726514;
        bh=GrXQNTXN4I9JHpQIL9zEkPq5zel3LSoEW3EB5ycEB2s=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Ng/LpVIzRsZ7uGyNkWHy/60hDS9y3MXaKxN/pLMXMT/Bss+fscGXO4sT151M0V6LW
         QnUUmI4ALzkM6LrKmpH2V91CL0TahcMQc1lrHnHJeNV17Pp51zvLwJ2S4ssCIqcPRr
         XOw/LyfRj5xsOxagZmKVtqZMHmRvG41kFNIfuAHc=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190628125514eucas1p1fd4db9f4161cfcae44ce131fc32d78ff~sXf19jycg2330223302eucas1p1v;
        Fri, 28 Jun 2019 12:55:14 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 60.05.04298.13E061D5; Fri, 28
        Jun 2019 13:55:13 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190628125513eucas1p149cf5397774d31921b4eee030d2d8500~sXf1JHVEo3050330503eucas1p1G;
        Fri, 28 Jun 2019 12:55:13 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190628125512eusmtrp1f2e2177567d58a7c6fc5cb876c1efe21~sXf06je0q1299212992eusmtrp1O;
        Fri, 28 Jun 2019 12:55:12 +0000 (GMT)
X-AuditID: cbfec7f2-f13ff700000010ca-72-5d160e310d01
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 2E.CA.04146.03E061D5; Fri, 28
        Jun 2019 13:55:12 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190628125511eusmtip2334885dcd96bf89cc8f0faa1cb1e303f~sXfzmDhKC0126701267eusmtip2m;
        Fri, 28 Jun 2019 12:55:11 +0000 (GMT)
Subject: Re: [PATCH 37/39] docs: adds some directories to the main
 documentation index
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jens Axboe <axboe@kernel.dk>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Moritz Fischer <mdf@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        linux-fpga@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-watchdog@vger.kernel.org
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <a89ef0db-211c-1880-e60c-dc599b36feb7@samsung.com>
Date:   Fri, 28 Jun 2019 14:55:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b26fc645cb2c81fe88ab13616c65664d2c3cead5.1561724493.git.mchehab+samsung@kernel.org>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTZxTee796qRavlcE7YRqbOZVkCnMuZ36NJcu8WWJCjGaLjGDVOzDQ
        anqpU7dkuPBZOnQyQ6hMwA8ooNAVggXEdWhbFKyTrwFaWCqLQlIRK9vcFKW9NePfc97nec55
        zklellROMYvZfdpMQadVZ6gYOdXsfOp+Jz48MjnO54iDCXs+gjrPMQbG7HkIym5lU9A3PcnA
        sCsHQUljLQP2p50ITD+2E1CZe46CzqJHNHhL/5aB0+Yl4FmrjYDe1jIG/N9fQ1D4u42BR0Yv
        A4P1V2RQkT0rHqvsJqD71xEGql0zBHjMgwRMPi4gwHbjDAnlR7dAZXcSOCsi4c6JEgo8NxwM
        vLg3TUN3Vw8NOed9BDRaT5Jwb3yGhPYRP0pYzjfVDBH8by3z+BaTR8Y3mmP5s5fHCb73pp63
        1hYw/EO3W8bXXLhA86OFLoI/W1RM857cjfzUn8MUf7H9AeInr/QzfFN/HpUYuVO+ca+Qse+g
        oFuzeZc8bWDkLnOgPvxQ07VSlIXG5QbEsph7DztdjAHJWSVnRvi8LQcZUNhs8QThbG+I8CNs
        f36fChABg3f6JCER1Qg/6x8JFT6Es9oMREC1iPsct/tdwVYR3Pv4utsRbEVyZjnus1iZAMFw
        6/EPebVBkYLbjP+q66UDmOKW46vmJ8H312cbjTottKRZiK+XjgVjhHFqbGm2BDUkF4WHx8oJ
        CS/Fl3xlZGAY5txh2PrCwki5P8Y/TxpDeBGecDXJJByDu4qNlGSoR/h5/oOQ+xLC1cUzIccG
        fNV1mw6cjORW4YbWNdL1PsLe776QYDge9C2UMoTjE80lpPSswPm5SqnH29hS9SpNDDa01JDH
        kco0ZzPTnG1Mc7Yx/T+2AlG1KErQi5pUQYzXCl+tFtUaUa9NXb1nv8aKZj9C14zrsQ1N9+zu
        QByLVPMV/8yPTFbS6oPiYU0HwiypilC84Y5IVir2qg8fEXT7U3T6DEHsQNEspYpSfP3aH0lK
        LlWdKaQLwgFB94ol2LDFWShae5NOO5Ikq4J3V/z06b9Lb0/E9C375uK2hzvyKrVl8nl6cUG5
        55fEUwkNsdF1H9hHp/xbfY5vNVXpQ5syNp26ZVnXdvqzO+v6MpfVpXBrV705evytgi93e7Ya
        h6jeDwdSEnYuaXD0VGyLK7q/stCY0ro91TxwbAl39ND6zk/aEv+rTl+posQ0dXwsqRPVLwFc
        V6c/BAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0yTVxiAPd+tpVvNZ0U4AzO2JmYGY7Ug9oUgarZlJ7qo0T9kjGjFz2Kk
        revXEi/ZohnX4mVOCWnDBogECnijTIsRqFWpl1oNeIPRLqldYiWKjrGFBNlKGxP+PXnf5znJ
        SV4prSjnUqR7DGbBZNCWKDkZc2/GG1y+cn5S4crQOw28dFch6Aic4CDsrkRQ/6CMgUeT4xyM
        eMsR1DnbOXBP3UZgP91LQVPFWQZuH3/DQsj2rwQGXCEKpq+6KBi6Ws/BxLGbCGqeujh4czTE
        wbPzfRJoLIvK4SYfBb7rQQ5avTMUBNqeUTD+VzUFrrtnaGg48hU0+QpgoDEJfv+5joHA3Vsc
        /Pd8kgXfvUEWylteUeDsqqXheWSGht7gBFq3hHQ7hinysOcD0mMPSIizLZ00X4tQZOi+hXS1
        V3Pktd8vIY7OTpb8UeOlSPPxUywJVOSSt3+OMORc7wtExvsec6T7cSWzJekbVa7JaDELnxQb
        RfMaZYEaMlTqbFBlrMpWqTM1hTkZWcoVebm7hJI9pYJpRd4OVfGT4Ci37/z8/d03begwisis
        KEGK+VU4NFlLWZFMquBbEO7zldFWJI0uFmPvhdK4sxBPP7FycWcM4arhLsnsYiGfj3snvGiW
        E/nV+I7/Vkyi+U4Z7q9zS+LFi2jR8wsza3F8Dj5Z2R4r5Hwe/qdjiJ1lhl+Cb7T9HZsvir7q
        G29j4s4CfMcWjnECr8UXL1+MOTT/GZ7+dZCOczIeCTdQcU7DV17V0z8hhX1Obp+T2Ock9jlJ
        I2LaUaJgEfU6vahWiVq9aDHoVEVGfReKnuDlgSmnCw1e2uZBvBQpP5Q3ypIKFay2VDyg9yAs
        pZWJ8o/8iYUK+S7tgYOCybjdZCkRRA/Kin7uJJ2yqMgYPWiDebs6S62BbLUmU5O5GpTJ8ir+
        +rcKXqc1C3sFYZ9get9R0oSUwyh5mH3KTKUZ0z3XPs1yr2leN+/jo+sP5m5eLCdLjwymOmq+
        eLTpzIndG1ULfjgkidTd77SNtTglX6Y/WMsWdFTrUn/bWSF/2O8Yae1/t9xtHW7J9+SMVjmV
        59ytjilD+OuNNvx9td0478eI45LuuyvBDa+DwWJ/Q9qy0VTaXFu09XMlIxZr1em0SdT+Dxpi
        Ik6YAwAA
X-CMS-MailID: 20190628125513eucas1p149cf5397774d31921b4eee030d2d8500
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190628123051epcas3p35e0cb4a5a1159dac19bde504ae21b0f3
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190628123051epcas3p35e0cb4a5a1159dac19bde504ae21b0f3
References: <cover.1561724493.git.mchehab+samsung@kernel.org>
        <CGME20190628123051epcas3p35e0cb4a5a1159dac19bde504ae21b0f3@epcas3p3.samsung.com>
        <b26fc645cb2c81fe88ab13616c65664d2c3cead5.1561724493.git.mchehab+samsung@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/28/19 2:30 PM, Mauro Carvalho Chehab wrote:
> The contents of those directories were orphaned at the documentation
> body.
> 
> While those directories could likely be moved to be inside some guide,
> I'm opting to just adding their indexes to the main one, removing the
> :orphan: and adding the SPDX header.
> 
> For the drivers, the rationale is that the documentation contains
> a mix of Kernelspace, uAPI and admin-guide. So, better to keep them on
> separate directories, as we've be doing with similar subsystem-specific
> docs that were not split yet.
> 
> For the others, well... I'm too lazy to do the move. Also, it
> seems to make sense to keep at least some of those at the main
> dir (like kbuild, for example). In any case, a latter patch
> could do the move.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

> ---
>  Documentation/cdrom/index.rst           |  2 +-
>  Documentation/fault-injection/index.rst |  2 +-
>  Documentation/fb/index.rst              |  2 +-
>  Documentation/fpga/index.rst            |  2 +-
>  Documentation/ide/index.rst             |  2 +-
>  Documentation/index.rst                 | 14 ++++++++++++++
>  Documentation/kbuild/index.rst          |  2 +-
>  Documentation/livepatch/index.rst       |  2 +-
>  Documentation/netlabel/index.rst        |  2 +-
>  Documentation/pcmcia/index.rst          |  2 +-
>  Documentation/power/index.rst           |  2 +-
>  Documentation/target/index.rst          |  2 +-
>  Documentation/timers/index.rst          |  2 +-
>  Documentation/watchdog/index.rst        |  2 +-
>  14 files changed, 27 insertions(+), 13 deletions(-)
Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
