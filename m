Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B4A4E89E6
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 22:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbiC0UCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 16:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiC0UCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 16:02:12 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB9F12087;
        Sun, 27 Mar 2022 13:00:32 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r13so24704489ejd.5;
        Sun, 27 Mar 2022 13:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=78iW5XK4+ASAwJVsAvI1krxN1Cn3kULaSzDMrQW3lbE=;
        b=W7sg25bHaszzvWVJN0gyX6n6UFKurK5uWS8e6vL3YRtpn8QA30BzDbsf0Fo0KnzuVo
         f5lgeCM1g7VjeI4+YsTMtUtXLU8OULMmeB5PSBFxtOhNQxOmFPwV58KHSise/8GMyt0R
         UkRxgQ3CLiyEWm9B5wmzgYC64NBf7VmqUh+uCDsTRhKm1dBL3PhDD7kvx2KxY5v+Ou9s
         LtCbA+PaAxJA8Aqhhp0q2Rfl3QnpipqfZJ/WNelj96BMMf018qhLZN8AMLxNqJh1Ixg8
         Af8ZbFHjT7fOZzcs+O1sgyvPQnq9W6Aze+RWRCdQHnD8mS6FSfbjKHib+pU03gWIfqf1
         ov8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=78iW5XK4+ASAwJVsAvI1krxN1Cn3kULaSzDMrQW3lbE=;
        b=ZmonW1tyc16bGmt4eGqB/bGDMcjSVrcxHhhvxkq1J2QuvGtadUCuauS2i64BFdbHdh
         fald6rcruUT0imX2uwJiXvXlKTP8dYRdWeRpHrHRwoOaLy/vXw0XnQRgl+UuKN4iGhUQ
         wMoMCVYNZokjU2MmEzQ3EFpHSOu5iLZhuXo1XYVH1W/YWB3EsczCMyrT1G9s4luM2sr3
         dIWUWOl0PGl/bwp825Gil0EH+SXT6FClgZbCeK9NuChTwFaD1jhHmq8SSwa2UOIUvJs4
         P6C+9+sp47+LpcVKv6x7AAhKT5PgWIIm0c5PXW199mhsksvS50i6feCxjKDtEbueZlzY
         /qPw==
X-Gm-Message-State: AOAM5321I1VjcLNmqJUahq/dlTke0c8clt5HM/mKGd9J3P0KvOqalsQC
        uvWTE6XKEfErJkyt5UtA372kjwV/uL0gsFfvKVo=
X-Google-Smtp-Source: ABdhPJwdyxkAQAdfH1wRFs+W0MNyk4bgRb4Rgv1M9DLQvwm3YbnfTG06hhOU+eKDq7Hs4uOIofL7RgDFq+x0npk+U+Y=
X-Received: by 2002:a17:907:628e:b0:6d9:c6fa:6168 with SMTP id
 nd14-20020a170907628e00b006d9c6fa6168mr23537601ejc.132.1648411230602; Sun, 27
 Mar 2022 13:00:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220326165909.506926-1-benni@stuerz.xyz> <20220326165909.506926-5-benni@stuerz.xyz>
In-Reply-To: <20220326165909.506926-5-benni@stuerz.xyz>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sun, 27 Mar 2022 22:59:54 +0300
Message-ID: <CAHp75VeTXMAueQc_c0Ryj5+a8PrJ7gk-arugiNnxtAm03x7XTg@mail.gmail.com>
Subject: Re: [PATCH 05/22] acpica: Replace comments with C99 initializers
To:     =?UTF-8?Q?Benjamin_St=C3=BCrz?= <benni@stuerz.xyz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux@simtec.co.uk, Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Robert Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, 3chas3@gmail.com,
        Harald Welte <laforge@gnumonks.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        Kalle Valo <kvalo@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        linux-ia64@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:ACPI COMPONENT ARCHITECTURE (ACPICA)" <devel@acpica.org>,
        linux-atm-general@lists.sourceforge.net,
        netdev <netdev@vger.kernel.org>, linux-edac@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        "open list:LINUX FOR POWERPC PA SEMI PWRFICIENT" 
        <linuxppc-dev@lists.ozlabs.org>, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 7:39 PM Benjamin St=C3=BCrz <benni@stuerz.xyz> wrot=
e:
>
> This replaces comments with C99's designated
> initializers because the kernel supports them now.

Does it follow the conventions which are accepted in the ACPI CA project?

--=20
With Best Regards,
Andy Shevchenko
