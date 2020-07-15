Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB88220D69
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731170AbgGOMwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgGOMwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:52:07 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67981C061755;
        Wed, 15 Jul 2020 05:52:07 -0700 (PDT)
Received: from [192.168.0.20] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id A585E564;
        Wed, 15 Jul 2020 14:52:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1594817525;
        bh=SoEmbpkNZkembnmkPfdAOrZOiv4yoC/24TU3qWemlqw=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TXxh4qKsDyfzzPZBpGyVHCp+0hGT2fD3gq6DsqNeDllH5KDjlNPP/ZptFy1ZSJ0B0
         Sgzp+9SIZ4xPKXIEWouiFjKgqTBvnhMczgmSrRnJpRPifpY5VzdpcJRKl3ojBgKIOe
         0S5lGfBRp/7wQt01/nMlVffif4LhDzZEYdfjJsuQ=
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH 05/17] drivers: net: Fix trivial spelling
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        Shannon Nelson <snelson@pensando.io>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Wenwen Wang <wenwen@cs.uga.edu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QUALCOMM ATHEROS ATH10K WIRELESS DRIVER" 
        <ath10k@lists.infradead.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>
References: <20200609124610.3445662-6-kieran.bingham+renesas@ideasonboard.com>
 <20200715102209.C9012C433A1@smtp.codeaurora.org>
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Organization: Ideas on Board
Message-ID: <f32e309f-a214-87c3-68fe-66882b949794@ideasonboard.com>
Date:   Wed, 15 Jul 2020 13:52:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200715102209.C9012C433A1@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On 15/07/2020 11:22, Kalle Valo wrote:
> Kieran Bingham <kieran.bingham+renesas@ideasonboard.com> wrote:
> 
>> The word 'descriptor' is misspelled throughout the tree.
>>
>> Fix it up accordingly:
>>     decriptors -> descriptors
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> I recommend splitting wan and wireless changes to separate patches as I
> cannot take changes to wan subsystem.
> 
> Patch set to Changes Requested.

Thanks, I've split this and resent the remaining outstanding patches.

--
Kieran



