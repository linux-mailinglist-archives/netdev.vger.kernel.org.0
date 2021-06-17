Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9BE3ABA47
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 19:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhFQRKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:10:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:60134 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230028AbhFQRKS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:10:18 -0400
IronPort-SDR: vRJrce0ntWpz6WgENjf0RIBxR/RntwfTyXNU1NhJBXWCwdr7zo4t8IiB5bq2hvsfqSsaPjeCPx
 kxndD/N51LTw==
X-IronPort-AV: E=McAfee;i="6200,9189,10018"; a="206365394"
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="gz'50?scan'50,208,50";a="206365394"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2021 10:08:09 -0700
IronPort-SDR: hKhanwvxOUQqaS72+J65Hjol8PyauZjcTai1o5vXjkOnGnZmKcMy8MwVl5fTCYS8VlEKRnHFXl
 LhvPPd4PMIqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,281,1616482800"; 
   d="gz'50?scan'50,208,50";a="421933855"
Received: from lkp-server01.sh.intel.com (HELO 4aae0cb4f5b5) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2021 10:08:06 -0700
Received: from kbuild by 4aae0cb4f5b5 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1ltvUr-0002BD-QQ; Thu, 17 Jun 2021 17:08:05 +0000
Date:   Fri, 18 Jun 2021 01:07:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tanner Love <tannerlove.kernel@gmail.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH net-next v7 1/3] net: flow_dissector: extend bpf flow
 dissector support with vnet hdr
Message-ID: <202106180013.j1Brew82-lkp@intel.com>
References: <20210616203448.995314-2-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <20210616203448.995314-2-tannerlove.kernel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tanner,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Tanner-Love/virtio_net-add-optional-flow-dissection-in-virtio_net_hdr_to_skb/20210617-082208
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 0c33795231bff5df410bd405b569c66851e92d4b
config: s390-randconfig-s031-20210617 (attached as .config)
compiler: s390-linux-gcc (GCC) 9.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.3-341-g8af24329-dirty
        # https://github.com/0day-ci/linux/commit/b03a1eb684b925a09ae011d0e620d98ebf3b0abd
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Tanner-Love/virtio_net-add-optional-flow-dissection-in-virtio_net_hdr_to_skb/20210617-082208
        git checkout b03a1eb684b925a09ae011d0e620d98ebf3b0abd
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' W=1 ARCH=s390 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/core/flow_dissector.c:882:40: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __virtio16 [assigned] [usertype] hdr_len @@     got unsigned short @@
   net/core/flow_dissector.c:882:40: sparse:     expected restricted __virtio16 [assigned] [usertype] hdr_len
   net/core/flow_dissector.c:882:40: sparse:     got unsigned short
>> net/core/flow_dissector.c:884:41: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __virtio16 [assigned] [usertype] gso_size @@     got unsigned short @@
   net/core/flow_dissector.c:884:41: sparse:     expected restricted __virtio16 [assigned] [usertype] gso_size
   net/core/flow_dissector.c:884:41: sparse:     got unsigned short
>> net/core/flow_dissector.c:886:43: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __virtio16 [assigned] [usertype] csum_start @@     got unsigned short @@
   net/core/flow_dissector.c:886:43: sparse:     expected restricted __virtio16 [assigned] [usertype] csum_start
   net/core/flow_dissector.c:886:43: sparse:     got unsigned short
>> net/core/flow_dissector.c:888:44: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __virtio16 [assigned] [usertype] csum_offset @@     got unsigned short @@
   net/core/flow_dissector.c:888:44: sparse:     expected restricted __virtio16 [assigned] [usertype] csum_offset
   net/core/flow_dissector.c:888:44: sparse:     got unsigned short

