Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2833EAA5F
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 20:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbhHLSlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 14:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbhHLSlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 14:41:19 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2198C061756;
        Thu, 12 Aug 2021 11:40:53 -0700 (PDT)
Received: from [192.168.178.156] (unknown [80.156.89.114])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 67417C0387;
        Thu, 12 Aug 2021 20:40:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1628793650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AY4PY3hsTxQYLKMCNMgERORhXj9ryGg51SKjqgp+oYA=;
        b=Yz7u0REUaockDMH+hWveERojN1g6bW6PQOEylmpBv7vnqi+oRGq+1UvY2PzZ1PfsN3bmEK
        nb0lOhJk1HuUDPPyiFQjPW5Oir5crZAyyyp0feLndPE84ZXoL6AURCKib5AsBsHhKw5W5m
        t+It1BGUw8axQWAnEw3+QT3JMRyCtcbhS7XFcVR6O+ZXCqwQ9Ssyi6y7l7JMPRUFV34PMf
        vW9GhlAoWHAes0qaHe2ObNYIzLfkZGq28sxVvm0XOH413p2bh+Sxr0oC/G6/WPmYuCDpaV
        cXYPzB79MFE0xxtfBsd2CS3/tzM7zIckl+SkRdWqVCO17iBXvpPPVgJx/yb9yg==
Subject: Re: pull-request: ieee802154 for net 2021-08-11
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org
References: <20210811200417.1662917-1-stefan@datenfreihafen.org>
 <20210812091651.593afc12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <0e8ccc65-86d9-433f-a93f-3c99d7036354@datenfreihafen.org>
Date:   Thu, 12 Aug 2021 20:40:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210812091651.593afc12@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 12.08.21 18:16, Jakub Kicinski wrote:
> On Wed, 11 Aug 2021 22:04:17 +0200 Stefan Schmidt wrote:
>> Stefan Schmidt (1):
>>        Merge remote-tracking branch 'net/master' into merge-test
> 
> Hi Stefan, would it be possible to toss this Merge commit and resubmit?
> I don't think it's a common practice to merge the target tree before
> submitting a PR?

Its not and it was an error on my side (starting my pull script from the 
branch where I tested the merge for conflicts).

Fixed now and send a new PR.

regards
Stefan Schmidt
