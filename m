Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6935761867
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 01:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbfGGXUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 19:20:21 -0400
Received: from avasout07.plus.net ([84.93.230.235]:55038 "EHLO
        avasout07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfGGXUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 19:20:21 -0400
Received: from Ultrabook1 ([81.174.172.105])
        by smtp with ESMTPA
        id kGSAhhYMhljKgkGSBh52Io; Mon, 08 Jul 2019 00:20:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plus.com; s=042019;
        t=1562541620; bh=GVpE7aGRhfl0q+cyNOzPjTFEpF5+NX5yIVU6eMlzhB4=;
        h=From:To:References:In-Reply-To:Subject:Date;
        b=qD34CxAyHcHyq2fWKR2YKZ7xj4lGvGoXYjuDkMswhiHt3/VhUktdyKs+1MpskP7wH
         iO9I3Fj4CLIn/HwU+WwQ5vHD46ChkYwxiRNWQKnc3j1e3wQCx8y/nY5qODYHbHuwNv
         hIx78KfpYPU5hAPKI1A1YShqcWCW/Q+7GOmZTrkKnMlCfcpcmYIGn4zUltll9f6X05
         8rQhm45NAlnQ28IQYpED5PnUtWc8uy+8gRoPprCUJURSo9Q2mW1O3FwkyuAUoKH6lF
         I0cq+IfxZ82RXHYHwRvwVlJURLj0E9pIPL97RVjDnC79dGzx2sNXVWudm+FXs+KUvN
         YKaUZms41NJ/Q==
X-Clacks-Overhead: "GNU Terry Pratchett"
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.3 cv=ermhMbhX c=1 sm=1 tr=0
 a=Cgy7cPM/+uUNK5d9KfAcsw==:117 a=Cgy7cPM/+uUNK5d9KfAcsw==:17
 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8
 a=D6tWAPrM7s6ZGdHEjWAA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
X-AUTH: moeller@:2500
Message-ID: <02C42761D1694BACA7C6BC65FB7E6E62@Ultrabook1>
From:   "Markus Moeller" <huaraz@moeller.plus.com>
To:     <netdev@vger.kernel.org>, "David Ahern" <dsahern@gmail.com>
References: <AFAC77AC6F8347289E6900614A523B32@Ultrabook1> <3fe925c0-e26f-492d-2552-b13a14451e3e@gmail.com>
In-Reply-To: <3fe925c0-e26f-492d-2552-b13a14451e3e@gmail.com>
Subject: Re: More complex PBR rules
Date:   Mon, 8 Jul 2019 00:20:18 +0100
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="UTF-8";
        reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 16.4.3528.331
X-MimeOLE: Produced By Microsoft MimeOLE V16.4.3528.331
X-CMAE-Envelope: MS4wfClPke6MljuBkzE8bAdLcIGI/WteAe7C2AKsSaC8ofmNC+/jkEuLrgXAXUd8y9HZJYeAXw7hI7UzP2N+omjJEsj5lKkdP9aaPkBJxBDWPEIYqIya6R7E
 Oh6P7zZkBMGv49EWfgxIICy1S7atx9/qSCWEaDZIZqhIG1/rlGGSKUn4WmjOnPHSeShPbOCIOplBBw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

  I read up about multipath routing and ecmp. It seems to do what I am 
looking for.

Thank you
Markus

-----Original Message----- 
From: David Ahern
Sent: Sunday, July 7, 2019 2:24 PM
To: Markus Moeller ; netdev@vger.kernel.org
Subject: Re: More complex PBR rules

On 7/6/19 5:06 PM, Markus Moeller wrote:
> Hi Network developers
>
> I am new to this group and wonder if you can advise how I could
> implement more complex PBR rules to achieve for example load balancing.
> The requirement I have is to route based on e.g. a hash like:
>
>  hash(src-ip+dst-ip) mod N  routes via  gwX    0<X<=N   ( load balance
> over N gateways )

Have you tried multipath routing? Does that not work for you?

>
>  This would help in situations where I can not use a MAC for identifying
> a gateway  ( e.g. in cloud environments) .
>
>   Could someone point me to the kernel source code where PBR is performed 
> ?
>

net/core/fib_rules.c


