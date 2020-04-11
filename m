Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7A41A536C
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 20:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgDKSlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 14:41:08 -0400
Received: from mail.skyhub.de ([5.9.137.197]:42696 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgDKSlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 14:41:08 -0400
Received: from zn.tnic (p200300EC2F1EE200B53534244D96C31E.dip0.t-ipconnect.de [IPv6:2003:ec:2f1e:e200:b535:3424:4d96:c31e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 57E7B1EC0CC5;
        Sat, 11 Apr 2020 20:41:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1586630467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=79SuGIhtfZH4AVqTBicnM2HnJJujV/UZuU+29Y4r+D0=;
        b=aVtlaW0y0wdDjE3pYEMBPnZDohg3ynnwv3dcVJ1I9mtiaLlV6bk0h7tr83V1cZ8NY4Wn73
        HQBj/E8z3vpAQxCyAl3r9i4B24Ea0cbJIQItbnOxBca2xtPHpO6VJu15jK0Em1Nm2xFrRy
        CqTtHoUiU5dic0cUPEtZhoKzomTssRI=
Date:   Sat, 11 Apr 2020 20:41:01 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Don Fry <pcnet32@frontier.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-acenic@sunsite.dk,
        Maxime Ripard <mripard@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Einon <mark.einon@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        David Dillow <dave@thedillows.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        linux-arm-kernel@lists.infradead.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        Thor Thayer <thor.thayer@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ion Badulescu <ionut@badula.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        nios2-dev@lists.rocketboards.org, Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH] net/3com/3c515: Fix MODULE_ARCH_VERMAGIC redefinition
Message-ID: <20200411184101.GB11128@zn.tnic>
References: <20200224085311.460338-1-leon@kernel.org>
 <20200224085311.460338-4-leon@kernel.org>
 <20200411155623.GA22175@zn.tnic>
 <20200411161156.GA200683@unreal>
 <20200411173504.GA11128@zn.tnic>
 <20200411181015.GC200683@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200411181015.GC200683@unreal>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 09:10:15PM +0300, Leon Romanovsky wrote:
> I want to think that it was an outcome of some 0-day kbuild report,
> but I am not sure about that anymore [1].

I pushed it here:

https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/log/?h=rc0%2b0-3c

The 0day bot will send me a mail soon. :)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
