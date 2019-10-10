Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A630D290C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733122AbfJJMLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:11:42 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.25]:24667 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbfJJMLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:11:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1570709500;
        s=strato-dkim-0002; d=pixelbox.red;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=KEaidVFzsFjQNb7feHdS5ADsbTK7f8S9yT1qJ0c4N60=;
        b=k77HUlO4BUfXALhPoTFYeDX3P6Pm35+++uFztc5ZsLKgoeh8ueKE2j6S3+K3T41/6v
        +72AESBLexZ0QEjKZ+7tXgS+pdetHQQoQl3nYcReLO+6L/ila9Zo4xkpnEvFdznKUa+k
        RksI90Nf7PhenHsDNIANav+i9DnTtxB7vA7e6G8wRmPzKuskZJYbfC9RTal9ESapaXco
        7tJ+AjdZlUg1Kw2TxPrN2ihI6bP9U2jDwDZjtsWnEYZHERSVzHyKqYLk5+gef8t8I2QH
        Gj2z3DNN0/RplbsDSeNzi8NuPY0FHd7YRuNc/F1rA7w9IY2XnNSn0x6+9MdSVv6OWMi/
        FAew==
X-RZG-AUTH: ":PGkAZ0+Ia/aHbZh+i/9QzqYeH5BDcTFH98iPnCvV+7P5vDkn1QYVmmALvzR3jit8G7LSXnCfFqUg7eaiCKBPHNl1EbvcYsaRHDltXw=="
X-RZG-CLASS-ID: mo00
Received: from [IPv6:2003:c7:871e:f300:44b4:9ee9:b8f5:3369]
        by smtp.strato.de (RZmta 44.28.0 AUTH)
        with ESMTPSA id d0520cv9ACBcp9C
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 10 Oct 2019 14:11:38 +0200 (CEST)
Subject: Re: [PATCH net-next] net: usb: ax88179_178a: write mac to hardware in
 get_mac_addr
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        netdev@vger.kernel.org
Cc:     pfink@christ-es.de, davem@davemloft.net
References: <1570630549-23976-1-git-send-email-pedro@pixelbox.red>
 <b5250213-7751-a3be-46fa-cfbdf28ccd1e@cogentembedded.com>
From:   Peter Fink <pedro@pixelbox.red>
Message-ID: <10918f81-ba99-9031-014d-4d3d7d0a9c0b@pixelbox.red>
Date:   Thu, 10 Oct 2019 14:11:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <b5250213-7751-a3be-46fa-cfbdf28ccd1e@cogentembedded.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sergei,

thanks for the hint. Will correct it and send a v2.

Best regards, Peter


Am 10.10.19 um 12:38 schrieb Sergei Shtylyov:
> Hello!
>
> On 09.10.2019 17:15, Peter Fink wrote:
>
>> From: Peter Fink <pfink@christ-es.de>
>>
>> When the MAC address is supplied via device tree or a random
>> MAC is generated it has to be written to the asix chip in
>> order to receive any data.
>>
>> In the previous commit (9fb137a) this line was omitted
>
>    It's not how you should cite the commit, here's how:
>
> <12-digit SHA1> ("<commit-summary>")
>
>> because it seemed to work perfectly fine without it.
>> But it was simply not detected because the chip keeps the mac
>> stored even beyond a reset and it was tested on a hardware
>> with an integrated UPS where the asix chip was permanently
>> powered on even throughout power cycles.
>>
>> Signed-off-by: Peter Fink <pfink@christ-es.de>
> [...]
>
> MBR, Sergei
>

