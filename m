Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4212E3D3C28
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbhGWO03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 10:26:29 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:60716 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbhGWO02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 10:26:28 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 36D312016405;
        Fri, 23 Jul 2021 17:07:00 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 36D312016405
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1627052820;
        bh=PppuTxDGhtfAAdyumBtL5Y8t9x8K2GECCCqea3tb2fg=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=rxL3bmTy14Q+9pIPA8LFutMRKW+Fyla9gpJ4tRB9z/ZX0fLwJZ/fi2OVV6QQIv9H+
         +OQmKCtDPW0LRgfa7HKPHCnq+MTIbwI7xirtdcBcHYolykuBM74Gg0swHNXKCAqvSS
         lkpDZDAnJ0TJtB96IUjZEgn5tiN/bmyyyQgg+plgRYXUOOnd1xHHoovflPq3eZVo3R
         pbmRWAuYgOdBze/RFj3jdtvUZcJvvwIiP9tvOIO1vJbZY+Vl0h9JhJutbIqYlF68Ss
         ZFWQHGw1/bLezT8tAIhhWfS3mL+OeA1VmGa/eltWq9h1mJohvLFvFPOwFiTxqeCHZV
         V9upsfhRTMNMQ==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 2FF2F60309F5F;
        Fri, 23 Jul 2021 17:07:00 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 54Gnokr0oEOG; Fri, 23 Jul 2021 17:07:00 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 188B06008D84A;
        Fri, 23 Jul 2021 17:07:00 +0200 (CEST)
Date:   Fri, 23 Jul 2021 17:07:00 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Message-ID: <1447995787.25531985.1627052820048.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210723075804.1387e789@hermes.local>
References: <20210723144802.14380-1-justin.iurman@uliege.be> <20210723144802.14380-2-justin.iurman@uliege.be> <20210723075804.1387e789@hermes.local>
Subject: Re: [PATCH iproute2-next 1/3] Add, show, link, remove IOAM
 namespaces and schemas
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4026)
Thread-Topic: Add, show, link, remove IOAM namespaces and schemas
Thread-Index: KgpGcxwkXHK5vVUwCHq/XYBRfvJUYA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> +		sprintf(data, "0x%" PRIx32,
>> +			(uint32_t)rta_getattr_u32(attrs[IOAM6_ATTR_NS_DATA]));
>> +
>> +		print_string(PRINT_ANY, "data", ", data %s", data)
> 
> The json_print has ability to handle hex already
> Why not
>	print_hex(PRINT_ANY, "data", ", data %#x",
> 		rta_getattr_u32(...


Hmmm, sorry for that, you're right. I already had this code ready for a long time and forgot to use print_hex instead (as I did for patch #2).
