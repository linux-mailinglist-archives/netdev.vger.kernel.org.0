Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835151D0BE4
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 11:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbgEMJVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 05:21:16 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:59802 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgEMJVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 05:21:16 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04D9Kixe120808;
        Wed, 13 May 2020 04:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589361644;
        bh=IlqvhSvX7dm7U6fNCP86Eh1rVu3aygJpNYeXEiRbTwk=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=N4WBlCpAf/TS9QYfLJ7UD/CdMegYlurlnTJmuVycuArXL4cpSl05bQcj3R8odRjcZ
         OjufQOaNPKqfqP+HrrXFGan1Nxk/Cru82bInTbI4tod0Kmca/FlOUZhePsvc2KxT44
         3KqUdSpbmjK5KWn0q7xSu8c4/ED8QDEjD4TK5YZs=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04D9KiNK027980
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 04:20:44 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 13
 May 2020 04:20:43 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 13 May 2020 04:20:43 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04D9KeXT046041;
        Wed, 13 May 2020 04:20:41 -0500
Subject: Re: mmotm 2020-05-11-15-43 uploaded (ethernet/ti/ti_cpsw)
To:     Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <broonie@kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-next@vger.kernel.org>, <mhocko@suse.cz>,
        <mm-commits@vger.kernel.org>, <sfr@canb.auug.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
References: <20200511224430.HDJjRC68z%akpm@linux-foundation.org>
 <9ba4bac8-d4ec-c2d2-373f-3a631523cb2f@infradead.org>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <a6e2a4ff-1ec5-4d86-4d00-ce62fbf1813f@ti.com>
Date:   Wed, 13 May 2020 12:20:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <9ba4bac8-d4ec-c2d2-373f-3a631523cb2f@infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/05/2020 05:12, Randy Dunlap wrote:
> On 5/11/20 3:44 PM, Andrew Morton wrote:
>> The mm-of-the-moment snapshot 2020-05-11-15-43 has been uploaded to
>>
>>     http://www.ozlabs.org/~akpm/mmotm/
>>
>> mmotm-readme.txt says
>>
>> README for mm-of-the-moment:
>>
>> http://www.ozlabs.org/~akpm/mmotm/
>>
>> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
>> more than once a week.
>>
>> You will need quilt to apply these patches to the latest Linus release (5.x
>> or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
>> http://ozlabs.org/~akpm/mmotm/series
>>
>> The file broken-out.tar.gz contains two datestamp files: .DATE and
>> .DATE-yyyy-mm-dd-hh-mm-ss.  Both contain the string yyyy-mm-dd-hh-mm-ss,
>> followed by the base kernel version against which this patch series is to
>> be applied.
>>
>> This tree is partially included in linux-next.  To see which patches are
>> included in linux-next, consult the `series' file.  Only the patches
>> within the #NEXT_PATCHES_START/#NEXT_PATCHES_END markers are included in
>> linux-next.
>>
>>
>> A full copy of the full kernel tree with the linux-next and mmotm patches
>> already applied is available through git within an hour of the mmotm
>> release.  Individual mmotm releases are tagged.  The master branch always
>> points to the latest release, so it's constantly rebasing.
>>
>> 	https://github.com/hnaz/linux-mm
>>
>> The directory http://www.ozlabs.org/~akpm/mmots/ (mm-of-the-second)
>> contains daily snapshots of the -mm tree.  It is updated more frequently
>> than mmotm, and is untested.
>>
>> A git copy of this tree is also available at
>>
>> 	https://github.com/hnaz/linux-mm
> 
> on i386:
> 
> ERROR: modpost: "cpts_register" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
> ERROR: modpost: "cpts_unregister" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
> ERROR: modpost: "cpts_tx_timestamp" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
> ERROR: modpost: "cpts_create" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
> ERROR: modpost: "cpts_misc_interrupt" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
> ERROR: modpost: "cpts_release" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
> ERROR: modpost: "cpts_tx_timestamp" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
> ERROR: modpost: "cpts_create" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
> ERROR: modpost: "cpts_misc_interrupt" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
> ERROR: modpost: "cpts_release" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
> 
> 
> Full randconfig file is attached.
> 

It's expected to be fixed by
https://lkml.org/lkml/2020/5/12/333

-- 
Best regards,
grygorii
