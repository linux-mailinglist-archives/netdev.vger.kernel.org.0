Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B68D426ADD
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241188AbhJHMeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:34:04 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55577 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230219AbhJHMeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 08:34:03 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 97E945C00EE;
        Fri,  8 Oct 2021 08:32:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 08 Oct 2021 08:32:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DvDfa4
        6uLmreDvNSkNMOT/rFibsmdyBT9iFHGnQGGMI=; b=BHwDVfHEMi9IaKhU/nrfrB
        CuLHK4AI8uU56ODo0mclWbB0ORSzfG7C4N81WT62IXgSE5qW4ikXfM9rW1GZWJ12
        +WKJmxFbZEpv79Ffb4SwclrxemkQ29fPxgYhNRHlgD7DDT6gKDBgDzKMpat9dFvl
        AHHLhpStHNTTvzf376yiTA0pMw++eMyt3CtdqUyOGoZmDnvJhKh3Pp1ATK3ZCr0J
        5SuHquqk/2voESoL+jJYtW1DLRaRqzQgm/JjVUhrzvlEphzlObjCpQM9yNO4JC2U
        MKsFopO2btmNvwQ0/mCxV0sGoRMQghQWJwUCvReV0panWgdByoxzzkd4sAT4zcwA
        ==
X-ME-Sender: <xms:RzpgYW3U8xjBJgBtnlZidKKBnu9BFTWAmhDIemY7NTZyvavEblnRrg>
    <xme:RzpgYZF8HVN5jPWE1MnD_zgF4aR-Eq8tzmd6J_Q5dv0kpTX4T5dJEohzEv4IleEVI
    7Son8v-XKMp0YE>
X-ME-Received: <xmr:RzpgYe6nhGxuyEAkK9DlXcPpbXYKT8JhKATu8KBA285nyjs9ed84J2n01Wa2t169TjhZaH_RnyGryWBmCACCf7-t9y8eKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddttddgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:RzpgYX3ApttX7qz9TGEnrg1bkyavfkh3TLbcCwbJG5DLDrs1AnmfSQ>
    <xmx:RzpgYZEHcGzp_LlaqSPlJASkUVMV8WczrnVRiSisvrlJ0rb3Z4-0Iw>
    <xmx:RzpgYQ8bEgsrXCz_moMSeR0saSii-i_NF6TRQs6xDgL6QJN_2eEw9A>
    <xmx:RzpgYeQV5HLGTJ9uF5JkBeApyzTgms0QlySwekTeZRrnTS3SKYS-6w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 Oct 2021 08:32:06 -0400 (EDT)
Date:   Fri, 8 Oct 2021 15:32:03 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org, mkubecek@suse.cz
Cc:     popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next v2 0/7] ethtool: Small EEPROM changes
Message-ID: <YWA6Q+6NtikWN+LN@shredder>
References: <20211001150627.1353209-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001150627.1353209-1-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 06:06:20PM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset contains small patches for various issues I noticed while
> working on the module EEPROM parsing code.
> 
> v2:
> * Patch #1: Do not assume the CLEI code is NULL terminated

Michal, any comments?

Thanks
