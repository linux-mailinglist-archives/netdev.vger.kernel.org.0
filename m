Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73029F3E3E
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 03:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfKHC5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 21:57:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbfKHC5h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 21:57:37 -0500
Received: from [192.168.1.20] (cpe-24-28-70-126.austin.res.rr.com [24.28.70.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14EA42084C;
        Fri,  8 Nov 2019 02:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573181855;
        bh=CQxQebx01rfyxWBjyBuBcT8jN9KYZVzIqhaOBlm21U0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Rfc4yF2gnMhTfT+o6yP2RkaqpUTOX8Xes/O4h90kfw6d0462bX7+n1Qs/7PbL9wCu
         UJ+ed34JvTN3rmfzSjPWicytH0MTwykymoEmqYhEUKLTQALmd+diBVSVBW/UEy5ctQ
         PHbkxbrFEO4WJFEC7rEpAYcIw4JcYfcBlzxIrOg4=
Subject: Re: [PATCH net-next 2/2] net: qcom/emac: Demote MTU change print to
 debug
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20191107223537.23440-1-f.fainelli@gmail.com>
 <20191107223537.23440-3-f.fainelli@gmail.com>
From:   Timur Tabi <timur@kernel.org>
Message-ID: <dfd60aa0-59e1-5b68-d8ea-61dc3a29ff8e@kernel.org>
Date:   Thu, 7 Nov 2019 20:57:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191107223537.23440-3-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/19 4:35 PM, Florian Fainelli wrote:
> Changing the MTU can be a frequent operation and it is already clear
> when (or not) a MTU change is successful, demote prints to debug prints.
> 
> Signed-off-by: Florian Fainelli<f.fainelli@gmail.com>

Acked-by: Timur Tabi <timur@kernel.org>

