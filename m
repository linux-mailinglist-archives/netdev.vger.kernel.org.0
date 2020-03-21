Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD1E18DD68
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 02:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbgCUB25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 21:28:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:51086 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCUB25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 21:28:57 -0400
IronPort-SDR: AtOvTwEr8ObaK+l1LoSqBkCTxLLxYkJOhRvwea5mOlaCAKNEo/8bKKkCpQF7zKcmUFR8XFx+XZ
 cF95cGUH/k0w==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 18:28:48 -0700
IronPort-SDR: K1NA4jXsOpROaaPwz5gE0oS9z7v6tD4gvpZiKXoTeYBHRSVTn0KQx0lTfZYcwIw+13qCrw4SUu
 A0G8RQBqmWdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="gz'50?scan'50,208,50";a="392329395"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 20 Mar 2020 18:28:45 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jFSwP-000I2W-6R; Sat, 21 Mar 2020 09:28:45 +0800
Date:   Sat, 21 Mar 2020 09:28:08 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     kbuild-all@lists.01.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Subject: Re: [PATCH bpf-next 4/6] bpf: implement bpf_prog replacement for an
 active bpf_cgroup_link
Message-ID: <202003210931.StdVFwZ6%lkp@intel.com>
References: <20200320203615.1519013-5-andriin@fb.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20200320203615.1519013-5-andriin@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andrii,

I love your patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]
[cannot apply to bpf/master cgroup/for-next v5.6-rc6 next-20200320]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Andrii-Nakryiko/Add-support-for-cgroup-bpf_link/20200321-045848
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: mips-64r6el_defconfig (attached as .config)
compiler: mips64el-linux-gcc (GCC) 5.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=5.5.0 make.cross ARCH=mips 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/kernel.h:11:0,
                    from include/linux/list.h:9,
                    from include/linux/timer.h:5,
                    from include/linux/workqueue.h:9,
                    from include/linux/bpf.h:9,
                    from kernel/bpf/syscall.c:4:
   kernel/bpf/syscall.c: In function 'link_update':
   include/linux/kernel.h:994:51: error: dereferencing pointer to incomplete type 'struct bpf_cgroup_link'
     BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
                                                      ^
   include/linux/compiler.h:330:9: note: in definition of macro '__compiletime_assert'
      if (!(condition))     \
            ^
   include/linux/compiler.h:350:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
     ^
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^
   include/linux/kernel.h:994:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
     ^
   include/linux/kernel.h:994:20: note: in expansion of macro '__same_type'
     BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
                       ^
   kernel/bpf/syscall.c:3612:13: note: in expansion of macro 'container_of'
      cg_link = container_of(link, struct bpf_cgroup_link, link);
                ^
   In file included from <command-line>:0:0:
>> kernel/bpf/syscall.c:3612:39: error: invalid use of undefined type 'struct bpf_cgroup_link'
      cg_link = container_of(link, struct bpf_cgroup_link, link);
                                          ^
   include/linux/compiler_types.h:129:54: note: in definition of macro '__compiler_offsetof'
    #define __compiler_offsetof(a, b) __builtin_offsetof(a, b)
                                                         ^
   include/linux/kernel.h:997:21: note: in expansion of macro 'offsetof'
     ((type *)(__mptr - offsetof(type, member))); })
                        ^
   kernel/bpf/syscall.c:3612:13: note: in expansion of macro 'container_of'
      cg_link = container_of(link, struct bpf_cgroup_link, link);
                ^
