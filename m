Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF03BF666
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 09:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhGHHnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 03:43:20 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:41792 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbhGHHnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 03:43:18 -0400
Received: from [IPv6:2003:e9:d72a:e927:359b:e3fc:a5d5:7a7a] (p200300e9d72ae927359be3fca5d57a7a.dip0.t-ipconnect.de [IPv6:2003:e9:d72a:e927:359b:e3fc:a5d5:7a7a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id ADE75C03B9;
        Thu,  8 Jul 2021 09:40:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1625730034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WzKCpAOxjZo2PkNwB1c0dcE+Sna2H3Vzrc3eOLIWS7c=;
        b=vdNL/lO4ZZ8bZNWvSEIvddi8fbi5lUmXJjPV5qBTGDzTzXhGo1eFAjrp2LheHrbd67keB9
        445yK7aGHMtzHyWSjmkiJWFfFuZ3nI+4++0johLEJ/zPXnki/PrbrVfj7d+SOAy0wrJFox
        XPH6Qp+LA9u/8pK6TrwKLKGR/9xECHI09bO/e5OXXM0Q+/8CI00G48Mla6nZLsbKFJhqgZ
        Que1p3rdZfOpSmu9Xjpt2pR0TvrTCdbF8sZx5DDM78LLmZaYLuLWfrI8MbNVIWpjc7mA9e
        DqZlUZr6+MQSo/j8ZrZH1yJuz6A9Dc6QhKRjBNVdA3kGyw6XRJLCc02DflgOoQ==
Subject: Re: [PATCH] ieee802154: hwsim: fix GPF in hwsim_new_edge_nl
To:     Alexander Aring <alex.aring@gmail.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
References: <20210707155633.1486603-1-mudongliangabcd@gmail.com>
 <CAB_54W5u9m3Xrfee8ywmWg7=aMB+Rx05w03kHfLuBpYVbxbEwQ@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <98ba898e-98ef-ac5d-d8d2-fb177d7fa73a@datenfreihafen.org>
Date:   Thu, 8 Jul 2021 09:40:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAB_54W5u9m3Xrfee8ywmWg7=aMB+Rx05w03kHfLuBpYVbxbEwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 08.07.21 01:34, Alexander Aring wrote:
> Hi,
> 
> On Wed, 7 Jul 2021 at 11:56, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>>
>> Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE
>> must be present to fix GPF.
>>
>> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
>> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
