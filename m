Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC36138164
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 13:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgAKM6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 07:58:35 -0500
Received: from mout.gmx.net ([212.227.15.15]:39405 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbgAKM6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jan 2020 07:58:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578747511;
        bh=DrspG8lK34XC2suHbu9XSvnMF41AEeS7UiK8uD2zcz4=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=AfNjADByzKZFaHzAk+6wWiJcgEmuUErN2mhxE51CI1G/xBTs6blvOIjd93jBTp5Qh
         Gh3CjKUKL/1atTjw3QmQ6yFiur0d/y+Q0tL9pBr6/feAKEmtTzPtKBKvsUrWUt7DMv
         M0tqbxf7nb/jTLnsuwXxVQwurnl1CyDf3emsmzgA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([46.59.197.184]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N1wq3-1jnDod3LqL-012JNR; Sat, 11
 Jan 2020 13:58:31 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
References: <20200110125305.GB25745@shell.armlinux.org.uk>
 <b4b94498-5011-1e89-db54-04916f8ef846@gmx.net>
 <20200110150955.GE25745@shell.armlinux.org.uk>
 <e9a99276-c09d-fa8d-a280-fca2abac6602@gmx.net>
 <20200110163235.GG25745@shell.armlinux.org.uk>
 <717229a4-f7f6-837d-3d58-756b516a8605@gmx.net>
 <20200110170836.GI25745@shell.armlinux.org.uk>
 <12956566-4aa3-2c5d-be1a-8612edab3b3d@gmx.net>
 <20200110173851.GJ25745@shell.armlinux.org.uk>
 <e18b0fb9-0c6d-ed5e-3a20-dc29e9cc048e@gmx.net>
 <20200110192318.GN19739@lunn.ch>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <53634c00-0fdc-a084-10b2-bfe64dd5181a@gmx.net>
Date:   Sat, 11 Jan 2020 12:58:29 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <20200110192318.GN19739@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:IWiG/Joo+7sJmoLCY1+sSY3JesyH8dOk76YX44OMcwGX0p6hHEQ
 zIszvKqrD879amu3SfM4T4HGXzSUzHLjpbhYq6EJDrFT4cU/UPhI8s4TlmO7pQXSQPHtCRe
 8XkQlp9i7Nxolc7nQn43glx4xzFuTmYX/TTy5abxdEBq1hxRRKOOoEQ7/Vmx7Rd8AAMz2CF
 GMjOyrZtHchrmBZnzsUuQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QJqCp7ekaQY=:8UIrVS/Akl6o95mIiYS961
 MQ9d4sKmHEvvSa7+OQrgvNf6iJJ7QMobHVb+XCKYPcCA0Yf1kr5Vrlse+MJRdsDQcmURKUk7g
 aulEik8RvA50JzNdAoRhw5NKEdJVfcOLEz5GCk/EdomDQLMaxieFsg271eHvO6TbkYNfnDUkD
 hF/p0qkys6T66Y7A9UGoJPQ9hGix3jGSZ7AgSgd2ASbAWpR2yVUQUbODk+tX6nIeYqevnq+6+
 FPCC11sMNSwYHq6qxE6RQZDMOD1H4Ik0n35HOxw0wIaAurRaLp6h6SAjcl1wQ4H0R4aGUMRsK
 SE+2IgwjNRqVahnk/2z9MoSZfXsO9F0JSPndmGEKBNMuyiTIxaS3YcLtrPe/1eN6hvO9AcV3J
 WtwSOTGeM7mpQoN1wlMM4yd0USf1on34M3TyPgzKit1b3g2FZoWcXbP/hz8Dx6navy28zhY3W
 3Ob0xZrLErBXOeXSexEuIhv5WSLpvsCGBpjBO1NuwQi6VwgmFDNf64yr2jKoW4tol0foLZ+d7
 o6NolUBmBKlP4lZJTpA0zuecXBUXaIKOotj2Nns/FPRGQreL1giB8nanXatmrVnyzpT0V8fMH
 wXN28yLpsaSxYvz8XFw2ff/AD1kzkqPAJ8jdzee8R5dNbuEuL45CcCuYo529xLgra0mo60/DB
 ZMcZgy8CUqskVvF5PvCVqGcMJ5KE6KO5UIABJEPob+2VM/8d+kYhtzJ5l3OaQ/xhRTvHfp2tZ
 3Fwi2cUg9+2Yh2zmIl9M3uH32HXXtCf7ZgagwvzswXELEUdeLY1aJDkUEK+J6+M3QEo9Z0ElS
 ADFJuD71Cz7oK2S3lfzs06vAaUU7Ho+OP8puI3nSia2WfE4mY29A/A5XluM1KfSzm3+4Qrsgi
 BWNW8aX6i0McyUHPBoFJyhzQTMqymiEiKSB6tdrWVo74FS6ii7vccMfVLsTRO2MDGnSnwSfZV
 oesrQ8iYs9GWpOe4F4T8HVXsoWc4K3rYAejGWtjm69IXG8gex71w0v7dRpqWbP5i6pPUa0Opw
 /aE+ScB7H8HxrWAZMGaR+rzUlLMMoDqiNfx7IUmyfFmFoReeujTh/F9CVX6sx5Mb4nbs2jCbw
 /fmTEN+uuFtvf6ny0oURN+6AKJdYXRQO0TG5EmcCeA9YeeOzyAtVsB/PCzgSkllqylgHNFHel
 qBnNWRo8ZnuICWaP0wpS34Q248+UEiLBlOZc3tHHfrtszqFfOl1z0A6+eQS5UbAJgj0eb3Wko
 6X6/88Cz6GvvlymSP0EhKDSJSeP+GcQjzZPvzbQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2020 19:23, Andrew Lunn wrote:
>> If really necessary I could ask the TOS developers to assist, not sure
>> whether they would oblidge. Their Master branch build bot compiles twic=
e a
>> day.
>> Would it just involve setting a kernel debug flag or something more
>> elaborate?
> You could ask them to build a kernel with dynamic debug enabled
>
> https://www.kernel.org/doc/html/latest/admin-guide/dynamic-debug-howto.h=
tml
>
> You can then turn on debugging in a flexible way. And it will be
> useful for more than just you.
>
>      Andrew

I have put in the request and will see how it goes, if positive I would
probably need a bit of guidance of how to leverage it.

Meantime, assuming for a moment that:

- the issue is not caused by SFP.C (emphasising that I reckon it is
indeed not)
- the is not caused by the module either (which I am not certain of)

, and considering that /sys/kernel/debug/gpio is not mounted on a block
device,

I was wondering whether the I2C bus could potentially get chocked of
sorts and thus preventing the module to propagate the change in tx-fault
signal state in a timely fashion (300 ms) to the kernel, thus being the
actual culprit?
