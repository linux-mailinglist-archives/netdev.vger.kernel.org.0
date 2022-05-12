Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0295243AF
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 05:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243418AbiELDrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 23:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345436AbiELDr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 23:47:29 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D618D80A7
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 20:47:06 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220512034701epoutp044df8f4f7c6362d209ba654803dcdaab7~uPtp2XLZD1222612226epoutp04k
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 03:47:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220512034701epoutp044df8f4f7c6362d209ba654803dcdaab7~uPtp2XLZD1222612226epoutp04k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652327221;
        bh=GirDdQEslfbySicVoQGet6fAqxxqlgyh1Y0KbsS0OHc=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=mFQ1cHXMghMiq5wdXiOOrtgZdKHnfIM19AOKZK3/WWMwEe/t1ehXaMEVzaygKpc2I
         lVrqoaBiWEKS+wDk0xobzmWtqc1udRVZNHx83mmL/5eWweGgQbOpaD78h78zaKfW7n
         XOvVt5jZoq9j1hGDntH86nNBT2lqdig8diRN3XO8=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220512034700epcas5p3377189b67258e82c3d3222ef5aaede3d~uPto-yY8U1006110061epcas5p3W;
        Thu, 12 May 2022 03:47:00 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-1a-627c8334f8b4
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AA.30.09827.4338C726; Thu, 12 May 2022 12:47:00 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH 1/2] kallsyms: add kallsyms_show_value definition in all
 cases
Reply-To: maninder1.s@samsung.com
Sender: Maninder Singh <maninder1.s@samsung.com>
From:   Maninder Singh <maninder1.s@samsung.com>
To:     Kees Cook <keescook@chromium.org>
CC:     "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "avimalin@gmail.com" <avimalin@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vaneet Narang <v.narang@samsung.com>,
        Onkarnath <onkarnath.1@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <202205111525.92B1C597@keescook>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220512034650epcms5p3c0b90af240d837491fff020497f389e5@epcms5p3>
Date:   Thu, 12 May 2022 09:16:50 +0530
X-CMS-MailID: 20220512034650epcms5p3c0b90af240d837491fff020497f389e5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOJsWRmVeSWpSXmKPExsWy7bCmlq5Jc02Swd9pfBZz1q9hs/j+ezaz
        RW/TdCaL3S9us1h8+Xmb3eLBwevsFosXfmO2mHO+hcWiaccKJosXH54wWpzpzrV4vq+XyeLy
        rjlsFo9nzWOzuDHhKaPF4uVqFqun/GW3OLZAzGJFzwdWi/+Pv7Ja7Ot4ADR24yI2i5+HzzBb
        HDo5l9HixZIZjA6SHrMbLrJ4bFl5k8ljYvM7do+ds+6ye7Tsu8XusXjPSyaPrhuXmD02repk
        8zgx4zeLx4RFBxg95p0M9LjQle3Rt2UVo8f6LVdZPD5vkgvgj+KySUnNySxLLdK3S+DK2Nxx
        k7VgNk9F76YDjA2MUzm7GDk5JARMJF49a2LtYuTiEBLYzSix4c1Oli5GDg5eAUGJvzuEQWqE
        BUIkLn1bzQRiCwkoSlyYsYYRpERYwEDi11YNkDCbgJ7Eql17WEBsEQFVie+XmplBRjILzOSU
        WHt2HSPELl6JGe1PWSBsaYnty7eCxTkFdCXunn/NDBEXlbi5+i07jP3+2HyoXhGJ1ntnoWoE
        JR783A0Vl5FYvbkXama1xNPX59hAFksItDBK7NsNU2QusX7JKrChvAK+EnenbANrYAG69PDN
        SVA1LhKzf9xnA7GZBeQltr+dwwzyJLOApsT6XfoQJbISU0+tY4Io4ZPo/f2ECeavHfNgbFWJ
        lpsbWGF+/PzxI9RtHhI/H/9ghoTzSkaJo93bWSYwKsxCBPUsJJtnIWxewMi8ilEytaA4Nz21
        2LTAKC+1XK84Mbe4NC9dLzk/dxMjOO1qee1gfPjgg94hRiYOxkOMEhzMSiK8+/sqkoR4UxIr
        q1KL8uOLSnNSiw8xSnOwKInznk7fkCgkkJ5YkpqdmlqQWgSTZeLglGpgqsl6d79lbom+SfV9
        jk+l7Yf/T720507t3e+//jNPCe5++jD1Tm7sN8OAtDovvSXH/jyouOTseXdP0hPxBqNzCbaL
        NV5PeHvQMO92Ivtyl/frbuZV9UQ26l+/Hzutjyf/wezTcnNe/997XfmXiIvvkx+TBU9MyAo5
        bxL2wK5qe+Vzu4Xn2dm+tOxuYGk6Uh9wpT5we7ZJ9C/5DJe/U6e4ZWjmJM6tPnnlquiH7IjM
        NtXFFXmTl36Z/PvmXIUvKnvs1UzqS16tX/I10jLU6KtL+dqXx3dYznwzd6JEU9Di2zKnnApr
        N838s4Vh3a07Af8VpqnkLH01U2PZnht8q9hUL08RP1Bzmqd0em1AaZrzYgklluKMREMt5qLi
        RAC3vJP+KgQAAA==
X-CMS-RootMailID: 20220511080722epcas5p459493d02ff662a7c75590e44a11e34a6
References: <202205111525.92B1C597@keescook>
        <20220511080657.3996053-1-maninder1.s@samsung.com>
        <CGME20220511080722epcas5p459493d02ff662a7c75590e44a11e34a6@epcms5p3>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> On Wed, May 11, 2022 at 01:36:56PM +0530, Maninder Singh wrote:
> > kallsyms_show_value return false if KALLSYMS is disabled,
> > but its usage is done by module.c also.
> > Thus when KALLSYMS is disabled, system will not print module
> > load address:
> 
> Eek, I hadn't see the other changes this depends on. I think those
> changes need to be reworked first. Notably in the other patch, this is
> no good:
> 
>         /* address belongs to module */
>         if (add_offset)
>                 len = sprintf(buf, "0x%p+0x%lx", base, offset);
>         else
>                 len = sprintf(buf, "0x%lx", value);
> 
> This is printing raw kernel addresses with no hashing, as far as I can
> tell. That's not okay at all.
>

yes same was suggested by Petr also, because earlier we were printing base address also as raw address.

https://lkml.org/lkml/2022/2/28/847

but then modified approach to print base address as hash when we are going to show offset of module address,
but when we print complete address then we thought of keeping it same as it was:

original:
 [12.487424] ps 0xffff800000eb008c
with patch:
 [9.624152] ps 0xffff800001bd008c [crash]

But if its has to be hashed, will fix that also.

> Once that other patch gets fixed, this one then can be revisited.
> 

I will check detailed comments on that also

> And just on naming: "kallsyms_tiny" is a weird name: it's just "ksyms"
> -- there's no "all".  :)

Ok :)

Will name it as knosyms.c (if it seems ok).



Thanks,
Maninder Singh
