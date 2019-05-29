Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235312D460
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 05:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfE2D5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 23:57:40 -0400
Received: from sobre.alvarezp.com ([173.230.155.94]:40872 "EHLO
        sobre.alvarezp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfE2D5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 23:57:39 -0400
Received: from [192.168.15.65] (unknown [189.205.206.165])
        by sobre.alvarezp.com (Postfix) with ESMTPSA id 0F9D821D78;
        Tue, 28 May 2019 22:57:38 -0500 (CDT)
Subject: Re: PROBLEM: [2/2] Marvell 88E8040 (sky2) fails after hibernation
To:     Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     netdev@vger.kernel.org
References: <aba1c363-92de-66d7-4aac-b555f398e70a@alvarezp.org>
From:   Octavio Alvarez <octallk1@alvarezp.org>
Message-ID: <a3a201a1-0b24-8d82-90f6-9196d4aef490@alvarezp.org>
Date:   Tue, 28 May 2019 22:57:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <aba1c363-92de-66d7-4aac-b555f398e70a@alvarezp.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: uk-UA
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On 5/18/19 11:07 AM, Octavio Alvarez wrote:
> PROBLEM: [2/2] Marvell 88E8040 (sky2) fails after hibernation
> 
> Hibernating the machine and bringing it back does not properly bring back
> the Marvell NIC. Most of the time a module reload does not help.
> 
> Problem starts on the following commit:
> 
> commit bc976233a872c0f20f018fb1e89264a541584e25
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Dec 29 10:47:22 2017 +0100
> 
>      genirq/msi, x86/vector: Prevent reservation mode for non maskable MSI

Sorry for insisting but can anybody help out? It was working up to 
before kernel 4.15.

Reverting this 2017 patch over master fixes the issue but the changes 
are unrelated to the driver:

$ git show --stat=60 bc976233a872 | grep \|
  arch/x86/kernel/apic/vector.c | 12 +++++++-
  kernel/irq/msi.c              | 37 ++++++++++++++++++++---

Thanks,
Octavio.
