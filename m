Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FEA3A6337
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 13:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbhFNLLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 07:11:32 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:33834 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbhFNLIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 07:08:22 -0400
Received: from [IPv6:2003:e9:d709:46c5:895f:5712:ed71:b02d] (p200300e9d70946c5895f5712ed71b02d.dip0.t-ipconnect.de [IPv6:2003:e9:d709:46c5:895f:5712:ed71:b02d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id DBADFC0209;
        Mon, 14 Jun 2021 13:06:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1623668770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nXlKb7AF6abmep/OhK+3nloRQ3gBLLmiigWv8Q57llg=;
        b=Lx75bPvAIra2817vcWVhtTwrkg7l3HUIVn3Rd6WX5orjkbRABhKzh3eXXttqpuACJB5AZ3
        F6fX0V9qOvAekcNOIADzBbwzXWGAzY8DaIa4f5Uw9sX2+EbuZpDqCsocM3YoLx04CK+wrb
        WrtbxHkuGYlS8aA0YDe71zInk3RD3Rwf+R0PdJXw8flCA9tbpS3KhEYQCxXJF2jIcoHMTl
        ZENHfUZEMYpz1HPrBmBIWqkRu3VKdQ5hMfRHnZ+5RXwJEUx/bIqX8yRIpp5GRk2fmUl+NV
        MAGGqfx8A4mtXmqaW1s3ST1/6kwBejSMvU3w2sHbWltlgPxhAbSs6/QozatMAA==
Subject: Re: [PATCH] ieee802154: hwsim: Fix possible memory leak in
 hwsim_subscribe_all_others
To:     Alexander Aring <alex.aring@gmail.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <20210611015812.1626999-1-mudongliangabcd@gmail.com>
 <CAB_54W4djgY19-z8Pr9A4FgECDTESwjprk-P-x4gQCLBxvt3xA@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <eeb3625c-7308-7cec-351e-7ebbf7affff4@datenfreihafen.org>
Date:   Mon, 14 Jun 2021 13:06:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAB_54W4djgY19-z8Pr9A4FgECDTESwjprk-P-x4gQCLBxvt3xA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 12.06.21 14:49, Alexander Aring wrote:
> Hi,
> 
> On Thu, 10 Jun 2021 at 21:58, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>>
>> In hwsim_subscribe_all_others, the error handling code performs
>> incorrectly if the second hwsim_alloc_edge fails. When this issue occurs,
>> it goes to sub_fail, without cleaning the edges allocated before.
>>
>> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
>> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>
> 
> sorry, it is a correct fix. Thanks.


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
