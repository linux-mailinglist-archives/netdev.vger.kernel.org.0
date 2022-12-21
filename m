Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7B965383E
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 22:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiLUVfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 16:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiLUVfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 16:35:15 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFD224961
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 13:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=iG6QiXdrGSXnm53elINo6kuTGoBCOpj1tLnospv9c+Q=; b=C1aIAjCS29rvKI+DMw/0pVqpKj
        xO/PLCjHeA/54B1MGPFsHLT89sMEyzi2HTYHtDboJM95nR0iuxOt8IMmsKb7WwbArP46YMYBc5Hry
        7SXiCdhw4GS9p8czcsl6og2mf1nmnDqORcdB/rvjGa/KdSwDJZ2sSqgGYLgwVZ9nA0zy2qC5gSmO5
        8F6IZsQMOw2+bKYPLKj/CJ+3oalA594Oudd/kWgi3Jx6117WGLY/khgylg75lwpskFe5LzIW/wLyK
        Y40EO9nZkCrvJhibQfH/Nu3224z+zOlK4w4kZ9KPTqUjIGtyN/tIhQrmH4nSRAV3A4qDiVUSUGktH
        gmzhY82A==;
Received: from [2601:1c2:d80:3110::a2e7]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p86jw-002oOZ-VG; Wed, 21 Dec 2022 21:35:05 +0000
Message-ID: <3cb81f46-ac18-061f-8664-3b96e8c8165c@infradead.org>
Date:   Wed, 21 Dec 2022 13:35:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net 0/2] netdev doc de-FAQization
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        f.fainelli@gmail.com, andrew@lunn.ch
References: <20221221184007.1170384-1-kuba@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20221221184007.1170384-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/21/22 10:40, Jakub Kicinski wrote:
> I've been tempted to do this for a while. I think that we have outgrown
> the FAQ format for our process doc. I'm curious what others think but
> I often find myself struggling to locate information in this doc,
> because the questions do not serve well as section headers.
> 
> Jakub Kicinski (2):
>   docs: netdev: reshuffle sections in prep for de-FAQization
>   docs: netdev: convert to a non-FAQ document
> 
>  Documentation/process/maintainer-netdev.rst | 363 +++++++++++---------
>  1 file changed, 196 insertions(+), 167 deletions(-)
> 

Hi Jakub,

Yes, I prefer it this way instead of the FAQ format, so for
both patches:

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

-- 
~Randy
