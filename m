Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2AE4EE7B1
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 07:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245046AbiDAFRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 01:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbiDAFRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 01:17:33 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A899B261337;
        Thu, 31 Mar 2022 22:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:To:Subject:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=XY2BFJBYWtB/i6G9kwzJq4ajFFAn49+17pDObTzzXt4=; b=XVo35RMV8F1tiLiNR/KLocttT8
        ut72fCLln9RQWuF6OVDURQr60hqoZmN/laAqm8UOwbzTYB2JR39YaheRyGhkiyj61GaMbMwrLIElv
        2a0eTYJrqwkXFPxX5AQx13fum/0seodnygY+T78SaYkoNJn0PWd87QnITuACgddUW+XoOZhmEYStQ
        Ka9w1u2Pkx/Srr/4h2uDDnDWT8fwZ9czKLzbuCohEND9FjV0WwMZcvIhhlugqKDZFUsNh2XqU81vo
        D8JCfixqDz9iCulyOLAuNfjH4iyToQEUHWeYW+3fqies0/3ELneLbnbCShaJZLxrmWQ/gfXrMvUY4
        kV88Fl4Q==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1na9d5-000HWh-Qw; Fri, 01 Apr 2022 05:15:25 +0000
Message-ID: <048945eb-dd6b-c1b6-1430-973f70b4dda5@infradead.org>
Date:   Thu, 31 Mar 2022 22:15:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: mmotm 2022-03-31-20-37 uploaded
 (drivers/net/ethernet/fungible/funcore/fun_dev.o)
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>, broonie@kernel.org,
        mhocko@suse.cz, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Dimitris Michailidis <dmichail@fungible.com>
References: <20220401033845.8359AC2BBE4@smtp.kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220401033845.8359AC2BBE4@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/22 20:38, Andrew Morton wrote:
> The mm-of-the-moment snapshot 2022-03-31-20-37 has been uploaded to
> 
>    https://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> https://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 
> You will need quilt to apply these patches to the latest Linus release (5.x
> or 5.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> https://ozlabs.org/~akpm/mmotm/series
> 

on i386:

ld: drivers/net/ethernet/fungible/funcore/fun_dev.o: in function `fun_dev_enable':
(.text+0xe1a): undefined reference to `__udivdi3'


-- 
~Randy
