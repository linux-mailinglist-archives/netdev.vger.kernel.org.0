Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75052B1440
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 03:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgKMCWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 21:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgKMCWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 21:22:55 -0500
X-Greylist: delayed 320 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 12 Nov 2020 18:22:54 PST
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41F1C0613D1;
        Thu, 12 Nov 2020 18:22:54 -0800 (PST)
Received: from [IPv6:2620:137:e001:0:fdfd:26bc:3665:75fd] (unknown [IPv6:2620:137:e001:0:fdfd:26bc:3665:75fd])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (Client did not present a certificate)
        (Authenticated sender: warthog9)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6BA6313411C04;
        Thu, 12 Nov 2020 18:17:33 -0800 (PST)
Subject: Re: linux-x25 mail list not working
To:     Xie He <xie.he.0141@gmail.com>, postmaster@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Martin Schiller <ms@dev.tdt.de>, Arnd Bergmann <arnd@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <CAJht_EMXvAEtKfivV2K-mC=0=G1n2_yQAZduSt7rxRV+bFUUMQ@mail.gmail.com>
From:   John 'Warthog9' Hawley <warthog9@kernel.org>
Message-ID: <ed5b91db-fea9-99ff-59b7-fa0ffb810291@kernel.org>
Date:   Thu, 12 Nov 2020 18:17:30 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAJht_EMXvAEtKfivV2K-mC=0=G1n2_yQAZduSt7rxRV+bFUUMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 12 Nov 2020 18:17:33 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Give it a try now, there was a little wonkiness with the alias setup for 
it, and I have no historical context for a 'why', but I adjusted a 
couple of things and I was able to subscribe myself.

- John 'Warthog9' Hawley

On 11/12/2020 10:27 AM, Xie He wrote:
> Hi Linux maintainers,
> 
> The linux-x25 mail list doesn't seem to be working. We sent a lot of
> emails to linux-x25 but Martin Schiller as a subscriber hasn't
> received a single email from the mail list.
> 
> Looking at the mail list archive at:
>      https://www.spinics.net/lists/linux-x25/
> I see the last email in the archive was in 2009. It's likely that this
> mail list has stopped working since 2009.
> 
> Can you please help fix this mail list. Thanks!
> 
> Xie He
> 