vim +882 net/core/flow_dissector.c

   866	
   867	bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
   868			      __be16 proto, int nhoff, int hlen, unsigned int flags,
   869			      const struct virtio_net_hdr *vhdr,
   870			      bool vhdr_is_little_endian)
   871	{
   872		struct bpf_flow_keys *flow_keys = ctx->flow_keys;
   873		u32 result;
   874	
   875	/* vnet hdr is either machine endian (virtio spec < v1) or le (>= v1) */
   876	#if defined(__BIG_ENDIAN_BITFIELD)
   877		struct virtio_net_hdr vnet_hdr_local;
   878	
   879		if (vhdr && vhdr_is_little_endian) {
   880			vnet_hdr_local.flags = vhdr->flags;
   881			vnet_hdr_local.gso_type = vhdr->gso_type;
 > 882			vnet_hdr_local.hdr_len = __virtio16_to_cpu(false,
   883								   vhdr->hdr_len);
 > 884			vnet_hdr_local.gso_size = __virtio16_to_cpu(false,
   885								    vhdr->gso_size);
 > 886			vnet_hdr_local.csum_start = __virtio16_to_cpu(false,
   887								      vhdr->csum_start);
 > 888			vnet_hdr_local.csum_offset = __virtio16_to_cpu(false,
   889								       vhdr->csum_offset);
   890			vhdr = &vnet_hdr_local;
   891		}
   892	#endif
   893	
   894		/* Pass parameters to the BPF program */
   895		memset(flow_keys, 0, sizeof(*flow_keys));
   896		flow_keys->n_proto = proto;
   897		flow_keys->nhoff = nhoff;
   898		flow_keys->thoff = flow_keys->nhoff;
   899		flow_keys->vhdr = vhdr;
   900	
   901		BUILD_BUG_ON((int)BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG !=
   902			     (int)FLOW_DISSECTOR_F_PARSE_1ST_FRAG);
   903		BUILD_BUG_ON((int)BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL !=
   904			     (int)FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
   905		BUILD_BUG_ON((int)BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP !=
   906			     (int)FLOW_DISSECTOR_F_STOP_AT_ENCAP);
   907		flow_keys->flags = flags;
   908	
   909		result = bpf_prog_run_pin_on_cpu(prog, ctx);
   910	
   911		flow_keys->nhoff = clamp_t(u16, flow_keys->nhoff, nhoff, hlen);
   912		flow_keys->thoff = clamp_t(u16, flow_keys->thoff,
   913					   flow_keys->nhoff, hlen);
   914	
   915		return result == BPF_OK;
   916	}
   917	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--ZPt4rx8FFjLCG7dd
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICFF0y2AAAy5jb25maWcAlDzZctu4su/zFapM1a1zHjLxlpy4bvkBJEEJI5KgCVBeXliK
rWRU460ke2Zyvv52A1wAsKnk5iEWuxuNxtYryF9/+XXG3l6fH9ev27v1w8P32bfN02a3ft3c
z75uHzb/O0vkrJB6xhOhfwPibPv09s+H/en50ezjb8envx29392dzpab3dPmYRY/P33dfnuD
5tvnp19+/SWWRSrmTRw3K14pIYtG82t98Q6bv39ATu+/3d3N/jWP43/Pzn8Dbu+cNkI1gLj4
3oHmA5+L86PTo6OeNmPFvEf1YKYMi6IeWACoIzs5PRs4ZAmSRmkykAKIJnUQR460C+DNVN7M
pZYDFwchikwU3EHJQumqjrWs1AAV1WVzJavlAIlqkSVa5LzRLMp4o2SlB6xeVJyB9EUq4T8g
UdgU5v7X2dys5MNsv3l9exlWQxRCN7xYNayC0Yhc6IvTk350MmZZN7x374ALgWhYreVsu589
Pb8id0/SRrFMY9MWuGAr3ix5VfCsmd+KchDdxUSAOaFR2W3OaMz17VQLOYU4oxF1Ecu8rLhS
HLdAP2pHbne8Id5If4gAx0BMmDuOcRN5mOPZIbQ7IKLjhKeszrTZC85adeCFVLpgOb9496+n
56fNv3sCdcVKV1Z1o1aijIkeSqnEdZNf1rzmbosrpuNFY8BEq7iSSjU5z2V10zCtWbxwG9eK
ZyIix81qUFAER7PKrII+DQUIDPs4644InLbZ/u3L/vv+dfM4HJE5L3glYnMY44W7ZxGSyJyJ
wocpkQ8AVbJKcYS7wrtMEx7V81T5I9k83c+evwYyhSIZRbAahhGgYzinS77ihVbdGPX2cbPb
U8Nc3DYltJKJiF1BC4kYkWScnGmDJjELMV80sOeMkBU9upE0vfIoU0dP44JdsUL3WxLQze9C
d4OCR2pESDXMTS8YguuirMSq5yfTlBwDksK5ySRLSPn9jod20IbnpYbZKaiN3aFXMqsLzaob
V7wWeaBZLKFVN/a4rD/o9f7P2SvM5WwNcu1f16/72fru7vnt6XX79G2YkJWooHVZNyw2PEQx
H2aZQDYF02LlndhSCXImfkKM/lhDH0LJDHjLohtGFdczNV5CDUNuAOeKAI8Nv4a9Ss2RssRu
8wAENlEZHu0pIVAjUJ1wCq4rFgcIZKw07DhYpTyXhY8pOAeTyOdxlAmlzaDa+fPHPwxWLO0P
cnuK5QLMfXC4ehONJhgOwEKk+uL4Py4cVyBn1y7+ZNhkotBLsNspD3mc2qVSd39s7t8eNrvZ
18369W232RtwOxAC651jVZcl+CyqKeqcNREDby329mHrJIEUxyef3XWP55WsS2qs8YLHy1JC
E1Q44EJ5W1YBOjFeimFAziSoiVSBOoAjFjPNE5IIFAG7oTydbAlNV8Z+Vo7TaJ5ZDoyVrKuY
ey5UlUw7EoCbdiIAGToQLu6a1samFe1DGBTtPwDqVmnKZ4ikREWEv72lkyWoe3HLm1RWaE/g
Tw4r7C1ISKbgB3WUQXXrDI56zEttwgU8bkNvVge4jHPQ5QLcgope4znXOZzbzibQXeJqhfY0
XbACDOAAsP6MNWwO1Byd8LkpcuH673NXYp6lMIsVbVsjBn5DWpOSpjUET46E+NiUTkfG1bHg
OC+v44Xfbyl9tsMsiXnBspQ+AWbEKbUfjJeReu6yWoDrRpAy4TjkQjZ1Zc//4L0lKwEjb5eB
OvDAOGJVJXg1cFoi7U2uxpDGW8weaqYXz3Rr4wa3sjJegRv/LWEOHVWuuOfMGQfOQMlZA2F5
kpCut1klPCZN76Z1mweBIEuzykFg6ZipMj4+OuvsZhtrl5vd1+fd4/rpbjPjf22ewPIy0Mcx
2l7wsAaDSvZl5Sd67LX6T3bT+xK57cO6Kt4hUVkd2Q49lQDxCQO/rlrSmzJjEXVcgZe34zJJ
k7EItkw1553D54oDuBTcBDTITQXnXOY+Sxe/YFUCXgO1kmpRpykE5CWDbsz8MTBEwbjR8EI4
oAVzNiTsc83zJmGaYS5BpCLuXKNekchUZJ6VNLrQmDzlrpMf5ffHJXc8lFvwSZvEjaJRqgj3
aZEI5nSL0QOYxM5kOxJDKLa0zs8I18UeiysOAQCBsCs/BvZHsTHD8jXrHKbICQgweDPuxACD
QERIFAU8G+eo+j5HDTMZcU9FKFbA2rFEXmEUoLi+OPrn+POR868f9en5kTMHxquQOQiSgpHv
pXaFtimaDI5Cpi4+emc+g4GWGP12B7ncPd9t9vvn3ez1+4v1oB33ym2amzHdnh8dNSlnuq7c
AXkU5x7FYCZ7BpRq7dtSTZrjo3PyhLYEx0cHseefDqF5fEy7PF3z04NY2oXpsB8PjBVmUteF
56Pgc6ctiJYGjQ1HbXDmaNtpsZMzaPETE9giJ+bPYienr21Mz16LpCevRVJz9+ksEq5KcO1j
UaFOURefzvptKXWZ1UbVjF1zDecWQo0bUoTFLcwYPSmAOvlI7WFAnPpLY7nQtBdO8njJr7mX
/jCABrQv5aGa7TO2GW3WrZBRSXlK1zBa4e+2DjaZiOgJJpKtPR7dRS9Y5sYSoSIi4/ZDasfo
pXzz+Lz7HqaNrVo1mS3wxcByYAeh1u3RI6uLwWe5uFGIhG2kLs4+9VoTTIs1MAP5FauKJrkp
WA6mosP1Q/AktIm8D5LKB10m4Hk+Ok7HQsW4BSlrHoNgtaNXIc7Okda073JzXjem5+Tt8QVg
Ly/Pu1ebnmm7qphaNEmdl+QqeM2GaOqqMw6r7e71bf2w/W9XS3GyRVLzGCJWk7+pWSZujfPQ
zGuIhKkkUrAUcZ7DmBwT1yxuSgiC0tCoLFf5GIL5Sz8n6mJcD9qFNxCH+8mnHjvEEd1hAiBT
N0XcuClBF9rgX4IVujXoU1w3xjBjFOkzWKViVBpAAYsVTGMCu27J65KYhmZl0mSmeyEhRiVI
wB3BEMtPrw3L4wni7klsa1ahBoCuJBmlIt6sr3sMgj1iUzWbh6+vm/3r3t0yln1xJQrMRWWp
DjbKkMrpW3sVpPXu7o/t6+YOlcT7+80LUEMkMHt+wX4dZ8Xu+dhmYzx16sM6HxAW3mRCO9LQ
V/sdTk8D7jh3fWcN0xkD2xvVj2XEooHjkAbJg5EnaFaOp+B8CwxcagiCIRLGxFEcc6UC3YZh
Eha4YBc3UVsH6TqtuCaZjwZkoT8gp4RvY/siNiedV5WsYNf+zmN/axkyL/sw1D8Mx4WUywAJ
gQGmdbSY19LVf90igZ03xYC21BhMCybuUvC0RXrT5bzGBOBjt0WdAIkpftXreW1SNaYmGtCd
noDNgCWAtW/SBpZAJuHkYIk1l0lbogyntuJz1TDc/mhL2hVu2Ch90sb5LsgEydiegmPqoOWJ
qp6ad2oTU1giMQFRXDNnegF92MACw1ISjanmH5CAfrK/Rgtk94xNAA+ZI0/U9mTYxTERb0DR
trN14glcIuuxz2CqPKKMG1s062rPxFQpHmPS4AAKvTYbkA2qz2KodLmWploT8DtYMZmiMAeE
2vgwGTBtQIx5tJ/gA4du4uwW6FyhnlrUc04sgJ0HmeomAb43ARZORuei8RjzDc4WkUmdgdZB
BYfJSdyGQWs04PwaTiDoHlPt9J01Q4NdIw5I5FURkvQzYnow/rO4DYcAPQt7xaHPNjheS4ZZ
jAgQ4BsmyrksIPHSgZirGsZWJKcjBAuUZJt5sjrFXxdcDTgng1FIR06RGckqZ2U4RAo2tOjH
3CytumhTD0OGkSYYe9LD5tKgnnUXe1RXTnL4ACpsbpefbE6hMEPkZvpCM4mcbXwQVzclJfYq
UdKkvqZSNm1uErZ4l5S0zkgsV++/rPeb+9mfNjf5snv+un3w6p1I1A6b6NpgbWqNN0GNOMSR
/tEhGbw1x7tKGP6KQvmd9GCa/885XP2egTXCfL/rSZgct8J87sWxf8TxLDSmOqNHp9/L/Fhq
oIyxIMio3GdLUxeID7m1TQnk2DqPzXYoh6ri/t4RWRgZRke1tmOOqWDeIQk2g4NRC3ZMp5k8
mpOTiWSUT/Xx02E5gOb089m0KB/9hM+YBrb54uLd/o81sHk34tJdChpdU5gkDCuWE2T+FaYQ
O1FRbMnwlF81uVDKXkDIOZg62D8iN/rA20DGQwbdoGGQH/Zftk8fHp/v4Qx+2fR3lEB35bD3
wJwloEq98pALba4WQpscv3MBqrOF5hZBBr5y7bgbEeo+9xGc1VgJMFuXtReEdNXhSM1JYCai
MRwj1nklXMs9QjX62MtxdQSY4CdLtoCP88SkiYx7VYWtryJNbgPLGfVweEvJHT2mw0tGnUlE
2wuPnSWwJthrPyJoUtgLaOJdjjZXvt69blH5zfT3l40X3JrqimnNkhUWnsmtphKpBlIny5MK
DzykyYIe3ZHll8Z5M7kEm36Swy0IJx4GOiFtxjOB0CnMATro5U00UcPuKKL0kjQZftd9zqe/
jgSRmfArKywwvqo4DmxluzCqxBul1Y2/76commhxgOgHPH6OQXul7kckiq1CZ9wlQ7t0UBhL
cFicluawQAPRcEmFoDU3eA/Os6H4CfSkzAPFpMQeyfQUGrJDU+gQHBbnR1MYEB2cwitQj/zw
HFqSn8FPiu2QTErt00zPo6U7NJEuxQ9E+tFUhlSjuayLH56Q3j9nWmK2psqvHNNsrp2YxjYA
dNMM1ZWCiGACaUSawA2xir0YAuNgZWkojNrl/2zu3l7XXx425mWFmbmp8Ooo4EgUaa4x6AyY
DgiTUHTvGGWpn6xsSVVcCYhnnMRtiwDHhboAjUzalFCvq6fkdcsu+fpp/W3zSOZX+/qKE6oN
FZlr8FrcYHZAreA/jE7Dos2IIswa8Nw4PaZy04zxKVO6mddh8d12013jbguBnuHzMFNlthEb
GJ5ceeJnEMGX2ohoyo9nFIOWLE9aUmfXWtYReqCuU9ACbKaAyh4EMHMDpOJ4PLx0US7mVXix
A2eSJUnV6L6gOpQCFHV7qruybJYwF4VpfnF2dP7JKdsSCSLSnYgzDj4SA5eCumJWSYjogzv+
Mfnqwq2fAjePvcMvq15o+JvZ89UznKSduq442eDzGV3+PtADHaUdarCI/39NJoKdKfqLd/eb
rw/r1827kPdtKWU2sI3qabYB6Wkqs2Q85QGVspe+fo7pxbv/nn59frgfSdlfqC8oRsjCE2Ri
FJ3EPev2Qtqj252FGYVNLgmIwqvKT1ObK7lEj6aiYQgwz7j0ji1YGEwEYj9uPaQuG7/Y1Jun
UnObWGXZxbhMTWj0jkPhZgDhAaSdV17tCYG8gxk7UWxe/37e/bl9+uYYCCcaipecGjBY+Ouh
7ItPWPJ218bAEsEohSzqeDW0Zql5dtpeJ2Wj8NUTTYeL4FrQawZwfN0N8/Q58+8COjNQ6hLf
8lNKpDfe3Ji2oFNNHhcWLC+Dm6VAY4sC9FtDmlK4SpfDWKNKJHMePjd55SnJFhqnOdnPKmNF
8/no5Ji+LprwuCAXLcucRD08OFlviOGy5SAWpgHAN8q4DxZlkpTBIwbcru6+PvnodMLKaKAv
F9LbooJzjsP4eOaezAHaFFn7w1zVhjUpNJkfcJrYbTP0mbO478LZAiYK7s7A5dvmbQMn4EMb
+no54Ja6iaNLV8oOvND0G2Q9PiX9uQ5dVu4Vgg5q7qFfBhvPYCoyH9FhVRqNhgnAyzFQ88uM
gEYpNcY4ou5Qd1g4ElQjzXBsB9qBGkrGIiQKD+54SuAvz6kZSSr6MPZzeRnKMSJRy+gHssYL
ueRjYS9Tck/EMuH05fiOIr38CaKYLSm3auAxnqXFIh0DS8EpKUEGwBzogLQehmHggA87gVbX
/VKNr0NaY/Ow3u+3X7d3wZve2C7OAgEAgFUJt+bYgXUsisR9q6FDpFf+2iGsPnXUXwswVXjP
W23hB4wJklRqVYYT0sGpFH0vVyYJybx3F11SP+HaYXK8BTwqMbkG31AcEIPFgd/A0N2RmYiD
PY9wLIC622luiCs5rQaRIBfVtOpCAgXGNhvtU8QUjLJlvZj4KYGxlEp490k76DIy5CME9K3G
ULSzYyguz7i/ZZTLZAwXKQ/XDMG6LrCUuuTU62DDTOtg/oGb6Qk1JIUYW5MWMZwMTxQdIxJj
/UN6RqQO0yR2qg1JofCFOYmv8rvxrs6ZyZ97+Y0e2v1cTby01NMVdKzkUJiiAlUwGEjQIfff
U209S1e4DjblsPZ4CORLLCkM029T9y5XGtG9z+nv8EwUy1GnQ2ajJN9ewpUp1GLoaqGq4eGy
0sETbjfHC8NoBB28iqdx4d4ZcO8qVqky95rcu3KYGKmu7ev2mL8pvXm9LoMjVOELouomuMcY
XWY+GWq29ssRfkwyw7uD1hfrg6ARKkC4cYyjxhkVTlbpUmSOF2Sfm4wn3jwYoCjKWo+g89Jc
CHYGcx5onfNyqO344O4Vpl5E4blR+Dy5vQ0S+MAqjtrUakITp+SHFXq96ysNV1NkV1ZdUSke
JjKJh9+RguuFxlC/3d0ja59s/trebWbJbvuXV96y1+Bi4XYNj5TQccyqxN3ROQTL4bO5bNDE
og91y/j93Xp3P/uy295/M1W/4Vrq9q4VaCbDNGlt76cseFa6Ws4DtzVkJ50BS6PzcqLcCaFl
kbBsqmpeVpZ3Kqr8ilX2pmgymsh0u3v8e73bzB6e1/eb3SBxemXG7krbg0yWIsG3sp0k9TUo
yb43p4A9tDI3E/sp6CUlCci666hBl7tyUxzhiPro1NT0UWd5efB+qrGynFRiNRGXtwR8Bf2R
GVFEYzKmZdKEqWGDs/e1Wwpzc8C5936j8No7r1ZCuS/t9R/SwHt5tZa2GYle1Rk8sEhkQgv3
Ck7F516u3D434iQewVSZC0eftYTth0PcS0Hj7W6/g/G2n92b4+llgfKFQE1OFozdJr16kqAu
8EtEgyzzQin/qYENgxkuH5jjpwMohBJVOmAG7xNxdXTdoqhavXY0BTyYxURZgpsAL+vd3i+3
a7zk+B9Tz1c+C+cWhO9HIFKmFk7LghG8efedYNuhElGZ6btpL4m8P55kYO6Zmzd0/E8NjQmx
/imL7IZcxfE0mNmp4ecsf8bbAPZFXb1bP+0fTJg2y9bfR/MVZUs4ZsGw7CDGoKZyjGeqvXUt
4JlK9BSWrjfDSeMBlEoTL82r8ibg5K+VJL8HgShTkQiWtr/aARo0ZyrIA9rvkLD8QyXzDynE
tH/M7v7YvszuQ0tntlAq/Cn5nSc8DtQKwkFH9NrGEwY4GAdXmssuU8NADRAxcDKvRKIXjXM3
g8CeHMSe+VjsXxwTsBMCVmie4cfaHkMMyxMVnlCEg4lkY2itRRbOA8z41FGTuc+CRQrsqvsK
1oHlsq4oGGp/4RBiX0Dxzy67MqhOsVTrvz/AWVo/PGweDJfZV9vF89Pr7vnhYbQhDN+E42sj
PmcH0SS6459v93cEA/wPvx7VUvE4hpF+2z5tnJfKwjbc/SyeC4UzAF5ZnvtVSJoATtoBLlH7
5a2uck2I1TvyOONG+KxMkmr2P/bvCbhv+ezR1kDIE2XI/Km7NB+yG05P28WPGfs7rI4oLzTR
zoBl6v7G4of2qzsAxNKl9t6nACBnVXZDo5Yy+t0DtG+2eDDvkobE+/ZgCVeon9y6vkVgnO7B
0HXPmPf1qPYS4EivFaucz9T4xUSENykdqBucZtU8rNZ0S+3y7Hc15YGw5OPJx+smKeVEra7O
8xucC8pmxOr89ESdHR0Pm4MXcSZVDa41zpaIXX+LlYk6//x/nD1Jc9u40n/Fx5mqt4ibRB3m
AJGUhJhbCFCiclH5OZ7ENXbksp2qyb//0AAXAGzIU9/FibobK7E0el34JNfuMcpyf71YaO4A
CuIbFpTidBHsHztzgYtQz+KBYrP3Viu0rGx+vegwV+MiWQaRdrymzFvGviGw9MFsYPb1skxs
gmJ+Bij4mXBfO9x7YJ7tSGKsjR5RkG4ZryL0Q/Qk6yDpMMFnjxbXyTle7+uMdUj9WeYtFiG6
YqxxqIh0D3/fvd3QH2/vrz+fZUiRt+/iDfH15h2YFaC7eYKT5qtYW48v8F99ZXG4atC2/h/1
zr9mTlkArDquLwRNIoGrrsaYnSzZG+7GLchjsOfwoSYlNcKtGPtIeXImjPaQ+TKQhscgv9Qd
vwlNIWgiGhwMCmiCIShuRASRkF4AMDy/ZQ/6ppWz+G9i6v7618373cvDv26S9N/i0/6uWVv1
5shM0+Qn+0bBDBH0CMWlaCPa4aktujqeB9YQEoiqSoYYKTomr3Y7ce25KmQJiB97x+Jp+HxY
Om/W5LOaqsm2OrBNevCzAabyL4ZhEB+2r8jsMWByuhH/ODvd1FrZwYnX6vdsHo4yPgku55AL
Y49uL2xBjne39smHZaDDChWOLc3Add149gg2QDzMSINxhKlc0wuNRVAQz6hYQuZEYbQ0GM9U
KWlB7oO3JVVduvm9NJOyf9tiwB7ar0Y2D3TUEyhhhHjhU8aVUZjDbB6mLi0GX+P5tKaG93ha
OGWOspKtLu8ciPvXXEFKsssaaYJpcIwWnfJHm4nloX4KzBplVWk0UoO/jnhsQfxOsDU3+9tC
3GNa44Fpi7PyG9OrYyWp2b4ygXxP5TPrQME1CDqmY9WnM9tV34EVDhuMQlnJzmzjdIpsg4sH
AdVgZnLQLEgNjc6Bak0XtQgQxF0EgZz0fDEwsJStgXzJGkz1DTUPK9xsb4CedRMCA8G4A7E3
D24DRyvHkFMIm2guu9ZqQQljjcUkWOrbzCwGwbH4yeqAAqrAWSfxZKw4OD2B95Pr2/Qlthkm
UIcFdqQ82c8+iFwPzABPXjpanxTD7I7qp+T+wLO6mO4Z+0d/vPx8d97+lm5D/lRakGcTtt3C
qyI3bAIURpn+3haktssUROzO7lZJMEeh0hPEiXmEmG9/3t3rAar6QhV4VmWGTZiJAcVFi/HI
FhlLxKuqPHd/eAs/vE5z+mO1jE2ST9VJqVgMaHZQXbOAcFA/6/M9U3RYYxHLc1ORBo+UqPXx
Cl50kHGa4EHvFIn040dtFhW6aiGMDcyAPtsaWDy+VvFqjdRgEDVihj0plX5G8bzI8nOhi4AM
dCuOftolVBOe6/hN63sLL8ALS6S/xpEQXQZ8vWlSxoEX49UnpzjhBfHCxTX8ztMZAxPPOast
sRBC4JwehQ8/rCF0VwHSAXGDub7inhTi2qOOQ0WnzDKOyTsMkh3JSYfPlcIhsnqDqEsCPJ6W
TrVtP1HOWrydXVWluhGqMViaiqeiA3cSQPE3XHaO0jSnYkG5kTy7xbvEluy0WnqO/rbll8w5
H7d863v+6uOPk6O6bJOkcjVzJIl4YB/jxQL3Qp7TWm9XhK4gnefFC8eoi4RFi4VjWxUF87zQ
1VlxYGzB/5/W4UddYDt/GcTOiuSPD+oQz4ZOV9MbFdyuPN9Ve52VBcQu+PjTpeIK5VG3wCQj
OqH8fyOjX6JLUP7/SJ0HtjpIP2jkmPJ41XXu80T+n3LfC/BJ4RD8LGtccybQ/mLRXTnRFEV4
DbnC624Ew84cW5DmKqwQOjPiHeGUxhh03PMDzDfeJCq2ugrPwHXxMnKubF6zZbRYdR/240vG
l77vCLyo07mCEhizVu2L/q50XKT0M4vkoYg3As4P9ArTRVlis0WCd/DCDof2S8/iVxSjkJB6
tmktwo24r1EZa8+QBd1CjJZz0+aq72pB4jDCo0IqCjDtOW/EJeJypJ6o0gxsebH9phEd6KYh
9jzcdvzTes7kimd9m0P0X3Fp14K9c9bcKtbd4k/rZBtHq9BurD4W/YDm8wE42cPrg2gqSDYB
0rLKsC5RJClZ+fGi7zNDvmza5UGIL3pFIdafv1zjoelHiqW/dHczKQjwFfPGe4TjPusH0Bz8
pTiyhhHY4wP0MtIGiKBX89JNQUMrZJ0EWctfwliBBaCWqK2ufRgg9gks4X7ay59tes+bQXwb
EhhaiR7miO6vkI5UAhIZGWoC+Qba371+lUY+EP7SloWao5E/4a8MEf1sgnO6qZmh/FDwhhxR
xQvgRIFChT+yCsnlLbBIydbq1I4UmRWyuoecSxZFsWa4MsDzUJeoYhMwxl/AXurq6fj97vXu
XryYNf3YcEjrcsaDHpuzEqsgz5Q/p8qXYsiFD3wgwbRNxwGpV66BwWU5tRykwOtrHZ9rfkJz
ikiVksROdU7APjGNH43BXPNU3ClS1tsH/5nEHOcd6t5atnluTsj+MFht6eUBCm5njqVCchVe
RQ9hqMET3shW+nUwXZdiECprA2ZErAyCh0l91iZ6jAFsgwbr0TmxCic+mDFJi8ebe2SNTAv9
VCbS3DjBBUdgUwlG0yH+LpvQoXG8CubAtw/1warI1atRBJYdDDU1GFH0n0pz4OoUHOyKtKWx
J+VO5m1RSSWGmWD/hWSCdpNziwFeBv7KGIiCwCfE+CiF3DK7BBrbmiV5bS5CCZltJwk9cN9f
9NTarI4YZIdOq7iAtY0b0ssqqi2a0AAiuHJSZ6NySs4aKOJuvg+n01xLOJQ6i1tcj+82wSM9
wv2hyKtdkxrsxqFI8JQ1RVU2MheRCyvFpxiTJZs/FK1223U0z0/G3h0gYKihWYLMD9VpKcpN
xpuWcTvquIEDEztl0joXuwpeYy5t1e02xY+zlAGCoYoJVnEFLZjMH2GKRQW4aB1MlcD1Jrl2
2G+DRjAdpnXn2Hvy9O3y+vj+/dkUX4oyJN9VG4o/ege8YEQxXmvEEv1TWM3p1Iy3G4OjA1hO
Dg7JqMAqfZNThD6RQEfQs0v/dlrBAOMepdmtfrcw1Gq91lhG8WOu2yt5DYjZlwDY/dOjskGw
1xPUJM510I7dDifhHCUvUn0ONRzwPmibffLWy6verMLyWvTocv8X0h8xCC+KY5U8cDRE+yHj
lNT7E6RcBOm/y9365v0ievFw8/794ebu61dplXr3pFp7+4+rHTApif060B62c4Kk0BfcfAza
7NASrnjkK8JkGRHXeoCMXiL1WMqVJZoyog0UU6hzyzLd/gBaOZVRymztnBj6hxF0PngWVNyd
q2DRDac8rGnZ1sPfL+ITWEoJWYKktWBhY1dvVIULrBnfkBsofjoh6yjABAYTemVXpl6vnQXl
NU38uI9Xp21RazjKiGybYsMcTGPmWD1EvsLN2AU1ObudeJoT07BdToBYYG2tLy60Nm19gTOn
tNVDQ+xLLERIyjUWQofaZgPSQaHuPUQHhm0PisRGftLF0tO/zoZwcZcKfvvoL1AGZiBImb+K
/Wm0A5xttLNsaMgADpSbz/6q6wwzLwvleJIPVCBeXi10xYyF8edDFph4rT+XB0Rexyt/Ne+6
dORCqpEWDXPynAfLyMPgSegt/XyOUaYqleyaFy6j5bw1MR2hF3XzshKxNnhVHeVHK4xd1yhW
QYQ2F0Fzv9Bao3iNPgI0inW8QPsaLXXmcFwcxSYIV9gy2JF2l8HU+esQ10oMdTR8HUbYch0I
2oR5i4WPdCtdr9eRJhKDyOWFHlq8B2hGaxZCZgpgpmRnwGUyOVgJr1jYg9V2q4wWzgX7Y6G9
F3ryCs/RMqCB05WhpsCuBXtGD4RDsJxdBRZxWX0+UmYmIUIIt4Q2EPvVpQhEiqiw9GBLcrWI
u3aEUO8vgt5ADnb4gw3nH/RJXIfbJvs8FLnSmaxox0yyY3GZVzqtMDuoUTirPVtHea11LE+I
Le0gxUqVc6KHf5kI+vQe8rXXFhla+2jSM1Hp8sORLo7rXbzE3wQTFUl4HC+x7aTRpFGwjtGR
krXnew6M7y3wnkmcd7XJLSmjIIoibJIkLtbPnQlnHuETnLJ8HSzQ6gRq6a88ghXL62C98oxX
n4lzJFfViMRVg/E+JkkUoa3zJBBHMNZpQC1XS3x+4XaJYjzJl0EVL0M8i5hFtcR1JCbVOsLk
pgbNSrARS2w4RVJ7y0g/szVcHYnr1DHSOo6jD4cgiD7cB0X9ebX2PxwnXwYfrFxJgi404HTD
yLEn6m3coRI3naT9AkbxjgoOYkt8+KEkVfyPqBwJ6DSqIx6YaqL4DLYD8C6+Oi5J1bLN+WAI
ayaChofxwsOH3fDi4F+fN5bvIs+wPtBwJ/GcWKJ7X6BiP+ywLylRqxI/F3jNIm+J6o0NoqUf
LNEzTOmFde2sjdMfRhbOC9BNdICHLFZITn5ONnSjBY1qkkFhP40vAUdA9HvntMFY9yYZdKKG
tkFwBmWWXFOXQuaZaCAwJD6AWV4v+umQaEUnOKvKE44g5alytAYsTH29vULcw7ebFK26K2pH
xbSoSqxec6hFcaVtOb2W05IotaddtE9941tq4Ur0BpTIADURgbFb/tcjSOmRCnBta4ymGTWG
WWQpJedEfOs+yu9MurR7vXv5/ng/kysllx9vlyfpU/PydDf4482FTMrfK7Hl6QZY/Ju3Rcn+
iBc4vqmOoFHQpMEftD660Nu9V3pNms47KoCGZJCm0xuaN1m547iJgyC09JiTig0acpQZIgrM
Jpy9PNw/3j3JTn6dG6RCURKKJypmJSWRSdNqR88IOm+39vhk3EBnB0nbZAT3FpGTk+W3FDNw
A2QiWHY96ZeCUfHLBlbtjjR2xwoCUZ8dWUKhlFy3rrZPtRkMDYDiG+2qsoFXzGTWPcKQuckK
dt5iQnGJzMWW1zyWJeyLMmK3PnKxoQ2aDhyw28aqZJdXDYVsbFY9B3ogeYpd0YAVDUsTHLvU
7cn9dY8k5xWW4UM1lx3FYUwTe1Z2p7kLi0FAE5K6G6UcVV8LzCcCRjfGXPAjLfektLtwm5WQ
L4SjfjRAkCeWeE0C9QiGClBWh8qCVTtwBNnjUPhRa5aqI3yreRQDsGmLTZ7VJPVnqN06XFiL
DcDHfZblV9ZbQXY0kRbmZtfEq5g3ug+OAp62OWSDMSagydRyn201mjQV5PByfjRxDYpTEI1/
JtHgFqKWn9Fgyam9HsX9kmHqdsDVpIR3vlj/mveYBkS2aA0xT08l6n8LaHHc5In12XvgEDrK
rK/HWdetSZMTyNUptgaumu9pTlIGdWWf1A0Vby1HzxmRhsvW7DFSsBb1Y5TYOstSUx4mwTwj
xawmDstN3D5okB1J0ZZ13jJz7ho9ZI08DcDYkDA9oNMIMpa+rLIgDf9Unfp6J+W3BnfvAE4P
lf29xPnFssx9w4Kn2A5//gC6hXv7XDPcZlOekVTwgNx9nHW0LDB1EODAV8ucwgEym5kvp1Tc
0PY2JnnNdD0FxheMuiKUo5FKZdh2xs6ZoL1dvlOpqldq19kbyU2WUggtPBerfULF44PzHPL9
iEvbOIAKccvaTjE9qsyOVnw3+KWCQWtn8Ag7qzMPw8gTSmztymB9JcFG2m6XkKsKrKXAUiWb
h+8SpBgrJmsgZbDwI4clpKJgwTKMrhGAbgdfhRKfF0EUYM/nCetbAxfAZYgB16byb4QvPFz4
IgmUdhB7LEu0GVtPVVkH6zBEgJE/b76OFh12FA7YqOumkIw2zvewCiPTEtvGLrFexJHD1WLA
x0vnR5AzFM2ntofP9MZzqmVw7QMcMQM6iZqE3LO1nfrxwvnRch5E68CaUJ4QkFzY0DyJ1l6H
Lpwo+tvVwi1PfbHerMooC7xtHnjrDkf4sh1r20HClJv/PT3++Os37/cbiJvY7DYSL9r+Caph
7Hi8+W26BX6fbdwNXJb47SDxRd6JuXXjQcTvGjoXZ17ROhYt7EJ7itmuCLxwNBJUMY7A9oJf
Xu+/Xz2AGh5GC0w30GPjSEo6xxnlr4/fvhkac9VlcRLujHxhOvhs2asYuEqcn+CljZeEqG44
Zp+Jm3+TEe6oF8QhufStwcsrWy8MA3laDtS00zMIru/HgQpPcSFn8vFFpvN5u3lX0zktxPLh
/c/HJzBUu7/8+PPx281vMOvvd6/fHt7nq3CcX5DXgI2Pc0kNgybiQ5DZVhzQNcQX+XhkyjP5
o7ZqKf+wF/A4yW1KK2dHLOPMkUhl4KYyeCL2pEgLMonMJiXhCJ1HPVChSgvSe/FqCxsynGfl
juq5ngE2avDEfV9mejxpwJrsUh/5pWC7FM2Hs2X5OTMiqsgIamcqYEsjoWcnhlx2gtsrP4PM
sbbqG+mktHcP5c/FrsAWxERhMNLbs13nODWJskkzAjXJuBS8O+PjElAzLNY0mSo0wa+x9k27
xTKSyPohqy5euyh1htidKlXhyWgIcDObux4uTo0aD3BpdWWoj7RdSlmtomf1MLA2gLfhxIen
YbiKF8ORbcONgyRJfezdJLZelvc8pOBsGTNydSusjPI44PQgtH2HxK0E+Z8dhhMDgcFDawjJ
AiNlW50/a8FyK20OIICEkGR62CJwkYKsYAqF1HTYChJaQXZ5fqozzbDmsDUPA0lZVpLWVVFh
RUUegb3UHN0eMnu6Mj3HvoIdw7k35S+ysp0Bp/xfRu0wRPATwptPa3zbHvYV47Kd2Q4sHu9f
L2+XP99v9r9eHl7/fbj59vPh7V17sWnhoK6TTu2Jl/ZpFup1WBMVCEhRFOPEEQ1JRnVOck2A
kMgYobN8uAMhRD+G1GNaAbl7rEpGGGiX12EcGeZRE5bRKAgxva1FY5hzGSgvdGHCEO2QwJie
BRouSZNstcAV9BbZ2kdNnTQi5oNHW1KjvRDcPQo/JK6pUjYqReFgYvZHyKsItrSzpZhIM1p2
+flquFpML3IQB4Lt67mmfBlu0IMWrWQYQEFovql0R1J5XJCa2qBe5TTcJEO4Y3Vk1HeCX5KW
yGy+Sz4iNduRN4lumjuAFXdXE8b4vqnanSbBhHiNQGV4eoD7QpIcz65DTRJAHOe+pAov+vB8
eX94eb3cY/MN8as5hMpL0JlGCqtKX57fvqH11YJT6U8xvEajpDa4qi3ToxV0QimkRN9+Y7/e
3h+eb6ofN8n3x5ffb97gufXnGJx6DNFOnp8u3wSYXRKje33rGFrFs3693H29vzy7CqJ4Fe6y
q/+7fX14eLu/Eyvg8+WVfnZV8hGp4uz/U3SuCmY43WI+f3x/UNjNz8cneAqMk4RU9c8L9Ymv
7p7E8J3zg+L1rytYPTr7tN2jeFP/7aoTw47SyH+0KEbmpxjM/Ea2Uf282V0E4Y+LuYgHk0Bp
fUgh64HgedKsgNi8CC+pUUNWoKopIBu4pufTCUA1JJPzomgsFJdeGjLRHTJ7EEjcoGnEZxnw
Cul31vFESgfUIvr7XbwXnSkXFLF4bRBxgxpXVo9xeCb0WHHzBoFuqdfDa15GXrSYwRser1cB
mcFZERkWYD0YJL2mFHBCiIUn/ga+0WmVgBW3qkDHYdyR4AM/eFtMM35EIuIZWBWvgCeYnx3g
pRgujkYfDMEByzDTc8H66B4yPhLFlWyE9ZwVHkilJwEYNvCmyvMppXG9P4nr639vcktp3gx9
3gGB1qs3qcdBwOJOzCyuKa/nUcbqh1eZgviHWGrPlx+P75dXjBm9RqZdOWTuB0V+fH29PH6d
xiG2blOZFhY9SPomZ82Z1vgVOFQ17kc9mlFpeqXKn7YjTg+sC3pmKRkDbu+PEB72HtLQzP0n
uZ5pmRcQb5BXdjKzCQFJJbiJkAYs034AkLhim94i2PAq1nCTSOwXgt1CKEYjPjYyiFEwUe8M
8UAvyKhhpmf+dlqZWeJLCYT4lbooE4JkY/AtM7S+WxlcViUEKSuHZQAQqRj9rlNMo9i3G6O1
MzMsMcS5W9XazmRUZ0XhF3iKWybILKfgV6nZUYHGO1G5MYy3Nni9o2LfotLjHMIv5fulfSvr
aFeCXsgGrnaxdtgfSE5TwsUHZ2cZrk9PD8OAvdSzjIij1j/rC74HnDuIEDsH1xWj3ZkkRn7e
AcmypG1wyZwgCZRbtQlwVhh8XGFodzy0K7RQQ3UWxrLm/7RJffOXTSGqKsY4rxo3TsVkC5wj
G9CnGapHdBIxTQ387p8354P29gT457bixAShMwiIBmMcAFGVMq0JS5p2YxfqcfA4d1gyANWR
NLh5AiDdF6l4SPn4HGx4M8zCSD3AphFeKXhWQQKmUJu/kIqatgRzUAjrKdPDOOuzw/VKoODf
MjMOxFRxtu1Di2LaaJqrcWsryFejNQFg94GR/V9lT9Lcto70X3HlNF9V3ktsK45z8AEkIYkR
N3OxZF9Yjq3nqBIvZck1k/n1H7oBkFgaTOaQRd1N7Gg00NuwGUeud/L7kdE0/qpHjBwvWwyS
n+DFNi2+8jhohaLL1tmdgnQNHLkkU6Y3Kix6u00apsIKl+77rS4wFYK+iklM18cLDBKcmi+0
Fhi8xO3hsLCp3Bn4m65BBZ61S1BhZMObYqRR0ZshKG3B2o5OYzVvvDdvF5BKAF5IjL4yl04z
k1F7AIAhXyEeZPOQ6xXGP1FfADtwxt0pM9z9y3ku2BytPJc4Sg2NpcatsXYg9MG8sc8ECXMX
eQc2m9TQqjwZFjMeYWAFhxmbIHGTWSBFwrI1E3LdvISUZpNV9V7KTgO3EVPpBXXwyXIuBqOs
rvV9IL69+27qsiCf+XCmmBKQjnhtA/ykhQIIG8xizyOUml392idbIluFof8/JFcJii6j5DJe
35ryy9nZR3p2umSuDwhdOF2gvF6XzYc5az/wDfwt7tB2lcOeaJ1DJ2/El3QDrgZq42v9EAhW
/JBz72J2+pnCpyXoWsT17eLdbv8MTk1/HRsqHJO0a+fn5HbAvtBtK1rv+ERQKMw7Iuu1eS2c
HDF589tv3+6fj/6hJw/eIenGIUZcerOk5gbzXfG6MHerdytfdgvBiiKyTFaDUS0T0ni6YEUL
t1xLZSb/GTe/vpX6XRjkbohBhev5WlwWcqNhZQ1qOY+RsCQs7LF5SNrjeIA4czUAlX4voGRx
BEXxW9oEWs2KeLhZUbBVXu++zoPCWlyz3GyH/C0PaCdujULlLfX41lx2rFna1WqYPNC9uPok
leS5ZCngXpNXPRh9B7wVXFI0+Juq0qSDN0PLkmSg8kS2AXMDoVEmys9uZuR32Q11CowV3hCt
uGnahCxshmkhIlRj3fxmYHge8SQhMy+M81CzRQ5RZlS+BFHoxelY1tUmtPDytBBSoMkGNAQy
gqdXlOVnmYdKW1beOr4sNrMQucCdeXxTAUOcs1a1Gw5YCAGDI8i4qrM5mjdDh8DZDUG6qCSz
jkgyIZHqijSbbVor+qT8PRwrK1DuRNeQnACi5BsBC0bCDB4OtFBPi32SVixGks6lmo0JYB+J
QmbL+I+qO5+d/EF1sNrNhLM21spEG26nHq8/rEaTB6sbCN79d3+4f+dRad82t02giwu3Qb3m
+Z+JLU3t0+vmytpknbOG5W+ZvMIstZvYCRABw908Gvbbj3wGOWDIS61PNvU4pGluUjtRN4ai
Is/4IrN/jNNmiGsGWst7vZD3xmG0MJ9PP9tFjpjPnwKY80+WuZCDo25CDkm44M+WcGjhAl7l
DhFlXuGQnIQbf0YbqTtEVAh4hyTYw7OzidrpGAIW0ZdTKmK7TfLpY6D2L6YZvY2ZfQm36zMd
cheIxGUI1l1P3wWsYo5PAkGuXarQFLImTlN3fegGhD7S+BN7SDT41B4PDZ7R4E90Id6UagSd
QsGkoFKZWN0KNPB4FqrzmE6GCCSrMj3v6ffSAd0F0TmL4VQnUz5ofMzBEcVtmsQULe9q2pxn
IKpLIU4x+pluILqu0yxLKWd/TbJgXBC4SwUxNed0hhpNkcaQ1oKSIweKoktbe1qGsZFCoINp
u3qVmu6KgIALtHWIFWns6I8UJi37tZU23dKpSAuW7d3b6+7wy7BSVR+v+LUlTMDvvuaXHURp
C91cjCxngr4W9xL7tVO+N3L0y6VEHQHuk2VfinL8QM/6SARDzAbVxW2dxpQooylNmQBN8zD0
KCS+hsdDeFPqVeJxMxKSRzSB6ueiAAxOMEED/KmpbCl/Xtb4iin1l1QfwE0yxkJyMb0yBKqp
+yTQPeY5e/dh/2339OFtv319fL7f/vV9+/Nl+2o8x6Q5k0PEQdPcQ+wNiAILYnlZUuOphexx
Bpih7M2a/OIdJMMC27f38Nf987+f3v+6fbwVv27vX3ZP7/e3/2xFgbv795Aw6wGW3PtvL/+8
k6twtX192v7EqL3bJ9DYjqtRWonKxMa7p91hd/tz91/M3W7m20pblZGvKE2LdkTg07eYZMNn
waeYi+1tE4x2p3TlGh1u+2AQ5O6xQVslRh5vOYaoKm3P7XwjEpbzPK6uXejGjOMoQdWlCwGr
9DOxYeLyynzXEFuxHB5VX3+9HJ6P7p5ft0fPr0dyzYxDLIlBh2BZK1rgEx8us5j4QJ+0WcVp
tbRCP9oI/5Ol5cltAH3S2kzSOMJIQv/OoxsebAkLNX5VVT71ytTC6xLgQuWT6uCNAbidNVmi
As5X9od9kjYyOh8oCr3iF/Pjk/O8yzwEBKYngX7TK5m00m8g/kMdk3oounbJi5j4EhrrG+y8
ffu5u/vrx/bX0R2u4QcIbPLLW7p1w7w2Jv76sfLIDzCSMCFK5HEN4Eev7U1OXW/0kHT1FT/5
9On4i96O7O3wfft02N3dHrb3R/wJuyaYx9G/d4fvR2y/f77bISq5Pdx6fY3jnGjCIqZ9+vRH
S3Gos5OPVZldH59+pKXBYQ8v0kaskXCXGn6ZXhFzyEUdgun6udkjtJyGA2vv9yeilkNMhoXX
yNbfNXHbuOxPtCciis5qSq2lkOU8IlZ7FHtlb+yUy3r78+t1zaj4Ino/LfUUeCUyeCxsu9zv
BlhfDvZb4CKpR9IbNSFYhute5owa6o3oXvijK/mR1EztHrb7gz+DdXx64u8sBHvQzYZk7REk
Qz2JvL5LuM/FROHt8ccknfv8jSx/GHWP2yYzAkbQpWJxQ4LI1O9pnSfHZrw0vU2W7NijFcAT
K7juAP50TJycS3bql5uf+oStEHKickHM77oSJXtbMt69fLdMbYfdT61rAe1J3YLGF12U+huQ
1fGMKE3IRet5Svps6ellORfXOZ8HxwxuKNpbzVv/Akv6pIxof+gTRzksofOQtYTe6Ut2QwhA
mtH6E8S5Tw2Jg6y0wMMM+4uy5Yzocbsu3ZFUccoeX163+70lSw8dxtdyijWSihqFPDcjKwwf
zCjY0ueXSp8j3TjEfeL58ah4e/y2fZVeLY7UPywrSHFf1Wa2a92JOlo47m0mRvE6CkOxB8RQ
xwogPOBXDDDHwZbZvEAaQhr6/bhN1gjZBH/JDXgtFk+d0gNxHbBecelANA9P7kDGC5Qdywge
91vu9Q5zT6tkIObl4ufu2+utuEq9Pr8ddk/EOQ8JBhj3OTnCJZ/wEYr9a3twasmOVOHeAZHc
mUZJIRJ/QQNqkOKmSzCFPR+dBPqvTychyIL68XiKZHoo/kTAG7tKC4Q+deDQWq5H0I2+Eli/
XXscBUUNdMKvwDbaVHc5oeT02Q2nDziZTUik4qiV+abo8zaIE0ejzlPln7z98CWJDX6bqPb6
56FGuO511W928UKmfD8NBL41Ja7fjBSYpEuPEJnnxy1jxIvb0p8UAwP8cUadTZjxw3PJ82li
yN45Tg5rrvOcw/MfPhmCwzWJrLooUzRNF9lkm08fv/Qxh2e4NAbNsGtPXq3i5hwsAa8AC2VQ
FJ+103oAi1kt5KLVs5ku4Hmw4tK+Ay1roQXSdlMyzO3rAdzFxBVvjxFe9ruHp9vD2+v26O77
9u7H7ulhZJ55mXQZWCXg++nFuzvx8f4DfCHIenEx/vtl+zio96RucHjxU8+0xsOih28sd3yF
55u2Zubw0VYWXPwngXSbTn20FhcKFowaYps0bbBpIwWuePgftNAmqvlVKcdUEriFGPixi9ry
7g9GXxcXpQV0D+1F53r6suBBJ1/izBc6DekjXsRCJKmNp2QwyWV1jwZatmafhUyBo1RI+RAA
wFjp2lOq4GB+l5q6YI2ap0Ui/qohF1hqJV+sE/Mcg+B8vC+6PIKAOEYnYCTNVBRowQa2qHFe
beLlAq2Xa27dxWKxrYWYZIGOz2wK/wYX92nb9fZX9iUSORzP5hil49GBC37Ao+tzmxcZGFpl
qUhYvQ4tdUnhZBMbcWeW8OJeeWIq+4k4VYdrs0lLvboMV+bR3AbzuxkjQXxlGp6MAwVQaQZm
w28w/1OhLwYmdLwuWNB51prPaaZZjRE556Ykq3PMa0aoYVVjUxuljA2hrWYQTNFvbgBsDqSE
9JtzSn+ukOheWMVuMX3qBrqRYFZTQctGZLsUG4z4rhFHDHXgKnQUf/VaYEeq0dud0HpFZnBX
1jRlnEoLNVbXzFKBNb0V1KcQt1YMgZOzCtVS3OECgGNJUvdtfzazuAtgRCMzhrZCS7wvOR9D
dZgXHIm7YlAhGhx9nZZtFtnFwj3FESwtcN+4EXSw/QMTpg6oRSYHztjJVdfXlstZcmkwwUVW
RvavkS8ZOl3bGS3ObvqWGd+l9SXI7Ea5eZVa6dvEj3liFFliVNuFOPesSNOgAdUr4CppSn9d
LHgL4czKeWJOufkNhjvrC9OwGbxrS5f1ozpuzcxwJwhKeFW2Dkye4+KkEdLTyRDnvBFLxRpa
UPcWC3MEhxPbO3BttaIWmBD68rp7OvzAEHL3j9v9AxWgSaa/xb6G3UNWPYTiprUtKjp7Vi4y
cRoPmYguPgcpLruUtxezYYqVUOmVMDMW7XXB8jSecD+xKMKpJIXAHJUgKPO6Fh+QYamwBPFH
yBZR2VgRToMjOjwz7X5u/zrsHpX8tEfSOwl/pcZf1gZPCJSPUC2aiF45F+fHX07M5VEJzgVe
zqbtG2RkxfcKgTK3/BIztYKHiliEGeVjphiF9BQDC/ocMioZC9LBYJvAx9DykpKlSB4274pY
OWOJS0B/ekJpMK5yIfd1m97mK0Ypa85WYGoxpHQdQv//4UhbQWXULkm2394eHkCBnT7tD69v
j25UNIy0DeIzGf5Kta8het4g11z3ziD7ZKCURMocnIknKlEF2sr+4bjoooYpT8j0hgOt2SjE
kt48fzQgdlPAyYNn7iyBr4W+CijrgaEwI/cnbG9xjYKg7aZJgiwDsPqwcUZqQOmHOMKm17gp
iFrKdRF4KUR0VaYQ0j7wvDBWCo6gEyR1mbCWeVpad3ok8Xrjd2xNZtnUYR7apMuNDSF/62jL
NnAMa+TUUEbg90kbYzdZF2ky2pAMKUDCIY3z4XRVqyLneSb2qF+/xoSZDZ6HnQqQN9YcL3mi
kLxIpHvr7wf5Ku+rBabh85tyRSuD3Q8niGSkEjShmVo4kk8BNwsOGzZ7xRrTBs5BgJLRkb1i
7KnE+g+uEgsm0SA0FOXID4Qoaon8TsVugaMFHCLKDvxHqSNS4qUjrVscTp0L9Lokweo9R91e
XTukkZM4K2cJIQu1FhaIjsrnl/37o+z57sfbizwJlrdPD3uTBRViZ4njqCwr843VBEPIhc54
b5ZIlBK71kwMKbOD9stODHfLGtpYcn05lZYQ38oyLw/tdG+kHaM47u7f4IwzOe1ogkWg3YUK
XVpxXjl8UD7ogG3CeCD8a/+ye8Jczu+PHt8O2/9sxX+2h7u///77/4zgweDRjWUvUG4dYroN
QiTE+FRe3S4YAvBjAYUYk9ROIYlw4ENBNlLD+3nLN+bLuVomKvydd2bR5Ou1xAjeV67RutAh
qNeN5WkgodhCZ3FL/7nKA8CbSXNx/MkFo6FIo7BnLlbyQvQTUSRfpkjwhiHpZl5FaR134g4q
RHDe6dJO3OWhqINDLm7TIGk3GedEdmw1y1J1py4w9DGEQydu5uAhHzpLx1nxbpNNPLe+tnQl
TSKLX7O0nXBr/l9W+7B1cZgFC5pnbOGtBx+Ok+O5+aAALdaNuOiDMlycefIZa+J8Wckz3duy
kmn8kLLc/e3h9giEuDt4xTXjIMvZSZvWn7MKwOGTeuF/gSEIUjr6qpQrehSRhNBSd9WQr9Vi
c4EWu1XFtRieok1Z5oeYEsuZFDglY4kNdXhopQgisZJYFlyBQDD1MYQM+W0BIBbg3Ws4Tk6O
7WJwgZCTD1h+OeWcb4+CJ2teqstUjeLJxAKTkTmEoA6KKFrSgY4sy7bKpASHXoYYxYxyBigr
2a3akXWGu+E0dlGzaknT6Nv+4D4XRvbrtF3CG5FrIa/QOcZzQpNhM+sQkogrYIyTBpTi7lC0
XiFg9+C+PEHHZbHG+sNuQAy+3mmzbEZsH1X4/hN187nZdQwiiPTWMQozAJPWiJ7G/oAZRanb
ZLM279tVzXkutmh9SffTq0/fU9yKFKF//LuzBLb3+LjmFe2vjNGNgFoWFM8KLI3fr4qhBsE+
QF9ZOzzc67AYsgaSh/uNlbcYv43jk8w6Y+0UgWqmWoFkWnG5oppCXDeszAsOYriX2NMeifNG
rBbVV/3CYLz7STgrBKtn6DGBH/CAf68mF7tlkhBc1UHNnZYTLG8liou4XO9kCBETb3Spmnsw
Pe0u3ClhbJ8oQ1UPgVnqlPQ3muYdNhZVg9b1qrkuxOLzezeuDlD56mQcJIWsQTIEGeIpTIYb
mn7vHw8Zg0lMU+qaWYZqBDe2v7uA5djAP13thpfS/CSGqKpqAbnbVu8DT/zTiJaJs7lytD8j
p/QoRhctgwavY9ReIwfILJE68A3SIYof8ruEZ+K+SLJegWLXva3HbRiEvbU9wxBkTn/gicek
k2/4lJ7HpJLar0evDELsdAhwuzTUpzVvJXLi63k6L4lv5a/pmDGCkUBYz1Q9k3I7Rgb6zCka
T3Lcg10QITra0r1/lnFWZ8oIgnj1QmmA0pJgOoGvOrqJktucNpianHa7P8CNBC7/MYRHvn3Y
mk/Uqy70FqUlc9BwlDUd/8098BxSY5PZMeSs85ilWZMx6lkfUPIZ1bkYO8URbof4ac5WXDtg
ulXiwSFlaJrtAM0crowBtN0C/c4+tcpW4EzmPrc14owTbEttMPv1TCAotiAOAxR65DOHNtcd
r8OrpKWvf/KxCM6ExsnObJPkaYGZUULvTY0VNQxBSXp1Zhgtq61sBle0Dkd9k0V+HOR/EZjf
ex/XoD1vyqyEBAbupwMVBqu7wuTVPHilktF6HG4pnyXOZsRZYfoG2h/hICz5Bl/cbahSwkp/
08ZHNrG5cKXxmwC35cahVRZTj85sSaVvaK66Lk2c0jceh0YwiClzOjod4mt4EZJP4063HTsa
BIrTamINrihrDt2bsmq8xqmH32AvwdAaOYDdNCGFuRAwhVuWqAMyXDvRmkvUbdiU2d/N0zpf
M1NzIivG89ZrrvI1Dvhsy03G81iI7v5qQUM10+ZDkxNQdMJFZ2nz9XeS93teuFLV//+GMvHL
xAUBAA==

--ZPt4rx8FFjLCG7dd--
