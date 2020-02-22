Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD590168C27
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 04:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgBVDSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 22:18:07 -0500
Received: from mail5.windriver.com ([192.103.53.11]:59552 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgBVDSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 22:18:07 -0500
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id 01M3GtsF001453
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 21 Feb 2020 19:17:05 -0800
Received: from [10.0.2.15] (172.25.59.212) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.40) with Microsoft SMTP Server id 14.3.468.0; Fri, 21 Feb 2020
 19:16:44 -0800
Subject: Re: net/kgdb: Taking another crack at implementing kgdboe
To:     Jordan Hand <jorhand@linux.microsoft.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <daniel.thompson@linaro.org>, <dianders@chromium.org>
References: <ccd03920-375a-2e65-cc28-d00f3297cb67@linux.microsoft.com>
From:   Jason Wessel <jason.wessel@windriver.com>
Openpgp: preference=signencrypt
Autocrypt: addr=jason.wessel@windriver.com; prefer-encrypt=mutual; keydata=
 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 ig4=
Message-ID: <f44ef944-d1c6-376d-cfef-920f780bea7d@windriver.com>
Date:   Fri, 21 Feb 2020 21:16:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <ccd03920-375a-2e65-cc28-d00f3297cb67@linux.microsoft.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/20 6:33 PM, Jordan Hand wrote:
> Hey folks,
> 
> I have been scouring patches from around 2005-2008 related to kgdboe
> (kgdb over ethernet) and I am interested in taking a shot at getting it
> into the mainline kernel.
> 
> I found an implementation from Tom Rini in 2005[1] and an out of tree
> implementation[2].
> 
> So I have a couple questions before I dive in:
> 
> 1. Is anyone actively working on this? From lkml archives it appears no
> but I thought I'd ask.


I don't believe there is anyone working on this. 


> 2. Does anyone have an objection to this feature? From my reading it
> seems that the reason it was never merged was due to reliability issues
> but I just want to double check that people don't see some larger issue.


I think some of the biggest problems here are what it takes to stop
the ethernet hardware, use it for a bit, and then put it back
together.  The changes to the network stack and the ethernet drivers
were fairly invasive to get it work with any degree of reliability.

Long ago, in 2008 I had proposed perhaps using a second dedicated
ethernet queue, vs trying to put the driver back into a good state
after you have stopped the core kernel execution.  I still view this
to be the best approach to getting a reliable debugger if you are
facing some kind of situation that you must use something that is "in
kernel".  You really need a way that you can process inputs and
outputs safely without using any other function in the kernel except
for what is provided in the debug core.  This would also give us a
more reliable way to have a "netconsole" for dumping ftrace data and
oops logs. 


> 
> I don't have 100% of my time to devote to this so it will likely take me
> a while but this is something I would like to see in the upstream kernel
> so I thought I'd give it a try.
> 
> [1] https://lkml.org/lkml/2005/7/29/321

I definitely have a version from 2014 that is newer than what was
posted there, which relies on the netpoll controller part of which has
been removed from the mainline kernel.  I also have a pile of USB
patches which enable the use of KDB with a USB keyboard.  Quite a few
years have passed by since I tried to submit them to the USB
maintainers. It is a similar kind of situation as the ethernet.  It is
hard to talk to the drivers in a polling state and put them back to a
working state when you resume.  Stopping is the easy part.


> [2] https://github.com/sysprogs/kgdboe
> 

This is a much newer project than the implementation from Tom or myself.   

Cheers,
Jason.
