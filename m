Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612E1221207
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgGOQLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgGOQLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:11:44 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E9E9C061755;
        Wed, 15 Jul 2020 09:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=ilGqLU0B6JSAMLnMU3a1AJslwpv+znvpmPHNeBrqY9I=; b=nAbB2/ewRCALtgBN9X4IK9wVcG
        iDB2wfvXXJWlU06VV46on4N8auBIpqaxqdp8GzE3O3aR8Y0YTdnQ8vpn9WX9Arh1ZnOhS2wyP7usN
        04izXTP3B9k0OeE+sPBsLQy3pWmwcxQc3DpSevLRr2k8D6TKK8wEAzwtcvTCYPs53ZG+PP64vYXdu
        XhMMrit8+l2pEM+3oE0eVmufUu9oP+EQ/V/Nk9UZaGyi8S1+3c5d1aMUiaMJdSKpBPbODcshZmK0/
        VUx/5wtnX6Wx30tPHP3mjvmeZm3K8PS8GdOhqY2yzooK5kHDxo+bs0fI/rNQSXT+v1tBdDFWt7yzL
        FM1gSljQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvk0S-0001M2-Dk; Wed, 15 Jul 2020 16:11:40 +0000
Subject: Re: [PATCH 01/13 net-next] net: nl80211.h: drop duplicate words in
 comments
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200715025914.28091-1-rdunlap@infradead.org>
 <20200715084811.01ba7ffd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d2b68464a9a7dd18ea39d1f1d483c8d4bc12c540.camel@sipsolutions.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <153e0d4f-645f-129d-f51c-d82f43e19b7e@infradead.org>
Date:   Wed, 15 Jul 2020 09:11:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <d2b68464a9a7dd18ea39d1f1d483c8d4bc12c540.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/20 9:06 AM, Johannes Berg wrote:
> On Wed, 2020-07-15 at 08:48 -0700, Jakub Kicinski wrote:
>> On Tue, 14 Jul 2020 19:59:02 -0700 Randy Dunlap wrote:
>>> Drop doubled words in several comments.
>>>
>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>> Cc: "David S. Miller" <davem@davemloft.net>
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Cc: netdev@vger.kernel.org
>>
>> Hi Randy, the WiFi stuff goes through Johannes's mac80211 tree.
> 
> It can go to you if you like, for this, I have no problem with that.
> Though I saw only the subject right now :)
> 
>> Would you mind splitting those 5 patches out to a separate series and
>> sending to him?

I found another net patch that I missed, so I will add that one
and also split the patches + resend.

> linux-wireless@vger.kernel.org would be most important in that case, so
> patchwork there picks it up.

Thanks.
-- 
~Randy

