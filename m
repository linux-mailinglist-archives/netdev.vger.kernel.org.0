Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF811C64D8
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 02:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgEFAIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 20:08:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:54560 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729539AbgEFAIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 20:08:02 -0400
IronPort-SDR: DerOqEKTUV769U9+zHue3u1Xp0q3AfWQ4a5hznY0lARvmvkhMEjSWX1fZG44+UCY+zQTFSnJrg
 dcmVaSuP7jPw==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2020 17:07:59 -0700
IronPort-SDR: ThuHwn2JsgByygfEPGwh36daP8vNxCMNiPR6FsLxLNqHiQGrys4TWFlp3169w+BJIv0mFq6tza
 Pgy/lQm1/kEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,357,1583222400"; 
   d="gz'50?scan'50,208,50";a="407042897"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 05 May 2020 17:07:53 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jW7bM-0006Zh-Tj; Wed, 06 May 2020 08:07:52 +0800
Date:   Wed, 6 May 2020 08:07:24 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     kbuild-all@lists.01.org, Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>
Subject: Re: [net-next PATCH v3 1/5] net: phy: Introduce phy related fwnode
 functions
Message-ID: <202005060846.UiuOBLdA%lkp@intel.com>
References: <20200505132905.10276-2-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20200505132905.10276-2-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Calvin,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on linus/master v5.7-rc4 next-20200505]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Calvin-Johnson/Introduce-new-fwnode-based-APIs-to-support-phylink-and-phy-layers/20200506-051400
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 3e1853e4e1137ba0a4d314521d153852dbf4aff5
config: m68k-m5475evb_defconfig (attached as .config)
compiler: m68k-linux-gcc (GCC) 9.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day GCC_VERSION=9.3.0 make.cross ARCH=m68k 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   m68k-linux-ld: drivers/base/property.o: in function `fwnode_get_phy_node':
>> property.c:(.text+0xd4e): multiple definition of `fwnode_get_phy_node'; arch/m68k/coldfire/device.o:device.c:(.text+0x0): first defined here

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--0OAP2g/MAC+5xKAE
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICMf2sV4AAy5jb25maWcAnFxbc9u4r3/fT6HZnTmz+9A2cS5tz5k+UBJls9YtImU7fdG4
jtJ61rFzbGf/6bc/ACVZlAQ6O2dn29oECN5A4AeQ9B+//eGwl+PuaXlcr5abzS/nR7kt98tj
+eA8rjfl/zh+4sSJcrgv1HtgDtfbl9cPT7ef/nZu3n98f/Fuvxo503K/LTeOt9s+rn+8QO31
bvvbH7/B/39A4dMzCNr/t4OV3m2w/rsfq5Xz59jz/nI+v796fwGMXhIHYlx4XiFkAZQvv5oi
+FLMeCZFEn/5fHF1cdEQQv9UPrq6vtD/neSELB6fyBeG+AmTBZNRMU5U0jZiEEQcipgPSHOW
xUXE7l1e5LGIhRIsFN+43zKK7K6YJ9kUSvTIx3omN86hPL48t0N0s2TK4yKJCxmlRm0QWfB4
VrAMhiYiob5cjXD+6l4kUSpCXigulbM+ONvdEQWf5iLxWNgM9/ffqeKC5eaI3VzABEoWKoPf
5wHLQ1VMEqliFvEvv/+53W3Lv35vOyLnLDU70BLu5UykHtE5L0ukLCIeJdl9wZRi3qTtRy55
KNxmzmAOncPL98Ovw7F8audszGOeCU9PsZwkc2D/wym3D87usVelqZFmnEepKuJEr+Wpl035
LAnzWLHsnhxLzWXSKmVO8w9qefjbOa6fSmcJHTgcl8eDs1ytdi/b43r7o+2zEt60gAoF87wE
2hLx2OyIK31oJvE4TA1wKLofUnTL6zH/i37o/mZe7sjhdEJf7gugmf2BrwVfpDyj1EtWzGZ1
2dSvu9RtqpUrptUHcnxiOuHMB/0kVRqVNID1FoH6cnndrqyI1RQ0N+B9nqtq1HL1s3x4AZvj
PJbL48u+POjiuqME1dhm4yzJU0l2FjeETBmsGEn2Jtybpgl0rshgkyYZp7cJ8Pl6L+qmbFsp
kLAZQQ09prhPMmU8ZLT2uuEUKs+0Scnoym6SqGK4MK3JS1IFNugbL4IkK0Ar4J+IxV5nL/XZ
JHyglOdeeips1WfCZmBDhX9525ZVmmdYhS45AqMkwFJkbZEccxUxOdXiWWjIr2ZvUBxMWOyH
hmFPEykWoMwR6J9RqtXLtJNjo5thALOWGUJcJmHwuW7oNDFBrviCnHeeJmFIr7kYxywM6OXS
nbTQ+IzHykKTE7C6JIWJhFgqkRR5Vhmqhs+fCRhhPZvGPIFgl2WZ0GtyEjtFpvuI3iFuGjSC
SDousPY/3dE044xc7vva4bb20bu8uB5Y6RqOpOX+cbd/Wm5XpcP/KbdgHxmYAA8tZLnv2IR/
WaPpyiyqZr3Qhr2jPjLMXdh8Ha1B380UOP6p2XcZMpfaLSCgy5bQbMyFNcjGvHHafdlFAE4s
FBLMESh+QqtBl3HCMh88rU2X8iAABJIyaBOWEKAFGDmL+0wCAShqTDqvLi466dPtJ2PXod90
cdFjX7DYAIM1EJjMuRhP1JAAyiXcDIwmTAvYR4JB5pHpyiL0InM02W1pnMBOSJNMAeAzINo3
wBKFHzHDlH37ctmCznSsmAszFIJywFYZnYYWGc4TvoBChH4gtBnRWphulkdUvBNUrEr3u1V5
OOz2jvr1XFb4o50rQLhSChJutdIb/pvrj6+mfkDBp1dy6YByfflKSAXC6+upw6euyedytX5c
r5zkGVH/od/NABaSRzltg/wZuhRqs7PMmxS+kPBViTHYGtAEnFtzjXwua8d/ZaoNgnVYQFeo
QPDQl12lqqngUHwxu7023ENqLJJ2UR7gVPjb7RWj2TNkwj6Y4g66+zK6ve0FIVrAPBOKq0nW
QVu17CS9d5k3HViwaLn6ud6WeuE7U4rr6nJurUCsQo6+npz/66kELD6VA2kZi5xVL5hrUAeL
0OV9uXi9MIrQ80PRqDv+GffAQvTZ9fxdvD4+dpmnPIt5WDNrQXVfkmFfWgzUNWtthyppHXyb
1IWD0bovB0Cuz8+7/dH0Cb1NaXqWoIWV3f37UP6zXnVXDDG+NqwQQHLSHg5qV9V/LvfLFbid
jtAG/w+InYhzuQdtOJYr7OS7h/IZaoEzc3Yn5TB32dUItkqRBEGhepqO0XCU+HX8KPvbI5x2
rdqYqQnPcHeBwxkbW1U3M2fgLyE+BP+RAaBoYtV+mK01EuZMad1pwrfO/kv8SqJMuScCYaQK
gJSHYBUASGiohhD5LLU/JNiPBWxViEkKZYKdBENlMZY5tBn7VwMC81R3MJXHr6YWfUzXCMEU
8QB6LhBDBIE8ZQy8ZPbu+/JQPjh/V5r2vN89rjdVXNk60HNsfS/7hi50cKyMEDFf9Cas4zh0
EaJ9D/0mo6FCzZXH5zgatTonAYLMU/bCAhobTkuEWZNxQcDFn20MMc28iAS41diI9goRIRSg
q+YxaBOowH3kJiHNojIRNXzTPjY+RWzgRTrZgTqEcyU9LIMOeOeNKFDxMfig87EiYhtLqAgc
XuRjUqzauzTmQ7a5SzsapOHwk5QNzW+63B/XqIxDbwfNKaH06tuhQiT9RLasRrAWiE5xa3B7
Lf5mdDO6g6BCnNJRSZsuMOwmMImkCuR9sBXdfKFBnN673fCoIbjBHekKuu21qUE9+TIVsd5T
ADhEdmemDjVdm62Kfo5G1tUgxVbZJNa19ezw13L1clx+35Q6V+zo2OlozJMr4iBSaGw7IXQd
QRu5zQxwdR6lp/wjmmd7ZqgWK71MpKrnZtCH1PQgZJ2gyCi2C0UqpmBnKSZjU52mRZfUd41J
TsnGYnoHVHQwLjRizziO31RS2+RWcK982u1/AerbLn+UT6RvN8GzgXJxeAidMX7vRjcxB8XU
iZYUjKGG10ZYm4bgyVKlVQBcmPxy3fF13mmPnbbuGLUOLWcvDmy2iRhDmNbZsC5E056xk2YC
IjAFUD7v+KCppEBfozoRDAqEo8nwsy/XF59vOwNMAaGgC55GHQ0MOZgXxOR0ai9iZPm3NElo
r/TNzWlr+k372MQjicJv4muVgc4NAuhmbnmGQwC9tHilcZ4WLo+9ScSyKWlo7Apk5Dv5MAHu
a7jp+Pv1Px2LqDdFZTibTuovRqZGaGWAtaTHBHQmUzpLgURQPisRfIAgVAIpd7nIprLXkypB
Y5UmVU67VCSKZGalpZmw05gUtEpMEpWGueYaOkcog+jnuN9tMGP9cJr3ejUO6x/b+XJfakZv
Bx+ISOYcW2VOdt9B7nqD5NIq5gxX5bSXgCxXZUVuO31wDkNZb/OenDU9A6fZ4duH5916e+zg
BphvwOk6GU+HXGbFk6jDf9bH1U96vrsKMof/hfImEKVY5dulmcI8ZsnQZywVfjdJ28Z461W9
BcmAv8pNTniYWrAaAD4VpQHlW8GoxD4LO2EXIGctMRBZhFFsdXbYoIBgvX/6D+rWZgeLuu9k
K+Y6Ruj3op6kfsWTH9c4HEFpxy+e+g5bt/AzMbMOTjPwWWY5qKkY8CC1FgN+KkpmtOnXbEze
x17DDMGpSx1znBKMYJqhdeHVkZMZjw3X7ZSBIFIH0UQUA3tZizOrGIY/ltSiRqqTNYevelzD
xE+LjJ+X+0NP87Eayz5qTG0JpIDDCBXOcMG66iMogmsA0puu6L7k8BEsESLkKjmv9svtYaMz
Q064/NXF6dASgHpYDfPgQhf24q1A0X48thGElZIFvlWclIFPu34ZWSthh5PEciiJxFOQgwCO
SdXdGE1G70OWRB+CzfIANunn+tmwbebqBaI7U1+5zz2t8t1y0PaiKe6uP0RdEK3pk8FedG9w
IUhzWQwho/DVpLjsCu9RR2ep110qti8uibIR1VMMjkO+oAKC02AiXw73D1LAVrIzFXMlwm4/
YBX6cjLLwYzebK7kFgd2Zj3rfPDz83r7oynE6KHiWq4wcd/f1ojhYRpwaiHIHNtWLZ3cyypm
6OpfVVxnvSx1cw/MQr7o19ULUMww00ebc90ARC2YkyaR7BsjrW4ElJvHd+iJl+tt+eCAzNp4
Uh5etxh5NzeX1g7JcNCdznyco8Kfc2RtmkbYwwH2Xh/+fpds33k4ugEQ7wjxE298RU7X2zPR
MzwxjwER2A05mxd9Bt2bMIX4y/mv6t8RIKLIeaqCDsuUVxWoPr8tqispd2kYjrTJPYAiWxCS
BDR8ZxmGLmTeTmfPqMxdnIchfjmbdcPARkrUCZFejRb0nYGGObed5TcMIXiJodZkLizx+oCZ
hAfne7lavhwAd+OpBABA2CwC47yqyqZcHcsHc2Ea0XLxyT782q4NC6vz8S+XtxRNnxnp+LyN
s32waUU6VZ4/sycjtQDZnSzd53gW8U7g0l8SpJNeHghFQEP5jtDKtq4PKwquAVKN7jE/RivR
hMXKYuyVCCINdukLHrEXJjIH3C15pnElHUamhQgTkiRtBscMlAZXC09cCzzLXxTSD/rhTrNu
o/7+qPKDPEX3dhiuSEUpPl95i1ty1ntVjabcj5cXg7nSslX5ujw4Yns47l+e9OWNw08ILx6c
I0JElONs8IwUNsNq/YwfzYj0/1FbV2ebY7lfOkE6Zs5jE9E87P6zxajGedJI1flzX/7vy3oP
kFWMvL+a8F1sj+XGiYQHtm1fbvSlW2KyZklqDQPOiTCm25vQioH5SIi3PLzj5VmMJrIASF9Y
OSYM0BgrGH1VsbNbOuki4XfAI3wdLKn0pGj8UzszjVYDEc9uOqe8TPh4xTSj94iWR7pFoqG2
GlN0/i+y3NZi2Zgr+4YOcjzRGgxWcM6dy6vP186fEBqXc/jzF6UPeAdgLmyyayLgKXlPq8y5
Zn5rLaI5rfC1SHvOrFbh55fjcIWMMCnNh4Zhstw/6H0iPiQOVjGiELBxwrimrL/i32hhOlec
NAF0MpUjeq01Qyjc8wwAYM5QWQjRFCvOiwAq5s3Picm8N2SM00oQfcqoeehUL4t43/ielpqa
59ZyECtnvXnQaLa6N9dgRo85j8Xi86ciVffkvV4+Zt69prbL3BbWmGF0cwINoa+tVK4STCY1
aSdZ7tfLDQUmcbJYWHwa3VwMIcJu+04TDlV1bdcJva1l5BBZh0KRt1orju5tUKMQb9fKJBwS
Iy+gyiCkzX28uPbl8vOovRZjMLQC+938Ki23+yqy9Lx4YblpXHHUav5VsTEO+V+wvsmWWfIc
FTlL7ZsByIEMIR54qw3NJeIAItch6yne6ajJQEYMk6pTnpY0bJx8SyLa72mEryzn6niAg7cS
YjoAqFvXR/iWYAQk15eR6QRUGomiutJMB86T+bmLnxDoh8Ijr09Bp6ozQzNfPLUFHxgADrOx
bcW+3VYe/LGc8wDQDO9tUIe689R2AgcKk55Lpe+2D9POlbsaeaSXGtHY32Q3uK8sqp3SeiJT
iwJN+mCkQeUpkZlVqbPa7FZ/G/2vQPZWnxGnk3u8CIJPQSCew2dImJbRd49AvyPM6jjHHcgr
nePP0lk+POjkKmwNLfXwvnP1bdCY0TkReyoLicWuz9/xHhUsAyyH9mnGUx/8Xr316RYUAZMq
ZWpSv3u6uRyZuofZeuSk/R+2oW/8D6asPuN8Wj4/AyrWEghvoQX4c5bSR36a3KT2MQ+FDyHs
nJH76VZ+pON4zVDFUnY6i3yIRCc0lLYPqBpw4Fel5eszKELvjjtBPZ18EbXMTrnqkyU3UcEW
PBb14cPl7VkmXnGNru1cme9djS4X5PCJjvZnP/Gmlic1czqZlyZznhVsZjmU1tSMS255nqXp
MgdbSnuByTzqAv3WDE54FjE64T9nypv4CXVrQkoX361I4faAgKQeCbhexEh2t3ejoVKfl81x
/fiyXemzlDP50QBz8GBe6aBoojx92O1dkeQw9QrRV3CDJi00bPUri78VHoR8FmOAPFMepaEl
X4kdV7dXnz9ayaT+GXQZ3VzQmsTcxc3FMDPRrX2Pd3KsZIWHDVdXN4tCSY9ZDoo04120+ETv
NSTPFp9ubmgLcm6JDXfKx3lofd0RcV8wrfVU0me8Xz7/XK8Ow3h9NmbgIwzzXxeAMi1g/+YS
E4Wt3e+a2SrXAmXEbWizuDqS3i+fSuf7y+MjoAV/mKkLXHJ2yGrVAe1y9fdm/ePnEbPQnn8m
4AVqoZ9m1GfAdBaTedMQ36+cYW3Oed9o+XS83J92wzZAQEVdnMzBliQTsN0Q4aiQD97aIL1e
ZdN2YHEepsTRtMEAH+OB0zbop7t6E8/vCbfUMG5lIpMO3HrXYbA8/fnrgC/Zq7NgynzFSaoF
Ljwu6Ks8SNX+ZGbDomda6olh/tjiPNR9akmnYsUswUvN+pIJvQkji3ngkcSXx3TEwucQafv0
sjEP3yILFwCKJabJwLJrhSWpPvqEQXq6OoOImJsHxh3FVjfxYkUgQnqfVPUKvJwBy6ZEQPer
Zptw1j8kby5Adds3xpwvfCFT20Pa3OJn9MXEKuihMhxIRjTC486bn7rYlkZtakW2Rv2UOm2e
4Vv9wk+NjVsVDZrXpdVb/Gqr11mXIRBYr/a7w+7x6Ex+PZf7dzPnx0t5OFL3uN5iNQBaxoeh
XaMFio1tlx3H+jWbpHfBZI6XovHElN4MTIRuQntzkeCbFZsXywBqH8vn/W5FmRC8L6TwhIIO
G4nKldDnp8MPUl4ayUYBaImdmlX+Cxr/U+rX9k6ydfBQ+C/n0LzG87uWkT1tdj+gWO68TvuN
AyXIVT0QCKGGrdqQWnnL/W75sNo92eqR9Co9t0g/BPuyPIBdLZ273V7c2YS8xap51++jhU3A
gKaJdy/LDXTN2neSbvpaD2DcQJ0W+DjndSCzTXvg+drMy8nFpyqf0lv/SguMiCVCsIHPFclN
wRfKClD1z3fQW8lisWJFx9R42mq9Bzwfwj48UtVXOggDNKAZ3UoBZlkb0lEd4hQFrjYkckXp
5L7z2xmtRWqyARPLkxovKqZJzNCPj6xcmJ1JF6wYfYojzATR7rzDhfKsXNVFGj7ABU3w3BlN
L4T1LD/pEnn0AmZs6OPZ9mG/W3cuD7DYz5L+pefGdtTshhdnC8K9xbPO+wX9tcr3NGhwMscj
2hXeAaIS+ZZb49V0KTrRQog0ggc86SW9mLC4GhmKyKaG2I8M0TK3/ARM/RMDNK7pXgKqr+OC
OayWuWNkZiwUPr6LDyTxjKvd/6Mi6FyXr4uKBZ6q2ozGVRHQwwPatY2WcYE/+CBt9K920sJO
GgdyZKO56kxzsQjPVA1G9pr4Wy2k8vIFgov+fFZl1UWvwnavEzEx/nyT9RFIgCjOy+71NUsb
BwBUG5j3zwBqUdH0uSMtmp2pfZcnlvNyPMMLpFUhKrJ1lvHdroUGAUIGIL4gssDecvWzF/1L
4qXP6V2C5q7Y/Xd4xRKvIuGmIvaUkMnn29sLW69yPxiQmnZo2VW0lMgPAVMf+AL/jpWt9erh
o6XtGdS1b8ozxFgRS9DYm3M9q5zmoXx52OkXa22PG1dT3TnrvMXBomk/Z2YSTz8e1K2jH0lF
SSzO/AQJBKsTEfoZjwnh+FsAgfnArXYpht3Ff+xzQYy0fdomq6AWhCqIx02xiX4bb9dy5p+h
BXba5CwpDXMr2T3TG9dOOlPra3DGkHoZiywkeZczObEp9BmbH4lYLKy2ITozNamddvd/lV1L
b+M2EL73VwQ5tYCbTbKL7V5ykCV6o7UtOXrESS+GY2tdI40T2M6i6a/vPCiJpDjK9hAg8Iwp
kRzOizOfk7tPvdTPHWpt2PQjHfgJ1PngkWL77z1rf/G7LZ/TutEZJrVdGIstTdyvz3pwye7z
W1GR9YhB1qOyE6ElvkziMI18Zz5OF/Mbs23Gcmd04cfqdb89vvnSSWN1L4iWCks0hYtoqnJy
/gtw4aXqAubtJXo3ni4/axAlsp6EKNGAJZlb0WGTMiMFhBrIM4UV6/Z01dZcd7+28wwMXIxJ
Pr06xftcrEscvC2flgOsTnzZ7gaH5fcKxtmuB9vdsdrgwg4eXr6fWngnfy3362qH7nC75uYV
63a3PW6Xf2//dcBiCNOS2qc7OIxEYlgHUNT16wueTM2MQFUir31J6r6Sg/TlmVFbMeLIl6m7
wN3qtuRNtg/7JTxz//x63O5cCIOOC1fr1rjAvjrwxLsgVSCdSQiSM8IqWRv3zmSZqKSmGnYr
i2Jfk3kTtlITq9X63cBrpk53R5iBEQ3jQghNslC48cXvFRfnUewvqEdyXJQLX0k90D5eOu/w
8RIEezISsE81wyQO1fD+i+erTPHfOmuWIJsHhdD8TRywWxL1sziySPBfQE7iIT1MKLLOwi9e
Ahe/CGvUhkx/wsnxyQXewsDGm1E2fmThnDXXNdwIOQ0I75HT/VahEFCCmae/2hE0UIbTOCT4
rfaQZzcLFx2x1oKw+o5kov5OvgpTrvtG3HNp67TVI+Pq0Kcve9B/j1Q/s36qDhufddHIo1hT
I/icREd8Q6+SDrmAD1FLCSKuQe77Q+S4KWNVtFgLYLxy9Hw7I3wyfDbqq+RXiUSM0Og+CWAL
xJ1iRBtgUFlGSMBvranBghz4A901THNlWmtxFXkZGQr6dwKthThr9Xgg1pWGiPatOT8tTka+
m0TGhFtMseqL4FcNoAtwMxWBNl9dnF9+sgVnRtBWIk4lgqXQwIFQV6mhSeC1wLgJuET84mCP
Cb8GQoJp4NzltR6FxcJI02kysUpteT7UqNHb98zITHMVjGuoC3/8+bNb8YvZc66PTlQ9vG42
aDyNdgkrMg2+xhS6Cb0w+lUF53CYB37T/lOvYYtpgwNnfYoBWp0+1P5CM5htvOGsqbtCJW7B
vjMVZJRhPWgY2Loc4lUhm8PDpMNvIAyCB9sAi0peEnHIoCBaIMkbK1GL+AchfCLmUknEx6pn
vFv/CdHrzJDf6L751CEjvo0D2O/aMrQ7xR8z9s5Fx71rt6szwWunA4tzKsh/kj6/HAYnE3CE
X19Y3q+Xu43jr0Fsgr6m23Hto2NStVQtYBoT0T4gPNC5sarpiKBzSoQ4Ymg7YdmQuLguE+wi
yf0LP7/xVog1dIIsmHhK4Zqscd9acIzVYGR7z0UNfSWBqBDdI4kdBG55G3ERx0rNnAPD/jZW
pran/9cDBDJUxDo4eXo9Vv9U8E91XJ2dnf3WNSW9F8ZabBG+uRc8IpvnSjAezMAODhxJmEIP
m07wks9UuzL+YSlZDGJTYB+g6OTN5/zy7/hF/2P9jLHRLIGSg+g9VypSUV95uda+rNCkSNnj
SRiHVUMbrpfH5Qmq91WL5G6vYSwshlbN79AFgD0mUpY7VkI3GetiCLWLAMOurPTk4q0zJ0zJ
fWqYwfIm+AMTHmjWsPSfScTvR5x2WTiQ410JIibsXRCp6ib3HX3jZwDkUw2qix2UzOOa2P4l
CTzYXgKr8WuZAEELuktEP05irpHhGM8Cu1e5/kjHE1en++fn49WHdfXjw9Nx/YCn4vy0nZ0z
tBlPFNUBf3eBNGn4/KPaLzcWZvO4TIQQshYydLUhqoqTb+wRCjcvmPvw8thmFaxnmN7qPpSZ
YVgz/C2KKYsA6h63TojNB8KB552+MpMFMdaw5ErmEL+P+UvdIINIf7IwDgvM+Mh0RHSDgCmd
wjEUuchlBku96B9Mo6qJ9Dpm7Q+zaeLX6g5hi3pWhqNXTucJ7T+aLw+F1CAxjIGjEK6diYEC
QX8WhugcWffSCUZb5ihLAdeMqHdBlgkhKNHx5m40Sf09mMSRgTRfE7B6z4IHQoEYUePIfx3J
kj4WevKReNsD1seTzzHIkrK3oxg8aIQAFsD4rK2mi66eJ8mxvBYVyhSLGXA+s2oaBiAUvcOg
SyKoqnoQkQFootvRqyg7+VnOzvwHA/orAaBqAAA=

--0OAP2g/MAC+5xKAE--
