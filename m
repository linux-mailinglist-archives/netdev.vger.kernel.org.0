Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD181A64B9
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 11:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgDMJfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 05:35:51 -0400
Received: from mta-out1.inet.fi ([62.71.2.226]:37156 "EHLO julia1.inet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728050AbgDMJfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 05:35:51 -0400
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgeduhedrvdelgddulecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfupfevtfenuceurghilhhouhhtmecufedttdenucenucfjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpefnrghurhhiucflrghkkhhuuceolhgruhhrihdrjhgrkhhkuhesphhprdhinhgvthdrfhhiqeenucffohhmrghinhepkhgvrhhnvghlnhgvfigsihgvshdrohhrghenucfkphepkeegrddvgeekrdeftddrudelheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopegludelvddrudeikedruddrudefgegnpdhinhgvthepkeegrddvgeekrdeftddrudelhedpmhgrihhlfhhrohhmpeeolhgruhhjrghkqdefsehmsghogidrihhnvghtrdhfihequceuqfffjgepkeeukffvoffkoffgpdhrtghpthhtohepoehkuhgsrgeskhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeonhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgqe
Received: from [192.168.1.134] (84.248.30.195) by julia1.inet.fi (9.0.019.26-1) (authenticated as laujak-3)
        id 5E93CD2F0001C3EE; Mon, 13 Apr 2020 12:35:45 +0300
Subject: Re: NET: r8169 driver fix/enchansments
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <43733c62-7d0b-258a-93c0-93788c05e475@pp.inet.fi>
 <20200412111331.0bea714b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Lauri Jakku <lauri.jakku@pp.inet.fi>
Message-ID: <d738366f-313f-2ed6-4078-c586cefbdb25@pp.inet.fi>
Date:   Mon, 13 Apr 2020 12:35:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412111331.0bea714b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

ok, will do. I'll setup git. are *_dgb()/*_debug() prints allowed to keep, as they do not show by default ?


On 2020-04-12 21:13, Jakub Kicinski wrote:
> On Sun, 12 Apr 2020 15:55:20 +0300 Lauri Jakku wrote:
>> Hi,
>>
>>
>> I've made r8169 driver improvements & fixes, please see attachments.
> 
> Please try to use git to handle the changes and send them out, this
> should help:
> 
> https://kernelnewbies.org/FirstKernelPatch
> 
> Please make sure you remove the debug prints, and CC the maintainers 
> of the driver.
> 

-- 
Br,
Lauri J.
