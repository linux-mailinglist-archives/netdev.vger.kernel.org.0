Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730D15AFCD
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 14:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfF3Mki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 08:40:38 -0400
Received: from mout.web.de ([217.72.192.78]:39531 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbfF3Mkh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 08:40:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561898424;
        bh=vXON2/tDrdrlRgRts43ALWOpPyXlNysEupL7Z4f2xZo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=RI36uk/KIfqt9HUDBK/xxQncTrzFVWLOvmmKgSKPRVGKUJ/s5//1tyIHBglSr05TO
         7Z1PnFAEiZY/NJHCpDuL76nPRWgkKKDSMOFm0HL4ymC1hw3pjDSiiwAxsP/RsCsjUn
         k9m2N4do2H9CUnGQvXhnp8R1RfDrptbhVShu+uxY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.179.31] ([84.46.37.29]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M2uWg-1iZwP02tSo-00sewg; Sun, 30
 Jun 2019 14:40:24 +0200
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
To:     Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com,
        romieu@fr.zoreil.com
Cc:     netdev@vger.kernel.org
References: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
 <85548ec0-350b-118f-a60c-4be2235d5e4e@gmail.com>
 <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
 <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
From:   Karsten Wiborg <karsten.wiborg@web.de>
Openpgp: preference=signencrypt
Message-ID: <62684063-10d1-58ad-55ad-ff35b231e3b0@web.de>
Date:   Sun, 30 Jun 2019 14:40:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:61ZSTrwpP5rTvQFFk/22hCa99srGcz+YNWBB5tttuaeLJJ6Dhq4
 YHeqQqaUOik/5aUwTrLNMJVv7BGkgnrIrUUNv15Py/mMkCrzZSNq9Cv+PL6GWJOH9R8b6yx
 DZVogrRGsImXH6m3ceYiudMRP07Tkae7b+7/j0f67VCq845qAsPaapn9FjZ0U6ivvH8BYUy
 W2OtGiq+mgB2hQ0n4AGvg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Y/bqo7tTVU4=:w0Amur+2s+k+fyHGj+mFOX
 71TGZiZ4NLPAQunD/fOP7va5/EKVrbU1I+Nk7jJ7YlWTpPXiPL4tawoXQqoeKyAHWSAslqV/n
 CqeE4XteihkzRW6kPcXABx3Egx9CF7mRNcypAlnQ1OCzKNp7ehYM2TtnfPy0Kx/ZHnKzxVoNW
 8OH0OlaVlo09TvNhMvAQL2IXdehL+A4Bs94GagdScgeZjeCM5hgxIKP36GGxNt0/4Z0Lf0FFE
 XwImW54EXNPRbN6RAiN8H0DS/AxdxxHlj/GC1/rA7MzYPmJtFqhACeEcCzLy1eiK+yU0C+QYl
 kx1nRY96I36HKShgMGIefBxpIhLuczyC7WenNz/BgO87m/LwEPNNDrZC9E3n7icn9bvKWqaUc
 ZpcGRUX4CyU8oStyAS1HxKjfF2rlJFADgZaxasAmUtang/mHJGGLk5k4UfZvpRunVWAcq3lx9
 FHoYzBEhZJVuEuVrg+VOm+cCs3JBqZbSxgvGIsmLL+Nz+exDipeIzWE3VHPvRwtQqCy7lIDkk
 KExxL1bv0r9IoEXRD7klesCqkh8wAGQAK0scHxZv7IoccmBq9yx7uFvFHRzd84rvlWFl0/BU7
 uaX+mcOCIZdTwHn5zz9Nzgvj8Ya2yYxzzXKRLj+5mOHxe8MYqcnWp21XuBeuZ6yAh2JMh9DxZ
 puLOLwGWUQY0ihBoe+okobs/8p70T5gQv76fG0gc/RTniwuPjIyb6HIFuswsA1egmPDwBi8ZX
 rGeIdySqOxFSpfO/dmSLoOw/Wt0D/E7jg9BdsJE/cA0eszxI6ZokTXb2jvHnj/nOn62dzdOma
 bIZ3OEYmq0Dom27kJ/jQ33uLu/VgcVCjvCIjolJ/8Sp2M4r+SpbIZI7L1oP4gQd/ygmdpV5J6
 Q8j12zibqMiaw8HWPJaxl/wtukf1FSW0YUuKblLg+j0Ry5O91gbuDNXzPULl+3HwvaTZcLn5E
 sUJt2Hwf/XTn63H/MqIzAg3rjw3xqK/uhtihNREQLkwqUYKY78Df5GdOg2VS4iALRbVsDGAp9
 2QUhb+UkWFyJ3S3tkXLSUZbRJ4nljKxnCLU3aJJmjsbQPCz6bg/3MYk7N2IeQIU1WUh2q1Ou9
 n/OLkniPaKy14SLv3jCXl6E1pM4i2gI97AW
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On 30/06/2019 11:12, Heiner Kallweit wrote:
> Indeed the MAC is missing:
> [    2.839776] r8169 0000:02:00.0 eth0: RTL8168h/8111h,
> 00:00:00:00:00:00, XID 541, IRQ 126
>
> This works with RTL8168h in other systems, so I'd say you should
> check with the vendor. Maybe it's a BIOS issue.
Tested some more. Found out that the Realtek-supplied r8168-8.046.00 is
buggy (compilation bugged out, see one of my last mails). I just
succeeded in compiling r8168-8.047.00, which ran straight out of the
box. So the NIC is fine and not defect.

I do agree with you: I definitely would prefer an opensource driver but
the r8169 simply didn't work.

In regard of my success with r8168-8.047.00, do you still think it might
be a BIOS-issue?

Regards,
Karsten
