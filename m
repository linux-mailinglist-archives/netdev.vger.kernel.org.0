Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B67A122D3B
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 14:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfLQNpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 08:45:30 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:50523 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfLQNpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 08:45:30 -0500
Received: from [192.168.1.155] ([95.114.21.161]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MfYgC-1i1FZn1CtU-00fzgB; Tue, 17 Dec 2019 14:45:11 +0100
Subject: Re: [PATCH] RFC: platform driver registering via initcall tables
To:     Greg KH <greg@kroah.com>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        bgolaszewski@baylibre.com, dmitry.torokhov@gmail.com,
        jacek.anaszewski@gmail.com, pavel@ucw.cz, dmurphy@ti.com,
        arnd@arndb.de, masahiroy@kernel.org, michal.lkml@markovi.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        linux-gpio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20191217102219.29223-1-info@metux.net>
 <20191217103152.GB2914497@kroah.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <6422bc88-6d0a-7b51-aaa7-640c6961b177@metux.net>
Date:   Tue, 17 Dec 2019 14:44:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191217103152.GB2914497@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: tl
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:UIxsKeF+t4AJ8q6DRnqSCsifxsav8JqTSzPbvflDT49nTCN38N2
 kn8QUDipr/KlL5RzF2fLtyOuCzxNjxUSI4UZqAlp6xIsJjV2bywjnE+BMyjssnPF9+oH6ww
 j5NFvhGrB1pzGK+XoSpXibonoL3JFM9dGJqe8hfLnfeBH94z62AKKyID1MFmz2D/kfr9ua1
 +I6P+xiT9RjL5BBgRigTg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nhzDFcqFHhI=:Tt4Fe7MEEtN81vc41C7AoZ
 wctLg7SjkItjTD1J3EE0wIIRp68zGRkICb7akDkm7TzGVY/Jv10cHWbbYxhEfiW4whMmm7gx1
 calgbAvlJfzZju7vWqVRx24cZKnsPXbGGNQI6AltrredEl0JuONWHGFccnaBRDzW2rH1MKxpx
 7guijvh0tF+MuaZMsUVm1dIggOl4cQFDElahLOqvviCWwKyID5OeS4sL9WhPMRRYqxAHM9q5O
 uPRf4lICI04o5CkAW0vu/jJU2fDAqqn8VRS8aZfQZtuRhCtoDTvZTEoOMN/icN7ljMBCxrxzO
 jKVvHCAs/ZD0+MWmVOPS6sdGZYhKGJfOrGUMZTIo07lGNMYuMdb6Mvx7qAuFP3Yttazz361XR
 WOiEbrlEia6jOwJTx0JGQiUkJqwUMutPSCYqHT+ZlswBl3PcXs2kTDeEimiMTkTWcs6cnQ5YJ
 0Ev+Ibgd1aJ5uVBqPmFfJs821dyrQ/nj2kpivSX944s+JlT5J79FdHn3yG5tlk4NsXcGYZpDb
 +Su81EDqspIcaHEsqNYqm4wHR4C4MRln/yQ/qEtoFPV/rx6N17k0IIo+d/DbjDUJ5PoLA6scG
 u5HIncBDs/JHZGLSftyL04NMt7m/WCxdQ6vh4pOOgJ+pBlIOtaNs/sr2RGvaMd1drejh8xN8T
 oVqTHasq/lYf0bopjmsmrUnoodoESr4GakdnC5EivRzMSeLiz11uVTbijiJ6z5hpZxZEUXDoy
 GSj9nLs8W6dvwEJKDzhLDRZdwjHLl6WE/XxOcwxG3eQ2N/ab5WauSh8y5djcp7H16KpJZ6A69
 pcY7K1TMdNUlig8lhlUX+Ij4IEaClVQj0yKqknPNhhHZTCef462eFxVdARrJ0sbaH1PRWpIfH
 buhiRZ+mDZotLHFEAKJ93oZ2o67FNflSKVDFquVEZb6lab6XoEveVJVdH6nxtOBexbBLcxxXW
 ARVod/u0vtgm8aj0oa/n+a8Xz6kwOYwTrei/SbYDwnKT6YuTO5xQd
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.12.19 11:31, Greg KH wrote:

Hi,

> No, what is so "special" about platform drivers that they require this?

Nothing, of course ;-)

It's the the starting point for this PoC. The idea actually is doing
this for all other driver types, too (eg. spi, pci, usb, ...). But
they'll need their own tables, as different *_register() functions have
to be called - just haven't implemented that yet.

> If anything, we should be moving _AWAY_ from platform drivers and use
> real bus drivers instead.

That would be nice, but, unfortunately, we have lots of devices which
aren't attached to any (probing-capable) bus. That's why we have things
like oftree, etc.

> Please no, I don't see why this is even needed.

The idea is getting rid of all the init code, which all just does the
same, just calls some *_register() function.


--mtx

---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
