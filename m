Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5728230CCB7
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 21:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbhBBUFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 15:05:38 -0500
Received: from mga06.intel.com ([134.134.136.31]:21765 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233040AbhBBUD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 15:03:26 -0500
IronPort-SDR: Zao066xfnf3Qr0QNzSNaPR2bVALbXyuxpLV0e7+okGhdwr29qDKGki8GHT7IQ6Y8IlHAmZORto
 jLRN8FU4IPPg==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="242436908"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="gz'50?scan'50,208,50";a="242436908"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 12:02:35 -0800
IronPort-SDR: v8cQxcjAE88KoWkAK6Vk+wFCLX3TG2uW92KweCZEdVk6qUvucFi79TTfcFQlUo+Tk+V+UO/4Ah
 dMMQdnt2hnug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="gz'50?scan'50,208,50";a="433059233"
Received: from lkp-server02.sh.intel.com (HELO 625d3a354f04) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 02 Feb 2021 12:02:32 -0800
Received: from kbuild by 625d3a354f04 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1l71sd-0009eD-Mx; Tue, 02 Feb 2021 20:02:31 +0000
Date:   Wed, 3 Feb 2021 04:02:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ciara Loftus <ciara.loftus@intel.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     kbuild-all@lists.01.org, daniel@iogearbox.net,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: Re: [PATCH bpf-next v3 1/6] xsk: add tracepoints for packet drops
Message-ID: <202102030300.vslSCRk1-lkp@intel.com>
References: <20210202133642.8562-2-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20210202133642.8562-2-ciara.loftus@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ciara,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Ciara-Loftus/AF_XDP-Packet-Drop-Tracing/20210203-020056
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: x86_64-randconfig-s022-20210202 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.3-215-g0fb77bb6-dirty
        # https://github.com/0day-ci/linux/commit/8566dfd5799adb0033d56bc33146947b9469c362
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Ciara-Loftus/AF_XDP-Packet-Drop-Tracing/20210203-020056
        git checkout 8566dfd5799adb0033d56bc33146947b9469c362
        # save the attached .config to linux build tree
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=x86_64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   kernel/bpf/core.c:1350:12: warning: no previous prototype for 'bpf_probe_read_kernel' [-Wmissing-prototypes]
    1350 | u64 __weak bpf_probe_read_kernel(void *dst, u32 size, const void *unsafe_ptr)
         |            ^~~~~~~~~~~~~~~~~~~~~
   In file included from include/trace/define_trace.h:102,
                    from include/trace/events/xsk.h:73,
                    from include/linux/bpf_trace.h:6,
                    from kernel/bpf/core.c:2361:
   include/trace/events/xsk.h: In function 'trace_raw_output_xsk_packet_drop':
>> include/trace/events/xsk.h:63:12: warning: format '%lu' expects argument of type 'long unsigned int', but argument 7 has type 'u64' {aka 'long long unsigned int'} [-Wformat=]
      63 |  TP_printk("netdev: %s qid %u reason: %s: %s %lu %s %lu %s %lu",
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:367:22: note: in definition of macro 'DECLARE_EVENT_CLASS'
     367 |  trace_seq_printf(s, print);     \
         |                      ^~~~~
   include/trace/trace_events.h:80:9: note: in expansion of macro 'PARAMS'
      80 |         PARAMS(print));         \
         |         ^~~~~~
   include/trace/events/xsk.h:39:1: note: in expansion of macro 'TRACE_EVENT'
      39 | TRACE_EVENT(xsk_packet_drop,
         | ^~~~~~~~~~~
   include/trace/events/xsk.h:63:2: note: in expansion of macro 'TP_printk'
      63 |  TP_printk("netdev: %s qid %u reason: %s: %s %lu %s %lu %s %lu",
         |  ^~~~~~~~~
   In file included from include/trace/trace_events.h:401,
                    from include/trace/define_trace.h:102,
                    from include/trace/events/xsk.h:73,
                    from include/linux/bpf_trace.h:6,
                    from kernel/bpf/core.c:2361:
   include/trace/events/xsk.h:63:48: note: format string is defined here
      63 |  TP_printk("netdev: %s qid %u reason: %s: %s %lu %s %lu %s %lu",
         |                                              ~~^
         |                                                |
         |                                                long unsigned int
         |                                              %llu
   In file included from include/trace/define_trace.h:102,
                    from include/trace/events/xsk.h:73,
                    from include/linux/bpf_trace.h:6,
                    from kernel/bpf/core.c:2361:
   include/trace/events/xsk.h:63:12: warning: format '%lu' expects argument of type 'long unsigned int', but argument 9 has type 'u64' {aka 'long long unsigned int'} [-Wformat=]
      63 |  TP_printk("netdev: %s qid %u reason: %s: %s %lu %s %lu %s %lu",
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:367:22: note: in definition of macro 'DECLARE_EVENT_CLASS'
     367 |  trace_seq_printf(s, print);     \
         |                      ^~~~~
   include/trace/trace_events.h:80:9: note: in expansion of macro 'PARAMS'
      80 |         PARAMS(print));         \
         |         ^~~~~~
   include/trace/events/xsk.h:39:1: note: in expansion of macro 'TRACE_EVENT'
      39 | TRACE_EVENT(xsk_packet_drop,
         | ^~~~~~~~~~~
   include/trace/events/xsk.h:63:2: note: in expansion of macro 'TP_printk'
      63 |  TP_printk("netdev: %s qid %u reason: %s: %s %lu %s %lu %s %lu",
         |  ^~~~~~~~~
   In file included from include/trace/trace_events.h:401,
                    from include/trace/define_trace.h:102,
                    from include/trace/events/xsk.h:73,
                    from include/linux/bpf_trace.h:6,
                    from kernel/bpf/core.c:2361:
   include/trace/events/xsk.h:63:55: note: format string is defined here
      63 |  TP_printk("netdev: %s qid %u reason: %s: %s %lu %s %lu %s %lu",
         |                                                     ~~^
         |                                                       |
         |                                                       long unsigned int
         |                                                     %llu
   In file included from include/trace/define_trace.h:102,
                    from include/trace/events/xsk.h:73,
                    from include/linux/bpf_trace.h:6,
                    from kernel/bpf/core.c:2361:
   include/trace/events/xsk.h:63:12: warning: format '%lu' expects argument of type 'long unsigned int', but argument 11 has type 'u64' {aka 'long long unsigned int'} [-Wformat=]
      63 |  TP_printk("netdev: %s qid %u reason: %s: %s %lu %s %lu %s %lu",
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:367:22: note: in definition of macro 'DECLARE_EVENT_CLASS'
     367 |  trace_seq_printf(s, print);     \
         |                      ^~~~~
   include/trace/trace_events.h:80:9: note: in expansion of macro 'PARAMS'
      80 |         PARAMS(print));         \
         |         ^~~~~~
   include/trace/events/xsk.h:39:1: note: in expansion of macro 'TRACE_EVENT'
      39 | TRACE_EVENT(xsk_packet_drop,
         | ^~~~~~~~~~~
   include/trace/events/xsk.h:63:2: note: in expansion of macro 'TP_printk'
      63 |  TP_printk("netdev: %s qid %u reason: %s: %s %lu %s %lu %s %lu",
         |  ^~~~~~~~~
   In file included from include/trace/trace_events.h:401,
                    from include/trace/define_trace.h:102,
                    from include/trace/events/xsk.h:73,
                    from include/linux/bpf_trace.h:6,
                    from kernel/bpf/core.c:2361:
   include/trace/events/xsk.h:63:62: note: format string is defined here
      63 |  TP_printk("netdev: %s qid %u reason: %s: %s %lu %s %lu %s %lu",
         |                                                            ~~^
         |                                                              |
         |                                                              long unsigned int
         |                                                            %llu


vim +63 include/trace/events/xsk.h

    40	
    41		TP_PROTO(char *name, u16 queue_id, u32 reason, u64 val1, u64 val2, u64 val3),
    42	
    43		TP_ARGS(name, queue_id, reason, val1, val2, val3),
    44	
    45		TP_STRUCT__entry(
    46			__field(char *, name)
    47			__field(u16, queue_id)
    48			__field(u32, reason)
    49			__field(u64, val1)
    50			__field(u64, val2)
    51			__field(u64, val3)
    52		),
    53	
    54		TP_fast_assign(
    55			__entry->name = name;
    56			__entry->queue_id = queue_id;
    57			__entry->reason = reason;
    58			__entry->val1 = val1;
    59			__entry->val2 = val2;
    60			__entry->val3 = val3;
    61		),
    62	
  > 63		TP_printk("netdev: %s qid %u reason: %s: %s %lu %s %lu %s %lu",
    64			  __entry->name, __entry->queue_id, print_reason(__entry->reason),
    65			  print_val1(__entry->reason), __entry->val1,
    66			  print_val2(__entry->reason), __entry->val2,
    67			  print_val3(__entry->reason), __entry->val3
    68		)
    69	);
    70	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--45Z9DzgjV8m4Oswq
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICLiqGWAAAy5jb25maWcAjDxLc9w20vf8iinnkhyclWRZn1NbOoAkSCJDEgwAzkMXlCKP
vapYkr+RtLH//XYDfAAgOEkOjqa78e43Gvzxhx9X5PXl6eH25f7u9suX76vPh8fD8fbl8HH1
6f7L4d+rjK8arlY0Y+oXIK7uH1+//evbhyt9dbl6/8v5+S9nb493l6v14fh4+LJKnx4/3X9+
hQ7unx5/+PGHlDc5K3Sa6g0VkvFGK7pT128+3929/XX1U3b44/72cfXrL++gm/P3P9u/3jjN
mNRFml5/H0DF1NX1r2fvzs4GRJWN8It378/Mf2M/FWmKET01cdqcOWOmpNEVa9bTqA5QS0UU
Sz1cSaQmstYFVzyKYA00pROKid/1lgtnhKRjVaZYTbUiSUW15EJNWFUKSjLoJufwD5BIbAr7
++OqMOf1ZfV8eHn9Ou14IviaNho2XNatM3DDlKbNRhMB62c1U9fvLqCXYcq8bhmMrqhUq/vn
1ePTC3Y8tO5Iy3QJM6HCkEz9Vjwl1bCXb97EwJp07u6YBWtJKuXQl2RD9ZqKhla6uGHOxF1M
ApiLOKq6qUkcs7tZasGXEJdxxI1UGWDGTXPm6+5ZiDezjmyqP/Ow1e7mVJ8w+dPoy1NoXEhk
QhnNSVcpwyvO2QzgkkvVkJpev/np8enx8PObqV+5JW2kQ7mXG9Y6ItMD8P+pqtxVt1yyna5/
72hHIz1tiUpLbbBuq1RwKXVNay72mihF0jLGvZJWLHHbkQ60WoTSnDYRMJShwGmSqhokDoR3
9fz6x/P355fDwyRxBW2oYKmR7VbwxBF3FyVLvnX5SmQAlbB1WlBJm8xXEhmvCWt8mGR1jEiX
jAqc9D4+cE2UgL2FhYBQKi7iVDgJsQENBwJb8yzQWTkXKc16dcSawjnSlghJkcjdYLfnjCZd
kUufIQ+PH1dPn4ItndQ2T9eSdzCmPfmMOyOa83FJDL9+jzXekIplRFFdEal0uk+ryOEY5buZ
zjpAm/7ohjZKnkSi5iVZSlztGCOr4cRI9lsXpau51F2LUw5UkJWPtO3MdIU0piAwJSdpDAer
+4fD8TnGxOWNbmEKPDMWbjzHhiOGZRWN6hODjmJKVpTIU/1Uooc/m42jDgSldatggCamDgb0
hlddo4jYe6rEIk80Szm0GvYE9utf6vb5z9ULTGd1C1N7frl9eV7d3t09vT6+3D9+nnYJ7P/a
bDBJTR9WEsaRN0yoAI1HG90glAzDeRNtlC6RGWqVlIKiA1IVJcKDRvdExhYtmcMiko36PGMS
PQ5r0voj+QebYTZNpN1KzrkIVrHXgHM3BX5qugPmip2ItMRu8wCEKzN99DISQc1AXUZjcCVI
Ssfp9Sv2V+I7KQlrLpwB2dr+MYeYE3LB1ldyFEbFsdMcrADL1fXF2cSSrFHgW5KcBjTn7zwF
0DWydxDTEjSx0SgDC8u7/xw+vn45HFefDrcvr8fDswH3K4xgPVUqu7YFp1PqpquJTgj4zKmn
4g3VljQKkMqM3jU1abWqEp1XnSxnri+s6fziQ9DDOE6ITQvBu9bZrJYU1AopFS4rgaFPF6Sk
WvfdRJjMIuzGTYPkhAntYya/Igd1TppsyzIV8yhAzJdaWnjLMhmdaI8XWU2WZ5qDnrqhItwh
XXYFhU2fwTO6YSmdgUGYUWPM4CCL+QyYtHlkHcZ2x+SWp+uRhijH9UYPEXwC0FcTrEPmkm73
RvM18S1CB3EBBZ6cWMLBlgeoYUZU2dGHpZU0XbccuBANFDhEzs5Z4cKAxazNnTI4CMAVGQUj
Am4UjTnQglbEccKQKeFojH8iXP8Of5MaerNuiuNriywIfwAQRD0ACUMGAPnhgkvKg6aX3u8+
phlmzDlaR1/JgUzzFg6M3VD0Aw37cFGDlvB98YBMwh+ROYFa5aItIajeEuE4uGNI4Ck9lp1f
hTRgTVLaGkfVaPTQU0plu4ZZVkThNJ3F+Ry+aJOCQWuwlQwZz5kHiGGNvtXMabRMMgPnsN7M
9T2tq2Z9IwdqjEH4Wze1Y8FBHqcftMrhuFwGXl49AS8977xZdYrugp8gRk73LfcWx4qGVLnD
L2YBLsD4uC5AlqC0HUPAHHZkXHfCtzTZhsE0+/1zdgY6SYgQzD2FNZLsazmHaG/zR6jZApRR
xTbU44v5iU02b3CXkOw3E2hMVgdAoA4q8PsX1ZVpnMe0hRkCreW0OJhHkwYnCtGVF1oBMc2y
qP6x/A9j6jBeMUCYjt7UJg4cPIc+e9cejp+ejg+3j3eHFf3v4RE8PgLOQ4o+H7jok4MX7dwY
idgQowvyD4cZOtzUdozBB/BMB6aqCByHWMfsUkW8QF9WXRI9GiSEjRfgaPQHvEyG5rhiEEAK
kGJe/wNCjO7BXY2dkSy7PAc3zvg4kZgcPMmcVZ5UGC1nDJZ0N9VPAA7EV5eJGw3vTMLW++0a
IqlElxpVmtEUon5nIrxTbae0UfXq+s3hy6ery7ffPly9vbp003xrsIiDa+eIvSLp2vrbM1xd
d4Gc1ehNigYdbhsgX198OEVAdpi8jBIM3DF0tNCPRwbdnV/NciKS6MzNKQ4ITwE7wFGzaHNU
nmK3g5P9YKF0nqXzTkADsURguiLzHYlRU2BsicPsYjgCvgtmqqkxvREK4CuYlm4L4DHnPMyc
JFXWM7Txq6CuS0fBJxpQRv1AVwITKmXnJss9OsPfUTI7H5ZQ0dh0ExhDyZIqnLLsZEvhrBbQ
RjmbrSPV3DO+4bAPcH7vHM/J5PRM46XIpDP5O+fgcrDSlIhqn2JazLVkbWHDsQo0FViq90EE
JAmeA0oBbjZNrYwbndsen+4Oz89Px9XL9682yHbCtmD+njKrY9ENSnhOieoEtc63L/y7C9L6
OR2E1q1J20W6K3iV5cyN6QRV4AfYawyvE8uN4JKJKqoTkYbuFJwh8kXvkSxSosxUumplzIdH
AlJPvUwhzxQ2cJnrOmELrccz7rPFEP5VnfB6sM4/r4FJcvDPR0GOWdo98Dn4KuDnFp13IQL7
SjAP5GWkethiOIUTLDeoAKoEWEZvBoaZdshPIw2uDVjKYHybHW07zNkBJ1bK9+HaTRmd2YlU
VEg6pB7GTn6DrSw5mn4zl+gJk1Q0J9D1+kMc3so0jkAn6SKOAoNaxzh7ULNt54uIOeQGrF+v
Q23+5colqc6XcUqmfn9p3e7SsgjMLiZ3Nz4EDBSru9oIUk5qVu2vry5dAsMvEPLU0jHMDJSa
kXjtBUxIv6l3S7oAxwAZsGI2B4NwzYHlvuDNHJyCa0Y6MUfclITv3FuLsqWWtRzizEQz000B
AZZiHJyCWOhubIlExwusSUIL6Pw8jsQblBmqd+1miAkAs67Q4vp3CObI8QpT98rT5RauYxpV
UAEekw19+ztYE03jJc+CxNfpTKUCCLOAFS1Iul9uFp7iAPZOcQDipY0sQa1HBoOOfqNpLAo2
nF1ScP6qSR1Z++V48Q9Pj/cvT0cvSe7ECL1S75ogSJ1RCNJWp/ApZre93XJpjGXgW19Tj37y
wnzdhZ5fzZxmKlsw/qEMD9dE4AZ1lfFeQuZoK/yHmtB7sk0fYsFKzVLBU++ubQSFJzwh7BlP
2m5EwAlbVZaD273EO6BIHjylhJbCX8N749L4sIwJ4AFdJOjWBR5G2hJbGyEVS71QDc8FzC3I
Zir20RsZ634ZX8QSkogfOKIHcQ7wtMK59XYd7y7DOB6z83qNPGirUCZVWqGkVYOhx/vCjl6f
fft4uP145vzny02LczkpoibFCNEFlxjMi67tOcXrBtUDGtV6mPpEajtY6Nze1OJ1wdYxF7US
fq4cfqMXyhQEAzEXxqyEhJsJVlyCb4siS/x8uUHbCNg/fwlBlQ/pataGq7Vy3K+094lxpWu6
X9KPtomSO3Oomud5vNOJIn7VFqHEDO+So1jsvHRLHvMoyxt9fnbm0gHk4v1Z/C70Rr87W0RB
P2fREa7Pp0KmNd1Rxw6ZnxjPxcI8i2w7UWBmYR+2ksy7sxyB9o4/fmkhiCx11kXjj7bcS4am
EnQAuL1n385DmcEMWUpMuHSqPUS/RQPtL7wSrmwPjgx4bT3nQFwMZtZxPWwgv8mkk1i0shkq
a898hCQ73lT76OJDyvBKetqlOjPRN8h1FdP2PGM5LCBT82yjCcErtqEtXrC5SZ5TweLs5EmW
6UBBG5xVq8MWlqB2qi683+tpZFtB+NOiQVW9nx+hwnDbBPg1K8RgBq1z8PTX4bgCY3v7+fBw
eHwxMyZpy1ZPX7E00Alx+/jeSRr1Af/s+quttawobT0IivAAnbyCWm/JmpoSkBiv1V4Xxr0O
mpNsgzcb2WKsNkwm2rq/YlZpvGFaORu6/d06LaBicpYyOuWal9ITuI8ObvZr4FUjahIMBF93
bdAZnFip+kInbNK6mSgDAe5UYODs3IzfJZ0knhPRtczuQRE6Xl5vbSr0kuzbSbeu72Ubhedq
oIJuNN9QIVhGx6zQUq+g1PrCo1k/JB5SGlxCFDgCcU1gCTqlFuyMwZsaBrt3c1KXcAOr4MG6
c9JM7pntjmTzTedR38DgTCgpKLCWlEHnfRUJxCejNx1HM++qykcG02MtRHMPC/2QohDUGCEg
CXbJRhanbkX65aO66VrQMhmdbYSHXdqRmZjaWabIZTzqk5p95BDjgjYXwUb0yhN8fD8ytGyb
zJmtjN4C2DE6qTh6f6rk81OGv5ZLFA0bt9SRfx/e3xkGfA+IZcbNWpUvY8FthsD0xG7B3yBq
D5OyY3gfDOcfeL4paJ8Mi+58kiUHtQ7TBzJn11Pl1io/Hv7/9fB49331fHf7xcah01i9METD
wnjrsWP28cvBqWOHnnyxGCC64BvwSjLv7sRD1rTpFlDK1QAexsncTc5iDxvSe4vLMnMfYxzj
+faTn/yKv7XTZieS1+cBsPoJZGZ1eLn75Wcn1gcxsrGhY1gBVtf2hxPAGgimuc7PnORyf82C
KRVHmMD9aJxkvnHL9zJP3BUsTM1O+/7x9vh9RR9ev9wGXofJnrnRuxcm7N7FKrV7J9O9S7Cg
mR+K2Z/u6tL6snDw7pVYX/s8tpxWMputWUR+f3z46/Z4WGXH+//aW9gpKsliWiVnot4SYTw9
G5SNDbKasfglNWBs2UKsIhxx+ACihmAQfVtwfjEigmO0mWr3IFMJ9iDJYROYV808IlwrkG91
mheLAxecFxUdFzT11iOkWxLRwzC+Nyk35ScRejQWj/FG8pMom/kzXtSky+ZUw1BeItNSbVpv
m23Z7eHz8Xb1aTjPj+Y83RK9BYIBPeMET+mvN16uCXP0HfDfjWHwmMYG27rZvT93b8bAwyvJ
uW5YCLt4fxVCVUs6Sa+DZyi3x7v/3L8c7jA0efvx8BWmjmpl5vXbWNLPB9oY1IcN2XqQITeG
5fZ+3PMFBlhfNGAKdtqK7pasp9NH2AOYzdHgTCGyvRWMSs9vEBSD+k9o/ArMvhkyFzuYp8oX
3teYaU1hQNcY/YGVaCn6UvMcjSlQBVdTJ/j0IvACGGwkXnRHrnnX4QWnheIVXwzB2zi87wZf
GeWxGqy8a2x2B5x1dChNktlLlhoyr7BpentheiwheAmQaCfQL2NFx7tIMb6EozAG1D5TiKRG
QD0rDML7urs5gaRDInEB2SdC69mm25nb51q2qkJvS6ZMPUjQF95cyzGxYYr0bYuwS1lj1qB/
RhWeAfhNIMhNZm+Ze07x7ails/VD0ePBx2CLDcutTmA5tlQywNVsB9w5oaWZTkBkqjWBtTrR
gOGAjffKt8JipQg3YBkNhvKmENVeogfFq1MnkfGHiiTRbxEmsGKnNsnwaWykdqyuOw0RTkn7
GNfkLqJoLGGPkfTcZaXB1oH394fBZHqovZdawGW8WyiU6P0TdEDsg53hzV6EFi8SJvrYnkia
IsEJVF9s4rg/YZMZ4aQ0e4y9cV3KwzhD4ulWwIrBfGblF65adjAnO98yBZ5Pz0GmLCBkM1RJ
EB4ZtbX2CreiaMxjm94CuoXHI6Funz8bCUWTI+t3WRRch+BB4TZ4y4K2Z0jt/VO6yFCWpQGP
pYBh/slwmEFikhE8DBEdSvLcKFu1n60jG66FaAoqxeFPQHWY90L7iJWxKK4RNW5Q5h7DK5Oa
xvaqzQICumMqbl/8VlMBW6Rfp/psqROXJNJVjzbkWNYaTtOya//8bW54YWeYTfeOdXp+SJZ0
gUVAnSBZ0ado380Cnx5PAjM/Rk4Js4UAsf1GLtGBSMRgkyFWYO7V8JpVbJ1yuBOosLlll2jz
GGqaL5b8QhDZX2v4phnNlVu8Gh5wX+87XInOj21wF5cxs0flk1wtFdf7aeS+XheE16sFLlK+
efvH7fPh4+pPW6/79fj06T5MqiBZv7+n0neGbHCrSZ/IGCpXT4zkrRof/WO6jTXRyte/iTmG
rgTGBKCDXSkxteASK5WnLwD0+sM1FD0jmKsxvVjn3VN1zSmKwY071YMU6fhovopHFAMliz+E
6tEod4JGS+l6Cjz6LfhxUqKhGV/taFYbJnE3oWtAo4J47+uEV7EuQWjqgWrtl+S7UMchnl68
DEpbgVc0u7FI/CsofFBjsgmC/u5XvQ1PbRJZRIH2/XcAx8xYIZiKPtnpUVqdn83RWJ2Z+eDh
9s94V8LHbRM1A+jaq+q3PaNchi+l3bVjeWIbTZsj2uqFQbV4ejiKdrM49vLu9vhyj7KzUt+/
utWosCjFbMTQX485ugXi9maiWETotKtJQ5bxlEruXb2HBCyNb01IR7JoTikkM5c0iqbLMxJM
psyfEttN+OhksAr1NAVEfQWJ0wwUiggW29KapB54EnuZcfk341ZZfXJUWbB4511lPiBwunfZ
NSd7XxNRk9iaMJ0YAWO69OpDDONImjPXIa8dsLCnSWZZWxSL+nfMWM9g6I67j5UQbK6P7acg
+PSs1pETaMe4LSPOwEP0zbSDXO8TP+QZEEkev6zwxxv5RDbnrqrtJVy2ELCgMZo5T9NNsuKY
exD1NqBA39l8ZiMz3ZiL9GUSsY0RoPnHRDHe1VakbdHAkCxDe6SNkYn5ZMPDJ53QHP+Hcbv/
HQqH1lZibAV07uraqXDAHBL9drh7fbn948vBfNJoZaoAX5zjSliT1woDgpnHGkPBjz5H6TxG
gqliXmF8JobRRf/6O6ambbcyFcx1/nowWON0Sjtj333KYuSDpSWZ9daHh6fj91U9XerMay5O
1cpNhXagqDsSw8SIIbgV1PXsJ9TGXkTM6vpmFGGCCj/XUbieQD9jJvn84sava4lpNlvUoqwO
wPrfS/cI4cDTRb1mYlxBUWzidfFuCczYJSYp9eBdDz2Ve1OiI7QKX2klECq4YmFL8jmGYX4y
yUmjTelpGat2H/jR7L/95kgmri/Pfr2Ka4TZswh/c2fwcttyOI2mT+66E4qlCZZCBZsLVWWr
/US295Zo7fBdWlFiaxNdi+C9k4Gfi1mjEZdLr7158iSv/8/jKicLEenqpuW8msT1Juky94br
5l0OQXGUp26kfSJ54pGCeXQ0ZPKd2Dwbng7Os02jfmzNCzI/9wJbaar08SMhExRELPiel9eJ
SbG4emCNzDQkIEeltKx3ptMcP7fSHF7+ejr+CaGeo50caUvXNPoou2FOLI6/QIl6914GljES
j4tUFfcdd7moja2JYvHTAWsarwbaZa35DAKNfnWF2SU7HzWw91L4faCFrx5MpWfmJUEsLQlE
beOyg/mtszJtg8EQbAqMlwZDAkFEHI/rZu3CZ80sskDDR+sudstmKbTqmoZ6FQxg5UE58jVb
uE2zDTcqXqaC2Jx3p3DTsAvflkA6Ui7jIApeRrIWjcXCaU/LdYHIkAFIpe0A9rvvsnaZgQ2F
INu/oUAsnItUgsfZFkeHP4uR22Lx/ECTdombYB1syoC/fnP3+sf93Ru/9zp7H2QnRq7b/I+z
a2luHEfS9/0VPs5GTG+L1MPUYQ8QCEko82WCkui6MNy2p0uxVXaF7Zrpnz9IgA8ATJATe3B3
CZkAQQAE8vlhYy/T86Zd62BTw6OPFJMGloD8gib2WFjg7TdTU7uZnNsNMrl2H1JebPxUZ82a
JMGr0VvLsmZTYmOvyFksJcEGUtKqh4KNauuVNtHV1gPeBoJOMKrR99MFO2ya5DL3PMV2TD1x
lXqai2S6obSQa8f3aQOGGbiFUmJn/Y94pIylzMzynEsLH6SWZNZOJ9zQUkwQ5fYSU08/OcAB
eTbc0gMHJKfJE4xa4ZmySeh5wq7kMSpmad8ibA3CkpLaIrSxc0KyJlqEwT1KjhnNGH6MJQnF
szJJRRJ87upwjTdFChy7oTjmvsdvkvxSEA/iGmMM3mmNY2PCeCglHH9lukPGNs7A8S11Eqnp
mrLfTk4fUcYy3EZUsOwsLryi+HZ1RuQKs58KjtZ7DqSF5/DTQEj4I4/CLwHpnkqJ0suRLKXK
KGAf93Hdl5X/ARkV+InfIkwBT1FyHPLU4KEJEYJju6o6PGvQpyA42/Su7O4tCaVFefHtDOAg
YiRtrbyjQK9WuL35fPn4dNwm6h3uKh8coPoay1yennnGHZ90L2iPmncIplBtTC1JSxL7Rs/z
sew8adx7OYylb8/aN3cU00UvvGSJjmMaHrw/wMcYjMawJ7y+vDx/3Hy+3fzxIt8TbB7PYO+4
keeMYjDMbm0JqDegvADWRq1RMMw0pP0dTzDbOYz91tI94fdgAbQmaYuAohmjyXEphrLi2CQc
38+yPT6ehZCHmA95E8TRPU7DztluwwI4Dlt5lp+P7J6FtgTKfq63tLaEVcdKarvd5uM6xQds
JDWF8cs/r09m3KrFzO1zCH77ji3LMOv+aOFvrVUli5WpRn7oSJtAJcJKAmpLjMwbqy1FU44C
IfuDz5LFBgaV/4h5AFHzMkodHBcCVIS1wAROoNyfeHnnjsrEolWpENUJO9+ABEYz+HgHXDir
Js/xDR9ocs/20wi+U6tHtrFYwxbWZl1AmLe7X0DZ09vr5/vbd8C4fO4XXbsUP65/vl4geBYY
6Zv8h/j18+fb+6cZgDvFpm2rb3/Idq/fgfzibWaCS+9tj88vkIauyEOnAQN31NY8b+/zwEeg
Hx32+vzz7fr6aRla5DCzLFbBe+hZY1Xsm/r41/Xz6Rs+3vaCurRiQ8Wot31/a8NqoMSETixo
SjlxfyvPfEO5adKT1bT1tO37b0+P7883f7xfn/98sXr7AGgW+DKNN7fhFpclo3CxxQXdkhTc
OW2HQOnrU7sr3uRj49dJx40cWVKg1h8pW1VpYSe0dWVSbjhlKMJuRbKYJLnpiZLKtnpSny+g
4G67seqjzb+/ySX4Pmzf+4saaMvj0hUpo2QM8LWGv6SuSjLE8A8+/6GWis7UL2y+FcrQu6vR
YR+qTMQ+QNZBe/qNg+vb1+0toSpAArz9liOmH3fw1cclP3s0xZaBnUuPAq4ZwPraNiM1CQjS
w/bEtLnPRXN3gkscbHutqk+U96xtRUPQG8qIrtZRvXc8GPA4KrfWA2UP5PMpAditHU94xc2o
mpIdLKuz/t1wE0W5LUtT07vaMZZGqDKEe6v4QLWs9vYKAeKeZVQbwvFUKM8X1yc2PSsxxXTf
HnnrchmUKV00cXx2HLDrtYOE9sZ8oiEY5lJSc4NQe+ohE554oQpXU/M9MrNu3q+OAbZB+YaC
YfvTRU2BJjO3RFJH0e12Y663jhSE0WqiZpZD00YPTMO2smqrDySVX3Kb0t6hp32+Pb19N6NT
ssLOhW7DdMbxNecmOyUJ/MCVnpZpjw9uRwbZTIhYTgIvlmFdTzKfUoYLcR1Dkucei07LEJe7
6f5kM3RxN0OvcfCtjl4S/A2oVFhTUGppfMafQKQ+BooE6A+4pUPpWLMTMjcCpbBnQSvj55QZ
QlqnOMlSnWr0AxlJqIIoiFBHG1VJZSQvqvI92ZWAe/PDLqVOQUXKA6ucurpQLQGzOybNoxua
LCPDaWcVMAdAS7HXj6fxtidYJvJSSP1ULJPzIrTcmCReh+u6kZIidmjIYzF9UNu2UYXvUshd
8djuSFZ5MFQrvk/V1GBmcSq2y1CsFoGlO2Y0yQWgnQEkDqeeo/YoT5YEt3+QIhbbaBESNLCR
iyTcLhZGuLMuCRfm+3bjV0naeo2BuXQcu2Nwe2vBxnQU1Y/tAs1ZS+lmuQ7NJ8Yi2ERYpqqQ
36qroXVi/ujgHyywADhbNyLeu8J618y5IJl7rnW7QAjb+ejrY0wKEKmh2HRTpsrlzhCuzDdq
i8eoSi5HSupNdLtG3r1l2C5pbWDctqU8rppoeyyYqJHHMhYsFiv0I3Lew3jv3W2wGC3XNt/z
r8ePG/768fn+64eCOf74JiXM55vP98fXD2jn5vv19eXmWX6O15/wT1MNqEAdR/vy/2gX+8aV
PDaANoCzQyF4FYn1FbeATbgK31Ob1OM/6hmqGuc4a93jnFL8EVKYutxjewGjx9zsKYRNydeg
kB3maUuxlAD/NM9xEriZ7kh2JCMN4ejcWFurZcTi1mVKcZ85W3x/efx4ka283MRvT2pCVfr3
79fnF/j7n/ePT2Xw/Pby/efv19d/vN28vd7IBrSWbOa0x6yppYDsXtwki8FvmpmZcVAoj+WC
Y9IREAWpMHsckA7xsGz070bf/TDMel9a4MNsPMkTzduLPSy54x7jtNEIZkMy6LIjbCQYAqGV
GK2eq1RMntPK4+sE2BmAkrPDi3VAqJyWp2/Xn7Kg2yt+/+PXn/+4/uVOVHePDSJ+YBi5DgtN
480KiUjX5XKvP3bh2dhoSUkZtZ8ZvbdtUU4TqH7j8ICvfhMGkzzlVxf1bMRCGN3MydYk4cG6
Xk7zpPHtaq6divN6WghX4zvdSlXyvZN1PuI5FtVyg4cRdCxfFKLj9MIvZH+nv4wqCm5x+5TB
EgbTY6dYph+Uieh2FeAO3L63MQ0Xci4bXzzciDFjl2mN5Xy5m949BOepE3aI8Ij1emYIREK3
CzYzZVWZSqFwkuXMSRTSemYhVjTa0MVi7BSDrJf2dBmLVColJrUhhErCYRuu0ChkqGAE40J1
F2ocynx7nepM2wsNS/c3KXH8399vPh9/vvz9hsa/SYnJAInpx9KEGD6WuqzCtiqBmT/7Kgek
GXocdV/+G4yfHje6YknywwGP6lVkBX2ijGvdma1eveqkrQ9nDgSALMGYj/qyp+PJsDk0TMrU
jMmTWfTNu+UJ38n/IQTngO7L4TZPD6K85ikL4126q8Sc1/8vezAvHXLscGQqiqOgWjSF2KJg
YMYTWB92S83mHzdgWs0x7bI6nODZsXCC2K7J5aWRn2+tviz/k46FJ6RGUWUbW98e0DHIyfHT
Cfg1JsiETnePcHo72QFg2M4wbH3nqd6IzpNvkJ5P6cRMxUUl1RNcV9fPh7BF8TA1RiVNPdEs
is5k/0Kcnkr1U+2c8gDyRWr0PBO6as8zPRRSGJhjCCcZRErKqrjHPMGKftqLI41HH5YudlUh
jGN0jVRHbSjEPk3Q4wuV373JMeoDJGZOdKBReYr5qOYRkhdxaU1/7Cch93WPlKrH9aH03ArU
UvEhbxXW4jy92QifpaQ9aOtlsA0mvtF9e62vT1NVTIfYY1HtDpOJuryYOocAMXri+5N0Enhk
d/36lUcG1tSHdL2kkdxHcem07eDE53uvJhe8CxOduE/I3JkQ0+V2/dfENgId3d7iwYKK4xLf
BlvMYqfbd3EntUyVzuzQRRo5AqBJbWOSfjiVuqO39YdPvLSzaMxz3REve/uQebsjGAeU6GBk
jMiSMyt3OaBuANyTTVKp8+YwQKECGkQ7CdQiHWup1AiA+Nf185ukvv4m9vub18fP6z9fbq5w
g9g/Hp8sS5pqjRzxba6j4VsUUOVSp4FUQv09Vcfx6Ak2j+BJiC8iRd3jAWMpGpev7f1uEmJF
04arBFesjiQCBoNaNUZZ0SoBVivgbcfMyuCgUBfT9F4MV8JT5dgw74qukon+dxJOvp02ojDG
boLldnXzt/31/eUi//57rO7seckgotBqsC1rcny2e7rsT4hW9EUUDwy5eEA/nsleGzNKKM+q
HIDUlSvec1WpvtjIkOQzZMZ3eRb7otuVSwalwGscTj4Bkt0r1MCJTCifKwpcUMzjI5RvDcHk
uD2t8JLOtY8CJihPcN1Ons6nGJcMDp6wedk/4XF6yPeiGu8RJVcnvIOyvDmrSStzIRUzj/Gb
oRcLt/7QzP5csiT1GIQg+MC3cqUc7JB0RNz14/P9+sevz5fnG6EDsIiBo2IFdHXRcf9hFSNa
FPBhKnsRn1kW52WzpLnjolIhXEu69py1A0OEB2Od89Inc1QPxTFH8QiMHpGYFBoHYhg7XaTu
NIAdYKaBA7O/T1YFy8CXGddVSqSyxuVDbMtFwmmOxi5ZVStmp0ATynxSZ+vfqdDb3sxGU/LV
TGK2SDY8dRpHQRB4nfoFrLslLt+1k5ml1PeBA/iv1Onneit3q6zilm2D3HuwJ8x6JcVfEZZs
bsN3V4kvlSXBzdtAwD93oPimZ26dnKRMZb+nKmmyXRShV4cYlXdlTmLng9ut8O9sR1PYXD25
D1mNDwb1rbuKH/LMY1yVjXmkKnX3gOtQNitiQob9wtSBit9lmD/LqAMVnMus5bGAxUNblc78
ZI1rdTxlEH8oB6QpcKnOZDnPs+wOnl3N4Ck9PAm/P7lxqMhbHFki7CSHtqip8DXek/Gp7cn4
GhvIZyxSzeyZFCytfrkbHFJFYTTYUAB1A7e144JShkqsRoOxfSjoJN+EY8ZMs1abITE8KAnx
8CYhp9HNABi3B2DlzEIh2rFwtu/sKz3yAt3r9qcvvBIn5BDep+cvQTSzIWmga7Tl44lczEsJ
DBKPwnVd46T2qrNhqgN0X4Pihcu38IQfHHALjyz3fHi89lVxT6OBsvI+Hd8Tv+DhZcNQpKSU
arw1GOk59SVviTuPh0vcPWBqnPkg+RSS2XhbaVKvGp/VM6nXo2AXkyouk+T9ZaY/nJb2IrgT
UbQOZF3cGX8nvkbRahTPgbect9/CsDuS7Ha1nFnoqqZgKb6g04fS0p/hd7DwTMiekSSbeVxG
qvZhw46ji3D1RETLKJw5/+U/WenA5YjQs5zONZpAbDdX5lme4l9/ZvedSzGOAZSQFI/hKoTG
FS7GLUTL7QLZlkjtE0syFt55DaVt7cJVg5Cen+VRaR0cymwV40qaUTG/s94ZbnKZOaQ0wokc
iwPPbKzJI1G3LKCv8sAgG2HPZ6TbgmUCkG0tA00+e3Bqk6pZ6T4hS5+f6D7xynyyzZpljY98
j6JNmB05QRhXaolV9xQC9HzgAmU6O7llbL1auVmsZr6akoHSZJ3hxGM/iILl1oMHAKQqxz+1
Mgo227lOZMxy6Zo0yA8vUZIgqRQrbMMzHGCutobUZCZQvEnIE6kFyz/7tmyPOUiWQ6YOndPE
BJebsG0f34aLJWb6tmrZfmIutj5nBBfBdmaiRSoost+IlG4D6snvYgWnXgeIbG8beEJmFHE1
t2OLnMov1rql1KRW6lCyhqBKARZyfnpPmb3bFMVDyojn3gq5hDx5CxRy7DPPmcTRW5yNTjxk
eSGVPEs8vtCmTg7OFz6uW7HjqbJN1qpkppZdA25Ik6IK4IQIDxJJ5Vgmxm2e7bNC/mxKuB4H
P1U5+EcSOa0oipjR7IV/dVCjdElzWfsWXM+wnLME6Bhvs/E26pvU3L+9tjxJIsd6doJqXuK2
PSCEHqfjPo7xtSQlNo+TSGFS7LwRhHJufZn2IEk32sI+sosWVHQuMMQEilCNJyYeqKyi8Pip
cSXyJHYtEIRyEJgjCSSpyOKzBMQ7qXl57HFALtiBiBM+BUAvqyQKPPfXDnR8RwQ6CNSRR2AA
uvzzyXBA5sUR38Au+pAwfg1W21Sf0RitOtqH93EigU9S1yMhEm00NeG9TJJhZkOonSkDITm3
fLukUh6S1qadQ5g+vtRKLtI1lnBnNjrolxiRSSHYO6amHoWQS2IDQ1i0Xp7CiGYsokkwncxm
eeXh//oQm+KSSVLGYpbZtqF2cyrJgycS/eJzTqWgj+D2r9a20vgB7uT2IzgW4q1cbAPyxiDA
i9iDGXNOR7sYf/3569MbKcqz4mR7b6GgSViMZj8p4n4PUJgKvuWHTdEornc2QKWipAQQo1uK
6tfp4+X9O9wx2DvqrdT3tloOYPE2gpDF8CV/0HmdVik7Q+EPtzV2dr54Y4B8CCW65h172OUa
d2CwN7Rlct8p1usQ3yltpihCXsRh2Q4vM1Cqu12MlN9XwWK9GGbBItxaKWkGKQw2M52NWzyp
chNheVU9X3KH9+tQmKncVrECW2JYpYqSzSrY4JRoFUQIRS8rdFaSNFqG+Cdp8SxneFJS3y7X
mGo2sJjJnkNpUQZhgPYtYxf8HuCeAwDBwHomkJceFLrRAOdJvOfi2F6ghXRKVPmFXMgD1uwp
g9kc1+H3YhPW2LykYVPlJ3qUJUi9usLbAxtaw+j4+1Rf+9SnDniPxqHRlTQkI0luabgDaYlZ
GAZybNxW3JfSfFcSs3895bAPsZiagV7aZkWL0HjQJAemE5cfR4om1vZMSgwgtEL7J3jMLhx8
QVNNVKl5x/fQcheahRNALkMf2pJDj4e357uQsuQeYIOeCZI0ElzhGt4SMOPzcod0VZF21nU5
Aw0Au00Qq2FALjyWPxDK1yPLjieCUOLdFp9pkjLqic4YHngqd/mhJHtcQB7Wp1gvAtzv1vPA
GXhC4/Z7lrogMfIKUCyPc/Q1FM2VA8ZsRV16PBsdx15wsvE4UtSHrTBJPRjImgH2GEFL5nFF
tLuHFKqRMShTvhql96tCHnr5RbobhkuV7M2c764EkszNMDpVHsZtbq3LHwSjktAtWVrW7rYM
k+FbEnEbWK87Aev4+P6sYGz47/mNm5yi+m1jfNt4IA6H+tnwaLEKLVOTKpb/dR30Fp1WUUhv
A0NQ0eVSWtTyg9Oe1LwKgSazK7LU5SXZ7VtJLnYKPhS2oS5Oa+7jRAhQDhMccnxm2tCiDdrp
k7NIYH9wkVW6siYTUgREn9OzJLgjvaez9BQs7vA9o2fap9HCYWntGtiy6QMbMV1CS+3fHt8f
nz4BsMsFk6jM65TO1g3Z+u5kdTtA4t6bdq46BqysEQlj5iURF5R7KIYbNWILHR/g4bdRU1S2
8VEncahiZDIThcMMaEiALdV9auLl/fr43bASGWuDJBq6n1p32WhCFK4XaGETs6KEOAV1v5Mz
MiafxsixFmNHCjbr9YI0ZyKLMhSS3uTeg1hxhz9kNLJWD0wQRpPAalL6+kbnupOVzYnArWMr
jFrCPZcpm2JhtVTvYzbaXTp6SjIAfi1nB0YBTrU4VGhL+iJa4PDuD32/UWBLq7GLdTGZTbL3
z77RKoyiGq+TFMKzcFLer97s7fU3KJN9UstYZXEiOd9tdRj0hFeYoN5y2Pd2G4XGSnJb/YLe
WdISE4jsux81qYu9y1NQmtWFeygoQrDh4taXs6aZdjTdLGs0mUMztGfLl4pACHU1mpyWrmhu
1wwaKJj6gj13HZtMO3KKS7kd/G8QrMPFYoLTNxoQ5zjqojzX5JemHx+MhqAs/EeeJO+FnIIC
HjrLxTNIhJ9jFYUbid5lo9j7q/MWKa3KpLM5uG1mOuc3Jii2fq8wwyFlxlc3Bw9cUZZ/zVPU
wwQ4YvqsGxxHgETnv7xDk4UNn3vucPtGM6huLjyNv2eFRgBDIJ8+gmwrlbro8UXglrU25Hy0
kHiRcikfZnFi6lCqNIY/qfXELjuk0jSxiwmiKIAfpA0VmMqvWlV+Ga3w7uGWsB9OGyjiraYI
vnf6eCGAWZ4fnGIF0pvvbe4d9uxB1NCXBSNF6qoBKe3BxVgIVRv3EQLEUyPFO7JaBhgB/I1o
cZsMNqLU4E+xbRqkKCC0fGwxblPGnhCRbvi6HjKqjIToSQ5JUAB3v9LheaNSE69E6nXhqraX
RwcPjm4G3u51LaYXcraOGLj6yOO7lqQ7h9Z9z2dAzjJ1RrhqZQTvObRjwyceC9txC7/V1Vu4
a5NkB3pkYBiABYR7oan8K7CuykVF27v9TD9t8rBz/XsdkvB47IzX1Au5PAl1+zjaF4sJEvY1
0urYti5V7LHPIbQzK2jBoUwKuiU74PH6QFbGQ3mQ2LFMIW0v6PPUolJ8084AozA9AeaXBsD7
9f3z+vP7y19yMKC39Nv1J9plqKQPmR/246E8qehqudh4+gAcBSXb9SrAKmsSnnja8ciRmWg8
TWpaJBqlr0Ofmnovu/0WTBeUGs8zRGogJ0Nr5Pufb+/Xz28/PuwxIsnh34xdWZPbunL+K3pK
JQ8nlxRFiUrKDyBISbC4mSC1+EU1tuec47ozHpdnnFz/+6ABLlgach48numvAQKNvdHoro04
diOxoTuMSPQiWxlPH5tOpOAwdW6aYa5aiMIJ+t8vr2+/8UKtPsvCOMK900z4Gr8SmHCPgyGJ
l9km9kQFUjA8lLmH30rPrgtw5pzadZB7oocosPSo2AQI3oNwrQKglVTv+gulbCXF2MDnCtmB
wLHO1i92ga8j/FJqgLdrfLcO8MnzwHnAmtb1vS3fG3v6CKfmBm+eyX69vj0+Lz6B316VdPHv
z6LfPf1aPD5/evzy5fHL4h8D1x/iUAUOtP7DHCAUHANjs0iWc7avlDsBxOmXlxc1UgCmvMxP
S3PaG75rUW4qhJeK2qhrLYHhmJfjxKJRa3k15e9OlPy+EpyVjid4DVZ2Rk4z5P8Sq9Y3cRYQ
PP9QI//hy8P3N2PE66JiNdz697p/Q0kvKks4o79jg9jWad3t+o8fbzVsKK2FpyNwkXXClmQJ
s+oq70x+2V2ygdfx1olEVq9++1vN10PdtK5mLUbDjG801nCxNsads6ZWdBo1ZvmuT83q80Lt
pGzS4CXTrpjCwKkoOBi/033BjbP3bcDMAmvEb1h8Oxx94zEVP9Jj6YK3EkEZwhQZvlTPGoB+
v2SwZRE83nf+Pm8GDXp2POgWLwfpA2ne6yhlPtcjOkzBLCT56St4/tRnMcgCNj7Ip5qGG665
G8ST+bgD7hrJPnqnbPj4LXeDBPmIAwEY9R/lFnaWtAZJ7SmKOKNPw4ZpayrEX+DF/eHt5Ye7
G+gaUcSXz//E1FcCvIVxktyo7RhBzSwyoNBisBUEwxRvCLm3lwX46BRjVUw+X2RwcTEjyQ+/
/qdhI+iUZ6oeq+DIPre6IMCuVP8bfpsJo7v9GdAOMTAUhizxo77CYH+B9YkBzcg2WBv3OyNS
0mYZ8QC/mRiZ+CWMUX/FI0NKrl1LTAO2EROnn7a9npjHz9/IVlyrixOixOKxTOimuhcZRB8/
GmqEqWhtfcFNMqYCkqqqK5neyZrmGYHoPUesZlleiTNj54smPXDlxfEAilWR/32+smQdT/vW
E7pnYNvnJauYnZstKJoP9XHSvye8UdK6kx7gHcsLTXcxQfmZyVK6wuJ91TKey1Z0E3ZsP7TS
MO20YrS/Prwuvn/99vntxxNmiutjsfMu4YxK3G9SvtoUSYy0KwBb7aoRpiJDQT8QZHxycAV/
K5hon3dxuNQ5bmY0gjERaz/Yz9DUUAYGTFsJWVErjsFEvJ2wlxISHj3MGiVQlk3BfBJWQZuf
H75/F/tYWQRn66EqU2ZN5xQhO/uiM0oYboP86DS53ds1Sk7mOeOoGqXJmm/wg4Jk4Ky+g54u
SYzZu0lwMpe3RHHbDf4azNjXmBjVGiWWgT8GFK5YLUGbJdptwgR9fatk0SUbfTJTVaSY1fQI
RWF40a6igXpmFXiPcTI683BNVwm6vbpbiem8JKmP//ouFlOkFymDSKswqk8GTmEkfemVhFSh
RHbrDFT78m7GNviRc2DYJfG9vtQ1jC6TMEAFhFRfDbJd9v8Qy9IVAGnZx7rCz7lq/InFO8bs
DxRqnHckyT3aSXLRRNsVruAY8GSDvpMd2imz1MyKzBka2x6wlsZdnERW23UNX8dBsnYaTgLb
EHvcouNLpwzdh/KS4KoZhZ8Lz0NANRzKJHLHjiDGgVNGQd5u8egBSAeYnG47HcPqAneUR5Ih
7XwPLlQjiBW/vjN7yuB98B4mvCMlGYZQcnl8mKk2zWjkOIrW4rxhEgAv+7+RAH5ynnJGcpBZ
nL7+ePspduh3p1qy37f5nliBlwz5iWND3+hzPZrxmOYcjluY8I///Tqcu8uH1zfr6+dwDJUL
1sw1NrRmlowvV1vNkMpEkiWOhGfjJmOGPBuNmYHvma5HQGqi15A/PfzPo125QSsg9vf4sj6x
cPwiZsKhhkFs1FADEn0UWhC8N8m8geIMZo/3bzNDfHwYPB7Tc50nCXCFqJFPhE1IJkfoEUkU
eUUSRTfaYjOyyZXgOcfBBQc2iXaxZwIhDiR5sPIh4UYfa2YXm3bqMsRqm3Pdt5hGhJ+dYYEx
BWVtCuOuXqffi42aEcWKCE9sUpLtMla4Viu5ctyg//WGOcoA+LJTi4udm4zvp2haVqDt2cMl
jtg+BGvsIJCSTgzo642el0EYW7HJJQLttMa6m86gt7BBN146GAi2KRkZeMqxaggyKl/wHNHa
ica80g9L25W1XRy5R8LSiqYLN/jqb7H4ky9RB29jlRhvILmmgRwA2Wt06+IRgJ3WcqOLdUQ8
0/aUsIvWcYh+KVzFm437KSG6VRhf3CQS0BccHVjGnqw2UYwCMXwDBZJtgAPbJEA7SJlGqw06
QkcWtYNEH/yPzbYn/T6Hy9vldqXJa4IH6yC3x7ddHIjp1ZFK221XMVb3bLvdxisXOLOCGndB
h3OJqqHk+kkM1dlAGkNw40YDA4+YBDsG9vjYuBqZ8jIXharA+nUwioGYO0R0b/4usJnPLZOG
+xDlpNGMkkZ8iJ8thAgxHfJGVJXnWPF1xh1hrbK4vFsbPYmMBytffdypmZm3W1i7kAickmov
f+DwXAzL8mTX5h9GzruVAq9exPZXOLxQfHt8AnXzj2fMylgF1pJNRgtSalbR4rxza46wZpTN
1IOciF68pres41gh57tSwRqtggtSCj03YMErO6zid/OyC9bQw93McLlo6+tg8YV0DA4v4GvO
WWqYSvLU+AMsEvU33DIVZTJSBpp6RG0iWCzdTTUymPQxRC9l0npWSzzfKDlsntoOTObTzJSW
BCkTkC0mVXpwjo1yTzhGFh3MIs8lNnYNAPFdQTh+StWTgneQGy2xqdJgc6s7umGfzX/+/Pnt
M1ziuN4exo3HLnM8LgON8GgTYputpmR0UuX80rMhpFsmm8CykQZEFC7eBhcjGqGkZ9t4E5bn
EyoTmeelWYpxh79nkmUfLoYNQygAXHXNTLXzM1ikZtwT5WnCI0yZOqFS4e4mQhfsGTWvp0DM
sKlDFVITGi9NSSuabYc2Ib5ST9djNi2yBSioIRr2U4KGKk7Km4bgWwslDqEZzfZplusl9iL5
APE1CGfUKBFQRS6NJ9YW5Kjm2w89aY+TXQjKXDTUq4IHDNc+z+uMbBN66DIwj9DdBxgMZbsr
MrttFA+8aPBHC7D4cOuYmQnUkvhnmpLe0gtuw6BzYfeQEh/fTBup3pPqo5i0atwLK3AMSlmj
jyWJDAFhZ6bI/iEo8TV6IasG+XQYsAb/ZbNZbyN/ss0mWUVmEdUZZoMQl84ol+QtvnefccxT
gkS7dbR2ZAFUM0sdzKvdMkxLag6wWZlo0tu86+0R19CdOFZ7XAXIRK7CU0fVccGQjqP2BiLP
KbIycLbarC/jI1YdKOMgtMsqib4jomQ4XhPR9NokRNJLHNhrEkmj0Eesu8Yq4pVT/YEb0DoI
mRJFsdgRckr0F+eAqnsGsz5w4k0Su3FFPkWJ2xbKtiFF6QmJBEfAMIg9PpPl+RC9SFDQ5mLV
Z76ScKjbwKm7uiixW0eyJ2tfTxlvN5BvqDsNhIotEQITU0aEXxZ052IVRG6o4hmGixB0x3Mu
wuUmuuPYFVqxjOLIN3+oWxi7uL6bV7m7UTdf1jZKEbE1XO4TPJcTsgplHAaYTmoEbenL2xxn
npRU3ywlwFXgZgMXSAhtqIVFj5H0cYDybrcrW6Jnmm2jFdbNWqlrb+bm1S3GfVvhOXOIGFJ4
rklae/ZqwYzO0HkWzOMvoKXDCyI0DopET0McFD2NODGLIpU1+h5RHPjzynw21N4YrmAZkOEd
+UwsaW7bcArOLr9RholAgNNTWj1F1Z9qnw0QA2U1PO/DBg0oLbo2J+VH0lh5Djf3/pKwfd02
Rb+3HHdIpCee22SBdp1IwXB7DSHzMfiPp7TyVZohw+GhmnzoXTJQoc1dBGCmmQuK/C9pfbll
p8xg6mrtGTl11kmgVHXHdiw3Xh1LF2YS9fS7mQF0/744A4oL4ZCnyP2Ph+9/f/2MRkome8wz
x2lPxBymaRsGAux+wJKevwvXcx4A8jPrwEiuxpb1TI+4J/64Zc2N9Jfp9YuukgJUWhmVnidR
EwPPix1cN+AfvB1LPrwdMb8N9F2KQrsUDJUmTRcGgrMzUhQ1fRfO71wBhidGN9EMGURgkoH3
nCrTnJq0fV7e+KEUP6fSTNYpj98+v3x5/LEY4qmL32TA6/nUDxmoJ0SbIDCWrBHhrAjXmHeO
kaG6NLdOnAa3+gNtB4wD21bbVzalj2tL40neqFrTyGZRW3Ge90w9AJMy873dALiq+1NO/Djb
htjSDdBJyN+s90l0Drs3nsrz3uMHR7ZhSWKPY0+A+wxXq8qacU+gB4GVe7Jf3sn3w8Wfb1rT
A7ZKAdaQSlqfjqGVvj89/Fo0D98en+wISjqi55C2LNtbnVvmOiNG5mx0oLdIf3z98tej1YWV
cyx2Eb9cwCPnPNUaaNbondCftymJvKvIieGqKcDF0tT2/PYhLzE/wKp5w2UfLQOnV4hF4MRE
x/Xm7YZbdQRWt2BBLuea24eetcfJmn334+H5cfHp559/isGV2T5LxPRFS/CCpzWDoMkF5qqT
tN+HSUlOUUYqKv7tWFG0Oe0cgNbNVaQiDiCjlacFM5OIcxaeFwBoXgDoeU0ihFKJJZTtK7FJ
Eqsbtikav1jrNzw7eB29y1uxZ7np2lU559M+1SxsBakUW7ph9jXz6Fghy9Qpryxuq/w9PlhB
7hpASLJrob1DoE2JP1iDhNc0b5c+Z8GCgXi2CgCJKR/cqfhwVvLOC4pl3GNaBWCOOgeBXrcK
Q0Okh73ZxLOzQJ2Lh9moVtS/o17r+UrRspMXY5uVV2RFngTxBn8fAJ3AsWwyPupfn0Dk3TVc
enMmHR7aEATgccgqEHIivrgcKbw29DaSX3JVXotRxrw953ht8alMYFHmWf/gk3Wd1TV+kAe4
S9YeWyMYY2LByP29lbT4rbEcP95Mqdhp+Hybg/hA/+SZS0pO+93F6KZi/Tb+ZqlYEy7dKg4C
g65dxpst0na952YVOt4Yn8TLkAr5eawmZV8oG0/ARlmfTWhNM8P6iS4vcgJLHz7/8+nrX3+/
Lf5tUdDM65lXYDdaEM6Hg69e70KLxI1dgImzWSG9uVkZOPixy5axYSY2Y80ZPx/MHK7JMcI0
aIHvFhNcUWiqzRmQoT7Ohr/YGeREnG4Ilsy21dW+NJlXY1CSmKplC9zgtiQTj7raw4palNE6
CgietwSx6xyNpUli3XTGQCyVqSagQdF7N2v7MbKW9UlIalPgHitmtjRbhwGuztdk09ILrfA5
fuYaVFPoiPrNuJmuwDIZMGkMEf368iT2D8NmVu0j3KEGx2tqe7uRUXN/Qxb/F31Z8XdJgONt
febvlvE0jbWkFCfrndg8uTkj4OhbrGnFDq41zBUx7rbuHAOSuwmmbVxHjnl9sl+7jt5C7otR
m5Zq+73ukIOjH5nT8Lqv3HfQB5a5zSSIxrUmy2Yzwq7Nqz0aL0CwgUpPj5xw8IRbhxyHl0hO
ifj3x8/ggwrSOvYBkJCsZORWq4CEtj2mhJWYOetJUg+e8U1amhdHVpk09VrSpjHxl02sW050
9Zoi9nti0UpCSVFc7fJTqfjyVIBem9bwAg9EIe19LV/4mRqTkXrbYXEeIWUOeqOdXYK8yC0n
RSb88ZjjO0DVmmXKUM9fEt21pf25fSHOjHWPne4BFmddUmTMTiXKIJ3UelIdr7md4kyKrsY0
g+or+ZlDlC5TtPtrq9RmVl4M4pV6ZYC76gPkPUn19RNI3ZlVB2L1tmNecXFI62qLXtDRDlkn
5s4oLfKqPmFqSwnWezaMHIQKfzTNjE1002sxkNu+TIu8IdkS72LAs9+uAiTp+ZDnBff3TLmx
l97J7UFTwPbSrm9Jro4RkwZLXf/eFqaKLVjvOotcgwey3BrW4K+WyR5n0ivdqAIIEAj7aJIa
cXwV04fo50ZDaWS/IJq8I/AE28pRTDxiSUaJho5Ep0+rPg5DfjiQZxxHKGstABxEtjCOrDlK
rqcXu9nERCmE5an56HTfTtPkeWZb3+p4l5PS/Lggic4mFpmcO7n1VVN45x5x6rLmA/CITTgz
39uNRH8rcrGZ6N7XV/jWnKNOtcaInBnYCT+/SrBueI7G8pPoQcwezkzbHcB72B0vG8AEXi/P
t8ZzlJcTKWP27Z+BX1hV+uaej3lbm0IYKYgAIJqMGKKYmkwKVfr8vh10HyoanYq6irPM4Bnc
XPSLwSfH6O0S2WpML+TMndG8p+Hp7d62prEx7cmcnuXsdAvbgUlvYczwM2bzagbL4rDuK64y
nwLHm06hDdteOwt1/1FmC75TAEcu3Eoh9J0/ZzT55P1a/5gm2/pA2Q2UlWLXrLSl81QD+HAz
aBIhcGVtMRaw227Z3qT2RcNM354qfVVZFqxAlt7aD4TfDvoc2eu2y70yRTZ2vZCyqsR2m+YQ
gGS8T3d2uuXX18+PT08P3x5ffr7KDvLyHUwCtP0u5DXa4INel/HO/tROfIFVDB5gdTDVIaNG
5nKtiLT4Y1XdWtWvu72dqyCJybvOetoVzHO5M/JljMv3CeAJuq1IAUPTUwpg33Ftnh5aisum
gncagmD6p5Hi7Lua92IJqDL1UOLdUodLucTPIxc81NHZQ13marVlo683lyCAtvUU9gJd0W56
Rc3SPdVjL00A9IVnjDoFFUXQQcFkZpejX5fUtq47EPKt6xC066DXcXFywdIaluMTdccL/Ot6
4cyGv/TLMDg0d+QHD7HC9UVWwqj1TnQDkdgFarTO9VQWu+wTwu0xWf+u/P3A4Cl7H0ZLt3y8
SMJwKKCR2wSISuOL98zlCXkmQ/0lZL2Otxu7YObqQ6UJO3ZWHGFHHECU7xlL5Tl4GitDNC76
9PCKOECTY486srvn6xjwc4YfIwHrSvfIX4ltxX8tpIS6uoULgy+P38U68bp4+bbglLPFp59v
i7Q4Sg/MPFs8P/waPVE9PL2+LD49Lr49Pn55/PLfC/AXped0eHz6vvjz5cfi+eXH4+Lrtz9f
zOoNfE6DKrLXZZfOM8bY013YKpKcuBq/MKavkI7sCO7URefbiS2ndUZHuBjPlrpOX8fE76TD
IZ5lbbD1Y3GMY+/7suGH2pqKRpQUpM8InrKucutopaNH0pbE1y6DRuQmBEd9i83IKybeW5+u
l6b/CDnKibsqw6hgzw9/ff32lxtiQ642GbWMxCUVTpXWqUZnYI3PClSuRVnFIztLSbztSba/
E75TMcHrn3tZyxXo3JqGbbLYcnbI0Cfqcttwpk65gCY3Ut5CSY47ZZK4qhiaedaDU/y6QELF
Pj28idH8vNg//RyDCGp7UzsjZ8VQJSONE+FVAHhMmRT0fWJXr9/261RxcqIexHxnZkBOwSak
5KUHmZ1LGSWX753N5+RTR5YRJpBbfRUXlm/QkNhy7CjbQnv0jREmpFb7blJfaccIBM51n8tD
WEthY2lND2NEhWMkdhcoNihyPYU/RCvs1lRjOR9Ylx9yYk9pQxQAtmdiVaR5kbsnkfEjjdjf
GHoPHRzmrhIzatb48rLJ92j2uy4Dn/w1Cp6YERJLQ1hDPqACY62nqLkYop6IUwiXER9WL24S
LqOlD4qjC1qovbz99rQia3D3hTpLj5vSaSzH/MobUoGvifs1HBg9hTkWaHwEnaNOGYRDsZfe
Ka7GrQcJoSBcrHs+XNZ887sxLJmSlb0fGLBL7+3DFTmVpPJ0jKZYRgFmRa3x1B1bJ3HiyeED
JeiFjc4ilgE42qNF5w1tkkvsyZ2THa6pMuagvG0JHgIB4b6WaY2bP2hc3W86gjSJek/oEa3T
+eyoOwZRNoMVL/bNuqyYFeEbz4HqqnANu4Cy7FZ2HlmeGT+kdfWb2ZrzPnR2nUM7dvjg75ts
k+yCTeTspqaAK1gcYVjYTN0JenDJS7a2vitIy7VJIlnf9chMfeJoIAAAi3xfd6avGEm2T4vj
PE+vG7qObEy+tzeJLFNXH0a2cq7PC2I1nbzTzMTaX+gxZiX1Vu6Y9JOpfF9YTcK4+O+0J3aV
C99RGB4T0PzE0hYeo9jJWI0EG9VTi1OnWYL8AO6C5Gl0xy5d31oVZhwuK3ZnM9VV8FnrRP5R
yudiNTIoRsT/yzi8pHZpD5xR+CWKA1zRrTOt1gFmci6FBRFZhOTB+4lTQSH2/6vsyZbbRnb9
FVWe5lTNTGzJi/wwD9wkcczNbFKy88JybMVRJbZcslwnuV9/G+hushc0kzNVk0QAemGvABpL
yUSm3n69Vl9/vu0e7r9PsvufVAh1KFettJksygqBt1GSru3tIWK0OSG5JUUTrNYl0I3oZWbS
nVHTTnu6qJekWXYBHQnlZBOBYa0nqr1L6lNoSioYhQ4ND6YEVomARZt3wiSDaXQWP6vrRart
Yff6dXvgwzFoEs3pUlos4P+N+V/WLkxpdizN8W0w1Z0fUSJby9KmnMahZIJlRELVFvcQxpGU
TEy5iZSVgJjSYufx+fnsglfjnSt+70ynl7RpWo+f09asOFbltZ9LS5bTE68IieY/ShWnL2Ny
5szNG0Imm5JxLt86a/kt1mWW7kwtE4eUhJZhcmvDcrANHBRNBm7BbMgqjW2QVLhZxwz+0y6v
oB4JrkcHkU+N1JPIT6HLF5FfrdUTJb9J1LE2ZGNKDkVbF7HHZtiskoxvaJBYc0LXs+CLoWO+
E0gj886Cmk5f/b9SpWqkTeRmEIMFv7x/fNoeJ6+H7cP++XX/tn2EBAZfdk/vh3viOQkeXu0O
AaxbFZXtg2buxoaORoHbeHQ9iMN44Z+4RVtEwOB6D3tjtp7J66IBXsffe5XEz3ebaHvM0q+J
vFd4WozUzvdTl4/cacKSxNu6ZXIngHFIujTifRJs9NtYj8v6y+Wg6mnuKt2ND3/yVVYZBgQ9
1JOAQ+AXwFORvt4C30ZMfxeLIG1GtLQgGLv92Sy4imeMzaa6IbHsEfrkz40DSmAY+NSeWvE4
+t3S/Hzd/hXpWbs+xls9hxf77+748NV9kheVYxqxdIafez6buq0DQR/ZxGsJ8L/2wu5+8B2z
8xy3k3z/SMRREn0B39SswScfa/RkJqkBS/XO04ixDDFDNDrMmgcgIJgcCHjkHLB5bsZQgPgv
dp4QiWMQ/dhM+QrkkuMWb+h59JHFH4Hyd959objvSQdwLF5Fqd09BNohbggKO1iOW0XWLHLz
WwRiAX/PTkzUJmSx3ZUmXeTwAEa30ntuOB9Qc9l/5Xt5BJIovLQDrGvYNbhkx3lOhr0CfBvO
Tqzut2zlTHTLPzO94GuDDNkE3bhZ6Q/oAFqxG2cUSrZKw2B0SvKGWlHDkN8mha4NyZMcgjYa
wQQUzKOGEPkH2HH38I0IZKbKtgWooiA6bpvr0WYg4J1Y+MbXMXczOI39zjpXzeOC8dxLPdG/
+HhVdLM57Z7TE9ZczCBGFYxcTGtBNOlAnxgK1qHRpv7dGg7vyajMSpopQsqwBhVBAcoVSDwP
ST0T17adk7oTg+WDqtUsXRHCZhdn54HTJwyxQm+MAU+NicJenE2tpgB4ojvNIFSkULBpJdSy
TUIUAcJIP2fuN3Aw6ZsisecQC8+uyXZ2kTOUrCH1QErrQYcun1Oa3R59MbO/XoZngeCpupFg
jzs/sYB2tDlRtxl9XSyVmIuftHyKeBkQjZ35XNTF8hDeTH4CCCJ3OacU4sK6KQogzpEzoE0W
nV+dkqGU++V1/sP6TD3MlrXQ0dLh8/fdy7c/Tv+Dd3m9DBHPG3iHSP2U0ePkj8F49D/WVglB
1ZU7HZdp8UYGJLulU6kiFoK4WjNapNHlPLx1hwiDUkkTP199bJnPTvGNox+Q5rB7enK3vrQz
s88lZX6mUqpZfZDYkh85q5JSSRhkXEa99tS/Sjg7E4qnRbqN3lzbP7aK1EoaTJEEXK5ap2bO
dYPAE77M/B5pgYgvEDjAu9cjJHF7mxzFKA/Lq9gev+yAcZRSx+QPmIzj/YELJfba6gcdwtVA
/ADPoEVBbgXPNNAVJDj/9WgVSUOnYbcqA0enwtOToI1NJz54B4YwrWmWevyjU/5nwbmVguLa
kjiAyEolWGayqG411ROiHGtXgFo0IjoDhA/QtRCIUhFYTRjEfoJoS/oSFB3J4ws6nBeik8vz
Kc0gIDqdT68uPSHgBMHMFwpAon1HsEAns9NRgtsZ7bsuSp+fjVZ+6Q20JouPd/38dLz22Ria
iWgjIwTXY6N6elLQqhdEV0VM336i8DIpqGTadRN1Rvo1APA77uxifjqXmL4mwCHvRrYTQ5Bb
2gCao8J24Vo9Q857fCPQW2EbhNMaFlmT+yEC0eXlOhmCiuh9A6wKv0RGmhEk/NzWI3PoUNh5
TZLrehjrw/rXufbWebGDNzrTBSc+O7ucnzg27RKuHz5pzutkUZrC2yN1sEXxVOOmZOrPPnBO
D4YALiov6IkFrkuciPOhVYEQTDfnRRjzRXiQn8ZZiK40XWRIEupy1/BCZjB7rSmQUlOpCan6
UrpNwFVxvQYLpbS+8dLEEM3qFzSBJ7Ey4DiLE5Uef5pWZoEinGANGn5n0VsfK6hbn9kCJFFa
XHhiM0IkBxm2m1rxgDZHU0CA76TfatZxRUfrWGNUcrucdH54OOzf9l+Ok9XP1+3hr/Xk6X3L
5VrCh2V1VyW1FflIhVL8RS3qm5Z1chfqkoUEdAkz0oxwAWQJiWfdUcEI/9KWnIqQCMofLqpQ
CqAgSupVvBgaB0Cn7E4MbiKPXbWhwuHT/jInjWYCxr8lC6qmNGJAInjUwCWO4jAgz70kyyD5
R1qaYcQALBryFapDTbiW1ZTzuR6lc9H+mzasVT124JjvwjBHWVZ8ZMroOmm6RUD73a8qYZVH
9GtVDcOtR3YMc355UQWE9xjjh25QaatGCIvIr7Fq2olwGRqnB1j0lV5bsWAMCv4n5yam3VqK
8FYF67Ah0+NGScHXZoLaC0PxLD0m/dOiCG70gKtKiRY2Xb24TjPtMFWoVWDmsMY1HuUVpQbk
53GAntTDMuxvc7geLy9UbtZBYV5WkDLK32/Mvw7qID4ynLJo0qDRAzNnt6R7hxzlilrWAlfr
drlSAwBOmRxSJFGvXBaucVxg3j5O2Pb79uE4abYPX1/23/dPPye7PmKb1+8OnVaBvYDYEvi8
tLDSp1hueL/flt1Ui4GpOkyCwhFN7bFVE9QqMHxXbWpruVmU+SKLR7OqSDJwfcTEXmHb0Pmd
JSFEnJfNupMG0eA9ZvJ9IPher+iUBauiLAGDSSpYnVZBzVmJrFzaa6BqwY8urSJncUStB+x2
A2jpcPgaXq1aOy6/aKdrm1TbjjAocOYMzStFf1ellbYholVd5klfO9O5TMCUzDlxe0QFr6tO
XRzRGPHcZYILrQKZ8cKIlqyAWUUAOUvZlBb4OkR/c8pXXRVTEVbtrnRIH+phNoYsHFz8XTAX
IY534UE88KIKCYI0za0CRctCfhcJWYKYZMwzBSP0bEO07vQ19ji8MehWexpycWtK+iwLivJ2
LF4Va/EAMlbIcI1I5IzYwgSR2O1lVSdLXyQcRbysaAGh705dUo2qyxtiFUWZplHjP8ARLCtL
kSbUIuT1JVyc0WMWoyxlVdLDnIDhGioPbq/O5oaVsYZl6TntTGDRnJ+SlXOUqa7XcFEcJZcn
lGyuEzGIrthFla9/07xinkS2gPdn4tUqAa267qG/YVVakI9U0ff9w7cJ278fqNw+vK5k3YCa
6FxLxoA/O3wH0+c35JeEohziI1H199xAkGZhaeiPq4jiVMAzrw66HIiH85d/b6up20S06e3L
9rB7mCByUt0/bVHrafjCq8BLvyDVbglsSZ4FNKefx4LKGeB6+7w/bl8P+wfKqUdEZ+ebibY7
IAqLSl+f357c6aqrnBlu4QjAY5hSGCGy0K4cAcG4ckt4Q/BjAGBjNSFUdd/opnaIQFwr4O6d
0WJ8IP5gP9+O2+dJ+TKJvu5e/zN5g+ePL3ymhldTEevgmTNaHMz2kTG2KpYBgRZRBg/7+8eH
/bOvIIkXXq+31cfFYbt9e7jnC+Vmf0hvfJX8ilTo5P/Ob30VODhEJi+4RrPdcSuw4fvuOyjx
+0Eiqvr9Qljq5v3+O/987/iQ+P6+KiPhU4Qlbnffdy8/rIqUeJ7ylXTbraNWN2ahSvTBP35r
dQw8mEoxqHojf06We074stc7o5IRYrJDdHTryiJO8qDQ9Hw6UcUFA34dg529KWxrJHDdMn7D
kWL3QAcvayo7IlUNZ53TdWJ/RGyP5/C9gjXRHhFuQUxSFSQ/jg/7F+VG7lQjiLsFC/gtemJX
4oRElOBeTJ6dXdFhfA1CFCmoxxVBROVfGlCz2Tmd2WkgwTRM/vqrpjg/NX2LJaZu5leXM8q1
TBKw/Pz8ZEqUVEb+Yz3jNJFiWv1NIBVYxM10G7qcXxVmmMPU01jR0G7pay5ohGQEJcEvDD/6
l6nhXt7kXisswA1ChllkQyoeOAaTgJ0EZrN93iOjEipdGUHg56GBBo0YMK2e0BPUN5g2wDUa
VAn+6hv9WHLotWngW/faM7Aiz7YU7jPd/UhgwjrKWRPCr0g3TBdYLuz3uaOES8DqjrMnn9/w
CBy6LFXS0htlUCmD4fwyBzDRtTDKu2tIEwSON3ZR/hM8HbrpvMjRuYYaVZ0GKrErQHZBeOd4
imsUqSZ2AgotQqe69gugMn8d/6gEjBI1XsMcGq0jmPo1oAO15mYgAjHG2wN4Xdy/8MPxef+y
O+4PhrZItTdC1s9ioDNXAZM5OAb2TIDG3XDOnB4GL4+H/e5xmH9+SdWlabMuQV2Y8lusBg0F
yWCqqoaCWRoW6zj15T8JKFV2wU8W7QDBn/bjtsqslCSYNlaq61abyfFw/wCBGwiNHGuo3SzW
QGMEu1awUTUOR0t9pg1eNitbr8OhOTNy3Q1tNPRR1BMQ86lCaLnf2yvSq6UWc0NKPBVMnUpu
1zcEpF2+rBVVtKaXN9KNvFQjPl5Q2vQm6RkO/k+KC9TBGgtSVnqMpSKFFAno3m685bC0NBw4
4TccoT7bFpaluahgKMJB4gCJmtqv56wjoSCmBWouiFiuHOpkMOJAwC9xTsWGYI3wyDJRGZ6U
TQ5LJHHYcUZcHFI69xkF0SrpNhBfUpinGG95QZbGQZNwngzefBnZYY7jAqge4IpzE1PDy0UC
utugaWqLg0EEeEzc8g5QC0LRsCRqa7BOMsvPaK8/jjnrTP2ZBP2qsbORxs68rAgir1EnjNYB
w4r7N4yn5i/b1AY8jEKcCP0eTvlwgy8PI4Cc1DQ/7jEg0YMZEc2gabWKySCp/kUC6l3T6g/8
lmqQbn1mwm/asglMUD/wes8BQcaMAERZQLYX29pJw4DyLq3t+jZBTSsZAembweWCTa0VU0YC
RtYVNrUzTgMnnGZuUTXdUzWMw3kIIDBoHS3R7x8LTI6rQqqV7KsWlxLVHWHGlxb/JpE/fLls
BJyewH09JZWyn8oicT+Zee5064P6/QWrzDxUBEQYwXdmMpyUi9EAFllshmOTcyfgmH5nUNCd
SIqovqvMhGgGmF+CS/uTNGwqVij+pltYJ/KIsUH9AaFXLVFhm2ZNysXBdFkE4BBPLhhmJ0WK
bUAqAMK6duhC4Bo+4U4mpx8xYHeCmjnyzVKnjBptQiHa2YKdGeeJgBmgRQvByfVnGSPes7Q2
sbYtH6osuLP2kuDv7h++GimlmDh3dR5HgHA7elLOSIpVyppyWQcUr6honKNegMsQtlWXWTE6
EUk4vCudtui9+JL4L87OfozXMV7tzs3OOZ+ri4sTYzD/LbPUdMn/xMloR8p4oUZVNU43KFRD
Jfu4CJqPyS38WTR0lxZ4vmmKBcbLWXO3XngPwaDpjYvBKrUC986z2eVwHsj6f5oQVSYtQR3N
pdt/Prwfv8w/9EJDs7A7gSDfPYHIeqOLgKOfL2S7t+37437yhRoWvLL1fiPg2sykiTCQyfU9
hEAYB4hqmjZ6JCdERas0i+uksEtAeGMIVytdKHrsdVIXekcsSarJK/MMRwDNT1k0fmZD4Plp
FCdk0sZVu+TnS6j3Q4LwyzVWOcE8w3US6J76fVjeZboEo5DIKiX+Gm4nJWS786XdIikTJqfC
WoVarPxM5Dz1tU6lianWGQe/11PrtxFJT0A8PCsijadBAenotzwMCFv4+JYF+lsoO/G4ID9O
EsFy4XJnXFjfomL8tnGlvZLpbVAaWH6QwvMuv+VKTfMNV7T90+A1C8F+GOavrC1q3ZpA/O6W
elYMDoC87hzWXdeh8WgrydVnpAXyUBAbMgKPWHrkVCGvRiVKqhV9skWpefzAb3H9UI5YiIVc
rJuhZ2K6jJsEqDZJAE+ysP5pd3ykaitIMuLHO3tXRzqcygClTckHPITlqDBa2gjhb/SPbYpf
0sh71yOLx4GPjw/8LP5VRc9mkenbIWPqAvrnw+5tP5+fX/11+kFHq7us43eZsYl13OXskm5K
I7k8N9vtMXM9abmF0URTC+Ov7dJX5uLE+wHzC8r0wSKZ+pq8mI1UTN0aFsm5t8cXXsyVB3M1
u/B080r3PLTK+Mb56szXzvzyzGyHs2qwfLq5p/nTqXeeOerURKErAF3/qT3WCkG682r4mfkl
CnxmHP4agko/p+Mv6PouffVd0Vea/mm0hb1B4ltOPYG1Ma7LdN7VBKw1u58HEb97czMwpEJE
CTgye1oWBFy6auvSnhvE1WXQ0Klie5K7Os0yPXWRwiyDJNOfQHp4neg5ahQ4jSC8XOzSp0Vr
ZrI1vnm8d1yMvbZCEQCqbRa0l1ackSF7ijQSEctNQFfAc3mWfhIZh5UDjyYKl93mRuf+DF2p
MA/ZPrwfdsefrv8R3F86B33HhYPkpoWIdUqlNzwJiawMfCqBsE6LJam6FDqEJFZ19+X57y5e
QWZZkXKKvpiACqX4NBqhUnohcF1h+O7X1KlHWz2iQ1Io69EWDp1GcE+szJz8d4qRh6cZNNUs
+Ne26ART3SFzEwWGOOMQ6a25NSx4FWAeSovvnB8FzQcr25pUVgDrhVH9khoinvRJ6sfQ4Au6
+ufDx7fPu5eP72/bw/P+cfuXSBPfX/dKFB3GXnfQzFj+zwewWnvc//flz5/3z/d/ft/fP77u
Xv58u/+y5R3cPf4Jxt1PsBL//Pz65YNYnNfbw8v2O2Zm3r7AC8+wSLV4EJPdy+64u/+++z8M
7aNpCkBpzT8quubLRs+tjQjUc/H5MB17tZcOQQPR5jUSUn3h6YdC+z+jN8Oxd2HPisKGKdW7
UXT4+XrcTx4giP/+MBGToNkWIjFo7wL9Tc4AT114EsQk0CVl11FarfQlYyHcIivDX00DuqR1
saRgJGHPezod9/Yk8HX+uqpc6ms9DZyqAbTBLim/Bfip4NYr4cYjvkS19IuTWbCX08S7i139
cnE6nedt5iCKNqOBbtfxL2L222bFD2vTLhwxdmw0axmkuVvZMmtVRnbwH1NruXr//H338Ne3
7c/JAy7rJ8ja+VN/rFbTTWYql8h4RfQyiWKPWKjwdTxWKcuJoWrrdTI9Pz+9ctbFgMIPlA/x
wfvx6/bluHu4P24fJ8kLfiXf3JP/7o5fJ8Hb2/5hh6j4/njvbOIoyt2RjHK37RW/i4PpSVVm
d6ezk3NiNIJkmTIrpzlNwf/BirRjLJk6DbHkJl070IQ3zk/KtZrVEI2T4Yp4cz8pjIitEC2o
CK0K2bjbKiL2QhKFDixDVaYJKxchMUAV75m/D7dEe5wTwTwS9nAUK20efCh6fDV8sL6dUvMI
ecCaluIQ1TCAWWNvCHL/9tU3E3kQuYeyANqt3o4OzhoKyQbj3dP27eg2VkezqducAAsLDxpJ
LRaA8/nK+Lk3MmO3KyuykkSEWXCdTEfWmyBgRMsSAxt8ZLnWUXN6EqcL6oMERnbemf4leVF6
V1O/VsAj9+LMwecxBTt376iUb2D0XKNO+zqPrXODorigozoMFNPzkTHjeMMoUx03q+CUmAYA
8/3DElreHah4my6dQ3V+OhVULkeDVVBgXobu2FhTOdFCwznLsHR5nmZZn165F9CmEi0T66bD
NdUVqdxOckNGGALY3f5B4p5oHNY1KXl7sL7isY1TbmTQPRqhVNnUppQUYimPzSuEwOHC/sjN
rSjUvnD2ocKLm46ftMMO8rU20E6JPtplQDxWn+ri3J2MULMjLsEFDR0rFieMgs26JE58ZRb4
NzEULMhYQKbYsNgQL3/imxDOCFeGZb0Jx7vS111Fo42Crxpt8lya3K262ZTkcpZw52HGQnta
MtHdbBPceVswplZs5/3z62H79mbIuP3MLjLhFm5PXfaJsv6TyPkZdZZln0ZWOEeuIqfXn1gT
q37W9y+P++dJ8f78eXsQPmGWYK6OlgIi4FZ1sXRXah0uMWSGM4aIWVEMjMBQ1yhiKF4SEA7w
3xSCXyVgYG6qYzThreOi9Mjrk0WoxOPfIq4LzzObRQciumsGIjQE33efD/eHn5PD/v24eyE4
wCwNyWsA4XXkbghAKB5oSGrlpXHvF/FcvU6QSpwKZAUCNdqGp7TVhF9eM9F9U+NkJJo6ZAHe
s2c1Sz8l/5yejnbVy+UZVY11c0T6GwZsEBJHdjen7lkfu6oVnW0qYHc5eGSnEWpo4SXZXZfb
wxFcyrjA+4bhGd92Ty/3x/fDdvLwdfvwbffyZJipo2UBLCbwhGe9Vpk2HvqNutVnhmkR1Hci
zPlCCa2Zd7eAoVtQdzVEedLtWAJlgNdXy5k5iCSkKRmVCwnn84oIVLc1emboiiKdJEsKD7ZI
GoyFwFzUIi1i/kfNRyhM9Uu0rGMz6xzkoMcMICEd70jo3XWHmd4FJkptO2iFssC4qsF+Isqr
22gljBrqZGFRgNEKJOYRUU2qLNU/uq+DLypMIN0IVb++26MuitLG4Bmi0wuTwpXDeHebtmv0
/eMImSBdqmcUcpMgQZZGSXg3J4oKjI+HRZKg3gSeGPqCgk8k3bTJUETmLy2nCmT2cGTuaD58
uJSPfw5zX8Rlrn36gOIMQm8Da0IhgqIN/wTHR1oIVsSEDgyK6uWnkqwD+YuhTY3+jG6Tcx4E
OYIN+sFW+hMgiDEeyLvlp1Rb2Boi5Igpick+5YEHUXrgZyQceSlnrxFvR2iXuoZ8a3WiW4Yx
VkYp3zb8egnqWo+zB1uPb1rdtUiA0NLd2MwAj/UvKjCKD0b96/hhtWxWFg4QvAp8RrIN1QAX
xHHdNZyhNY4qtknLJjNCKQKxldrZwAH34zdHUt0IkyLifGJNxtRfZmJAtQm40c++rAzNX8Pe
0F6OTav1KPsET4Pa/NQ3cDNr9eZVagSUBH8yCB3CLwBNEkDGQM37OmaluxqWSQNBestFrE+v
XgaD+BqxCBYlyFOu2RrASbtUoJ//mFs1zH/oZy0Df8Ays6YbFk8FLmvGQ1SPaoVHTrfIID6+
6R/SE+F7Zx5ZGHzO2wR6DBMExUmlJ19mfI0ZyxkegYulfsL1/INz/Ztvj4o5QejrYfdy/Dbh
Es7k8Xn79uQ+myNrcY2jb92/AAZjLvrpR2Tf4lfmMuOcRNY/cF16KW5asHk+69eWCELp1tBT
hGAgKTsSJyIA57Bt7ooAAvCObCydwglQpfFukCKS0yV1zQvQrvpQA/+fs0xhyRJ9Nrwj3MvA
u+/bv467Z8ndvSHpg4Af3PkQbYHjkH7YKhjffXEbmRHsNKw6kxM6xrdGyTgfQ9sYaETxJqgX
NHewjEPwBkoreivWfCDR++ef6cnZXBtsvqwrfuKDcyhpr1tzKREfEQM9o/IqAZdsJiLK6QeU
6CwTnjFgD5wHRlYTG4N9Ap+lO2s/Khc7w8tEJrMr6yiRJpwifrc+/789w0ZwGrlb4+3n9ydM
Wp6+vB0P78/bl6OejyJYpmhsXt9oZ/IA7N/5kwJTLp/8OKWo7JxnLg5ey9oEAll8+GB9PHOX
Wm/26rP07MngRRgpc3Cz9O6svkLT7AHvFTxFr/ly0/sBv4nahgM7ZEHBedcibbg824kl05dG
rM8KRrQXMWkeZkUKGp0386OEUba9mMBkXclx0gyjr0w7lOFgTG6bpGBWBllRC+CRHyC+AsuW
myIxvPEQWpUpRHv0KGyGqvkupKPwCpK65Bsl8L2t95MgiDe3bvc3lLtZL781YI5s9B0ho9GX
RL3CmWeMgmUBtXBw5uW0cTYg43vd7bXCeJexOEhaZiWnY5xfiCUy4fIvOvr9euDWeVct0XTL
7cqaelQlinlqTuumNbMMGghv3SIACZoa2ev6GlhY4Pht1koycEyjkCeqwe/YtVA02v4MmJ5z
2ULAK6/JLEcRfr7Auqo6gQU/EeC5inI4OLgIYEljWMeYVdWwnZ3Ft7KiUotnaKCflPvXtz8n
2f7h2/uruEBW9y9POp8G+RLAwKs0HCwNMFxibfLPqYlExrvVgoSDmqOF/dTw3aILaKxcNF4k
cGNVwC92nQxb+B0au2tgKmg1hQGV9EntKYRrLHwH30V5RdJoHe6HfeiORljZiSd+SSz7fqLP
JzTWrSA+bxMw2rxxc8O5Dc5zxCXlvYaplEUrunPf+GoQJrCcy3h8xxxS7s0hDhvL2VEATZ4S
Yejbot9zVN3mFoVZuE6SSugThT4SbGiGK/GPt9fdC9jV8E94fj9uf2z5P7bHh7///lvPJVKq
HF1LFHRcOa+qIf4/4RrcU2Ad8A3eEwu0BG2T3OraULkZZTxE54Luye1LayNw/A4pN2Bk6m90
www3MwHFzlrnEnpRJZXbmER4m1DZR7LEVxoGFd9yRtIkYJf4ngHvZSsl9vC1ugTar52FUYyS
D1ksqt8EaaM5JykZ9n9YMgaf3tRGlDRk5/mgQsa2JIn5KhfKQeL2FsyB5/j9Jvi6x/vj/QQY
ugdQxztSmfQSNvkl23VYLi9qzwuUMAkX2YyGowrYl6JDxoqLqnVbub7+xhHh6bHdj4gLjAnE
4M5cH+w6aqkjhF4QnLiDCFUU3CrRdwFwnJXUytGOkFBFTfurAy65Ye4KMjtvjjA/eQX7UA/i
minK49LkDDbEyyMzQwWc947ujKjL+JI5LEI3zQ9kf0eUYS/PzzCVKfcX2GUdVCuaRukyFtb6
J5DdJm1WoKVjv0EWpzVcZKDm+R3yoHZqlegcA+nwZuEpxyIBb2nYo0jJZZCicSqB1+s7CxjJ
2kTVA1I0GJmHN2rLRLL4AYhBEJHeeP3ifzUw9yIFqjPgWlVSLGUbnQ116lOSi12RJHQXij2L
wHqg+nOoetB2mmuHVmGhbDFCwPlOzpAtRutAHsElUDOy4Vti+MK+WJ6npbN3h87LnSIWAC2Y
iTo7VgSVJ01byM90Pk8yq41SEuh8AsLl6xsEJMcCHv/gnpyvSIpQNZoBe7IGnyQ1W4MCgdcR
JmPhv9ldwbfLCAGErOjT2lHsIQ6cWMAi9IvegWEnjT4b6Cu5pxuObtUGl7ZA7rJzN6nJawJ+
ulcjx7fWyv9E3Ee1wrUfJ1lDJjWp6iTJ+XWI+i4IJ2JfM8AopnHSlasoPZ1dneGTCgip1EtK
AJFd9dAKCDCzPA3TKJDaZFAdNKiEvlqLc6YjxfOWjZOsiQNfbfgCTYJrnGi31CJdGF6IEi4j
Pmcpnc1EUolfpru7ajaN64A2nZAUVRovaA2zJGBJBKroMRLM2ThG0EKuyxH8egHZjWCL5jGY
K9ART9X0GsEQPUqkvuJR9IhMp1N0N23S0joYDI6YSp2nqcsXvn+SxmHYfswvSIYN1xbfH4ss
WDL3urHwRZ4SKQqDOrtTjy0t04N8zS86+e6BF5UevF8v5akrDpeeAhhO7zY2vSykkJmF+Nbm
U9X1tw4lN0KHRb7EmjSOGG7FUh4oJ7dz2iZco0ioUBk9vnXep3oUXFf+NyV84gKtg2nEXwXe
sDeioGKYrIHDufUbhIihQZW7yRaLJCogVXrbbYuNiCTKOWvjMlRw8eiDh5W9syXPbq5f/dmy
2b4dQRAEVUcEsbnvn7aaa29raBxFdD+VmEPXzfVh/4j+C2RyK48f6w4RWORSPcKyEtvgnbCs
h3hsw8Fc5TSR4U6N+UxpOuohzYz9ZlzPQZp51NmAEop8S99gVac78epF8+A6Uc7TdpPIEAmN
oq/lBSgOzHJms+rVZ0wJfh2Va0dFyzi7Vq7VTat9mEkNv+SbGD6JBjW8e5hLBUjgObFuczS4
zii1t6DijEfA7+EObSNPfpyd8P80joYLJ8i788EC5sabcI+f6O5RZLrc0tvA8csVT/z/D2Vt
kLmTqAEA

--45Z9DzgjV8m4Oswq--
