Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 654E2DF584
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbfJUTBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:01:02 -0400
Received: from mout.web.de ([212.227.17.11]:48129 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730026AbfJUTBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 15:01:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1571684444;
        bh=E9JnthHTX95IhhGDDKvUesddTu58VlOGnTwXioVWz68=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=dXC9wpXPDFvaz4Sm/0U0n/LG+Rymv6glc21q0wFts94hQXooyZPRZPfsIKAN0l3K/
         RGXwiO8PbSNHxdR8/EzaBzOKvaVHcxozYH52F7+yjZoCZGPfqJg+9BXMynFdBLYCou
         wBRw0KbV6zNHZPnghnlmKmQExJ6ss5vCMwmCwT7I=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.106.164]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MQelV-1iSWC913E5-00U1iU; Mon, 21
 Oct 2019 21:00:44 +0200
To:     linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Nicholas Mc Guire <hofrat@osadl.org>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: sysfs.txt: Checking the documentation status for the directory layout
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <5781c1ca-1558-48f0-84f1-678985832eed@web.de>
Date:   Mon, 21 Oct 2019 21:00:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:acHw5VN4paUC2wbACFW68PCnIbeWkc2czjkqq4SSCtkAhx+Sa9U
 TD3TUm4U8Ehifvgo+W6h4Ku5640TfbkqFCAtMM+9KvXC0yQrx5xkpcJIcngdUo8CCWl/ZaA
 TMH8QCHwWPDIn0568fn4DBgzkwm1oL8YGvt4sFfQvqjtuhq1igtFLzM+FUSRveW277f9lmq
 qzE3N4hvK8I6RwqHvdM7g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:I2K9kI3dMxI=:zN5mptROEanvfHNZ6nyQIH
 CszkddXYyTAk0kdVh9AAy25t3lylzVxsgnIsMTPsBnYpxkFybywhs/lV4WRCIhevzCmkYEEgI
 1WKpZXNr0v4LUZJwzKF7i6yCphe7XYSYrrt+dM2amNCSZ7mmPEOD46udJM/l0ficnxQDforUv
 9OkdqA10bDfo0g9NnNgusLvTo24rykMvQjIbYCNUNOBOx+bC2HNtKtziAA49hjx20Z2VfvrTT
 DUwUMxQGExvSvmZ/J7FoyIKscebx6Nlc6AWTTRbgv/u/ZCNEophSft86mMP65X1EqSgsXp8u8
 cFpeg/8UEQmG+VYnAdhKgnzLO9MtoSTjDbSLwDaJB1OB00t+sRgjil4IwMQIw/bo1HmBx01fx
 AqHDrOWnQd85uLhKJHDM+HLmwpYofKFNqf7TqiW+2esVXDgRbjkWcN0WyP79XoMMQxM0l6yZo
 s77voNE9SF5ndmdssRqmWvRc67hKmysNzOWfGWPrEcN1fYtsniTn/fa5rxBOAvixGRUxU54z4
 0aHp2ZKYqVZ9X4SXN3vqI3JztIaTXyY2oZrcHkytgZuEkqJ1dWk5btLtJ0f7BNTbTw25vqXnj
 htk4wQAQTl7weqhUaJgxPlxk5tvatY902VgwXHChFmP0PcOx2Fx2ib2oaIBT4zJtql1NT2oz6
 JfMlC7e3Qsm9jvOf47N41Ev3noLa8hs56WJsYdODf6CEDMJQ+xYRUaVfs2DnQV9nABwDBLXqg
 mc1qTTGljx/7K2T7aBykW5ohCaA+R1lVPB7XimKFOgqQp6JC2QMauoeFZB8MhDi4sXj4zEj4M
 FzO+ME0CUFeeWYz4r/Dxdz0g5uvNAvU8UtBuVkthz5zihFPqkZzJGhtwlLRrYMzMIZ3g6WUAV
 CZ5LDySIp9p6oofT3t56hzn0j/kxixm+54E7cRLmiEZV0LWYuTLTHe+zh837V6Lcc5Xf1MJkr
 dsLfgBPvpFOw0nttLkkT9edeV8RK8HOgPlup47mBx0lWe3UiMSrwYQ4Jj6WA8oUV4hb0FaRJx
 HCvkhNLZX5W0QWuCNd4TbYgfbtSdzzxIZl+ZUcVkILJKGto1N4fqLWbjZ6YFC0BwAOPTCHSlC
 5zoAB3V9mEjWiACaHGI35Ry8nVtTYjMDs+LWX9Jb12++KRd4s2HRS/gHKd+IvqQkit4+1/MMN
 zWmyqDPVRMRn/rzPTowHzygQ6GyhBYaSQ8BpqSyj6KfOXPXTynqurAgOtxPAEgt2YJL+2J1o8
 p3UhODwjyG40tLrpj1Nrap6zGDvwFXE7QAtwB5a2V0jrbErFT1lt9bn59bKg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I have taken another look also at this text file.
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/D=
ocumentation/filesystems/sysfs.txt?id=3Da6fcdcd94927a1b24dea6a9951ffa7c645=
45ecfb#n276

The following information is provided at the moment.

=E2=80=A6
Top Level Directory Layout
~~~~~~~~~~~~~~~~~~~~~~~~~~

The sysfs directory arrangement exposes the relationship of kernel
data structures.
=E2=80=A6
firmware/
net/
fs/
=E2=80=A6
TODO: Finish this section.
=E2=80=A6


The directory =E2=80=9C/sys/net=E2=80=9D is not listed on my Linux 5.x sys=
tem.
Will this documentation get an update?

Regards,
Markus
