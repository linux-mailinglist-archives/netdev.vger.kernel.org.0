Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E9D5099F6
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 09:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385919AbiDUHm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 03:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386007AbiDUHmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 03:42:12 -0400
X-Greylist: delayed 508 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Apr 2022 00:38:49 PDT
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3C61D0E8;
        Thu, 21 Apr 2022 00:38:48 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 1B80030B2943;
        Thu, 21 Apr 2022 09:29:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=KTD9Z
        V8p2M5RwTqrWZsqKaCS5uVbljw+5gJNNUbPEM8=; b=DLI6+ZJeZCwh3CBG+aKCY
        RKo7kn450DvBswU2vENANl3ZmvSlq0CiLLP9+T6XTGIIUcI99pP4yKva2S9BSbV0
        WTAft8SVyWWGJX7dJNgNFf9qzk4negBlxNfHLsjWcmq/q/1wvFIOxeU1RQOkpPka
        pT0PrtWZUWobo6W4BRqR48jNzGt2Co7Raz0qIeXUsFlvEMFXP44vbkcJ502X/ENq
        X592uWjcyue7+R+AXoZJ4ZcvWLdJnfOMj0rYytElgBibHVl9Ok8sIJnI1fAP6GnV
        5XkftzSdIyZXE1ep6LYV0FY0G1DzYXjDwnWn0VaONmO/3D+jJxXg8MUEPn3G6JaX
        Q==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 6B3D530AE004;
        Thu, 21 Apr 2022 09:29:48 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 23L7Tm9c029713;
        Thu, 21 Apr 2022 09:29:48 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 23L7Tk2S029710;
        Thu, 21 Apr 2022 09:29:46 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build warning after merge of the net-next tree
Date:   Thu, 21 Apr 2022 09:29:46 +0200
User-Agent: KMail/1.9.10
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20220421170749.1c0b56db@canb.auug.org.au>
In-Reply-To: <20220421170749.1c0b56db@canb.auug.org.au>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202204210929.46477.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Stephen,

thanks for the notice.

On Thursday 21 of April 2022 09:07:49 Stephen Rothwell wrote:
> After merging the net-next tree, today's linux-next build (htmldocs)
> produced this warning:
>
> Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst:
> WARNING: document isn't included in any toctree
>
> Introduced by commit
>
>   c3a0addefbde ("docs: ctucanfd: CTU CAN FD open-source IP core
> documentation.")

I would be happy for suggestion for reference location.

Is the next file right location 

  Documentation/networking/device_drivers/can/index.rst

for reference to

  Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst

It is documentation of the driver for CAN FD open-source
IP core developed by the group formed at Czech Technical University.

I have probably minor updates for the links to the external
resources, AXI, APB and other documentation because
it moves from site to site under Intel, ARM, Xilinx
web sites hierarchies.   

Best wishes,
                Pavel
--
                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

