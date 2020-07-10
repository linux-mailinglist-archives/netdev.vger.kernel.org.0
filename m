Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8088E21BCB7
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 20:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgGJSC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 14:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgGJSC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 14:02:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A69C08C5DC;
        Fri, 10 Jul 2020 11:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=DGJlzFFDge1qMvtsN1Pa3grJiZ2vQ1dk0udm/740NIY=; b=f7y6Ff8OYEXsz02C0opjEvjErS
        cCtaP6cHfmHVeihCqhY3pQ1DsbthbT6dHm9hi8ODQzwlxoXhDsmmqIPo3Z3UtegBrquFJZd0sZ/Hl
        g20vHOmES9MT1SEx8e6AwwOOnckHLkvoDxXf+LsPvk8JgBRj8UcEVcP9BTvKUEVVjKgNsUuOlEKVp
        Y9veJC6flRBqKhQ4chWIDqGczNPryLPLfp7x9fe6NZN7+UtkzFe4SZaiO7MW8bcYfQYnOWY7B7V0r
        ulxCsJblN0jKRuG8lbA7PkSu40XCWOKlECFwiKoNoOoVIT4qDq7eqeO3Zb2PAN+ia5n/HPogcg49z
        2z4Grghw==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtxMF-0007qE-4O; Fri, 10 Jul 2020 18:02:47 +0000
Subject: Re: linux-next: Tree for Jul 10 (drivers/net/phy/mdio-thunder &
 mdio-mvusb)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
References: <20200710183318.7b808092@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ce86d8cc-95e8-cb8e-f06e-fcf0975f56e0@infradead.org>
Date:   Fri, 10 Jul 2020 11:02:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200710183318.7b808092@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 1:33 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20200709:
> 


on x86_64:

ld: drivers/net/phy/mdio-thunder.o: in function `thunder_mdiobus_pci_probe':
mdio-thunder.c:(.text+0x218): undefined reference to `devm_mdiobus_alloc_size'


on i386:

ERROR: modpost: "devm_mdiobus_alloc_size" [drivers/net/phy/mdio-mvusb.ko] undefined!


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
