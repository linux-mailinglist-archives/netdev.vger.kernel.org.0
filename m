Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 140B7B7D30
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390200AbfISOtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:49:22 -0400
Received: from mail.neratec.com ([46.140.151.2]:41493 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389041AbfISOtW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 10:49:22 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Sep 2019 10:49:21 EDT
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.neratec.com (Postfix) with ESMTP id A4B65CE08F5;
        Thu, 19 Sep 2019 16:39:28 +0200 (CEST)
Received: from mail.neratec.com ([127.0.0.1])
        by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id FIx9KfitQU0N; Thu, 19 Sep 2019 16:39:28 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.neratec.com (Postfix) with ESMTP id 82F37CE0904;
        Thu, 19 Sep 2019 16:39:28 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.neratec.com 82F37CE0904
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=neratec.com;
        s=9F5C293A-195B-11E9-BBA5-B4F3B9D999CA; t=1568903968;
        bh=vaMZdO/c0ybbuvIBNMGdGA7moqdUvFEpfWfjrtGDT8A=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=iToj46hyBY6zdAIlFTazhXSbktouysVs7yuepTEWQlrsYipYfY+J3CxOd9NuplPGF
         mqfwxzUR9HcNwIM1h59no8CKwXXm68Vs69ustjcA968yJNdN57tXEIfWrBgIJXV2Eh
         3QVOfo5ExMsy4yCg6qkyWlcXdOGnBhdj3muhtGoUkCbwroxzYI3qp7UWIk8DOL4yc1
         RPMKq+K1OfWm17fDb5m8dkJS6+vjIGMoaIkcFyNUe3IU3c9z3Ps/rFy/1w4mbWJGsn
         Vi5WCBPRZ4nE8NJO9i4GMohlxzW20i3IR8H6FAJz0Ad7fSYYbC0mqQqZsQK1eosZOb
         ad/WaxT5siGUg==
X-Virus-Scanned: amavisd-new at neratec.com
Received: from mail.neratec.com ([127.0.0.1])
        by localhost (mail.neratec.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Rpmhnxuf6vxK; Thu, 19 Sep 2019 16:39:28 +0200 (CEST)
Received: from [172.29.101.151] (CHD500279.lan.neratec.com [172.29.101.151])
        by mail.neratec.com (Postfix) with ESMTPSA id 6FF6CCE08F5;
        Thu, 19 Sep 2019 16:39:28 +0200 (CEST)
Subject: Re: ELOed stable kernels
To:     Or Gerlitz <gerlitz.or@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>
References: <CAJ3xEMhzGs=8Vuw6aT=wCnQ24Qif89CUDxvbM0jWCgKjNNdbpA@mail.gmail.com>
From:   Matthias May <matthias.may@neratec.com>
Message-ID: <e8cf18ee-d238-8d6f-e25f-9f59b28569d2@neratec.com>
Date:   Thu, 19 Sep 2019 16:39:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAJ3xEMhzGs=8Vuw6aT=wCnQ24Qif89CUDxvbM0jWCgKjNNdbpA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/09/2019 16:05, Or Gerlitz wrote:
> Hi Greg,
> 
> If this is RTFM could you please point me to the Emm
> 
> AFAIR if a stable kernel is not listed at kernel.org than it is EOL by now.
> 
> Is this correct?
> 
> thanks,
> 
> Or.
> 

You can also look at the wikipedia page at
https://en.wikipedia.org/wiki/Linux_kernel#Maintenance_and_long-term_support

I do the updates of the entries for each release once the release-announcement has been sent to the list.
At least since I'm doing this (last ~5 years), the last release-announcement of a branch always contains a notice that
this release is now EOL.
I reference all these messages for each version.

BR
Matthias
