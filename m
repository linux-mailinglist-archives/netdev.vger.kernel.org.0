Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1076B8F49
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjCNKJd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 14 Mar 2023 06:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjCNKJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:09:31 -0400
X-Greylist: delayed 2400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Mar 2023 03:09:23 PDT
Received: from ns.iliad.fr (ns.iliad.fr [212.27.33.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEEA126EF;
        Tue, 14 Mar 2023 03:09:22 -0700 (PDT)
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id C1ECC20449;
        Tue, 14 Mar 2023 09:53:09 +0100 (CET)
Received: from [192.168.108.4] (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id AA0F320126;
        Tue, 14 Mar 2023 09:53:09 +0100 (CET)
Message-ID: <ea21b14025085e7934ddfbb84bee0a5020d67d4d.camel@freebox.fr>
Subject: Re: [RFC 1/6] pccard: remove bcm63xx socket driver
From:   Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 14 Mar 2023 09:53:09 +0100
In-Reply-To: <8d6896f5-3710-0b35-582a-fb482e5f4196@gmail.com>
References: <20230227133457.431729-1-arnd@kernel.org>
         <20230227133457.431729-2-arnd@kernel.org>
         <8d6896f5-3710-0b35-582a-fb482e5f4196@gmail.com>
Organization: Freebox
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon, 2023-02-27 at 13:33 -0800, Florian Fainelli wrote:

Hello Florian,


> This is probably fine because PCMCIA on BCM63xx was only needed for
> the very old and early devices like the 6348 which modern kernels are
> unlikely to be able to run on since they are usually RAM constrained 
> with 16MB or 32MB of DRAM populated. Maxime, do you care if this
> driver gets removed?

Not at all, thanks for asking.

-- 
Maxime



