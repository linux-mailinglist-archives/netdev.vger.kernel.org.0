Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78B92280D
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfESRwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:52:21 -0400
Received: from sobre.alvarezp.com ([173.230.155.94]:53554 "EHLO
        sobre.alvarezp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfESRwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 13:52:20 -0400
Received: from [192.168.15.65] (unknown [189.205.206.165])
        by sobre.alvarezp.com (Postfix) with ESMTPSA id B48F31E31B;
        Sun, 19 May 2019 10:26:12 -0500 (CDT)
Subject: Re: PROBLEM: [2/2] Marvell 88E8040 (sky2) fails after hibernation
To:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     netdev@vger.kernel.org
References: <aba1c363-92de-66d7-4aac-b555f398e70a@alvarezp.org>
From:   Octavio Alvarez <octallk1@alvarezp.org>
Message-ID: <e3d9d6a8-fc28-cccf-af91-3533a98c0786@alvarezp.org>
Date:   Sun, 19 May 2019 10:26:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <aba1c363-92de-66d7-4aac-b555f398e70a@alvarezp.org>
Content-Type: text/plain; charset=utf-8
Content-Language: uk-UA
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, I want to add some details:

On 5/18/19 11:07 AM, Octavio Alvarez wrote:
> PROBLEM: [2/2] Marvell 88E8040 (sky2) fails after hibernation
> 
> It occurs since 4.14.

Sorry, 4.14 is the last known good version. Quoting section 5 of my report:

> [5.] Most recent kernel version which did not have the bug:
> 
> $ git describe --contains bc976233a872c0f20f018fb1e89264a541584e25 
> v4.15-rc6~7^2
> 
> I understand that 4.14 is the last known good released version.

So it occurs since 4.15, sorry for the noise.

> Please note that the kernel version I am reporting is not the latest 
> commit because the current version is affected by another bug that 
> made my card so I cannot test this bug anymore. I am reporting that 
> one along with this one as problem 1/2.

I have been sent a patch to fix the other problem (1/2) so now I am able
to test this one (2/2) on the latest master.

I just did that and the problem still occurs. If I revert the first bad
commit [1], the problem gets fixed.

[1] Commit:
commit bc976233a872c0f20f018fb1e89264a541584e25
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Dec 29 10:47:22 2017 +0100
genirq/msi, x86/vector: Prevent reservation mode for non maskable MSI

Thanks,
Octavio.
