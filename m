Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A197F466BC5
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346898AbhLBV41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:56:27 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52525 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243133AbhLBV41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:56:27 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A04A5C02FB;
        Thu,  2 Dec 2021 16:53:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 02 Dec 2021 16:53:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=bFvWOW
        J4LdOV/Y+8jd0qcNtjXaCmF5S4Md4cOklUnWk=; b=RbApYxyYiQloZaawSgIXDV
        zyZAEbFFr6jrr6CK1YqerGzCZ3N7jUED4RZC8yXc9ZrjCx026tzJQtS0rMA9qmdp
        PP3N+MaZgZVfqvqSqw1COzT5E2kIQeLWS1zXeYvP2OhwNtDuD0O6hAZA4diHTfUn
        pcK7YI4Yb0IZsfOmjYz3LsQRbrijsvttA3aXKf7iaEP98+cDQTSIs74DwJO52Ec7
        WUY/YyhzNEvx33B6vygRMLWVN2Oqonkn2pW0WqdQVZ5Ktbx1SfcSyG3hNy/TXsQh
        Frn1zU4ccWEvWE0VUFN+aByok9MTT7b1oj382sJUQeLmtOSQFyrMgaTVHYeqziww
        ==
X-ME-Sender: <xms:P0CpYbc0qmwvQ2OWBTwuRtiogKDEt73R1W0SKaKpyo7zVo37AGYMIA>
    <xme:P0CpYRP4fsL_Xy2rmbwLn-Z1_nIfP5YaP9lguvn5E7prV9Gjqr5rASIPtGQvAdUyt
    fmb6nlFNSj3GbQ>
X-ME-Received: <xmr:P0CpYUgK1QXTlEzXw0d3h-Csw7cZ6yjExWB1OQ5eNnazt5VhkZTgAFpXY2ifquIKJlpSFaYheTNaArAaTHaIQQfrgJxwuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrieehgdduheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:P0CpYc98NRLSPhWqQUZF3cNxHWNlflf8qHudNP2ON6KfZ8NiHmplLw>
    <xmx:P0CpYXvi_5s4vNyILP1XJMo3uOZBPKNI1R5P_ZsjNQyD-iLcLpLtzg>
    <xmx:P0CpYbGMuEUF-Vv2R7qsYaU8URfCwPZTyRJyaK05FVGhDPrqve7PZA>
    <xmx:QECpYRLn4w2ek7BNWpRz42KIeC0Sn791DuYQcGkGKU2-czD6N_CMPw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Dec 2021 16:53:02 -0500 (EST)
Date:   Thu, 2 Dec 2021 23:52:59 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next 0/8] ethtool: Add support for CMIS
 diagnostic information
Message-ID: <YalAO4PwKrJaFAZ4@shredder>
References: <20211123174102.3242294-1-idosch@idosch.org>
 <20211202214518.rwhrmzwhdmzs3kue@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202214518.rwhrmzwhdmzs3kue@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 10:45:18PM +0100, Michal Kubecek wrote:
> The series looks good to me and I'm ready to merge it but as it is
> marked "ethtool-next", I better make sure: is it OK to merge it into
> master branch (targeting ethtool 5.16)? In other words, do I see
> correctly that it does not depend on any features that would be missing
> in 5.16 kernel?

Yes
