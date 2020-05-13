Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4FE1D18F0
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbgEMPSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728692AbgEMPSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:18:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7653CC061A0C;
        Wed, 13 May 2020 08:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=1tZgH8MNeghSPyWNWnOBlGuYAdG9LL5O6RnEdePT1vE=; b=gb6ABaw7RHKKCr1HU766fZDB8U
        SB3h6fppxsH05Z02CrRcbdER5PcWclAq30iLWhi9toAcrYx2gDTi2f6Ygq2i3bRxwrtVW7K2alru7
        a+2SkgnNRPyVTAjzPq9QrRPgZ7yeMbl2gC2E2b3QQ6seYdYrig544U3QgoVJPrQB+7RDAvAdQJ/Ts
        rgvKSg3kEfaXw9mw1je4fbu3TRJcZ2Q1tpcfypeCRLm5C/8RRahy35PNCo2iPB5R/H6RIa+gUJkkA
        hH9pzFXBD+vbbm+BjX1GgxPVCk5WVYTD1l6LYY8oGm33ACtlpFIvBju6/vnq9aBVH05Hr06pZP8zD
        9sSHwAHw==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYt9J-0005kF-21; Wed, 13 May 2020 15:18:21 +0000
Subject: Re: mmotm 2020-05-11-15-43 uploaded (ethernet/ti/ti_cpsw)
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-omap@vger.kernel.org
References: <20200511224430.HDJjRC68z%akpm@linux-foundation.org>
 <9ba4bac8-d4ec-c2d2-373f-3a631523cb2f@infradead.org>
 <a6e2a4ff-1ec5-4d86-4d00-ce62fbf1813f@ti.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <86830472-e970-cf07-49ae-2970fd99c25e@infradead.org>
Date:   Wed, 13 May 2020 08:18:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a6e2a4ff-1ec5-4d86-4d00-ce62fbf1813f@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/20 2:20 AM, Grygorii Strashko wrote:
> 
> 
> On 12/05/2020 05:12, Randy Dunlap wrote:
>> On 5/11/20 3:44 PM, Andrew Morton wrote:
>>> The mm-of-the-moment snapshot 2020-05-11-15-43 has been uploaded to
>>>
>>>     http://www.ozlabs.org/~akpm/mmotm/
>>>
>>> mmotm-readme.txt says
>>>
>>> README for mm-of-the-moment:
>>>
>>> http://www.ozlabs.org/~akpm/mmotm/
>>>
>>> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
>>> more than once a week.
>>>
>>> You will need quilt to apply these patches to the latest Linus release (5.x
>>> or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
>>> http://ozlabs.org/~akpm/mmotm/series
>>>
>>> The file broken-out.tar.gz contains two datestamp files: .DATE and
>>> .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
>>> followed by the base kernel version against which this patch series is to
>>> be applied.
>>>
>>> This tree is partially included in linux-next.  To see which patches are
>>> included in linux-next, consult the `series' file.  Only the patches
>>> within the #NEXT_PATCHES_START/#NEXT_PATCHES_END markers are included in
>>> linux-next.
>>>
>>>
>>> A full copy of the full kernel tree with the linux-next and mmotm patches
>>> already applied is available through git within an hour of the mmotm
>>> release.  Individual mmotm releases are tagged.  The master branch always
>>> points to the latest release, so it's constantly rebasing.
>>>
>>>     https://github.com/hnaz/linux-mm
>>>
>>> The directory http://www.ozlabs.org/~akpm/mmots/ (mm-of-the-second)
>>> contains daily snapshots of the -mm tree.  It is updated more frequently
>>> than mmotm, and is untested.
>>>
>>> A git copy of this tree is also available at
>>>
>>>     https://github.com/hnaz/linux-mm
>>
>> on i386:
>>
>> ERROR: modpost: "cpts_register" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
>> ERROR: modpost: "cpts_unregister" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
>> ERROR: modpost: "cpts_tx_timestamp" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
>> ERROR: modpost: "cpts_create" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
>> ERROR: modpost: "cpts_misc_interrupt" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
>> ERROR: modpost: "cpts_release" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
>> ERROR: modpost: "cpts_tx_timestamp" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
>> ERROR: modpost: "cpts_create" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
>> ERROR: modpost: "cpts_misc_interrupt" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
>> ERROR: modpost: "cpts_release" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
>>
>>
>> Full randconfig file is attached.
>>
> 
> It's expected to be fixed by
> https://lkml.org/lkml/2020/5/12/333

Works for me. Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

-- 
~Randy
