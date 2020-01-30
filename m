Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC4E214E2E8
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 20:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgA3TIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 14:08:24 -0500
Received: from node.akkea.ca ([192.155.83.177]:59260 "EHLO node.akkea.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727541AbgA3TIX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 14:08:23 -0500
Received: from localhost (localhost [127.0.0.1])
        by node.akkea.ca (Postfix) with ESMTP id 375164E204D;
        Thu, 30 Jan 2020 19:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akkea.ca; s=mail;
        t=1580411303; bh=QCWqH3i6d7d//U54D23iF2Hbhl80FK9JvAL3ILoF+mE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=pOO9Itn2isE39rKwYWjLZuG0PjnqpBRrjBatfdhXx1gXo5/x7qBUtyTjWR1JIFOEg
         VoOCQ2Ou3A75wCcZntUteAjd34cbEReRk+efA4XTL7SDRwGRKIFQbNfaYr2R/VRvQ1
         xJny9RnrFPk3orRjH35Pnpwh346cr6nXbAv+IrdA=
X-Virus-Scanned: Debian amavisd-new at mail.akkea.ca
Received: from node.akkea.ca ([127.0.0.1])
        by localhost (mail.akkea.ca [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id e0iH27lz8nbj; Thu, 30 Jan 2020 19:08:22 +0000 (UTC)
Received: from www.akkea.ca (node.akkea.ca [192.155.83.177])
        by node.akkea.ca (Postfix) with ESMTPSA id AE0BA4E200C;
        Thu, 30 Jan 2020 19:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akkea.ca; s=mail;
        t=1580411302; bh=QCWqH3i6d7d//U54D23iF2Hbhl80FK9JvAL3ILoF+mE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=JYlXYzUu+ZVgG563aVfsaQ99S9y/WvTjFPlAI8N3r4iMe/smi2lGQMlZri0yfiwVY
         BFoP5No+HHdspJjFgD9I8P/hFjtVLeNX3KYlmsM8jECpvU3GMFLYa9p3XLqWztFa9K
         XA0CaUykfYrziL+9kXgSRCifzJGKiGdy/nrw0TyQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Jan 2020 11:08:22 -0800
From:   Angus Ainslie <angus@akkea.ca>
To:     Dan Williams <dcbw@redhat.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Redpine RS9116 M.2 module with NetworkManager
In-Reply-To: <dec7cce5138d4cfeb5596d63048db7ec19a18c3c.camel@redhat.com>
References: <59789f30ee686338c7bcffe3c6cbc453@akkea.ca>
 <dec7cce5138d4cfeb5596d63048db7ec19a18c3c.camel@redhat.com>
Message-ID: <47d5e080faa1edbf17d2bdeccee5ded9@akkea.ca>
X-Sender: angus@akkea.ca
User-Agent: Roundcube Webmail/1.3.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On 2020-01-30 10:39, Dan Williams wrote:
> On Thu, 2020-01-30 at 10:18 -0800, Angus Ainslie wrote:
>> 
>> I suspect this is a driver bug rather than a NM bug as I saw similar
>> issues with an earlier Redpine proprietary driver that was fixed by
>> updating that driver. What rsi_dbg zone will help debug this ?
> 
> NM just uses wpa_supplicant underneath, so if you can get supplicant
> debug logs showing the failure, that would help. But perhaps the driver
> has a problem with scan MAC randomization that NM can be configured to
> do by default; that's been an issue with proprietary and out-of-tree
> drivers in the past. Just a thought.
> 
> https://blog.muench-johannes.de/networkmanager-disable-mac-randomization-314
> 

Thanks that was the fix.

Angus

> Dan
