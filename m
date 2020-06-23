Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D8A204927
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 07:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbgFWFTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 01:19:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:45362 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728729AbgFWFTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 01:19:36 -0400
IronPort-SDR: biYWdCzgrAIIUInvY3ChRglo4ZWv/0dNSU0xRAKuAd25e4ILqhglWBHmhJrbGIJhBzbWWWls/2
 KcG1rdJSdUGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="162043796"
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="gz'50?scan'50,208,50";a="162043796"
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 22:19:31 -0700
IronPort-SDR: 2R44EXfAZN/F1PxVCdAljUZX2ueI/XZoDBT0PbsSVy/ve+w6X4ItUpl3exfIqweKXsmbOapW+6
 OTNA/emDy9gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,270,1589266800"; 
   d="gz'50?scan'50,208,50";a="311167271"
Received: from lkp-server01.sh.intel.com (HELO f484c95e4fd1) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 22 Jun 2020 22:19:29 -0700
Received: from kbuild by f484c95e4fd1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jnbLE-0000cU-VN; Tue, 23 Jun 2020 05:19:28 +0000
Date:   Tue, 23 Jun 2020 13:18:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v3 06/15] bpf: add
 bpf_skc_to_{tcp,tcp_timewait,tcp_request}_sock() helpers
Message-ID: <202006231355.JxltgTLl%lkp@intel.com>
References: <20200623003632.3074077-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20200623003632.3074077-1-yhs@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Yonghong,

I love your patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Yonghong-Song/implement-bpf-iterator-for-tcp-and-udp-sockets/20200623-090149
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: openrisc-defconfig (attached as .config)
compiler: or1k-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=openrisc 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   or1k-linux-ld: net/core/filter.o: in function `bpf_skc_to_tcp_timewait_sock':
   filter.c:(.text+0x3e60): undefined reference to `tcpv6_prot'
