Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DAB396077
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 16:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232814AbhEaO1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 10:27:12 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:32977 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233713AbhEaOZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 10:25:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D890D5C0183;
        Mon, 31 May 2021 10:23:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 31 May 2021 10:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+aB/Mt
        xAfNs0HuhvD3KKCnu9xC8hel/rQ1nGXPG3MIk=; b=QnpcUutCWCLN2ZGLbSZwJF
        cjRbO591Ink88KGFDH42dlIeSGc2Knyu4+QwIYD7DGMgyGciZYgMpea+4EbuEJri
        yk5HRcUP4mzrxRxcRSjy2nicRAZIBqO0oyXW8b4iRygEqAiAL6OlTMeF5c68xpra
        iVrKNjHJ9t2JdQqpKx2kgwwXnkzDXVnNdUwz2ejE8qW/YA88lIgIvuyHfdFwkhd/
        gL6niPgLnC9hzal552zGYnkSZF4tPfpuqdVGaFhdPpZq66nGqBXjsGc99ylrzGne
        aPNm4Nc9ZlLd1PuUoTTeKmCF9Wb27P+K2tGD04/CG5aD2TCevP44Ibj8mRI806VA
        ==
X-ME-Sender: <xms:XvG0YMxHWP4i4RqhPAGwHMuzxyYep9D3mmk7cBVkrkuSlBIdtVA4Hw>
    <xme:XvG0YAT2Hfzd0haPhC8zUTPRAPAEQk-P3LLM0GHjgswY93ilNHzSWl5JexmoK2Vla
    G-JAUtArDVMXGA>
X-ME-Received: <xmr:XvG0YOWv2X5lY3JjAfJ4qkQjOW121e8nUXTcxSE4yJWxJsqgU6IzeGpQZ-uomQ9UHs_tKvpkGlSbhyi6V5gAhPJ-4z2GaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdelfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtudevffevleefleelvdeghedtieevgfeuffeghfegteeghedvhfffkeeivddv
    gfenucffohhmrghinhepqhhsfhhpqdguugdrtghomhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:XvG0YKgOt5i1iFbs5r5eWVcD_DqG4M7sH_t1vh9vk12N9leM2a7EAQ>
    <xmx:XvG0YODxP-w57UR_9HR6T8ZtscSONEGqQZn370zrZgDkUa_LUrupZA>
    <xmx:XvG0YLLY78UzOQ3vj0vm95HuWTo6mPdTkX99c7x3yGaozEeyQovupQ>
    <xmx:XvG0YB8qr5DUR4M4zvichOjYJrgF0eWSXW8qxwE4sWFcP4leWt5UdQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 May 2021 10:23:25 -0400 (EDT)
Date:   Mon, 31 May 2021 17:23:21 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [PATCH ethtool v2 3/4] ethtool: Rename QSFP-DD identifiers to
 use CMIS 4.0
Message-ID: <YLTxWcO1pNQkN3Yr@shredder>
References: <1621865940-287332-1-git-send-email-moshe@nvidia.com>
 <1621865940-287332-4-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621865940-287332-4-git-send-email-moshe@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 05:18:59PM +0300, Moshe Shemesh wrote:
> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> 
> QSFP-DD and DSFP EEPROM layout complies to CMIS 4.0 specification. As
> DSFP support is added, there are currently two standards, which share
> the same infrastructure. Rename QSFP_DD and qsfp_dd occurrences to use
> CMIS4 or cmis4 respectively to make function names generic for any
> module compliant to CMIS 4.0.
> 
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> ---
>  Makefile.am             |   2 +-
>  qsfp-dd.c => cmis4.c    | 210 ++++++++++++++++++++--------------------
>  cmis4.h                 | 128 ++++++++++++++++++++++++
>  netlink/module-eeprom.c |   2 +-
>  qsfp.c                  |   2 +-
>  5 files changed, 236 insertions(+), 108 deletions(-)
>  rename qsfp-dd.c => cmis4.c (56%)
>  create mode 100644 cmis4.h

Is there a reason to call this "cmis4" instead of just "cmis"? Revision
5.0 was published earlier this month [1] and I assume more revisions
will follow.

Other standards (e.g., SFF-8024) also have multiple revisions and the
revision number is only mentioned in the "revision compliance" field.

[1] http://www.qsfp-dd.com/wp-content/uploads/2021/05/CMIS5p0.pdf
