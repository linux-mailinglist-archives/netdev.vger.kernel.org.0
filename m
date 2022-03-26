Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584894E83B2
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 20:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbiCZTZl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 26 Mar 2022 15:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbiCZTZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 15:25:38 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45D43207F;
        Sat, 26 Mar 2022 12:24:00 -0700 (PDT)
Received: from mail-lf1-f49.google.com ([209.85.167.49]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MrhLu-1ntDVC3m0C-00nf9d; Sat, 26 Mar 2022 20:23:59 +0100
Received: by mail-lf1-f49.google.com with SMTP id p10so12670836lfa.12;
        Sat, 26 Mar 2022 12:23:58 -0700 (PDT)
X-Gm-Message-State: AOAM533bmgyf9gtICHhD4uX3bpHPI/aYdc1Wjn6Ki5JXbMOATEGat/Y+
        Gy1rG/hWj2yhVg3daMun/t2j8RkW6hPx3SLZkuY=
X-Google-Smtp-Source: ABdhPJxx8NCR/u6qmXzG17FP9feBwegQPJsf9Aqi/l68ye4U4vfPlOZSED7ECKkFvKmT885cCFviGMxdRBsqoooKkLU=
X-Received: by 2002:a5d:6505:0:b0:205:9a98:e184 with SMTP id
 x5-20020a5d6505000000b002059a98e184mr11258676wru.317.1648322627645; Sat, 26
 Mar 2022 12:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220326165909.506926-1-benni@stuerz.xyz>
In-Reply-To: <20220326165909.506926-1-benni@stuerz.xyz>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 26 Mar 2022 20:23:31 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1e57mNUQgronhwrsXsuQW9sZYxCktKij7NwsieBWiGmw@mail.gmail.com>
Message-ID: <CAK8P3a1e57mNUQgronhwrsXsuQW9sZYxCktKij7NwsieBWiGmw@mail.gmail.com>
Subject: Re: [PATCH 01/22] orion5x: Replace comments with C99 initializers
To:     =?UTF-8?Q?Benjamin_St=C3=BCrz?= <benni@stuerz.xyz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Robert Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Chas Williams <3chas3@gmail.com>,
        Harald Welte <laforge@gnumonks.org>,
        Arnd Bergmann <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
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
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Nicolas Pitre <nico@fluxnic.net>, loic.poulain@linaro.org,
        kvalo@kernel.org, Pkshih <pkshih@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES" 
        <linux-samsung-soc@vger.kernel.org>, linux-ia64@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:ACPI COMPONENT ARCHITECTURE (ACPICA)" <devel@acpica.org>,
        linux-atm-general@lists.sourceforge.net,
        Networking <netdev@vger.kernel.org>, linux-edac@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        wcn36xx@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:9figIUnCgtvaf/cKMq2S8Mrl7ngptWVGWjzOtUo3hOJ8JuZUqXf
 uGJHsYnWe/msKkwufx5cx8GjLMtmeUa4P0UGqi2U5Ehg8teMr5a6CVVLi/oFydUeqagKVDu
 3Vvsy5IH4R2SidR4u3VseNYZpAa9Csqs9tqhrAAeU9/eoVB7bNuRhKsZXmCiVLDG5heinbb
 Fo2pPNQpCoAlPoGAryzUw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:RlqtZ8kYXZg=:weygU+7tyLUDVksTpjS8e5
 HMK6a3RwJ4pP/DourG9N6pv/FKqMEGI+hY/rz9ZEkyBfPdVkwMhwkf75UAwHmKUqLiIJ4X16S
 fERCRgYWtzpSZo5S/1ir1vo+pLydwh5/vJoO4jjki7XDP0mVHb7VcMLUH2KMcATjZEQpBxP5/
 Le8AXBRQbX0WX4mu1jAQQRUngcl6lVuJ1N0hdMcMMHSV1FjZjnUpBcy6TF8sTFzV/Ku2/DO86
 XJGfxC0muugsEI3U+JUJGN+eBjFzkg6xS1u57ZMaauo4ALrhTdEi+PO7YxjVvscnqa1Pkx3bI
 16XQ0Vt5urqXFfb7WPiNmvS0VF9EYpjL/2Xbi4Ygx4oMcluDFY7y/lgjRWqamPp5v6/mV5Joi
 hMFe6szOl0BsDPOXMuLdYmXUlkAnsFzL3m/3DhYUko5pP9kD4lRW6ea769aI3pTKOhWQ1/WhZ
 2sBRqCre4vFTPxO7FLmbuDIDrgW8YS7mJfyh2dBxfL5qfG0KLCKLLuhoxy2PF86/ZpkzKkSSY
 TnWCjOoGCAe/Tp+NXlEZ0HKO2mTfVq/vc26d/9rCKENTUPCDGml73zyXYdOoOeXYI97YXlrHH
 1/yZ+w9fQMQ4GVXmNtdmjsQTA6+8u8Mfj/oAsvjhc/7Du7Kx+nKd+VVT5m3SLPrK1qC+Oo9ns
 WO5HxobIpnBO2OVQOgap63NODBQtF5TxKHN5sX6NRJBG24d7dV5t3kW93fmrf+2QNq3W8hLTs
 xyTuMkuS7qKlerszk+X0tFneKJO4KuUui7P+wsIrahl5OwoahacsFleLfRqSV3i5DFizM/1rv
 k1jFyA4vTU3aAlFBb3cj/2kYzyHcjB0KWr8wUwgz2924c1/53s=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 5:58 PM Benjamin Stürz <benni@stuerz.xyz> wrote:
>
> This replaces comments with C99's designated
> initializers because the kernel supports them now.

The change looks fine, but the comment looks misplaced, as enum initializers
are not c99 feature. Also, the named array and struct intializers have been
supported by gnu89 for a long time and widely used in the kernel, so it's
not a recent change even for the others.

Also,

      Arnd
