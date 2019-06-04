Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CA5352AF
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 00:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfFDW23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 18:28:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43794 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDW22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 18:28:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9A8itsAphAb/as8ui3xdV6CzJFxywKBTzPtaBp5prAw=; b=xKnpAHQa0UnnwpRa1epErIXLim
        wF5aEkvyjVUxbMCnqhdWkGGL/rZZ5cf7F5oANx1XJj2yTomOnpCiJg2tfGzR6pvy16H0wm3mIvxvA
        deTxDJ2HwluuSPJm0yfymqe9pJUuw4eI3L18NynVm/ddTj94JbslLcqrxJM6s4cfIpqbETgJAyxtU
        FIA+NMuCZEvsoZyRkgNQRuhHkA5UdOXkbvmHaIAtEXNQFxNbnl1GuQXBaZh+c1VrCe9lZN/Nx2Imj
        A4Ej1f5lFBCRbzrFawHioxY+YTygzpkLh5DhFitayYOTViIIHD740/1pmIaBfDelgCZLvM92ACPqv
        aDVfc0lQ==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYHur-0001CN-LF; Tue, 04 Jun 2019 22:28:26 +0000
Subject: Re: mmotm 2019-05-29-20-52 uploaded (mpls) +linux-next
To:     akpm@linux-foundation.org, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190530035339.hJr4GziBa%akpm@linux-foundation.org>
 <5a9fc4e5-eb29-99a9-dff6-2d4fdd5eb748@infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2b1e5628-cc36-5a33-9259-08100a01d579@infradead.org>
Date:   Tue, 4 Jun 2019 15:28:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <5a9fc4e5-eb29-99a9-dff6-2d4fdd5eb748@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 3:28 PM, Randy Dunlap wrote:
> On 5/29/19 8:53 PM, akpm@linux-foundation.org wrote:
>> The mm-of-the-moment snapshot 2019-05-29-20-52 has been uploaded to
>>
>>    http://www.ozlabs.org/~akpm/mmotm/
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
> 
> on i386 or x86_64:
> 
> when CONFIG_PROC_SYSCTL is not set/enabled:
> 
> ld: net/mpls/af_mpls.o: in function `mpls_platform_labels':
> af_mpls.c:(.text+0x162a): undefined reference to `sysctl_vals'
> ld: net/mpls/af_mpls.o:(.rodata+0x830): undefined reference to `sysctl_vals'
> ld: net/mpls/af_mpls.o:(.rodata+0x838): undefined reference to `sysctl_vals'
> ld: net/mpls/af_mpls.o:(.rodata+0x870): undefined reference to `sysctl_vals'
> 

Hi,
This now happens in linux-next 20190604.


-- 
~Randy
