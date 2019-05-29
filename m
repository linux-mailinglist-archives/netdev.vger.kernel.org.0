Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5E72DC54
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 14:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfE2MCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 08:02:04 -0400
Received: from sobre.alvarezp.com ([173.230.155.94]:41534 "EHLO
        sobre.alvarezp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfE2MCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 08:02:04 -0400
Received: from [192.168.15.65] (unknown [189.205.206.165])
        by sobre.alvarezp.com (Postfix) with ESMTPSA id 5A6851E2D9;
        Wed, 29 May 2019 07:02:03 -0500 (CDT)
Subject: Re: PROBLEM: [1/2] Marvell 88E8040 (sky2) stopped working
To:     =?UTF-8?Q?Petr_=c5=a0tetiar?= <ynezz@true.cz>
Cc:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
References: <26edfbe4-3c62-184b-b4cc-3d89f21ae394@alvarezp.org>
 <20190518215802.GI63920@meh.true.cz>
 <56e0a7a9-19e7-fb60-7159-6939bd6d8a45@alvarezp.org>
 <61d96859-ad26-68d8-6f91-56e7895b04d3@alvarezp.org>
 <20190529045756.GC13432@meh.true.cz>
From:   Octavio Alvarez <octallk1@alvarezp.org>
Message-ID: <b669f655-9183-2a9d-a63c-45b0b0a4d7ac@alvarezp.org>
Date:   Wed, 29 May 2019 07:02:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190529045756.GC13432@meh.true.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: uk-UA
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/19 11:57 PM, Petr Štetiar wrote:
>> I just pulled from master and I don't see any updates for sky2.c.
> 
> it was fixed in commit 6a0a923dfa14 ("of_net: fix of_get_mac_address retval if
> compiled without CONFIG_OF").
> 

Oh! I see it now. I appreciate the quick help.

Thanks!

Octavio.


