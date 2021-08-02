Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623C63DDE8F
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 19:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbhHBRci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 13:32:38 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:60832 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhHBRci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 13:32:38 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 7766A200E7A7;
        Mon,  2 Aug 2021 19:32:26 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 7766A200E7A7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1627925546;
        bh=ndxGfaF8djPbixACkmqFH7MaUzgxyujAODvZF9u6DrA=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=KLoZBJPML0qLX9kKLElIv9jCcO1IO+6t+3KENqb3sSFwWxP3yEu+mFrn4m4quawPJ
         GxPsULvs9eT3SK2X7dgsWojSv4ELuW4GMVpY0zcNZYWtEPdz5SaOJ3vdbdsJWi9ovz
         Eh6q1VAcCTEf2WHmbPB3xTLGh/ScChwyrVZL1AkqlvQMLLRz1fDS1Gfc0VE1MpYrd5
         QNvnJa+XQxh/aE5DwjadTa9HYHM9SDDGtMaCE3y1WXvt7RLIMKn4WVazHcXRBZL2/D
         3AJpmpPmb1CLEY/oNDUurzAfZiNi4uhix0rkzCssFIRJc7XfYU0nH+MPJS/J8jCrvU
         +W28iwM1QHzZg==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 707D0603CC46E;
        Mon,  2 Aug 2021 19:32:26 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id d6MqyfROBIN2; Mon,  2 Aug 2021 19:32:26 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 557866008D408;
        Mon,  2 Aug 2021 19:32:26 +0200 (CEST)
Date:   Mon, 2 Aug 2021 19:32:26 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
Message-ID: <483557951.30287665.1627925546277.JavaMail.zimbra@uliege.be>
In-Reply-To: <559ce547-b07c-0ae9-c137-32b82f231b1b@gmail.com>
References: <20210801124552.15728-1-justin.iurman@uliege.be> <20210801124552.15728-2-justin.iurman@uliege.be> <559ce547-b07c-0ae9-c137-32b82f231b1b@gmail.com>
Subject: Re: [PATCH iproute2-next v3 1/3] Add, show, link, remove IOAM
 namespaces and schemas
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4026)
Thread-Topic: Add, show, link, remove IOAM namespaces and schemas
Thread-Index: OVJPdlH5R+1PfohO2ES8h2/8mVuzQg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> +/*
>> + * ioam6.c "ip ioam"
>> + *
>> + *	  This program is free software; you can redistribute it and/or
>> + *	  modify it under the terms of the GNU General Public License
>> + *	  version 2 as published by the Free Software Foundation;
>> + *
>> + * Author: Justin Iurman <justin.iurman@uliege.be>
>> + */
> 
> This boiler plate is no longer needed; just add:
> 
> // SPDX-License-Identifier: GPL-2.0
> 
> as the first line. I can do the replace before applying.

Thanks for the info. OK, I'll let you replace it then.
