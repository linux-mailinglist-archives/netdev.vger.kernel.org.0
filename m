Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35C5235706
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 15:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgHBNO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 09:14:58 -0400
Received: from mout.gmx.net ([212.227.17.22]:43775 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbgHBNO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 09:14:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1596374093;
        bh=DSad71Zk678qylLHNErfeqoZOG0r1atupcK7uPYhtns=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=b8yTjGXOpeJegWgcwisHnmw3rtaFXz7sLAWyUW/z/27E+mAOJv/VMQ4rqT88scW3l
         yfxTiNfCu+jC0c2MllUOsZlfEk2ejDezT+CVDJrhlEZ3cQ/qNOR4tYapM6Xt5CLdwo
         V0NXOQ+ACYaiFztjAJ0kwfpbdni8WrsjCVTY3bYE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([84.154.217.86]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M7sHy-1k63aB1Udm-0051NR; Sun, 02
 Aug 2020 15:14:53 +0200
Date:   Sun, 2 Aug 2020 15:14:52 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/2 v2 net-next] 8390: Miscellaneous cleanups
Message-ID: <20200802131452.GA2321@mx-linux-amd>
References: <20200801205242.GA9549@mx-linux-amd>
 <20200801213204.0a52a865@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200801213204.0a52a865@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:mYlJ9oqSGLDcrv4eUw9eFBWMtSxzb5O7Gm7pUBpH45A508cg0cv
 JbMTuNlt/m1yZQ+ThoTbO4XxBvtK2Q4xVIVmdKbiER7J3UVvY2e5uXF6npJ529j9o2wDT0j
 5hKWfzeJfshkhjWQ2Uh4hUOONUgfEBV8stRIKphd21ukfSlAdJIj4tzh2na8p605BrcnI/B
 emQ7NQLmjsM67GMftujVA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XlXXdZL4h7Y=:IebhA2/ucyxAm8XlCuWR6G
 15uQBtX0B4nWMNaxvzeWfCtpsRpIJ/e2Gm70csmWBKMGqzP55n/QtBTsh+hgt3l+8FBrPf/zW
 9xnNCcVUYcNazXLl+c+db9VXhXLPU9GyruJinYmTLwrJ00zedTiEkuFK+exQqhL05SV8SZLEP
 8cLu24ZQ8A+n07FsjdSjrSyRlpZAvZoK0JwANUwwmB8HpazDb5prSc/u3CuHRlBodGQeusIyr
 A/Tc33RIiZqrWDJeubDE2idNKrFKV4uYX7osgaGG+Xq8R8xhBW8b2iE4wr6qofcJVQhiVjS4Q
 ldWDJtnSOMJWq+fxWMlHFeCGiApDlt/J7pnQ2LOJnvIbmxzrR9tlQE0ql2zrGhwG73licxFY9
 mAmc0MbS1e0r6/JNeqgLQKPZtCvJtJxN9ll5eeK26b/6X2D28RZ4bLORL5DSf+P5iVjmHrzp5
 CnonfpT7rULNSa+wHq+LUUNaZcqHW/7MCq36ybfzTdh1/INwaQmC35sQ6Qx42ngioOfhUZ6Is
 nqJ0qIz5Rk4WHdeFcorXR2wLpCmIYUyEgYOHbDB6W89H/NQgziXzRxz75H5JgdE+JVaht0V43
 7x9fZE+N2/+uhF8A6rdqd7J9gZFmMNaAixqTH4416FeH9uU7246fdT2RumKTvzk7xKaeF5GSK
 SFG1Co1wAMtsgDqr1sTBGwyJQ2B9hDTvs9j0L/EgyanhuFRQ6MCrmb+rFEjbmKdPru0H8X/0T
 cQsDrfOGAf8omb6qdv055AlnUfUwdONQi8SopISToasrAQKwdfwVb28l1xoPvzqCY7EH5whfW
 LDkKGOlVHNNdZkVoakT4Qt1OUGim8NgEZKCIrjXU3S4Dzh9mrnpXgB+dfoRal8qpYCN4hGzIo
 B1dvCgLVqogqAWMbwcl1+6RQBAqFCE8Ho7M556Pq0INvQeV6TY0zNrdbMWWoND55PaVOfRN1J
 osm4bKfM+01htRw4Ezn0d4tmrhYKJ6HIlbfO3cSWD+fvgU2XaO38PMC4OjAup0IwCor9qFiks
 KLs7SLIeuXD4LH8sfNp+sHbwcFnvk4Hp62HgO+ltJIcc+unbNhUkUDNw5X+ME+A504ZrgVu0r
 U4PkeAluZHryQB6p9za/J8u1YdfX2baZz2ErMvPqt0UK5/YfJ1VoSDTW1azctNALXbZw5A5zZ
 Bre76/z/kS8DludFvVIjbr1BWfMtsIQLlR7x46xxRU1qz43m3Xjp0fzONnJ07kbgSzCcCs3Tu
 eUBde32J5uemHDCbJ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 09:32:04PM -0700, Jakub Kicinski wrote:
> On Sat, 1 Aug 2020 22:52:42 +0200 Armin Wolf wrote:
> > Replace version string with MODULE_* macros.
> >
> > Include necessary libraries.
> >
> > Fix two minor coding-style issues.
> >
> > Signed-off-by: Armin Wolf <W_Armin@gmx.de>
>
> This doesn't build but also
>
> ../drivers/net/ethernet/8390/lib8390.c:973:17: error: undefined identifi=
er 'version'
> In file included from ../include/linux/kernel.h:15,
>                  from ../drivers/net/ethernet/8390/8390.c:9:
> ../drivers/net/ethernet/8390/lib8390.c: In function =E2=80=98ethdev_setu=
p=E2=80=99:
> ../drivers/net/ethernet/8390/lib8390.c:973:17: error: =E2=80=98version=
=E2=80=99 undeclared (first use in this function)
>   973 |   pr_info("%s", version);
>       |                 ^~~~~~~
> ../include/linux/printk.h:368:34: note: in definition of macro =E2=80=98=
pr_info=E2=80=99
>   368 |  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>       |                                  ^~~~~~~~~~~
> ../drivers/net/ethernet/8390/lib8390.c:973:17: note: each undeclared ide=
ntifier is reported only once for each function it appears in
>   973 |   pr_info("%s", version);
>       |                 ^~~~~~~
> ../include/linux/printk.h:368:34: note: in definition of macro =E2=80=98=
pr_info=E2=80=99
>   368 |  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
>       |                                  ^~~~~~~~~~~
> make[5]: *** [../scripts/Makefile.build:281: drivers/net/ethernet/8390/8=
390.o] Error 1
> make[4]: *** [../scripts/Makefile.build:497: drivers/net/ethernet/8390] =
Error 2
> make[4]: *** Waiting for unfinished jobs....
> make[3]: *** [../scripts/Makefile.build:497: drivers/net/ethernet] Error=
 2
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [../scripts/Makefile.build:497: drivers/net] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [/netdev/net-next/Makefile:1771: drivers] Error 2
> make: *** [Makefile:185: __sub-make] Error 2

Did you apply patch 2/2 of the patchset?
Because version-printing (and the need for a version string) was removed
from lib8390.c in patch 2/2 to allow the replacement of said
version-string with MODULE_* macros in 8390.c, and failing to do so whould=
 result
in the exact same error.
