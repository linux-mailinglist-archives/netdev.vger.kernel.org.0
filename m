Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D533C1F89
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 08:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhGIGrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 02:47:14 -0400
Received: from mout.gmx.net ([212.227.17.21]:46219 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231142AbhGIGrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 02:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1625813029;
        bh=vVAyzRrCSPuou7O8fmRuvcyN2SCr1akeu8W447VEfas=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=fr5BxgNYHXy8VM1OG43PPmyNVp/5Md7QYnwor0mUWd1HOEC0/FYGXAjLVXEd5pOiJ
         UZ890ILtyzWhAyhR2gcHucpaVnCBXwngmVXQyReH2TF72VXiwfS47uZP7rMBPvd9WI
         gbyoQF7VIFHVu7I79d7oxfr9oFWxs8Zp1qd3oNLo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.158.163]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M4s0t-1lzpMR3Nqh-001vwS; Fri, 09
 Jul 2021 08:43:48 +0200
Subject: Re: [PATCH] drivers: Follow the indentation coding standard on
 printks
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>, gregkh@linuxfoundation.org,
        Carlos Bilbao <bilbao@vt.edu>
Cc:     davem@davemloft.net, kuba@kernel.org,
        James.Bottomley@hansenpartnership.com, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <2784471.e9J7NaK4W3@iron-maiden>
 <2148456.iZASKD2KPV@daneel.sf-tec.de>
From:   Helge Deller <deller@gmx.de>
Message-ID: <6ce9de29-2669-deb5-ea0e-895992240bea@gmx.de>
Date:   Fri, 9 Jul 2021 08:43:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2148456.iZASKD2KPV@daneel.sf-tec.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7dPUIMjRp2C2rFEX5BSD+HwTJsQVb/TG2TFwrk7tXcNW5j19Qlm
 bJWbeMS5Lro/lPgpvcSEiUeDr7PrJAL6WMwn+zlgl5kinZ8rQq8Qb7yTZf7pC5mM+uT8GFL
 9woMuMqFfHIbBdRR47bPnO8g0U5t9VbAAU99Dm3DJ60DGabCQ9mcVr2Gi7OXZZEfnQLToAB
 ykwOZ1lbGsa0Z0knrflbA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:p2WCvwaIHB4=:kscVqtEG5RSPR7HjGOMCzr
 nhDBZT/vlA7xBPJ6/AEhg1p3uwSv8Gq8t/81aojwv1Dy+iSYaS7yNecE4KE0hFtsn1k3g32QA
 Zld9i8am6s7/tabMQSvJUpb9xoNc9NNpT5P+GYlqw90gfQ6GjCQkbtoXx++R64oHAKWVd4dTY
 60ACFPSsBtY8Ta3dPaJsRmRfaa8POQeiUtWaTARpblq03aXVX2Z+fw+w3R7Ej3p3UlB8KT8IX
 T84aHD1m8xd4bG5sQjStS3KfYF+WPtTDpu7PUFqxoXDNfndjRBgCvhW/+bDiBSWzCtqQlFT7x
 EODpV6WAAKqi2p7+32+RIE9ytRxZ/ji+Fl6ERthzFEYBQP7v2IPktJgkZ0YyGE8FYphqx8GAN
 joqdc1LP9gwQ9OLo2MiKB8i7KH7tzIb+gRTufz+69xihngcznokbqIGUxhKHmV0nkoWPyI9Jn
 esq/M9kqtYaP08BNV9MmP3HE4O5iF/4b9oJxbgW3OLclDBUoJlV8WGZLnoJKexWVM4FbPlCZ2
 N5GV19nqnG8IZesh+ec64m/X0UWfJrARLLlB9m/2NuyVnZF4MA8okQZzu4awD84hLZAVfuVlJ
 bIGPN5FJCqzSqjQEWu52G/yg3ks5sxn+pGgd9mngmNtv5/HXtZ2M+ptTraE3slylmMyd1GdJE
 zLBO0yDijnmmAQD9Dbo2XTK7jdA1c6x8S5SYzvNVXX/Kq8md2QV7S6r3v7Ezm31wRm1qpw0zg
 OyjEXitZ9mxZ+FyyBnJ4uZhbByC3OAFVE2d/TwFcDc1dRXKznmOgeOQjUIMDiN3zZkyoVFGtQ
 ldqZgzh4pHq+nyzpTsiv695LjcWSAZeXnRb52Cj0dQ7Ze9utyHo+3ZtuYrtjtOcb9ETiwaAJs
 7d5ml85Xq0yI2MmpI55q/+86ftUirzf1NDU0GIahDsGHhDkS6PMIdjLW9ZvnsoKSO59EdtOEa
 XQP09S8NhxCswgXqTBDVsVLQdtPLxrHyXMzw/U56EjBw/1lCYV08i9Mxbz5bWFkpiukc8znJj
 mTG59tJC17DKkkDm5xAwIx1vvsV1+5tAYK/byxADjb/ErAs4RlPNtN42i6vhh8VoIKwyhx2gQ
 p+GGJGTlkbb7XkSrk2DR1V1/BObvg2zWwN7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/21 11:25 PM, Rolf Eike Beer wrote:
> Am Donnerstag, 8. Juli 2021, 15:10:01 CEST schrieb Carlos Bilbao:
>> Fix indentation of printks that start at the beginning of the line. Cha=
nge
>> this for the right number of space characters, or tabs if the file uses
>> them.
> [...]
>> --- a/drivers/parisc/iosapic.c
>> +++ b/drivers/parisc/iosapic.c
>> @@ -633,7 +633,7 @@ static void iosapic_unmask_irq(struct irq_data *d)
>>   	printk("\n");
>>   }
>>
>> -printk("iosapic_enable_irq(): sel ");
>> +	printk("iosapic_enable_irq(): sel ");
>>   {
>>   	struct iosapic_info *isp =3D vi->iosapic;
>>
>> @@ -642,7 +642,7 @@ printk("iosapic_enable_irq(): sel ");
>>   		printk(" %x", d1);
>>   	}
>>   }
>> -printk("\n");
>> +	printk("\n");
>>   #endif
>>
>>   	/*
>
> This is also debug code. It is basically unchanged since it has been imp=
orted
> into git. So it may be time to remove the whole block. Helge?

I'd prefer to clean it proper up and keep it.


>> diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
>> index dce4cdf786cd..c3381facdfc5 100644
>> --- a/drivers/parisc/sba_iommu.c
>> +++ b/drivers/parisc/sba_iommu.c
>> @@ -1550,7 +1550,7 @@ static void sba_hw_init(struct sba_device *sba_de=
v)
>>
>>
>>   #if 0
>> -printk("sba_hw_init(): mem_boot 0x%x 0x%x 0x%x 0x%x\n",
>> PAGE0->mem_boot.hpa,
>> +	printk("sba_hw_init(): mem_boot 0x%x 0x%x 0x%x
>> 0x%x\n", PAGE0->mem_boot.hpa, PAGE0->mem_boot.spa, PAGE0->mem_boot.pad,
>> PAGE0->mem_boot.cl_class);
>>
>>   	/*
>
> This is equally old. It should be either also removed, also this seems a=
t
> least worth as documentation. Maybe just switch it to pr_debug() or
> dev_debug() while fixing the indentation.

Yes, I'll clean it up too.

@Carlos:
Instead of just removing or fixing the indentation, I'll fix it for both p=
arisc
drivers. Unless you want to try...

Helge
