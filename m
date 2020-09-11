Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945D6267666
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgIKXMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:12:45 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:36214 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725915AbgIKXM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 19:12:26 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2399A2ECA50
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 23:11:54 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EBFD46006F;
        Fri, 11 Sep 2020 23:11:33 +0000 (UTC)
Received: from us4-mdac16-4.ut7.mdlocal (unknown [10.7.65.72])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EABA42009A;
        Fri, 11 Sep 2020 23:11:33 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.41])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6CCB11C004F;
        Fri, 11 Sep 2020 23:11:33 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1D81C4C006C;
        Fri, 11 Sep 2020 23:11:33 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 12 Sep
 2020 00:11:23 +0100
Subject: Re: [RFC PATCH net-next v1 11/11] drivers/net/ethernet: clean up
 mis-targeted comments
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
 <20200911012337.14015-12-jesse.brandeburg@intel.com>
 <227d2fe4-ddf8-89c9-b80b-142674c2cca0@solarflare.com>
 <20200911144207.00005619@intel.com>
 <e2e637ae-8cda-c9a4-91ce-93dbd475fc0c@solarflare.com>
 <20200911152642.62923ba2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <115bce2a-daaa-a7c5-3c48-44ce345ea008@solarflare.com>
Date:   Sat, 12 Sep 2020 00:11:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200911152642.62923ba2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.003
X-TM-AS-Result: No-3.124500-8.000000-10
X-TMASE-MatchedRID: QW5G6BKkLTrmLzc6AOD8DfHkpkyUphL9CiTOKJLx+V5emWwoCXDj9cH4
        sOUTLtl6Zcz/Uu/FtYO7XIAWdEYuS+SWo/6D9AOphJWD2TZy7hEGchEhVwJY344iwAQuovtY4Bu
        rlNbLTrdr2m2LeKGQIJJw2WJhPKcIE29kWrNuieAZSUX8zcPGn34JYJwdJw4T4PdcWsl+C/M5aN
        wEkGdqbSIHx0QmSwcpHJXbPWdbF9o8gnzDlk9Fs6IBnfMCFBiC9ewculJK3jgcNByoSo036SXi8
        Z7hCx0ohUJOGGla76DhJSQgZSPD5L9ZdlL8eonaC24oEZ6SpSmb4wHqRpnaDjoYZD113WgYjjng
        rjCQrJKuLUuaCnCg1BjXHq4CgwmGGAcz2d+peXNwB1XVgJ6lsgvvGaBTAdaAljNIcAh3F+MN2bS
        n7NZCvofMZMegLDIeGU0pKnas+RbnCJftFZkZizYJYNFU00e7N+XOQZygrvY=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.124500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.003
X-MDID: 1599865893-2XPgwhGQ0_rs
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/09/2020 23:26, Jakub Kicinski wrote:
> "Toolchain" sounds a little grand in this context, the script that
> parses kdoc does basic regexps to convert the standard kernel macros:
> ...
> IDK if we can expect it to understand random driver's macros..
I wasn't suggesting it should _understand_ this macro, justrecognise
 when something _is_ a macro it doesn't understand, and refrain from
 warning about it in that case.
But I don't know how hard that would be to achieve — not being fluent
 in Perl, scripts/kernel-doc is mostly line noise to me.  My best
 guess is that on seeing 'DECLARE_A_THING(name, argument);' it reads
 it as though it were 'DECLARE_A_THING name, argument;', mistaking
 the macro name for a type.
I think the only way non-macro declarations can legitimately contain
 parens is in function pointer types, in which case the contents of
 the parens are part of the type and not declared identifiers.  So
 shouldn't kernel-doc ignore anything within parens?
> This is the only use of _MCDI_DECLARE_BUF() in the tree
Well, except for mcdi.h's
    #define MCDI_DECLARE_BUF(_name, _len) _MCDI_DECLARE_BUF(_name, _len) = {{{0}}}
> , how about converting the declaration to:
>
> #declare _MCDI_BUF_LEN(_len)   DIV_ROUND_UP(_len, 4)
>
> 	efx_dword_t txbuf[_MCDI_BUF_LEN(MC_CMD_PTP_IN_TRANSMIT_LENMAX)];
>
> Would that work?
That could work, yes.  Though, probably lose the leading underscore
 in that case.

-ed
