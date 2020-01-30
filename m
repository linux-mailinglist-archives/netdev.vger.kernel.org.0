Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7820614E323
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 20:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbgA3TYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 14:24:33 -0500
Received: from node.akkea.ca ([192.155.83.177]:59672 "EHLO node.akkea.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727438AbgA3TYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jan 2020 14:24:32 -0500
Received: from localhost (localhost [127.0.0.1])
        by node.akkea.ca (Postfix) with ESMTP id CE58C4E200C;
        Thu, 30 Jan 2020 19:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akkea.ca; s=mail;
        t=1580412270; bh=4coEijb91+C3yBzf6U08YuNwpSUUpsO4Ej8i38UBRfI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=sarQ7AuQVs7XPT6rGSaTlXvXy2dThgoRJMY47p4yTlxXMZVjBscWc7LLNtipfM+3b
         udGv/WwzklbhzCgKuI4BXsaFLBJ0ijA5011bnkhKn4ziwLcGNEhbV+H5AZn/UEXaiG
         NG8IL0Nt2vuNRc0tghfy1mlhADtodiYFYdgP0wTk=
X-Virus-Scanned: Debian amavisd-new at mail.akkea.ca
Received: from node.akkea.ca ([127.0.0.1])
        by localhost (mail.akkea.ca [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id C1ZebFokfI60; Thu, 30 Jan 2020 19:24:30 +0000 (UTC)
Received: from www.akkea.ca (node.akkea.ca [192.155.83.177])
        by node.akkea.ca (Postfix) with ESMTPSA id 5B8593940A3;
        Thu, 30 Jan 2020 19:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akkea.ca; s=mail;
        t=1580412270; bh=4coEijb91+C3yBzf6U08YuNwpSUUpsO4Ej8i38UBRfI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=sarQ7AuQVs7XPT6rGSaTlXvXy2dThgoRJMY47p4yTlxXMZVjBscWc7LLNtipfM+3b
         udGv/WwzklbhzCgKuI4BXsaFLBJ0ijA5011bnkhKn4ziwLcGNEhbV+H5AZn/UEXaiG
         NG8IL0Nt2vuNRc0tghfy1mlhADtodiYFYdgP0wTk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Jan 2020 11:24:30 -0800
From:   Angus Ainslie <angus@akkea.ca>
To:     Dan Williams <dcbw@redhat.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless-owner@vger.kernel.org
Subject: Re: Redpine RS9116 M.2 module with NetworkManager
In-Reply-To: <47d5e080faa1edbf17d2bdeccee5ded9@akkea.ca>
References: <59789f30ee686338c7bcffe3c6cbc453@akkea.ca>
 <dec7cce5138d4cfeb5596d63048db7ec19a18c3c.camel@redhat.com>
 <47d5e080faa1edbf17d2bdeccee5ded9@akkea.ca>
Message-ID: <31a7f0aad8e3de605f95845e77637785@akkea.ca>
X-Sender: angus@akkea.ca
User-Agent: Roundcube Webmail/1.3.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-30 11:08, Angus Ainslie wrote:
> Hi Dan,
> 
> On 2020-01-30 10:39, Dan Williams wrote:
>> On Thu, 2020-01-30 at 10:18 -0800, Angus Ainslie wrote:
>>> 
>>> I suspect this is a driver bug rather than a NM bug as I saw similar
>>> issues with an earlier Redpine proprietary driver that was fixed by
>>> updating that driver. What rsi_dbg zone will help debug this ?
>> 
>> NM just uses wpa_supplicant underneath, so if you can get supplicant
>> debug logs showing the failure, that would help. But perhaps the 
>> driver
>> has a problem with scan MAC randomization that NM can be configured to
>> do by default; that's been an issue with proprietary and out-of-tree
>> drivers in the past. Just a thought.
>> 
>> https://blog.muench-johannes.de/networkmanager-disable-mac-randomization-314
>> 
> 

Any chance there's something similar for bluetooth ? hcitool shows the 
device and can scan but bluetoothctl can't find the device.

$ hcitool dev
Devices:
         hci0    88:DA:1A:9E:XX:XX

[bluetooth]# list
[bluetooth]# devices
No default controller available

Thanks
Angus

> 
>> Dan
