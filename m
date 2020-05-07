Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2C51C835D
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 09:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgEGHYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 03:24:20 -0400
Received: from mout.web.de ([212.227.17.12]:35925 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgEGHYT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 03:24:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588836241;
        bh=MSRiNNksVbOkIX9Otcxvv8e+072C9Icjsw6N++UnbSc=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=iWx3kPOZfZTXNC2ZXOHvh5AyZbBkFrSkmty43PEZOZz0zEUqe5kFoeSV5kKIcKPFg
         8U5GeP1v4aTMeVhhfdAX3IVszPk4AO4InDKKFRcBMEyH/3ivYZ1oR3mh7cQ/w9C9b0
         9W/V/5apwYCFyk6FgFuyRndqYqfIp8BlMg2idPnk=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.29.220]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LnS4I-1ivaqE35qA-00hhg2; Thu, 07
 May 2020 09:24:00 +0200
Subject: Re: [v3] nfp: abm: University research groups?
To:     Kangjie Lu <kjlu@umn.edu>, Qiushi Wu <wu000273@umn.edu>,
        netdev@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>, oss-drivers@netronome.com,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20200503204932.11167-1-wu000273@umn.edu>
 <20200504100300.28438c70@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMV6ehFC=efyD81rtNRcWW9gbiD4t6z4G2TkLk7WqLS+Qg9X-Q@mail.gmail.com>
 <ca694a38-14c5-bb9e-c140-52a6d847017b@web.de>
 <CAMV6ehE=GXooHwG1TQ-LZqpepceAudX=P63o139UgKG7TMRxwQ@mail.gmail.com>
 <6f0e483f-95d8-e30b-6688-e7c3fa6051c4@web.de>
 <CAMV6ehEP-X+5bXj6VXMpZCPkr6YZWsB0Z_sTBxFxNpwa6D0Z0Q@mail.gmail.com>
 <956f4891-e85d-abfd-0177-2a175bf51357@web.de>
 <CAMV6ehE9YRxakbP9ahXkiZEPut8E3qYsN0cxiLqCWasfvLAWFw@mail.gmail.com>
 <e6989cd8-42b8-d1ab-1fe3-aad26840ae05@web.de>
 <CAMV6ehFCcSZtqpxonfbp6i_v5zzmnLJ9Gncx=5Y36R35wqTtDw@mail.gmail.com>
 <ce3917f4-8fd5-d9b6-e481-6118cdb504f2@web.de>
 <CAK8KejrEuumVxdbBmuHbhjXQa7KH_jP-XLmAHjp1+AC7DUa9WQ@mail.gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <2be8f7c7-2df9-33fe-74b1-43f783c281ff@web.de>
Date:   Thu, 7 May 2020 09:23:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAK8KejrEuumVxdbBmuHbhjXQa7KH_jP-XLmAHjp1+AC7DUa9WQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:L2cLK2Xb8zF2nedlHGp91/vQkl6r8dBDov8HbnVZG91f3GjihDO
 70F9OKg5rtvA/qH3/LnCj6419W9aV+2DHY1WZQxgNf8phJK3dWPuIJSJKk4j/RC2ZQO1GQC
 hldl411SVDoNOSRhlRm2v0efSpAOSeJJ3h1R3hPsxsoswuyCPnTvrJemp5MF13M7pIsUCos
 geNom8Sa8Px1OGOrufhNg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LNccG5OfLwk=:5OHxPkoeOwQ17LSCn6kola
 uz8GKhvr1RQS+sfXFavCiXRhzOhdFwemfkFoAX1jdGBGfQe1iQeKmN3GhUnOXQW6v41qLCvyQ
 uDV6gAUFNa+htB0LWh19ThWqr0otQgjBLh1D37ob0QWoBnZKmHBBlbh0wUzYQbe1QEQooWDuU
 Y1SY5MccqvIiFWaYkDxkrhl+yzBcHRx3Xg/AlIz0vDdH8HRgiZStGBmN9Jv3jqYPlw0pcZcfO
 L80t+HvdjfARNGKVWOHzQf2bkqVtYOHe4CKK8oerSnudJjLvDGcAaySnNOSb0CqZAR/c9tyXO
 Tw+CtSIXbns3GqkkP+/OqWOQXDjcMkZcG1APv5ifM+EFtPoik2ESgLIWCLui7wpHkXHUb6V0w
 /CMYRWiZqYSD4h41J4c6NGCCR+E/1l/nQQnlmoZwccIiUdRz97WWwTfA6eM8aSmk3/wOOUWVm
 6H6bww54KLTLKwMHkm4zMQtvR0kBWx/OEQOGfHzBfNQ/SgZCbsRfExKQ3JQhjNPTYTHAEmbyJ
 8vvVOGFt+3H+uevZDmqFVeUkn4K/mXyfvniecpkpmOmCVNxeb/hDGUCG8N5w4unBdgOgdbLFl
 WgYOEnUrpZsJcMpMCFpnLw99GkPyVnWmcS1y87sBstAzfLRdBNN0tkaJ2sVynW/cpSZjn1CYf
 V5RHnFMQHSjrBayPQNZR2q1vljhRPo0AnXjPBSnhV47tKTu42EjHcut3FvdoxdI4pjSPtiQMQ
 II/rTs794eVrAwWs0i79nMUunzZWVYeDMOJD+n2zdZIQWO1BKr3Cm3QOf6oafcVzngLsyzhic
 M0esQlVqW/WhN2m3sGoLVLrYkEVCC3FSTEZlV51IEUKYGzjoffvAGFh4bpVaF9ZYJ3k+LWji+
 e/SUgUMiVEZfmqKS2viNaP8l0ntVfht8/VvzlNbYzbff6NYBS3f7Q2iAK0EAGP55Th3cCNH6n
 FTJza4WOwT/jxhe1cErd5ZAdzwkkVy8607JeLfCV5JhTf9uen4i40077uN8ZB6Vp0//INI+KE
 ApeJM9clBA3ZyaP/X0PQmHJnDvwXAKV5V3lhYhtvDY3TtVemGNahVQi0qOFe/MhvAXN0krqkn
 4ZKWdFnMvpw9SvU2+34QNY+g+D9AXJmWUHOcDy1Fsj3YVg1dtoPg1kTw7N8vZ55iYgm3Ig+5e
 /ze+wxHYQjzgvhwXmNVN0Tf/4nl1DLyAH4wH/8lARi4v0j/CWCI9s8w5IaFhy/YzjHdtmpBbf
 MmI/Jwo/jzqcWEiWA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I imagined that the bug report (combined with a patch) was triggered b=
y
> > an evolving source code analysis approach which will be explained
> > in another research paper. Is such a view appropriate?
> > https://github.com/umnsec/cheq/
>
> Could you elaborate more on "university research groups?"

You are working together for the publishing of some papers which will
eventually be presented at conferences.
You might build additional relationships and participate in further work g=
roups.


> We are continuously working on automated kernel analysis

This is good to know.


> to improve the unfortunately very buggy kernel.

There are various software development challenges to consider.

Have you got a desire to express connections to recent research results
also in commit messages?

Regards,
Markus