>> kernel/bpf/syscall.c:3618:9: error: implicit declaration of function 'cgroup_bpf_replace' [-Werror=implicit-function-declaration]
      ret = cgroup_bpf_replace(cg_link->cgroup, cg_link,
            ^
   cc1: some warnings being treated as errors

vim +3612 kernel/bpf/syscall.c

  3576	
  3577	static int link_update(union bpf_attr *attr)
  3578	{
  3579		struct bpf_prog *old_prog = NULL, *new_prog;
  3580		enum bpf_prog_type ptype;
  3581		struct bpf_link *link;
  3582		u32 flags;
  3583		int ret;
  3584	
  3585		if (CHECK_ATTR(BPF_LINK_UPDATE))
  3586			return -EINVAL;
  3587	
  3588		flags = attr->link_update.flags;
  3589		if (flags & ~BPF_F_REPLACE)
  3590			return -EINVAL;
  3591	
  3592		link = bpf_link_get_from_fd(attr->link_update.link_fd);
  3593		if (IS_ERR(link))
  3594			return PTR_ERR(link);
  3595	
  3596		new_prog = bpf_prog_get(attr->link_update.new_prog_fd);
  3597		if (IS_ERR(new_prog))
  3598			return PTR_ERR(new_prog);
  3599	
  3600		if (flags & BPF_F_REPLACE) {
  3601			old_prog = bpf_prog_get(attr->link_update.old_prog_fd);
  3602			if (IS_ERR(old_prog)) {
  3603				ret = PTR_ERR(old_prog);
  3604				old_prog = NULL;
  3605				goto out_put_progs;
  3606			}
  3607		}
  3608	
  3609		if (link->ops == &bpf_cgroup_link_lops) {
  3610			struct bpf_cgroup_link *cg_link;
  3611	
> 3612			cg_link = container_of(link, struct bpf_cgroup_link, link);
  3613			ptype = attach_type_to_prog_type(cg_link->type);
  3614			if (ptype != new_prog->type) {
  3615				ret = -EINVAL;
  3616				goto out_put_progs;
  3617			}
> 3618			ret = cgroup_bpf_replace(cg_link->cgroup, cg_link,
  3619						 old_prog, new_prog);
  3620		} else {
  3621			ret = -EINVAL;
  3622		}
  3623	
  3624	out_put_progs:
  3625		if (old_prog)
  3626			bpf_prog_put(old_prog);
  3627		if (ret)
  3628			bpf_prog_put(new_prog);
  3629		return ret;
  3630	}
  3631	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--y0ulUmNC+osPPQO6
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICPxqdV4AAy5jb25maWcAlDxdc9u2su/9FZr0pZ3TtLZjK+m54wcIBCVUJMEAoCT7hePa
Suo5ju2R5fbk359dkBQBcqHkzrSRubsAFsBiv7Dkjz/8OGGv+6cvN/v725uHh6+Tz9vH7e5m
v72bfLp/2P7fJFGTQtmJSKT9FYiz+8fX//725f75ZXLx6/TXk7e724vJcrt73D5M+NPjp/vP
r9D6/unxhx9/gP9+BOCXZ+ho9+8JNpqebx/ePmAfbz/f3k5+mnP+M3R08esJEHNVpHJec15L
UwPm8msHgod6JbSRqri8OLk4OTnQZqyYH1AnXhcLZmpm8nqurOo7ahFrpos6Z1czUVeFLKSV
LJPXIukJpf5Yr5Ve9pBZJbPEylzUls0yURulLWDdJOdu0R4mL9v963M/E+y5FsWqZnpeZzKX
9vLdGa5Jy4zKSwk9WWHs5P5l8vi0xx661pniLOum9uYNBa5Z5c/OsVgbllmPPhEpqzJbL5Sx
BcvF5ZufHp8etz8fCMyalX0f5sqsZMlHAPzlNgP4gf9SGbmp84+VqATBP9fKmDoXudJXNbOW
8YXfujIikzO/3QHFKpA2H+MWGbZk8vL658vXl/32S7/Ic1EILbnbsVKrmfDExkOZhVrTGJGm
glu5EjVLU5AKs6Tp+EKWoYAkKmeyoGD1QgrNNF9c0X3JUo4RuZGIjCJG4y1YkYD8tEMGTZE8
VZqLpLYLLVgii7m/+j4ziZhV89SEW7F9vJs8fRosetc7zgzOnuJLoyoYpE6YZWO+3WlZoeCw
LBujXQdiJQprCGSuTF2V0LHoTpm9/7LdvVAyYCVf1qoQsMm276pQ9eIaT1muCn/uACxhDJVI
Toht00rCwvptGmhaZRkpsQ5NYhZyvqi1MG4xNL3Io4l1vJRaiLy00H0RcNPBVyqrCsv0FTl0
SzU6SLysfrM3L/+Z7GHcyQ3w8LK/2b9Mbm5vn14f9/ePnwcrCw1qxrmCsQZitJLaDtC4gyQ7
KGpOInpakm5mEjzIXID2AFJLElk4psYya+iZG0ku9HfM/KC9YFLSqIxZ6aTHrZzm1cQQ4gcL
XQPOXxl4rMUG5IxS7aYh9puHIGwN08uyXnw9TCHgWBsx57NMGutGbScYMnhQBsvmD089LA8y
orjPtlwuQFkMBPVgedDEpKBKZWovT9/7cFyunG18/FkvxbKwS7BLqRj28W547A1fwNycZugW
3dz+tb17BRdi8ml7s3/dbV8cuJ0xgR0Yexj89OyD5wPMtapKT+WUbC5qJ5JC91AwXHw+eBzY
yh4GVh6dgmSIW8KPZ5+zZTv6kJt6raUVM8aXI4xbkR6aMqlrEsNTU8/AIqxlYheewNgIeQMt
ZWJ8AWjBOskZZdMbbAoSe+0vFmy/Eb4aR7nCvlvMaNhErCQXIzBQ45EnGJqVKXnUD/2BDaO0
OXg8pmSgTPqxKmvqwntG78Z/BoZ1AMB5+M+FsM1zz8VC8GWpQNRQ11ulKYeokW102ToZOLQH
Gwm7lwhQ2RwsXkJOVYuMXRH9oljBejp3U/s+LD6zHDpurLTnFOqknl/77gwAZgA4CyDZdc4C
wOZ6gFeD53N/UjOlwDi4vylR4rUqwR6A342eCppk+MlZwQNTNyQz8AfR24KB/wbObwLaC8ZM
GpekFuh1F50OP3R6lJDauc73DZ5Bv3NRYhNQ4cyXZhDW/qGxAp5mAG9coox5/c2FRcezHvlK
jWCMwGnj+nki6nzxxsfwTyFq3uFzXeSe9wnnxuM1S2FRtD8VZoTze7zBKys2g8fad2hFqYI5
yHnBstSTTMenD3BeoA8wi0BzMulJmlR1pRtHpEMnKwlstsvkLQB0MmNaS3+xl0hylQfnt4PV
LHTwhmi3GngOMV4I9nu8R7jFLvTy56WN+OgP7PSWgxLDAvMiSXyl7cQcT0o99JsdEIasVzlw
ERr1kp+enI/cwDZqL7e7T0+7LzePt9uJ+Hv7CO4QA9PK0SECr7TxGL0xmoFJ9+o7e+xYXuVN
Z53tDXbEZNVsrNVDdGt/3RFRtNOJMTaz9UwvI92wGXXeofeQGUWTMWRCg/vQRtlhI8CipUQn
rdZwYFUeZaInXDCdgDNEmwCzqNIUQj7nsrh9ZmBsIjNwTlnJNGY3wuhBpTIbud/tJoa5jMNB
ks5jctKQ39z+df+4BYqH7W2b6/HIOl/OH9LBWQYGMKdjFabf03C7OLuIYd7/TgcQPhc0Bc/P
3282Mdz0XQTnOuZqxjI6KskZxMWJ4BiZyIhEOpo/2DUdLjosbI0oIqxnDCKnjxGUYUf4ypQq
5kYV786+TXMmaG8rIJqex2lKEGX4lSq+jqCnLDvWA49wWggOJHopZEGHf679Sp+fRrax2IA3
bGdnZyfH0bTglTlmZEraRWNwriKqZi7B0zyjp9Qi6TPQIj8cQb6jZ9IiI2PK2ZWFwEcvZCGO
UjCdCzrv0fehjvfxTQKIonREPTYEmbQ2E6bSR3sBc6IMLVUtyUzOo50Uso4w4UTKbt79HtMM
Df48ipdLraxc1np2EdkPzlayymvFrQCP0ij6/BdZXm8yDc412IkjFOURCnf8wDAwTN+M/IJs
+/nm9usEs8Rvq4X8DX9TaX+ezJ5udneBQ5CJOeNXzUiw9ix5Rysmn0xxkanxqDDCbzBaP0jn
XUpbyxzNXZqAHVcQXAWufIgv5On09/Nz+uCGpBuZpeWcFpWQcsxx58Bg9quZFZh3vqj8VMzY
Sg5zHYu1kPOFFxkccp+gRWYa4kCwJRDyeV6xiyBVDuylENmBH4Ahp+/cuphLMy/VzcUKIOd+
YsFoHkIau4ZJFyJd65K9pipLpS2mZDHH7jmeSc7QMcQAlKuF0HACQ2ShijECRun7XChbZpXL
IvgUxYDLw/KYKo/0BK45ukSYiwmCSHCEZuhQF4lkVICHBI2CaWki/fedRAi+p5NFBeFeNkv9
jIJqg0kQPX/t3caYEvba6wvzTRADubTGgDQ7BeEBIWnya/X7o+jL94d8cODLBcuG7d6d1fqU
1lkeRUSreRTToxTT82+NghRnkd3r8NNw0TEBGEzjOPrsOPpI54774+gjnQ84Xwu2rBWcKd3l
2/sENqFQ+l6CjJyD+d1aBqEKaDbD4KCsLqekdL47m4F6WQpdiCwiwNNzigRH/EYvAcl39IIn
BUMdM5Djcp7U/ARzS1ZsPK2CsRP4EaJeM8sXTjkeopY2ON1/fd76Mu4YJWTKcTcKYVYMVAAw
dv6BaOKCMsxP1efLIHzsEafTJX3l2ZNMz5dUrOku81yK/Ro8KScbl6envdp3Ftgd7qFaxwUd
IBCG4ldqkQrLFyGm07NJlZc1KKpBh2nZbVDYDHQ14KoxsFE5TUe9r+VMmcnJ6xFf2A6EEWF0
6TT/jtPjVZ/VVsHJqgVQYaQ8WpuhZHGUrnwIHAH8C3KcJt7IGNTiBgIT62iUBlquVRs5B8oM
1/5AGVV5SJUbMg3fYhMp5HhXtdwMoMBYphisImam60wTauLM3c+tZBRFjYQ2erA0zMikNS8n
YwQenhgcDpeWreUOFhu8FVLgejUBblSQLgzN7VHsYRti4uXtIY0vzek0whjs3sCPSkEMgZn2
vsiXC891oY5E7iXraX8JDmtVHuEylPbBIngNC+0ubS5Pp8E2NGD8yVmJSP8+/YxOBQDmnA5b
AXN6QgetiDqj9CuOc3FyGd7kn13QXkUzQHyEk5BlalWYRgO18O484G/gwEsbi42gwzSumVk4
DUqNIjjmJQdyrsDDSEvwBEbCjmld5d0oQJzkHH0/iS9BCxZ1YofaGo4+K0vwR0GJNtjQomHG
3yeIB4wQVUQpQ22ZZLKA0AnODTlkRwA48HotdHgk2eZ3hnNGPSbo8D1o0K0INUCYrnYeQTcD
jIESQVg4TGct3TXPGFfOm5KwTKxEZi7fhfqtAhNUpgXsYNrchDr3Y/b6Mnl6RjfuZfJTyeUv
k5LnXLJfJgL8s18m7h/Lf+4jYSCqEy2x9MtLsXZD5dVA0+RwTGtdtLo1l4V3I08RsM3l6Qea
oEuidx19Dxl2d9Gv9XdP1187OBBNn556HTx31WlDeNscztQIVviwmSzS3OIpcFC3NeXTP9vd
5MvN483n7Zft475jvN8KN++FnIHv6hK9eP1mZGC62qjZ4Hkh0C1mBPCu1ntXqUWZpSydyY0U
Gh3YoXzTvDaZEJ7O6SCt8vfSm05kHS6S/wT3eilc9Rc50qC32NU8oHi29InXH2Gl1kJjSZ7k
Eq+G2nsV8vxG9+kQ1TYU+YHiUJQKOHn3sB0Gu1j1FSscahv4kFH3TSbrfvfln5vddpLs7v8e
3KClUucuQAEfAI4Nub5zpeagTDpS6l4wlbVgOrvifWmS3X7e3Uw+dWPfubH9QpkIQYcecR1c
OS5Xwa5i4qvCktmRuAXlsDe727/u9xCsvu62b++2zzAUeZzcEKq5lgp8omWTbCKW4A+MTTI2
E8HNlrt34WCW0YzDmY5U1rqziUa1MxKzsK7H8SPBVUbNBizYAWo5zIE1UC0siQiu2x3EMeCM
yUKp5QCJOTOMbOW8UhVRGYmOHgpqW9g5UDnolkOsaGV61ZV9jAmqwsVkrogsD/JyDXsmr3OV
tEXGw+loMQerhvoITSKW6LlKvXI4yfaq2wc15320EsFm+ryuGagAVO8l03i13RZDE0St7fku
WpUlHj3FUOugYTIuyK7G4K6lWw6UFsGDSLMtQwvRXUmn710QbQeNjNXKj3GbRW2yIE6elnKE
jpRoDqV9XJwZkdnCwAKjau6SMwM6EJx2EUvBZRo4KSqpMmHc0UO/EwspjmIJJsUGfHJVNDXd
NiiYO4i3a+3u2+X1kL2x6zMgcAOQRyts1XtTRL+eKxTrxCf5MBbSrmzfqjJR66Jpl7ErVQ1P
K1flVctwbf3iF54pdIRhjcCOJD6iGbrJ0eGuU2vUvp2g68VgBrg/YL4C7dhf9eAdglfVQenu
5rQ0x7S9bYCwsjNkc65Wb/+8edneTf7TOOjPu6dP9w9NWXJvJYGsTR7SZQxHujl4IBBEY62+
Mpbzyzef//WvNwGP+NpJQ+Or4QDo8dOBa37V+KMZihJd7uBRZ8ziasH/GjbyW9Qo1qAFqmFZ
9KB44xuWt5sLaIYcq7d8k+VKnAwWEXmJmuZoBpGcA7VpSQzKqHCwoakKxEcbN2g6ouuNUAyP
/RjNDy/ERAr0O0pJlxO1aNw1DdbsGA1W3awhlgCPvvDqS2uZu6wB2bQq4NCAwbzKZyqjjoTV
Mu+olm1xWrcfbS304XFZG24kqMePlTA2xOAt3MwEJfoeOPa+TV9AasVcx2S2o8L8M71dHQUo
I2XtuMLII+vCdKcF6HAeydYzuqClr6QGP82dIB5n+kDIFekONmxjHV5qhiuHG6JKlo183PJm
t7/H0zSxX5+3YZkclly5sJAlK6xnJc+GSZTpSfttROfeB/fhzmDEQEBGATAyn3/EpMEIhh6B
X0+JYBe1Na9Zqb6m3vPRoZ1UTS4eS2dx8zzT3SOXV7Mweu0Qs/QjqbLC8boeZeHEw5Sg81BB
wAzD95savDN6Df4YjmzrSu5jjX1k2PpgA917b4lj0cXCPUkcM2ys13TTEbxPC7hNEv/d3r7u
b/582LrXNCeu3nLvbVef1xgM3iNctORtIoDC0l98ai6BOmcEW7Xvh4xSKIZrWQa+QIsAVUm9
Z4W9Y+e+iMem1ZQdbr887b564fY4kGyz696yAQBc7cR5LC5xPXBWRd4cn4ZmhE+ZsfU8SKuX
GThNpW0OHebJzwO3ioenOZdzzUJQuYDolCWJru3hltGLq/HGalaF1ckmJxaw2xTnGeaycH1e
np/87qXmKX+dzldngjVBIV0QA3GHxSCZbpzTZTTXpVK0Ob6eVbQJuTZN+TKJdFGvuyntYh06
QSW0u4WJvh42x/dJwGQssIowlh9w96NYUoZhTFtA25X2RCWx66HwX3nB10WAV3QsuvNbbPf/
PO3+A87oWIhBhpYiOEgNpE4ko/JoVSG9anx8grMYpGscbNi6l5GMXqVNqnNXxB4pwsS7e9ro
bpIS69eAZ8rXkUU4O1k2d7icGdrYA0FnSGuw5FZQBc9AVBb++7nuuU4WvBwMhmC8SaBluSXQ
TNN4t5mlPIaco9oUebUh2GwoalsVxSB1dQWBg1JLKejdaBqurIxiU1Udw/XD0gPgttRsEceJ
SM2rbFhD7RfZ7X66PhAFcgCyvOzAYfdVUsYF2FHg7dRxCsTCvmAOhRZbHB3+nB9z2w40vJr5
qY1DuN7iL9/cvv55f/sm7D1PLgz5MhTs7DQU09W0lXVXpBERVSBqXo4ymPZMIlEUzn56bGun
R/d2SmxuyEMuS/oS1mFlRlsHhxwItI8y0o6WBGD1VFMb49BFAr6Gs+X2qhSj1o0YHpkHqqEy
a7/wEDkmjtBtTRxvxHxaZ+tvjefIwAjR1i4vQWRiJxq/TYHpyKEFG9GAt+FSPGAN83JgMXvS
YULzADqchc5y8afdFs0X+Gf77W70zY9R+97w+ay1SPgL6+Xjr3mPSUdfmzhCmylaHYwplaGP
WIGvwxWFczdiBPhKM/QDgW+M4og49axsKKrusunYoge2y4ioDV0FfTexXvnvI3vpT6Ex5yi2
dKUHzrLUanN1lCTBMPwIHpcyangb9LHmWvwh+BEmYRGACqKUY8cbSYCHI7txbNXaZf17+v9f
WFqFBgsbJWkXNorvVyZK0i5uTJFP40t3WJZjs/bCwrKR+Nj6Jzyi9lC8ecRt0wm9n6DPae0K
gSIJz84iI8y0TObRV4+dg+GqvQK/K4m8i7LKWFF/ODk7pd/kSgQvIgc5yzhdaM0sy2gdtYm8
yJSxMlKMii/r0MNPM7UuWeQDH0IInNNF5IAK2xRz0lPmVEFRUmBNv1H4waMgtQDbx1x+jexM
laJYmbW0nHZ6VkR04vPpbELUm8zLiAvdfBeAHnJh4nFUw2nUgABF9g4/TIRm4hhVwQ3lTWm/
7k+n7qsqvje+GRSoNulS7LDUkRf4PBqeMWMk5ZI5txw/CWKu6vCN8NnHIPbB16f/IKuwXeyC
+fbm61lh9DzZb1/2g2shx/XSjr5B0+qoUcsBwg/Ivb1juWZJbCkipyGSuWagjDc6ppTSesmp
XM9aapEN3CiezvG0Ba9MNEvRIR6327uXyf5p8ucW5olptTtMqU3A43QEXna3hWDSBDMfC1dp
jvXol16541oClFa/6VLGPo0EO/J7JG/EZOSjHqJc1LHbiiKlF680DO/c4tFzSuMoP71TP8bW
g9J5EHxgL/jIQMpkpla++yzswiqVdapkeMPcynsnzsn27/tbv1zIJw4S+MOH9tNfhgRS72ED
WuA1FZxJYrqIZcYvf+8g1PvtB5yr2TLALL0tARkWT34Xcf81kChhXVrqrOAS5GawULFPqCHu
YyX10gymduTbA4g1torYTkBKRetoxIFKjePYQJH2Gqit+Aaq0XFH2O3T43739ICfQbobV51h
36mFf2Ml10iAt+DUS/P+gm/wswGbXm5f7j8/rrFoDHlwQYp5fX5+2u0Ho4s6Wdcl5uIXKpLk
c5sElp7W28eGasa6udvi9yYAu/VWAz+qRjPEWSJAuGJcdYHXN7s93M7Ru3DYIfF49/x0/zhk
BN8UdO8pkcMHDQ9dvfxzv7/96zv23Kxb18IOq9S9/uO9+Z3x2LvEmpVyYBr7GsD721arTdQh
y31oWTVlIgvxP86urclxW0e/76/w01ZSdbLxTbb8sA+yJNua1q1F2pb7RdXp6dR0pedS0z1n
k3+/ACnJpAxQs5uqyYyFjxRFgiAIgkBakhZd0HRkVpq3JLsnTYauJZaXVB4FqeVRVVa6+t7j
UgXH7Fi393Z8/Qoj/N04QTo32sPcEOY1bP/7ejCIUv8JPVrHjLr9FAJJ+RhcQd1qc+uX2ba0
P6NQbgj61q1xkNb3FB5na29xZoehAPGpYjbCGoAOlG01oIdnBSO2FSxQN3ZbsHKEJD6xv8OL
DmlHWQwidlbx3jqE07+bLFPn1babyy1z9Y71H9WKanHbtgozIbfNPhFbvNlBa/ZFLZmNj0hQ
uUCn5cHaabm4dy82VJkCdItwEKSlp+5zztlEUhp1JA2Ts7oRct3y7PCYRzIer0DFo1CMNGhW
oL2IadJdsf1gPcDjRa2CXp9ZJ+Pw2zr3KtDuAPPiFEeNPpU1W4sa0yCe2VXeBBVqKcSHtC4m
lINLfkxT/EFr4y0IZb8Q0B6JcTG4EDAt+AitdgLSomCMBS0gqrZuV5l8hC7uRug1fb+qo1cB
/QVhhBdqYKcURif6DRgVDccIlVliILQTCb6HGouxz66E3fV6W3fKYkqB6PsK6aR2D4RmuCvo
NnZmpdqP4OXtiZIQQeTNvbqB5ZiWACBjswtyPGMzCXLJBHiSyS5TYpo2m4Ris5iL5ZS+/A5a
SlqIY4XBTapTEjLy+lA2sAuhR7KMxAa2dwF38ifS+WY6pWN3aCITKUfEuSgq0UgAeZ4bsz3M
1ms3RDV0M6Un5SELVwuPtn1FYrbyqcgAJQYSOtjBvFDYQTc2cVguiPCE11Zxc8dU226Cd1+t
bkpXbkS0Y64Ilqcy4KI8hfOh/NNuPzGslxml02oKTFrmJuaVTtsCW7qO1OJCZEG98tfOSjaL
sKbNyD2grpdORBLJxt8cyljQzNDC4hh2NEty3g+6yuja7Xo2vZmN7R2avx/fJsmXt/fvPz6r
uHVvn0D1+jh5//745Q3rmbxiSJePIEFevuE/zSGQuCsk2/L/qPd2cqSJWKBLmXMGKVAyZ6xL
aHUPUFsub/0Zky/vz6+TDPjxPyffn19VBgCCz05FySpArioMlSfOz/e0JIzDAxcvTIQYPg7D
hIZ0DyhIJUX9E4ijoNW/Q7AN8qAJ6ODR1rph2WiSyD5rjm5ZC11228JGt3ajh/68WWG5SFdB
EmHUfDISMxYwtj9YPDJDtaonKgTvrnc5Ui1oX63uvE5+AX7761+T98dvz/+ahNFvMF+M66a9
hmE1KzxU+invl6vItLrbl6Ylbk9mzPbqs+DfuN9jjPcKkhb7PeccpgAixMOD4VXKazfJbl5a
CoIuWia3w2JDduEYIlH/HwEJzGAxDkmTLfzlwFQlVU0XPnvwuf9h9+NZXWm2mFtROM8ETVVB
qFRYTscw1vvtQuPdoOUYaJvXcwdmG88dxJZfF+emhv/UrOPfdCi50HJIhTo2NbOj6ADOkQpY
I4smB6G7eUESrp0NQAAXoK4DbJYuQHZyfkF2OmaOkYpKCYsTLeL1+9HZBBjHgcBtPBO9D+kx
tG/OhAcA3UZJ1Tw+czkKeoxDEeox7q4o5WIMMHdPXIxMUt47+vO4E4fQya+wRaMnqm7ChbGD
dFRX6zjVtV2N6sVsM3O0bddmLeFWawXaR9KxEnCxczQRs/o4WA3oAWcO1x8oY8dEEJfMW4Q+
iAwmuKZuoINT72GVSkIMdeJoxH0ajIm/KFxsvL8dMwYbulnT2wKFOEfr2cbxrY4ozErPyEbk
Upn5U2Zzq+jalOB4/4AHzKVroFL11lEzHQ1aMk5xtS3wYmlVWfdrkVYq22nr3XY18f/Py/un
CQa/FLvd5Mvj+8u/nycvGMH6z8enZ0N5wyqCg3kypx5lxRaTO6Xq5CtNwot5ktoXUucPeNJF
a+yICOMTveoo6n1RMeGA1TuAzcPZas6MrmoFrjqqLh4jkpQMl6Nou12vYkJHPQ178OnH2/vX
zxOVT8Loves2OAJ1KWJuEKi33wvOfKobV3NN22ZaK9aNgyd0CxXMsgQhUySJo9OiMyP81MjT
p3+KljtouGFNBBMltx0GF5GRhop4OvPEY+oY+lPiGJlTImMhbnc75c/3dal4kGmBJma0bNHE
SjIrnCZLGEYnvfRXa3qgFSDMotXSRReet6BNGZp+4S+UKkC8C2jeVlRYwRcrR/VIdzUf6fWc
1nWuANryp+iJ9OezMbqjAR9U/DRHA0DJgR0GzdcKkMcydAOS/EPAxFTWAOGvlzMmmLcyc6cR
O901ABQpTkQpAAix+XTuGgkUc/AeHoAeRpzqqwERY0dUE5zZMmsinsFU6A7uqB6Ey4pRRUqX
fFFEWYhDsnV0kKySXcooVKVLzijiOcm3hR3FS8uZpPjt65fXf4ay5kbAqGk8ZZVNzYluHtBc
5OggZBLH+LvWeT2+D8OAddZB+p+Pr69/PD79Nfl98qojdBOn/liPK/GBepFrb0MzaBs4lj3C
2B0FFQcIHUIns8VmOfll9/L9+Qx/fqWMirukitHDja67JTZ5IQaN7uyOrtcYnoQ659Qgj1N7
5fVqEQA+42xH6gSIpGAD90du+x7fq2BJjpt0jEubuhMVM8cQWRCiGzFthylZ0qnmKMg4zAH/
NqjiY8TEq2IcpqF9gjn6QJle5KJgvPXkkW4gPG9OatBUalGm9Ml5YDm4fJinGbM6BdXQB1s7
Pb28vX9/+eMHGreFdp0JjGAb1qTsnJd+sojhPYhxTQY3SE9xHhVVswgLOxRXUXEbVXkpDwUZ
Dc6oL4iCUsaWk2D7CA8Kql1CRiAzK9jH9gyK5Wwx4+4+doXSIMQb9nZKWAHbpIL0jLGKYn4E
q70hmy2lPfKQYuwjsuDBrjTOg34gxspaFnL46c9ms+Gx+VUEI1stqMNKs06QGLlMApIFgDPp
59jcwnJkDGTK3RZI6R05Euh5hRSul8eG+wi7butyhH7S5Fvft9e828LbqgiiAddvl7Q9Yxtm
KMWYw4m8ZmLUc+wjk32R09ovVsZsEC9Cxtnw/NYsOMJQ8MHonWh9b06FgTbKtO6MZhmQv9SV
CqsQZhwxy8jDMUcnNeiQhkm4aEJO45DtnhFOBqZiMG1GlJJZYNLk/jj0PbwhDtpIdMIhTkXr
Xta9Vz9qJJOOoCPTnNGTaRa9kkdbloiwsGVSQmYsNopg5L/cmmn7OEvyhJRlV8Um23CxkqNR
+RfZq4e+750m1GVws1TrGH99UTpnEicBowz9wG/rwwjvKivhdc7E89G2xw9tVu9rH6snTa4S
VOWwuGU6OtdYTTpqp9Xxp5EmH47B2YyqbpASf+7VNU3KpX0iF3Nm7JgNgK0ojDfSnj4SgOfM
bE9qrggQmJcghatuybUMCFwZ5pbALptNaaZK9rTE/5CNDFprr7AE7SnjpJC4Y+KtiLvLiAqQ
wVuCvLBYOkvrZcMdXaW1x+/QgCrOTvLuPNKeJKxsxrsTvr+kV1QkebT01CR4I23SuRMPUOuN
FwfdnuJm9ubh3P+wYrg+D+v5Eqg0GXp7vVyMaDLqrSLO6GmbXarEGi/4PZsyLLCLgzQfeV0e
yPZlV/mqH9H7KuEv/PmIPgX/jKtBQlwxZxj4VJN3Xu3qqiIvMkv25bsR8Z/b35Q08J7/m8D1
FxsrF0BQ+/56w1xvjud34xyVn0BhsNZOFaAwoveTRsHizvoawBcj63Qb0SfO90lux1U8BJhK
jh7eS4xO/7tkZEtXxrnA6KeW20YxqjvoA0mz0H0aLDiHgvuU1ZqhzjrOG458TwZWMRtyRFev
zFJM78NgDWsW6wB3H6I7IBdKo8pG2amKrE+vVtPlyDyqYtxdWjqMP1tsGM8YJMmCnmSVP1tt
xl6Wo2sDKXUqvMxckSQRZKA+WfF0BK69jFO3WTI2ozebhCINqh38sSa8YCxY8LzZ4XCO8KxI
0sCWSOFmPl3MxkrZOYMTseGO9BMx24wMqMiExQMiCzfM2UZcJiHrPQDVbGZMQUVcjoloUYQw
Ya3UViZVqlXIaqrMgPd/YlSPuS1syvKSxQFzrAicw1yACPHOd84sQslxpBGXvChhl2xp/+ew
qdP9YALflpXx4SgtaaufjJSySySYCuesQuMIJj6PTMk8gWad+sjDqjhceL590HRb7mQvMfCz
4TOwIvWEqRYGQVlvqz0nDwPTpn7SnD2OUXvAYswE09/77Mu23u0ocdOECYXUYoI64SXzLopo
LgLFjhH1qGw32pZPG9gOF+7quNZhUQXdbDzuPK9kPKboLe1RbHWkD52ZxewjJIWBpD8ciXew
/2OshEgu430ghr7WBr2SKXAbPbZXOq2gIx0VXp9Z3pEOfziDAZKT8kDLm/NAlHfBC5pzRNl2
EX61Rmd6SaVo0jIWw0+HZxJQPU7lsyvNzFAYJsmwOxLUzjhDkLodOkOqYK2zhHCBHvk0L1aJ
yDzKvcWs9LolpYgx6LRsn+p81Qyt128ooumAbhLMiNTmc8ngHy6RqdaYJGUDj/O8d+GJVQyL
yfkFw1D8chuy41eMdfH2/Dx5/9ShiDPSM3cwltVomedUWpA4IqHiDajzu2sIiKvKLSJyCbFT
qcDPphzcWmwvZHz78c5eGUjy0kwEoH42ux3esxzGCdE0DMDCxY7RCB2R/45LS6NBWSCrpB6C
VIOPb8/fXx+/fLy6eVnd3pYvMMa5sx0fissAYJHj0+D+Z/d4IAqMTuQCbOiSd/FFpc+0TBvt
MxBIpef59B3LAYjS4K8Qebel33AvZ1NGiFsY5u6cgZnPGMNHj4nawEbVyqfdYXpkenfHXOHs
IfuSsRlYCMV4TMynHijDYLWc0Xt3E+QvZyNDoflz5Nsyf7Gg57lRT71eeJsRUEgvzldAWc3m
jBmsw+TxWTJH0D0G41mh7W7kde1uz8WH+yKNdok46BwdguRIIYtzcGauZl9Rx3yURQqQE/Qp
SA+p5WgtYVDCdmpkULdk3CRD6FyFpfrZlGJOPGqC1MoJ2z/fXiLqMdpM4O+ypIiw0QlKmYRk
hT0R9oTbIwlpnQcpkopIqW6gWvbGnh6nuHYyTmFGI2LUVRhDjfG24hge7sgIXVfQrghRYTCz
CRsvygYxzTVJxFXC7D41ADaoaaxe7wDB2Huch7tGhJegpNV9TcfuYu9NashJ1HUduCphBWL7
rf2Au190xXH3FPt1EsP+MucbCqKiNTIBQTUAe1bApog5VGjnzyCCv2FXS5b0VdrD4/ePKmxJ
8nsx6W7SdTspND8b3vL4E//fJtW87rgUAXR4YCCC8zQZtnp6Jg+KVQHj8ayorV/IoOLhm8U8
u8k9aFdThSN1BOXWDdBrJAM5KgxJ2gdZfOtj0HocUb1/vaVL6JVaUfv0+P3xCUN3XqMjtG+T
8nIdsJOVj1O5celEA6nKdCBMZAegng0zUh7OBvqqlkuDgDklhu55XV/lSb3xm1JejAZoV0f2
oc5R9d9zb2UPS5BifjYdVojx6cuLh4I7hWn2ggkEofPHghJGF8QIJpK09PTrtjUS5tM2lstN
f6cqJjbG2mmzMLXPQYseBGWBJ3eDiCf65sTz95fHV2MrZfeUkYnSJvg6W/PtQ3gTLGwhbEsj
5TVb2Km0TORs5XnTQKcGZ+/8Gvgd7rCpnA4m6KaPrLZZF6kNghV8zyTEdVDRlLxqjkEljRwh
JrXCPHtZ3EPID9L5ixkF2gQGooyhP09Y2yg44oVj3zo5933GiG3AYDIybiktqtj1vs/dPj7/
+uU3LAxoxVnqSjrhF9zWALr4gjW2mxBna7FfhqZKG2FnvzEeUmKpJX9gZnpLFskuYVxqO0QY
5swNlR4xWyVizV3L1SBQgVYLN6Rd8z7IYD/GIy10DJbs6lXN7DlbCAZgGaumtROXYhQJ662L
XJX8SgvknUibtBx7h0IlOd5WGIOGeEajkjUm+yQE+VqRq/FAfg4YLAtllSo1gGAvlbiNMQGj
zC8rkHeUuDuculBsxsqrPaAJZk7KLGkOsNqlZCQ+WH91Ok3LbNk9VOkFQE3hgmVdgY6Lnqjn
QxfSNajcHnwsOxnCn5JOkXQaKpXAbOmFi2ByqwGZjdAfWx2FZDLRa5MTKPe35rq54bILPxq1
aQUuK+zHfRa369Dg0wOAOZsZ0OlUM0jREQnV6t8JX2xfrx9izLprY9sIkxPYrMHzT1/f3keC
TOIrgjSZeQvanNTTV0xwqY7OXEFT9Cxae0xUek1Gd2uWnvjM1WNF5K5NIRGvAzF5BICaK98Q
Wt4ounImgXlNJ+VBiEiE5234ngP6akFL15a8WdESH8nchaqWVla3MTsV6/7z9v78efIHBjPU
Az755TNwwus/k+fPfzx//Pj8cfJ7i/oN1vGnTy/ffh3yRAgTjN8OIyKKRbLPVWBO582oIZY8
0EFQvJ9PbyZOnMUnfoicDUwyJpUQ0D48LNfMVTkkF7ypTvFVOHIbDEHV3YIfWpFkNxFdDbJe
T29GN/4bBNsXWIgA87ue4o8fH7+981M7wtyaeXNkzBWqncW2kLvjw0NTCCaYN8JkUIgGNhw8
IMkvQ3uHak7x/gkaeG2ywZjmHRtWqg16jgvbrIgpF5ZacyEGROWj+PWQIN27+B4hbAQtY+0w
yi1I9bq0nBowLtHNcahB0+kDhiXI7V6ZTLLHtzaFRyf9o1sWUaGQlKZIK0lIrnXEJO3oxsK2
idwGXMAmoLe3G1j6VUKwEFCyG9Tp2AhqgGEFAhJBIMDfO740Ko6u2gvN5Sy9rAMuICmS0csL
3V1ZAOwTfFgxpowOjAjHbgSZoab3cUCSRRmmyW6H+vyQh2r01WMrvRVGFvnhkt9nZbO/H/Rc
z4nl96/vX5++vrYsecOA8IdTjZCMEVoxAzofp1F9Xhqv5jWzkcGXsJJBlIwR6MDEbCntoDVa
5ZLl5On169NfZLRyWTYzz/cxnXt4e0zcnom3Ti94/Mpm/jIOxx8/flSphGE1UC9++y9TmN62
x2hOkuOGhTJRweyBNhjWKf1AJVEt0V1DJ/HwZvMOUexuNj5aQA5nolGjDizWabNtKs7Pj9++
gWKiihGLmSq3Xta1iiRN21PL3izM011ySAGiM5dTR5HRUsRTdxL/mjJ3zBWkC5/t1B80smKl
maIf0jNtU1JU5Qp8opd9Bci2/kow8Q70KAVZ4EVz4JdiS6vAGsaLpG6wQ+Z0VNEd4kWPaBY1
u6GSb6dxpXinV4fV0+e/v8HEonjK5R7QAnLm1rQaJMyK4BgGdQrNWL6uAOYeoj5ZCIONx6iS
LWDne66BlGUSzv0hUxoKy6CL9LTcRVTXdR1/S+2TG4x0+FYOPNbsb7EWp/YZLN3oMci4F3Sg
WKOY8LkKVUXh4ibYiZFJgfokXMJGPgnk0mzleK2ybXKOyAab0NtcDQgXC5/ZsegOSETBhNXT
06wKZsthhOjOvHX7idofCLR5ngcI6rDRsNwd6clzpr9VZ5gJTpSXoaZhPHo7ic31cZciwFG1
xrGCdQjCf0rOhmiClalBPyl29C7KhKcynG8Yx04TR7yeQGkRe122b2l9yyzVT5OqWEX7zIqI
luIYfz3jUNYbxbEs08vt4Ojnrnw8UaChtHUQc1PwZLSt7VWe09Kbrmi+2gYS9AJogphz+34L
8hO10IPXQcSWNh90jeXoXfnt/ZyNBNphQGjM1oNLLhyIuTbftgZA/oYJH99h0tJfz9dOCDut
+jrkYsVcKuwgUSxVsg3V8OWKsRt2aOim5cxj7p4bmDVj3jQwnr+he7Ifsmy7WNId0HX2Pjju
Yz25l9TFlx7XnvqaU6V7TSU3S49u7eHMhTrBq+EZ44ZzDjA1YUGaFdBHvRAi2Q6OxgQVd2Ab
ZgEJR8LNtib78fr+8uePL0+4S+m8FQjNHlSJJgilD1/NuOYgQCzWjIm4I88ZaZoloVbymAwI
qnwg5/76Nqa8DUJHc2WB4E45rqhDGjKxvhCjvJ2mzOxWgGjjrWfZmd4Vq9fU5Xxa835IO3SA
jLitkOqUKIApz7cByd6ctYcYEFcjFITm5o68ogeuJ9NiqSVztycUOc35qrNwhjcjnd/XYVwf
eEhWy/lM9Sg9Z2WossKF9GcgGarn9hBpCWTmhANp3OkHtuxDkD80ISzYnE8bYO7ijHs1kn1f
RX4dofPDq+gr5lRf8ygIeW9NS9UWsF6vHFNXAxxcoAE+vY5cARuezRTAXzoBsHg4P8LfMGk7
evpmpPyG3qMqulwtXMXjfDefbTOaQeMHvKrPXBnA4qGTekpKDMzLOVkhpIolbT9AIuxeQWtj
nLlVaWrPZtKlN3UVDz3p+Q76nT/le7bKPbliPNaRLuLQvWiIZLle1SOYzGO2fop6d/FhjvCS
DC+kksRgW3vTkUVNyKykFHpF67YVVgmJAakXC69upAgDxyqXlouNY9KgPsnYXdrXpJmDbYI0
Y0Kvy1KsZlNGKUSixxnoNJExpahGKYBDlmgAo0j2gPmMn6z/y9iVNTeOI+n3/RWKetiYjeie
ti5b3o16oHiIaPEyQeqoF4baVlUp2rYckh0zNb9+M8FDAJlJOWJ6ykJ+AHEkgASQB7YbeqZn
Y64Q01t+Qam+0tO7CJgxb88N4J7pJw3Qv/s3oL5dFkCwx4zpGZCtg8nNuIeJAYCG/v1cvg6G
o7txPyYIx9OedURZBjM+1hX9Idz0MMZqM+sRg4LY9iNrwVwtK3kvFd/iyOrt7RrT19nrcDbp
2dCBPB72CzwV5MpHxqhY2F/K/T2j74/rbuyHIAXfDTnrVh0EMmjPCt6U1AOSGcpvPWtwFnrM
C9hCKISI2wJefVPadwy6lIPORwOL85Ke9u0yaB6qrlioeGOL0+7t5+Hx3FVoWi3Q97b22FMl
qLjhiySXX4eaTrWTdp+ZLUjTo/BVLdaTS5ydDP5hfTwdjgP7mJyOQDgfT/+Db9PfDz8+Tjvs
GqOET2Uow8Cedi/7wV8f37/jC3db6d2bo9/gQOhhZSEtijPhbfUkw2VMHW8WOpbyc4KFwn+e
CILUtTOjZCTYcbKF7FaHIEJr4c4DYVxfYkkwtGIRYUQ6wVi2Agpv3iptMHrfA0wmAvWBrKVg
3+2qn7WmBXEix+qKNGWUFoGahLQ0ghm3czcdcV7LAABHoQAVwTm6CGXGEvut6AAgh86QdXiD
I690ujhqKpg4DVivO+aiDYfGytKY/WYK53Dm2gb7I9sOmZWppLJNpfcqpFgri/NYNWe9gGPv
uDGwKHOQBfpym9JHSaCNHWaFBNoqjp04ppdXJGez2xHbmiwVjsvzi5XSlhiKTdlCbVikOHUW
7CMQqXO+PblD37Qhm8zDYrHJJlPSIQcAqKs/7AORZjlzgYccVrvoYgFz6EOe78vYxyxVwqxh
zq+qN+6GrQlfh7amVt8yhvPu8e/nw4+f74P/HgS207WCv1xj2HDEDCwp+zyCoAJIIBZ+1gOt
gzj3f7kOEnM+PqtwjW/Pu9oPO71H2oRB08KCvwoZe1kh7TQOAqwfMd5lwFm7baxiJMO/QR5G
8uvshqan8Vp+HU21IUmt0J3nnqdikRNOuGtd6P5WakMQt/Xd6ijdbelBE3zinHDn78OO2elF
SDTUzoVzeSbJUjdaMB5UAMjZAOY+uTVj0ZWCRa1eIt/2j6i7jxk69k+ItyZtJ9Yq1bZz3mi1
RKSk0raioc1rp0hMFLSAp+h52vLjpHeYGyxF1OlGN4uTwqO80CLZ9t001eScMk3Ar227JDvO
ueMHkkPLtoKA3otUdiWF8mRoWSZWbiHnN1PSK5tCNcbSRmZggkUcpVxcHYS4oSyYV1dFDlzu
yr4kU5pKivJt6Xa6auGGc8Fcdym6x2j1INGPg5Z1m0GGz/Vz3XLL90JuK6Uflr62Ai7UDpJX
wl3LtpNBs2XbVNmHsgCB6lU8lfEyhbQ/rTnzVoHUbC0in3TnVXZaJEHgzeLO/Ahs/tlY0d0o
XtEiTcn10J3KpLsHEmRcdJySvvVgx+IHNHVL/mbaVnorhY3GnMVhjG6IuryJ1s6in4MiJsZJ
SUuZUNpIxTgFPOsmINTDehPEPVMDxPcQ7XV7AJkVbBl1MAVAKy0mYqKio9eEFLmYCbKOmFSg
YyF+RKCAHjZOY9u2+CZIS/R1E+Hhw6SjDWjA2RcrBBtPpKK6AdqecVHmhXL8kQTM8U61kNOI
xTUAPQ3AIY6frCrq5Z/xtvcTsBvw8w5WKekyBrOK7qMJV6kPz6+GKDwUCXNMKtfDvl1hI4BX
Weo3N417G4hesdi4WaqbVMDvwmfMGZREELTjY9YKW4RQ02hskTIYunsj5LCEifpYwTt62Zrq
l/6Zi1ma8e2mOGXI1v6UbvehZ2tcIOgf0OoVY9BEvOQA2bi8MrmsjUivrsLMRNRwN/cH5R8v
QNOFHgd98GfEqTIj3Uptv/AtWfi2Y3zQ/HppeG6UbEURrIS2i96DquNMV60cA5bvn593r/vj
x1n1euUnzRxYx/UsWPgLvBoSMmt/ytlGFj74w4k3Zu6OVL9m9KpU0Yq1L9DTDKOEX6PmgTqq
yazN2XrbQbSWOax0EUh3bmBtv47MgkIiFJXiOTRo7DdpUaN2e7e5uSm4yLoI2SATtQAa2a3I
7a5U6SkqwkHrioxSzGtgWYZjK0EIN1mjpBIsodI9SV8C6LXqVx5XI7HJR8MbP+ntAyGT4fB2
04vxYEyhpF4MqreiDgTfnfGlO4lUqi/iTzc1J0bSAMhgNuxUzkCkM+v2dnp/1wvCyihNxLYK
ZMOdlZM6+3l3PlP3qor1bb4lyhSc2dGQvnb4vJn5ul86aYgz938HqguyOMUrwaf9Gyyu58Hx
tYy9+9fH+6AOoC6dwcvuV21DvHs+Hwd/7Qev+/3T/un/Bmh2opfk75/fBt+Pp8HL8YRBdb8f
2y2tkVRPiZfdD/T6qL8e6Azl2JzWiSKjTMzJWAAQCf9aopYHJ2KkAlW6GmyH8VOg1tM1o8xT
EXl/rWj9JRyXlp3qKXln+mNoOk352GDYquuFq8lm7iFMfjcUjBpWRR3RT5uKpZ08y2lxuqza
Srr8zhK4izhjD2kK0TMpqysD+PfOZhTFSphSkOS73eFPeWoVzByhPIzxnYCXOw4MX8B43VNd
IWDXm68W/PgzulhqhqcYQmcl4JzMPROqpsRrK01FD4K1oyu3GKkiFsI654lNlvdMIyHxQtZj
LugAsIXcPF+431TPMgG91CTMlQfj0XS4oWVkBZIg2cAf4ymjv6yDJrc39Juz6nv0rAnD56b9
XWT7ViyX7pacbcnPX+fDI4jmwe4XbZYdxUkpgdiuoPU7kaqMD1Z9oikuFR2TEU0+Z2rS+ozl
LBj3ctk2YSzU1ZapvH+tRWZT/qPDUHOWkaxT6T7AIkIklu8SmrvB0AYJMraXRFIlv36dXWoi
0eCH9fGCOdsjWYrVof2HdP7A3J8RKbEczjAbadIxYsc3SQVaj9kg18s4lRQ9aWdLhR37Ve8Z
n6/wQeYxmsfYVOGFuItz9PrliQWwKh0h+oO445SBQuWNAr4cMhqGqv/oZQJJ6IuBeVtVZedz
zoAOybn0+a/m0G/iFniVunJWzXrwTdlTdWQZF4CNNYyYMKPFj9ANeZeOeNSDXYKe0yWniLkI
BPPoK+D/I6hYRInZaWYXhu0uJqjHMjPJt6F5WzqxOod+/XJ6f7z5ogMwIiKI5GauKrGVq6ku
Qrhpg7So8l6nplqKTvZ1r9MaEKRir7EZbqcnaWwTyS0P03p6kQtXBZsjO1nVOl3RCwfeVWBN
iWW9zmfN59NvLiNfXkBu/I12TXyBbGaM4nQNcST7aqtDGLeqGuT2jt6Ea4i/DWecA6AaA4fA
Wy50S41J5dQeX/mWkMFwxGjkmhjG4KMFouXWGrQBCK2WVyOUdS2jnWBgOEMFAzT+DOgzGFOj
uT0Wk2E2u2nz/4UCJ0l6x6xh84cxE8qxRsjxdHx/QwuyNcYLx0PG+1HDEcDkzL6iQaaMPZ5e
CqNeX0PccHzDWK81pawA0s946Wo2Y8TMpmMcmJOzzsqBe+uVlQPHhrFCMCBXp/OYcSBiQPq7
CyGM7rYBub76MLrQxrLBGHY3vX5/x+jHXxhgcp1HbofXOA2Xp0k/B5TLXH//wgQdDa8sGaGd
3N1TcYbS0iCogF2+chDU8A+6BvnEDuTI8Wj8mRp+Yjrcm5cZpY3/8+79+/H0cq0edhjTko7G
HiNGZVqDTBm7Px0yvcqqt7Np4VmhYHQYNOQdYyt7gYwmzCmyWQOy5fAus65w0mSWXWk9QhjD
VR3CBDloIDK8HV1p1PxhMrvC1Wkyta9MQ+SY/ilWOgvqsNTx9Xc7ya8yVI/vlmbPyeCva1tK
z4mjGcJo1c+8adtfQ6P/JPev5+Op1ZhWbk0LsKI4aK6JcrQZVK1J7YrS6oMA6Ko9Q2Llr8so
v4gN8//KRWwoFw4TSAvz9HjKc9bKO5jDRgaTQeFyZaMzrtCxC5aOYQ3wYs5iPGskwYbNrGJJ
+pi5CBchLetcMFzj2IZVNPaACHS23RVNOSwhARLONA5hT41p9vNh//puTA5LbiM4svJ9Aenk
WQbS57mnPSheaoAleoLRFy3zFb5rMY/TrYJrBrTyTXU/ajxCO5M2f2kMYklbCLwANrJkw9sl
Y6mDRvSoUDpHr9W0QpgOobRuNLrS3DFeprgYuyJt4scRRZZecztufEM3yg210jKZ46qKPLeC
IGb0CiqIivnA1kN50OpWJkTvWKWxRHFZiapn6MfT8Xz8/j7wf73tT7+vBj8+9ud346W/Nne5
Ar3UdZG6bS++Nf9lFqxdRshTmKsuE2ZQxci7H9GmgkDkIgmms7shm0tOuTNoqQ897T7RyLf9
7u+PN/S3q7Ruz2/7/eNP09mda3X84Vw0OqjcWuayU4qOomVpYvP6dDoengwjmiqpWwRvrQs7
QgG7wd1oQnpoqmMVWLljunxbyMJLFhZ6iCHLzSMhtxLDk9FTUilnFHawLDZBtME/1t+YKqJF
gEd/ZSnvuJ0/ERNzxSiNo3bnv/fvlA1Ti3IpaCMC3PSgvcJjbCGEGzjoPZdzaqiectVDwtyi
l6h8TbNsPYDuxrMy2F7pfS24Fu/bNwKu+wnnmT8UiWze3ykdlRZfEFEtEpFoMgiMK96/wfIF
00BTaLRWrhr8JHWBRfQMDWPUS5F9fHk5vsJGiL4NlfkBRhDUZxkW5EuHvr7QOA1OcvcTJoia
BpNiOp4wLmtMFOfYxkANaWHGBE0+A2KiyWkg27HduxvGgY4J47wT6DCJZl0FExxbA67sq2V5
YuM6HU+OXdw8lqVWbxUK8Mf+9fA4kEebfMiuAlkU9iLvE/HbsNGUi9Fk4pgOb8M4t9IabDPk
DORqVGbn2AHkVkF3w8Xog5wg2nxfy0REpCfSMpM8fpwMVz1VRhUkoDxDGClJGs/NSS5Tu1w8
WtHom9ZhPmbJsdMYtSRg5chuJ3OyA8hqamVYIpgz5ngCeCtnjWXT/cvxff92Oj6Sx1A3jDMX
3xvIWhGZy0LfXs4/yPISOHqRERXqEo2c2jaApjcYkrcrg0Dd/iFL/+8xMAF6dkdR4vHwHRjm
8rRZygwvz8cfJR9R/rgpcpkPZZMnNluXWhqEnY67p8fjC5ePpJdqTJvkD++0358fdyAYPRxP
4oEr5BpUYQ//DDdcAR2aIj587J6hamzdSbo+XsjyncHaHJ4Pr//ulHkRNDCkysrOSd6gMjey
5Ke4QBOO1Obupe4DOWfcTWYz540QpkTKPFYyR6WIcc+4Cl1WEzdZd43PRfowwMgFRKSO9AFX
EPOqA7YcyjM2YMuVyk5y7Sm+b+2ClRm/3SMeJ1XOer1u11QrNEHH1lyzSweO8CNDE0MiUEni
bwfy468ylIPhlbR2MuzTgzO3w2KJriJQvYZFofvp6s6tcJjw1gakpxy8CxLhZhY+sDERERaC
YBBg/4v+4pKNVYxmUag0e66jsJn8N60k8WM49YZOeHvLbMwIjG03iDPUtXMY4wpElRdXbkcZ
onYza4yZlhV14FhHSzZzhrW6OuP6UbBm/8hJY0b9vntMhANztHIE4xHesaijYf2Wr/803Xz7
68H7afeIWp9UnLCMCSyhOrNtH1obCHSL1I5hCaNm5zFu3aVgZAYZiJCbokphF/6OXJs+k6rw
hG1hp74oM4Nal04aDnj4V8xhbAcrKxCOBcdzD45kGOWbivIENIEBe/V1C1bvEXdUBNq4RbtQ
JoWub6ESMLYpnAVVmS0SViuWYlNYdtAlSdfOU5FtWxWbsPohf84dIyIo/mbB8IFwblu2b5jc
pq6AXgIa0/g/edKGJy08yXbnPOv5XCSCnqzeqJPz0jiyY1GA9aTZoWVapS0XJ2RxInDR3dCy
vGBrRObIQa3SLUOHQmGJT7cq0iOTjFFTjPoAdeWmggyG6cm2DxannSDKBBVBVfuk1eAuNx55
nNFzHQ1NPDnher0kM/2umF2bAXYZgbp910pmjqHhgbUtzAG6pKLVp0DnMRjJvTf/BWkFa2sL
lQVRIF4zxYrIYTRuNdAGelY1/RowdDMLndl0z4m7x5+m1r4n1fyjj2sluoQ7v6dx+IezctRK
Ryx0Qsb3sAtzQ5Y7XodUf4cuu3zsiOUfnpX9EWWt7zZslRmDHUrIYaSs2hD8XRte2bHjJtbC
/ToZ31F0EeOrAjou/3I4H2ez6f3vQ01TTofmmUdfPEcZsbjUOwndvFJIPO8/no6D71Sz8TDb
YlKVtGzbT+hEdAuYaWuRSsTWo9mWgFWkUxyI44GTutRry9JNI71XW2p+WZh0flLrYUnYWFlm
fN3PF24WzMk5ChKKV3kmMOZ1+Q/f10R/6vcXsnw6Q91IN6S+Wwd30VCa4OSZXIe/V6PW73H7
t9kXKm2iNwlT5NqULQ1wMWxnL7SPJqpWamOwtnGetSmBu9GpL+2yC6XkHbpRprwHFOjTAcQU
EX398vf+9Lp//ufx9OOLWV2VLxSLrsOBentHI7zI5F3MiMt2FR7aicj+r0DIeSBbOlGrux0h
MeY6rDSJZkqqf4NSv12ouNAJRtHUrNxwI23/LMdG+yAMXtdmFQmNzWo9N/IoTez272Khq/hW
aeiPBpYckEsDvfIVlXfEb7uJzy29tuAIsWOxWyy3v0aB3u+BrBdAeoVEQL3IFrDI0iukDrr7
FOiOvqo2QDPGuXALRB8wW6BPfe4TFZ8xMXtbIPpFogX6TMUZldQWiH62aIE+0wW39KNFC0Sr
PRmg+/EnSrr/zADfMyp1JmjyiTrNGIVsBIH0g7xfMCKAXsxw9JlqA4pnAqVecbUufP4awfdM
jeDZp0Zc7xOecWoEP9Y1gp9aNYIfwKY/rjeGeeUzIHxzlrGYFfT7SEOmFReQjIpJIAcztoo1
wnaDjLk5u0CizM0Zj38NKI1hh772sW0qguDK5xaWexWSuozVb40QNlpp0poDDSbKBX1ZY3Tf
tUZlebrkrKkQwwryeSRsOooOHCfXD/rVsXEbVL7w7B8/Tof3X11HEEt3awhD+BtOjw852nIS
p7NahCt9RsBYY44Ujv3M5UZVJH2RVN4CuA4PAULh+OjBsxTpaFR9UVQ4oSvVDXiWCuZqrcb2
EknZQykcqIjcEVQZLxjwmFugYpVttQ4wHRh9fwPCG15WyDhPuSinKP3aqhj0IFB6ciUqVx8E
L11haTJfIMOvX/D98+n4r9fffu1edr89H3dPb4fX386773so5/D0GxpS/UAu+VIyzVJJ2crn
6/4Vr0svzPNfWgjGw+vh/bB7PvyndshbsyWc6rD69rKI4sg4LC1sjGSYL0SErvxyOBe61lK1
kb49I+HzberSijA9eBwt5koWaquuo2A0m95kHrBqsAcrC4s1gw22e6km853cvMu1525ztYST
pwnvbp9+vb0fB4/oWOF4GvzcP7/tT5fRKMF422YlmvmokTzqpruWczmZaYldqFzaIvH1S7cW
oZvFt3TtHy2xC02jBVE7tuRlkhBwOBkRybBog8jTrXeVblwoV6Q2p5IZmyMh6tFKopQoDyi/
jRqV+nai/qVPVCVC/UNvZnVP5JkPi28fpK38a1IrNfGX6q7o46/nw+Pvf+9/DR4VF/5AB6C/
DPWqahglfeNakR16X6w/al+jp05/+bA0rtzRdDo0xLXy/evj/ef+9f3wuHvfPw3cV9UQ9L3+
r8P7z4F1Ph8fD4rk7N53RMtsxkNLRV70k+HQDf8b3SRxsGWtrJrptxCSc/5czzn3gfES0PSV
b8Eqtur0w1xpybwcn3TLgLqWc5tgSNujXxlrctYzVexMduada8+JrwQpbQpekeP+SiRQdb4W
G3J6guixTpmX1Xoo0I1YlvcOLVpnd7vZ351/Nr3c6bKWBUFrgQwtahg2rSa26atWoeUF9+HH
/vzeHejUHo/IsUZCz3AiWelBUBXc+JxHywoxD6ylO+odyBLCXCg1lciGN45g9Pir+XitLp+Z
iTVGtbgPGDqMamZN7v1MKGCyKv2G3gFOQ+fKqoAI5gboghhxsRMbxJix1qrXHt+ighheqPCF
rpDgW9Mhtd0BgbHZqOiMt/aanIGINo+Za8tqq1ukw3sm0mWJWCfTYdei0T68/TRUHZsFmmJ/
SC0YH6o1IsrnjJf9GpHavYw0D+I166ujnh5W6MKpun+ftGTWy5II6GUTTtWlIntXhZilb32z
eoUYaQXS6mfFelvt3yoZl6ENPU24QAIND/aOSsZ47qrJ67g9ZrXO+ttpfz7XUU7aHewFFuMZ
ud4yvzFhVUvyjIvuWufubRSQGQ8qFeCbzLqO3tPd69PxZRB9vPy1Pw0W+9e9FsalPRukKOwk
ZZze1t2QzhfKIqoP9KdAt/EuKsQxB3FNri/gIFRc2x0aYH24+RT4Slsa3P9XdizLbRuxe7/C
01M702bixHZz8YEviYz4MpeMZF84jqJxNYlljyR30r8vHqS4JAHavdkLaLkPLIDF4oEXrDE5
8P3ux/br/h7uk/unl+N2JyhpceQqHAghb5CfiMYH51UsUZ0e453kZGGiu8DO2ikgvW1osqo8
xlbETbgU1geDTLgOa+BNknaHiN2/v5i+0wByGmGll9pL08tLpdqGhR0l8zLwRjQ4RmwCBB/F
XowzC1ZeIFs7LDzPAwn56mwTyhFfz1dyf465TbDYCKCgxQ6TgI0JeLM/oisx3KIOlAPysH3Y
3R9f9puz9d+b9fft7qEfToqP3FZi2MbOKBpZ3tI3dR6Pj09n03TIf0lYcxf2L8AoTStggayB
lMhXgrautBg/VZVR3D+PWeFHkobPNk4nHveTU14wdtIbgAbNNCR8qfaSfOWF/HxcBLM+wXuw
75GYiBZg51dD5EmFGoZQVrXS18eBUocXBBPEM9W+QAhx5AXu7SfhpwzRRBOhOMVSl4yI4SqG
fIAqj5Gernh58uMQMB++RWk/U9I8OKmfJdNrdIeMLUpJ/lsm3js8qmjiaqphnNovxPbVHTbb
K8wttVaPsAGTx3EuT6tBibTg+wbuKDk1O3AZVol8D2xwMCh0cgzK2nUrUc/vIuvYWAAXAB9E
SHyXOCJgdafgZ0r7xfgc2+8IJ7ZqMi/iGihOUTh2URaHvHZt92luQoeQuscRsN23B56CyktZ
GgCNHhiCAftAmOP7RV3WVxduVA7ATYf1sohKLESUuKOcETDZ2CkQGJLmJfRggrLKOcFEbiQ4
5hNAMPoON8niXsHqhWP0hooxosJgEJRmaQvgBy/qU8dJBq7StFgYeaD4GZt5zHtraSF5BRdp
e4/8G5vpx1nPBIb/TzGENB56sGGACihIknkZmMfMt5Ygo9oVc5CwvZo/KN1ayvzim2xMr/Og
xIi8bObbdDnLYIlGfknU+unn+dWgiVK6Y50dC9dgVENmLYcBChysOb7vpXNxTU46wUjUDydA
mrIJYz/6OJ5dAyxUYDwFBNnr288pNqw6AfuvbK0GRK3P++3u+J1yN3173Bwexg+3lPZ7QUGR
fc9Jasa6S/IbRVMeDPS5GJSW+ORA9ZeKcVNFQXl90XlAGoM+IqMeLrpRYEh/OxRK1S+y6rbC
gHpybhM3A4FfB0UBmIH9xq0u0OnuvP2x+fO4fWw0wAOhrrl9L+UvoVGgXJWii4OUnnKSCl/F
w8DONEt11eqlU6TXcBf41CfSHIgIQ1oS+cpVwE2POgYsESEEBNAsYVjAp8XznOVAAnCtApQ4
SgcJMHhOBs4XelAmkUkcOfXuEIXmU2dpfDvuDjitBxPGN9U8IKYr6+Rv3QNOqoC2gO26PQ7+
5uvLAyV7j3aH4/7lsUlg09IglljCK0JxY3lfd42nR1net+v3P88lLM5/botomp8Z8EGSJIu5
32PK+L+wkCepU7nGSUEZhbsf7g5snv1rggo/5185cTRPE5ZUXXKJt6xQfybsrDqcH3obt9yn
eZ0+dda/D8EpD1Yl1slSHsK5Q0QkCSfiUDfZMlWMJATOswhriCn2Ef5K5n4GIlUcQOLKJU1G
9dtoFgQUJnQGGBN1C5kYAPsyVEarkko1OxosrFFCfGKivy9KqBxvEsXIkqfB1Mrz+UNF7pWZ
07AwSmM2iAMRwEJPC4eoGbGuz38ZOjd05DPqNxxEvfKzE+KfZU/Phz/O4qf195dnZg3h/e5h
cCXH4FngS5kcl9SDY7RbBWe9DyQdpSqhuduobFbirRjVz6AEolLS3jOwDitQNUrHyHu5vAFe
CRzTHz4ynML1pubK3lnAHb+9UBpx6RwyXene1wQfEX/nPyL0PtwmXKRFEORSAWgctMVtfjs8
b3f4SAzzeXw5bn5u4I/Ncf3u3bvfOwZNsWTUN6WeETzi8wLIrY0Zk6/Q2AfOa+IA4F2nKoOV
8tzQEKGQuWJ43F7tZLlkJOA12TJ3lOKjzaiWJlAkPiPQ1HSWyUhwF0TtyMSwMa/0hWtM5uhG
IZa/TV8FYsf6DHqxgm6ik9r1/6AKWyUCBlJi0IP8aVQ6YFnqKsVnGaB6todMzH7BYkFhMRwo
cvbt/nh/hkJyjSZBQetT61M1bPYVuJmSWxR5GGnl10mypbXvlFgzuCiqfFwqs8dJlCkNv+oV
Ada/BvVmHOtdeJXMaQCAImWmEwdiaBRkoaBMIoX1xH4/nNtwIgGbG2BjcCOkq+zSmvQGPTqd
N41aWggKaQ+Tw1xBrUGbgmIHhNGHWYkuhGweabMpyKcKEFLvdlAj1ZbAsypl7ZqmXQy0yxN0
Xjh5KOO0N6VZu3C9DqixTihoHK4UaF4eoGDwHe0GYoKylZZDHddrfsi9dEDu2+sX18BGha3P
9NNtHAzoGpPj4xZEok2PvU+D/jCLnbkZGxXatINuz1rQtF7/urnf//h3/bSz4oHaX6Cig/Xh
5WE20kI/BBy1yvSkBDA12UFMnZrzq8vL9zRIka4Hs7dtAuXmcETmiuqC9/TPZn//sLGP66LS
tMOW5+DNOStAi/zM9zsRuQk2lXCGl5qFl/UKJOD/EgsAEoJzTyvI2Qf7KSvjha9kbqASQvTc
YzKlPguhqFC3FTAkviYYmYueIRNwtJGaLM4wqZiKRYkcQO2spzsDnoo8RYWzpL+6UESuPfEw
WPlVIusDvDJsGmNHcZk4WzzjKc/hhLAAjFJJbkEIZN+RH4UIzma7SThlPdQxqkopNErQFZnE
dbh0neljFPjGWqKFYGLBNVcAgka+/PjLdLyYIPIvia7/8eTRHUANHeAVzKeWH19OQ7TkaSkl
ZxHcUmEXahcEWJg4hawhN2W9igTUs4mF4gDvifnohsCGICnSQQ0FYaJMsgmKgEuz5wBhTn4E
tWWFbbadqAgAUzXiSaY9cvdna+9/ldpvtYdTAQA=

--y0ulUmNC+osPPQO6--