>> or1k-linux-ld: filter.c:(.text+0x3e64): undefined reference to `tcpv6_prot'
   or1k-linux-ld: net/core/filter.o: in function `bpf_skc_to_tcp_request_sock':
   filter.c:(.text+0x3ee0): undefined reference to `tcpv6_prot'
   or1k-linux-ld: filter.c:(.text+0x3ee4): undefined reference to `tcpv6_prot'
   or1k-linux-ld: net/core/filter.o: in function `init_btf_sock_ids':
   filter.c:(.text+0x11384): undefined reference to `btf_find_by_name_kind'
   filter.c:(.text+0x11384): relocation truncated to fit: R_OR1K_INSN_REL_26 against undefined symbol `btf_find_by_name_kind'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--YiEDa0DAkWCtVeE4
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICBiK8V4AAy5jb25maWcAlFxdj9u20r7vrxBS4KC9SGrvR+LgRS4oipJYS6IiUrZ3bwTH
qyRGdu09trdt/v07pCSbkofengJt15zh93DmmeFQv/7yq0deDtun5WG9Wj4+/vS+1Zt6tzzU
D97X9WP9f14gvEwojwVcvQPmZL15+eeP7XO92a33K+/23eTd6O1uNfam9W5TP3p0u/m6/vYC
Lay3m19+/YWKLORRRWk1Y4XkIqsUW6hPb7a78Y+3j7qxt99WK++3iNLfvY/vrt+N3lh1uKyA
8OlnVxSd2vn0cXQ9GnWEJDiWX13fjMw/x3YSkkVH8shqPiayIjKtIqHEqROLwLOEZ+xE4sXn
ai6KKZTA3H71IrNYj96+Prw8n2brF2LKsgomK9Pcqp1xVbFsVpECRsxTrj5dX0ErXb8izXnC
YIGk8tZ7b7M96IaPUxSUJN0s3rzBiitS2hPxSw7rIkmiLP6AhaRMlBkMUhwLqTKSsk9vftts
N/Xvb07jk3dyxnNqD+1Iy4Xkiyr9XLKSoQxzomhcndG7qRdCyiplqSjuKqIUoTFM41i5lCzh
PtouKUEwbYrZF9gnb//yZf9zf6ifTvsSsYwVnJptzAvhWztrk2Qs5jiFxjzvS0MgUsKzU1lM
sgD2sCnWHCeSzEkhWVv2q1dvHrzt18FQsU5T2BfeNlycj4uCBEzZjGVKXiRqqSQBJVJ10qvW
T/Vujy2U4nQK4stgJdSp0UxU8b0W01Rk9vZAYQ69iYBTZG+bWhwGP2ip1wSP4qpgEnpOQZb7
W92u1Nlwu9bygrE0V9CqOasnoWzLZyIpM0WKO1x0G64zGaJ5+Yda7n94B+jXW8IY9oflYe8t
V6vty+aw3nwbrBdUqAilAvriWWQPxJeBljfKQMiBQ6HjUEROpSJK4qOUHF2UfzFKM5uClp7E
Njq7q4BmjxZ+VmwBO4ppIdkw29VlV78dUr+rU7t82vyBzo9PY0aCwdYfVZzWZSGcSx6qT+Ob
077zTE1BwYVsyHPdzFquvtcPL4/1zvtaLw8vu3pvituBIlRLG0eFKHN8M7SChNMM+4mSaczo
NBcwOC3SShS4SpTAFxiVbbrCee5kKEE5g5BSoliAMhUsIXfIuvnJFKrOjKovgr4dKkgKDUtR
FpRpM3BqLKiie54jzQHFB8rVqSEoSe5T0itY3A/oYvD7pncyhFDVuVicLLHIQSPwe1aFotBa
Bv6Xkoz2zvmQTcIfmOjeSaoSW1XPWFXyYPzeMpl5ePrRHILT7wGv0ctgmgp7LDJiKoWTbHoj
SYKPQy99Qz81FzYa/lTQ2NRGIVqlRuhtIx9ZI05CWM3CasQnYHLCstdRCRBs8LPKuT0Llgt8
6DzKSBIGNq8ZYIhLprE8fVrXUgzW3m6GcIGwcVGVRaNNO75gxmFK7fJZCwPt+aQoeH8/pprp
LsUPKuw2tk827igMLHJNL/VZEDhOZU7Ho5szq9LC5Lzefd3unpabVe2xv+oNaGwCSolqnQ1G
ztZS/7LGqeNZ2qx7ZUzRmTW10CZRAAqmuOJJCA64ZFL62H4mwregDtSGDSki1gHL3hmJyzAE
kJQToMPaA4IFJekwziLkgMEj1Pj14XfXuchZVnBpuQ3aMvt6v7KAEwuspallyzrIFM8ZgJE+
7OEiF4WqUmKhP1Ch1KC5MCERnOcy1zwIBJNlaq0MYNtpU/WshsZqoOotgpGDfLdd1fv9ducd
fj43Nt6yZt2ki/G0Gl+NRvZCA9oDG1PNC66YisHIRDGydd16GX8BLHoVKL9x0PbrpzctGHpc
7vce5x7f7A+7l5X27uzeuyaMTuWZVFUYjk8zw+jJZTpo14v0gM9s0IEP0JK5FDNpAEzH/SWD
kqvbESqLQAKP00WCdkZoD5/GJ1f0OA+QKZmDpSqqQC7s/vszlTEJxLyKchQX0TQw7umbdpOC
+svLt28A+bzt82CD/izTvCpzcBHLrLEzAZg3ysBs9rH8sX8GYztyaCvTwBr0HCIdd6RLwttz
oZe71ff1oV5p0tuH+hnqg5I7n4lZF1KAM2lOUSzE9PzMwW4bj6MCqQdYaVkPXVF790FKKskU
LIc5Iy4WmjBSuJiur3xw6EUYVqqnU6qIqJgVepMLkkWWNW5DC0YJgGpTjILi6/yWrgERlAl4
QmB8jD3X6M4y/5EiPkwsARUP1u+qtyxU5HftlCtl28ZW2TcD1gb7GMCgYvb2y3JfP3g/Gjvz
vNt+XT823s1J0V5iG2rjV3byCAb1GQfowaxxGrQiU42LRoP1sIW0KdJYj2rkT3AD3HKV2SWO
NnKC28i2BXBwjgEWB1LoOB3eTUvW2wAewcXOtD2cVymXEqzeydOoeKptAl61zEBYAoAyqS8S
nEUVPO34pm5ApE0QBsNMHAxUFs/MeoK32wtttHQjeA39Eg2ta4yUq7JN7Nc2B1EfFRNaCswQ
NZd0sxTzjsGIOPunXr0cll8eaxPx9AzKOlgax+dZmCp9FntAu4+z9a8q0Fq2i6Tps9v6tJaA
N21JWvC8h4laAuw7FkPRrevGbYvnGreZVFo/bXc/vXS5WX6rn1BFCrBFNRjcKgBdFDANpftY
R+YJKI5cmfUHNCU/3fRUCx2aEQPtCqZFdgDeOmnnUUGGtaYyRVi7BU1hSFAPDmEQFJ9uRh/f
HxEag20FX80AvWnPrdAKvNHeOApOCVp+nwuBn/R7v8SVyb3RWwKPjxpjZBZFW63pGaDtlo0V
egruMFBU5pXPMhqnZAjcW7Fw7/xptY7QMqsPf293P1DIALs6Zaq/qboEkBfBdrTMuOVV6l8g
5r29MGXD2icN5dBci7BIjSeGh2JgQFOGRT941h89zxuPXUdA8T3KtXOpgwugIwSYJrxHYMsz
PFqjB8NzfokYaTXB0nLhCPdkcKDElDsiS00bM8Wd1FCU+Kg1kcRuGpgZN5Hn+pi76Q6RUDTX
wZ3ouK69uEFH9Dl+Zo4MtHyVZc6kmguBn8wjVwx/vcIhX2e58xNcaRxZZiwiDjPcsWSzy3Qd
lNBA7zJX8spYZywTlznumEMojhw8ARMs+CvzCeirC0cDx8E/CoJfIELUqf8C5nLSL11pV/nT
m1292b7pt5oGty5EBqfoPQ7DctdEQND13R+4DfRc+w548vjO4GzQ5Gnu0vbAHILH7dAzfn6B
CEoooI5xAk1ShdOKwLGPros9wAhoeXLl6MEveBBh4VfjoRhlIYmtB9oitLFZQrJqMroaf0bJ
AaNQGx9fQq8cEyIJvneLq1u8KZLjobA8Fq7uOWNMj/v2xrXzTfgfnxbF+/NhM4iGP7ju0K77
TM65oviJnkl9F+gAFjAiOOZTt3lOc4d91nPJJN5lLN1WuxlpwPDJaI7kGlCohCNQubg+F8rd
QUb7d2YWqVhUfinvKh3mtsD552QAjLxDvT90vrBVP5+qiGUo/jqrOSDYWMtaKJIWJOC4sqYk
w+UBlz0SwvwK13kOqynFj/ScFyxxeadznhIcsxThlDu8Yr1UH3E1QQkPcQLL48p125+FjvQD
CWrWYSwNfglxWjJXZZYxfPQh4YmYMcwmMRUrcBC6U9NJTVD/tV7VXrBb/9UF8bsBUkqK3mk/
Bb/Wq7aGJ44Y/ISZm1B+zJIcHQmcDJXmobQtY1NSpTr834s8ZwFJzu/ITQchL9I5AXBqkkbO
Bhqud09/L3e197hdPtQ7e4Th3IRghoaqlfphxaNTbsIc+nay59se56ADjkHBZw771zKwWeFA
yg2DTqVpmwH8kMJu4tZPsxEA37RjNtkhyHIfg/rgpUHvnLaBKTsEdr6fZrn8l733YASkt8Fp
zLUuQhfPrmKdEAEiS103JlHmii8p7B4uUNY9iQh7oeBQe2zKkY4EVB0wUAVjdgMVI0Vyh5Om
wv+zV6AdeVA4vbJedAd+N17c6XcKWrJXAC2wYgY+2+BCEUj69A6uxi1nttDRiTNJz2Yp8+TL
8/N2d7BDoL3yJsaiE+CQHQVhTu/0PNB+wXlPhCzhpOlhc1cOgSwIrqUX+joMXOsgZA5dOMtJ
5vCX6BU6Z8ZA3lNvb826G62hVB+v6eI9KqKDqk1eUf3Pct9exDyZm8r9d1ABD95ht9zsNZ/3
uN7U3gMs4PpZ/2l3qXg1dNC7BKD/vV3TMHk81LulF+YR8b52+uhh+/dG6yTvaatzQLzfdvV/
X9a7Gjq4or9DvSaRbHOoH70UlvM/3q5+NHmRyDLNRO48xJeasBaaxgKt3pOyJqlF45qmxBpL
JzdA1KFkWythFSw0dNJjnabg3Lr9ZKpLKTgBD5EFLqfGSL8TX0TlwAyeFuBzSRJ+fyHMo5jj
SKSEakfB5ee5SLOFi6K1vMNU+GAjywDHNJHDJYLxScdhhXnBX1K4HP0SHyCUVzOzMyZx0lF7
BjAF7zVJRXamBYI1HKz1lxctoPLv9WH13SPWVY73YMGa7uLvX1axcBMrehpdTwIASCAKgASE
6jh/P/eTaB+YVEpi5tiunZJ7keENg2hlihOcWFC8vCxE0XNUm5Iq8ycT9KrXqtykWoqePfJv
cF/Qp6mWNxzLyzvwf9Kh0j7vkAIAa7KiMNqM2ykINsnE53uzjFjKM37cKfyMDwjnDbP7NlX2
dL5NSZXlAExJRqAbDTuHEz9vKRIiSvCJxSWZM46S+OTqdrHASZliCUpJCeAI4xCeju4sDdDE
JLsapwXr1ZrKyeR2XKVoDtWgpujnFA+pErYDpWZEuWlMFSITKb5sWS/VC/Z6EbH/bU8m1x9H
1l2YigV+hnKWSXA6BErU+l7nEtuD+QwFFQN9iXua6asjK2Dwkki0w0KHPwqUBO6jLPs5u3IR
+awaaFCkJmOf8SZFQgqAwQW+CVJQDq7YAleFUpnN741HpbAu/2JAd5nIQW303Kk5rRZJNFjX
87oz3lMF8BMoCYxUYRcsVsU5vx/ctjQl1fx27EiZOTJcv6ZMG8RrN95iYLLgbmFpeZIEcAM+
cX2yWyfOwj66EKBcTwmYMqrvz7mru4aHK584cFHXcJWWiyrKHaGeHleacgBe/6I5c6+VJ2zh
QE+GOeaADEPnehkenn++GY0/uhlSSanGhw4gplkWOcWSlfL4LuF2iuAcSrrACbTowc8OpD6c
B1AIAE7dBh7USgM3rTX+bobFZPLh43vfyQA7/2GxWFyiTz5cordg4FIDtzfjm9HFHm4mk7GT
gXIAAO4ptmbeSQ8AIVwaYJBPridXVxfpik7G7gGaFm4ml+nvP7xC/zikt9SQL5iRgN59L80T
OB+uFg0MqBZzcudkSaTGQePReEzdPAvlpLV44lX6eBQ5JtZAi+HMjrDB3fKRQ7n35IgvnByZ
ydAg7hl8vli9YBq8Ty/QjbF208FgX5ymBHXkJio2Hi0cd5LgUoCF4dTd+Qw8ESmZk97alwhU
11Wh/4sHY3LHu46knyVgVF283R/e7tcPtVdKv/PUDVddP+gHmdudoXRXDORh+Xyod1hAYj5w
bZswz8ZkC83XOpT/2/l9xO/eYQvctXf43nEhmnjucJpN9gESMj+dOBmcj4lvnl8O59EM65jm
5XnAKl7uHkwUh/8hPF2lN0KpH6PhHjpJ2dCZOjqzWKOnIA4yzKbP78vdcqW34RQK7KRM9Y7t
DMOuOifmI+hF1UdsCYsIvTPFSKUk0Bm6+uWQjrx3RlTWu/Xy0doyazngDJvALLVd5JYArtII
LbTeHZkHNiKTON/4/e3tCLAigaLmGWJvLzq2UOtcLL3QZqJNOATvKCuqkhTKSj+zqYV+eZey
Iws6CIDcACsdN6+9yc9fZSnU1WSycE9IhFWeEKXfLB0vFrebt7oucJvdMkcckfu2BT2VBDSR
u49+GqJVaK3ksFXJQ+6Ib3UclGYO3dlytHGZPxXRMT1H9KLH+hpbq1Fz+SonKXAM25JDmVRJ
/lojhotnIcDm11ip9tRAsquARwCUkuHVSxdn7R/AwZ6kVBWJQf7IjmSwV+Z+zhEdzapI4pg7
K7WLo3Aj1T404ZnjkU/Tub6FO4ten3RY++TMEV5Nj0+TUYZ4rnPgA4Ends4GdzZQMoUifCQU
/s2dlyLJnSsAf66hLYhhxgbrVEplHiOeX2U2ZuqKotbpiqJd2uwW97VDbHMcPEhYXHxRh4+B
j2hDno08V7m3etyufmDjB2I1vp1MmnfiLsDQuG7m7YYzv8lCDsuHh7XGE3AUTMf7d3bI+Hw8
1nB4pg8JIir62PTcx7YAEIdUOVFx+z2F2/HxRQQo3+Fhay6Fnc63JjSvM89Wos2qfVo+PwMQ
My0g0Mg08OFm0bju7j4aheimt9FcN0Mwd+UkGXKo9P9GYzzyYli6i+zOPl3gLC4vWJzMcZ1l
qKk/eS8/4JkjhqHR+hfWCnz7cJjR1M91xnal2bUwaErrf55BegeXFwh12HcUFQDEnFftZoJw
cByPt+dj/JSKOSsqMnM89DdUfamNm6SGrp8IJrjOj+eDy52TBo1ZkRI82cV8nyMQWBavlL5+
iyy5PwATEnsI6tOUoOz+INe+2aGXx8P668vGvNe7EP6BvdKpiOALa3tNhSP+dOSKExo44lzA
k2odj58/TY75+5sr8Jv1nS26wgrODZGcXjubmLI0TxyPjvQA1Pvrjx+cZJnejnDZIf7idjQy
+M5d+05ShwRosuJwpq6vbxeVkqBo3KukPqeLCX7rf3HbbAc/KhPn8UlZwElFGe0evF7gQjia
BKrd8vn7erXHjFvQ12pNKgCU2Skb7Xzs4ibfabd8qr0vL1+/AmwIznM8Qh9dF7Rak/2zXP14
XH/7fvD+44FsXvB4gao/WSRlG5vGI4KEThP9TPkCa5dE9ErPx9yl4VJaJ12UGZY8VIJmEDHl
YHyVStjZ+2pNPz1mPjani8skR/KeLAb4Mzsz1Rb9+EwzpsGg8bNd12XG0TpplmN5/v3nXn/6
ykuWPzVEPNc9mchNjwvKOJ6GqqnGGMxcGPRCT4NmSBA5NL+6yx1ZBLpiIfT7Q3f2b5o6TjpL
pf58jSOmM68S5sgZJ1R/0Ib7YMAd7gd4VzzjPskc3y1RtBFfPOSrtfRsmCDVZCqkxC9D68nS
SVJ1Dl/IHQkRTb1K5wHCrioeOoLNDVvMyPD7L13aQ79/a0nKRcBl7so5Kx04asaLLk0RC/do
skYaLCv713NNsQtqzoKcYK3pT3ydN2ZKm3SS5hi3Mahzk71e7bb77deDF/98rndvZ963l3rf
D2Icc5cus1pQqmDn/lu3p4pErmyjSCRByB3Z582XqkDEcOGO591j0bM5UuOgyO3LzgFHThF4
rt7f4MYAbcRqg/DEF1j0iAv9iHzwFYgutdQQvXz5rW7efiKpiq+xNh+EAux8qJ932xU2QZ0s
q3Rq3/9XdmXNbSM5+H1/hWueZqq82Ynj8uYlDxRFRYx4SDwsOS8sjax4VIktlWxvzeyvXxw8
+gDo7JOtBths9gmggQ+yfis8zJWeHp8fxPqWadnNWLlG60nn6EHPMW+MSmjbryWBTF3kT6Dl
H06/XTyf9rvDt94Dt9/pg8cfxwcoLo+h5Mckkfk5qBB9m5THfCof9ufj9n53fNSeE+lsHtws
/zU77/fPcE7sL1bHc7zSKnmLlXgP79KNVoFHI+LqdfsDmqa2XaSb4xU2dngiPbxBrIC/vDoH
8w1a/m7DWpwb0sO9ze2nZoGhPqUoK82KSPHO3VSq7EzohPI5p+zAy7UvgaJf8A5a6btuAsV1
mkIzZSz5LhDcyzIOTTdPr2ajgRi6q4pbpGyiwFWBEJEI1i+8AzPB44btt7Mi6BfXzSLPApRQ
9OtjNCa1Jo8GlIUiyhTV1+Cb/kxlZZDcKiMDXGgAjkHFSVeu0GixpfEGFMo0Bnl19KXLTdBc
fcxStM4pntkmF/aI/s5gScFlTTpNb25cD5rOkmaNimMhCAPFF1WJLSsCX8wKnu7Px8O95YaR
TYs8nort6dgNQUoJGUJfen9lzNfoyL3DC0npQkQJROR7fNfRtbvS86s0dDj0B5eqnCnm1TLO
lbDtJE61xYXtK0IO2VCkFELpkgVNO6CoDcWB7Z4H3dpEb4MkngZVBM1vCGlUDFzaoEwxs67o
ujJG/2jypSSDokxNAFUWGFuKVxYVgrY6dKMvMeKhuKPrQ6W3EZtXdjGblSymW0ZcX3Lvu5oo
jYvJNwtGhP1VnVfyNMD71Vl53cwU9YfIGnWGgCMKrQ1LaQQ7c7jd/elYGkoBvaKTMJmb9+jn
/ev9kaBAhsnR7QggxzX2oFPRwrUjmUQXLpEKCcIChOoYBt2rDk6vZFrYcZEtfREVmRmkRlb2
4WcXwjbouhTBxgiIQSibLJlng4FGwhthh5lNQaGJYElYgCD0Rxi4blf1+3HwxilZuWSvbKvB
OSE96fMhJMBNecP3IEJ77ZsvW+xXdkR6l/379sr5/cHy9KUStTuJfC01AxFI45Jgp+rpUrLo
AItkH/pM14+MDTy0jGDunJ/wZrvpPcpwN2HqrFiGlvmZSvhOR+5yjCTVhiPWCPk0UFe8PryZ
EhxdZzHUKA0uaO5rCwja2tdbh47d6/nw8rdk6FhEd4q2HIU17qbNNI1Kku0qkNC0623mHSUq
X4wYNSD54V6bwheOBKgyUMPQrsBwFk/K9NMvqCdjONbl39vH7SUGZZ0OT5fP2297qOdwf3l4
etk/YEdc/nH69ouFo/nn9ny/f7Lxa8wLu8PT4eWw/XH4r4NHT1DsBMPmoUYTiaG+8rBvvnJ4
dcygUEQqr31b5TbJwfkUvmjwL3Dmg7m9wAmbe8dJcvjjvIV3no+vL4cn+2BZ+jhEndQeVxgV
DCKEcd/aIetVRRYu4ezCsMD2oBVYkihTqOgmVldxUtqbcuGAhxsnC7r0ZHU6kY1jvQoSxmg4
MVGrehD1ttjoLTiswrhSBLIifC9jg+Bz1fvfp1roOpDjqm4kPy+gfbhy2vDhClZFMlMCbFuG
JA6jyd1H4VGmyEFFLUtQrINKQb4ijkms9sGNWrNKkG+0knhCL1NCUovwo6KRoGvGeB8lX9GD
v4PVM7aVr9di+eYrFru/m83HG6+MtKilzxsHN9deYVCkUlk1h2nrETAPgF/vJPxihThwqfLd
w7e5kNwGxYbmNggmRLfFnyvlxgfjjQusJxM3rsXKNJ5NA3weY19gZc8jVOgHan9xw/H2wIuY
3X0chmmFbwJUut0DvqOvzCguijf3lz4oJ2kc3liY45T9Qca3hqk6m9pYxRXCT4tzsN+XvV3W
PqF23xlBhEpPZzjNvpMvzf3j/vlBOttbXHv0r9G2RKQjbLV45Ibs+IeY+AQT2mMw/1vlWNVx
VA1elSA6lCjpezVcG+NzlwXQtyMCmMXh3Vn3mgCCVgJXVBSUeMQQidTO4t46Pp5AZvonZT4A
RWj3/ZlYd1x+lrqWmxJnM9ksFGUk5aboDebB3XYKGUjyUbMOiuzT+9+vru2psqS0MSq+JoJg
0hsCxZuvBYwkiGMZPZ6/AKQpwuUFlSRFzw3TA9SmUEtBJEnunCW4RodG/hjKVWDhVFrlvgsV
I6+uo2DRwS7K+unPjpB1w9EunAFU2Ij4ty5hgs8xqakK0kLbVEUwn5SuH7tzezLaDHs0ULs1
Y0q5NGUMclMc7SuzBTFYaeSWXGo2Eq4QGXWISaomX2eKIyaRYUBLUN610H16Sz75AlNoDFWF
5eYadwhZNaDEFswVZVMJONqq71ZeC20vclIgFLSF1UCgYkar0LQySyh9j9TojixtmgzNvAhg
XnTHxzCiXEx1fHrvifTDsHpvnTs4IP/ogbov8uPp+fIiAeXn9cTrYr59enBkdNAfUb/IZauc
RUcLYB0NwMlMxFMkrysoNu5oZoTkWiNYbaVDyTCxmdcZZ6cRmdYr0XdssNIgtk4iOMmZ2OFq
X7Ae3OdpMdePNdmot61zG4sFHFUv9Ys+dthziyhy4ftYscKr3WFr+PUZNFbydb28eHx92f+1
h3/2L7t37979NjSVzKtU92eSKXw7yrJA14TWjCoL01gHftfIkhmQtccWsXD37S69NytZr5kJ
0z+s0Q13rFXrMlKORWagT9P3N2ZigQ7eBwPzRl3YxyhAdrKb/G56K6yACiF5fBGvm+X9h44K
gv/HrLAsKW1KCPnVeH5DtzR1VkbRFMFpPYd65+sXvIcr+06L4H6/fdlecK6EPjGS3Yex0hnt
afQGvRw7ZMggH2u5SegYypppUAUoNha1cHtgbR/KJ7lvDQvoPwwGTnzLO2atEo9nTIeFiYf0
yYEcb84gYlIHmXJurUpJmDayaul7FezCLJMVgjTWzfQARIzwrsqlTBjYNHtT6iRBarSjP5WU
9AAJ8snBm/IIw3yNYOMjDK0k3sO8EqcGbY+0psyCJearkwxasGJA4uVkMpGQJ47LgwymJUW7
8QPK1tezw5ocZQQFt5pzLp6RlnOiMAXUu38l5aijhIOY7EufZgyE6E/vPmOnOcdNPbVivEo6
e8Pjf/bn7YMFy7WoM8VW1K1l1OAIX+ULqyDyvVibfFLgsQUxkLfC/LaNYDLtMF2UH3YBzljX
k40FDtibQM5RfIqJBZHk0cVP51Cfnww5fBDlX1/zE8TAG6Ejbj0o4nlKeVE1XHLUwUC2a8Yr
a7HjVXpnClGOMPPD59EGERlHeoatImz0V+Z2y1eGSyU2DRkWwFEpt+rEQLYO2dxK9ElcpWNj
CHSYm4orPnHUtevPYFI3QVEo3pxElzQKm6OA2TyvdCxv6vBAcWEkajxV8MZppi+UcLn263Ml
hyHRb0dSFnDnlKje52NDOFmODU8CS2We004u+07PYtAQMS3N+A7I04mupEdaO3UzIbrTke6s
1Lsz3heiNISzaXT209WJsh12lagMQFMlyNHN2LspYsvi/wCIbNHYxHkAAA==

--YiEDa0DAkWCtVeE4--
