Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE3019DF55
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 22:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgDCU1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 16:27:06 -0400
Received: from haggis.mythic-beasts.com ([46.235.224.141]:58843 "EHLO
        haggis.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgDCU1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 16:27:06 -0400
Received: from [2001:678:634:203:cf83:32c6:10b8:3403] (port=38206)
        by haggis.mythic-beasts.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <code@timstallard.me.uk>)
        id 1jKSu8-0006eC-2L; Fri, 03 Apr 2020 21:27:04 +0100
Subject: Re: [PATCH net] net: icmp6: add icmp_errors_use_inbound_ifaddr sysctl
 for IPv6
To:     David Miller <davem@davemloft.net>
References: <20200331231706.14551-1-code@timstallard.me.uk>
 <20200402.175502.2304965794103611918.davem@davemloft.net>
From:   Tim Stallard <code@timstallard.me.uk>
Autocrypt: addr=code@timstallard.me.uk; keydata=
 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
 NAAvmw==
Cc:     netdev@vger.kernel.org
Message-ID: <efcfe4b8-bbd1-bf4f-2f88-3e3e0d49f67a@timstallard.me.uk>
Date:   Fri, 3 Apr 2020 21:26:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200402.175502.2304965794103611918.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-BlackCat-Spam-Score: 0
X-Spam-Status: No, score=-0.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/04/2020 1:55 am, David Miller wrote
> Why don't we see if, explicitly, a source address was configured on
> the route rather than us using a default saddr?  And in that case go
> back to the old behavior.

My original intention was to mirror the existing behaviour for IPv4 -
but yes, that approach seems more sensible. I've just submitted a patch
for it.
