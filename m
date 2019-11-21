Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD72105078
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfKUKZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:25:01 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:47537 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKUKZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 05:25:01 -0500
Received: from [192.168.1.155] ([95.115.120.75]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MY6TD-1iLpOi45hV-00YNz8; Thu, 21 Nov 2019 11:23:58 +0100
Subject: Re: [Cocci] [PATCH] net: Zeroing the structure ethtool_wolinfo in
 ethtool_get_wol()
To:     Joe Perches <joe@perches.com>, zhanglin <zhang.lin16@zte.com.cn>,
        davem@davemloft.net, cocci <cocci@systeme.lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mkubecek@suse.cz, jakub.kicinski@netronome.com, ast@kernel.org,
        jiang.xuexin@zte.com.cn, f.fainelli@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        lirongqing@baidu.com, maxime.chevallier@bootlin.com,
        vivien.didelot@gmail.com, dan.carpenter@oracle.com,
        wang.yi59@zte.com.cn, hawk@kernel.org, arnd@arndb.de,
        jiri@mellanox.com, xue.zhihong@zte.com.cn,
        natechancellor@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linyunsheng@huawei.com,
        pablo@netfilter.org, bpf@vger.kernel.org
References: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn>
 <c790578751dd69fb1080b355f5847c9ea5fb0e15.camel@perches.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <bc150c6a-6d3e-ff01-e40e-840e8a385bda@metux.net>
Date:   Thu, 21 Nov 2019 11:23:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c790578751dd69fb1080b355f5847c9ea5fb0e15.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: tl
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:y/h5sb/786gqDEWE6z9CgDPlnpwNX3Gqz3Dd/ECnTJtWNM9dchd
 wYzIcJa2BskCfye2WvWuQJYxPD1WSdzRujKS5IMCH2W4row9fRyWflQacup7BdSwS5mdQ5z
 f7k0w7vMQ2IZDeSZ7WCd4Cq9+uNiSVBhSVNkecGzAcW1I9bgrLzfYmDWl3qQ+ROFL39bUB8
 1TQmJNqn0xBYKWY1I2q6Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TMnK+eKxlyc=:WkOGlPj1Fg6eBOPiIJmS8g
 H5AYFdqQAPJKBXp/5cbtKH1sHvPNyiEttn+BXhtZwmhOTqYOoKdvenJCgBHXOhqwM6UvNjtkT
 f4fPVaBWeZr1dKpf8rRzlOJ+Zys6m6eJKEuM0FGicf+BqtHVymDlw4gzRtdrGlwLPccdZyrE1
 bPqS+hDCUTc/aSJYnsRnpeboym6JtWFCq+JchgSMY9I1BL6WjMwfU9NAYph8VqIiheeSB455q
 CJXvVnnWiyIbCMbIhf375LbolBLaC96r4dLFSLo+Tbvb8zrERNAfNq3dRM08VR6eOsYeFtGNN
 rQqMJTOzLhYYSZfgS/tUEt0U+RzCs5X5uwr735yWmmGxUtAMAPs5KtfwRnJOCPJg0z+xdWffP
 SFU/mhpwkZwqf62DuYUBDeHwJ0HdPMTjMM9yJMLwFTIf5wm6E44otJv1dg1kXXCuLYswLw9Ke
 D3VT6XmY1vOG2BiOKtRu6M8FzNB/IUJ1mOQ//uklrRo9moo9GS/nsUoDMz5++yKW/6JMhxSbU
 iJzK7IjQoZLyamOLi0MSqBEiBC1DYULfyh7gZDOehbAXGqctAt70v8Z8gtYaM0ODazzlIoxaa
 sk2czPrncKN8YZ15m9yQU4nTNHJIjulGqCYYATpZJvjHO4V2FLct8G1ItfvTLFhERCFJ9yIff
 GHSB42xLUpUJJOvfjU11LmYVjzP0LLiyNZUIaZsN/W0/LHcuRukMlkTAazibh+LiMb//oCHdI
 HsJcK8QhmKEOjfLkUrtdPeD4Zr5P9LsQE335ammcn3tY4P5sKlss9Ne/NR6poZVa7SVFLj925
 XwHQy3EajV/A48x79Wcw5CeApItN+ft9/bW7yicNBVrhi6ez4vvSzTv29+gF93aawaUmt7Ny6
 fSZhgNBkr0RzK27UmZiA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.10.19 21:40, Joe Perches wrote:
> On Sat, 2019-10-26 at 15:54 +0800, zhanglin wrote:
>> memset() the structure ethtool_wolinfo that has padded bytes
>> but the padded bytes have not been zeroed out.
> []
>> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> []
>> @@ -1471,11 +1471,13 @@ static int ethtool_reset(struct net_device *dev, char __user *useraddr)
>>  
>>  static int ethtool_get_wol(struct net_device *dev, char __user *useraddr)
>>  {
>> -	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
>> +	struct ethtool_wolinfo wol;
>>  
>>  	if (!dev->ethtool_ops->get_wol)
>>  		return -EOPNOTSUPP;
>>  
>> +	memset(&wol, 0, sizeof(struct ethtool_wolinfo));
>> +	wol.cmd = ETHTOOL_GWOL;
>>  	dev->ethtool_ops->get_wol(dev, &wol);
>>  
>>  	if (copy_to_user(useraddr, &wol, sizeof(wol)))
> 
> It seems likely there are more of these.
> 
> Is there any way for coccinelle to find them?

Just curios: is static struct initialization (on stack) something that
should be avoided ? I've been under the impression that static
initialization allows thinner code and gives the compiler better chance
for optimizations.


--mtx

---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
