Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B8AF427
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 12:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfD3KYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 06:24:08 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:57539 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbfD3KYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 06:24:08 -0400
Received: from localhost.localdomain (p4FC2FAD0.dip0.t-ipconnect.de [79.194.250.208])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id B013BC8CB9;
        Tue, 30 Apr 2019 12:24:05 +0200 (CEST)
Subject: Re: pull-request: ieee802154 for net 2019-04-25
To:     David Miller <davem@davemloft.net>
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        netdev@vger.kernel.org
References: <20190425160311.19767-1-stefan@datenfreihafen.org>
 <20190429.182109.2278488103649846421.davem@davemloft.net>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <04de2423-65bb-debc-2a8f-addb401b006d@datenfreihafen.org>
Date:   Tue, 30 Apr 2019 12:24:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429.182109.2278488103649846421.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave.

On 30.04.19 00:21, David Miller wrote:
> From: Stefan Schmidt <stefan@datenfreihafen.org>
> Date: Thu, 25 Apr 2019 18:03:11 +0200
> 
>> An update from ieee802154 for your *net* tree.
>>
>> Another fix from Kangjie Lu to ensure better checking regmap updates in the
>> mcr20a driver. Nothing else I have pending for the final release.
>>
>> If there are any problems let me know.
> 
> Pulled, thanks Stefan.
> 
>> During the preparation of this pull request a workflow question on
>> my side came up and wonder if you (or some subsystem maintainer
>> sending you pull requests) does have a comment on this. The
>> ieee802154 subsystem has a low activity in the number of patches
>> coming through it. I still wanted to pull from your net tree
>> regularly to test if changes have implications to it. During this
>> pulls I often end up with merge of the remote tracking branch. Which
>> in the end could mean that I would have something like 3-4 merge
>> commits in my tree with only one actual patch I want to send over to
>> you. Feels and looks kind of silly to be honest.
>>
>> How do other handle this? Just merge once every rc? Merge just
>> before sending a pull request? Never merge, wait for Dave to pull
>> and merge and do a pull of his tree directly afterwards?
> 
> I would say never pull from the net tree until right after I pull your
> tree and thus you can do a clean fast-forward merge.

Thanks, I will try to work like this. Normally there should be no
overlap on ieee802154 patches I get that would need a newer pull from
net. Seems I was to eager to always work against your latest. :-)

I pulled now after your merge of my request and will do again after the
next. Will see how it will work out for me.

> If you want to test, right before you send me a pull request do a test
> pull into a local throw-away branch.

That is what I have been doing so far.

> Otherwise I'll handle conflicts and merge issues.

Thanks. When I see a merge conflict in my pre-pull-request testing I
will include my merge result in the pull request.

regards
Stefan Schmidt
