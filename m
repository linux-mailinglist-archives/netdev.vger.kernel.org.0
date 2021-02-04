Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D15A30EAFE
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhBDDeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 22:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234478AbhBDDeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 22:34:03 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C6DC061573;
        Wed,  3 Feb 2021 19:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=Dyu8cZeCdV6PkpUEQxxpmgbQNy767kTV8BXSItnpZnA=; b=yJpz9Kj2v6TMLAoYcPW6SFAO7n
        OStFZzriY/z5qsc2Z13mTztPKvwUTcQUQa2JW2bbhLJnLS/71N4clrhpJND0ejCzD+lz6JioGs1wZ
        3wBGbNT9U9KiGuO0HiOp90jzUsOYvkOCjGLnPKh4IKjvX//wgSel/p4SvLsAIAyECe9xSIrnPFryw
        N0m4Mu01xxgzR47YBnYjFIoAyURTtA6l9rOM/6Z15PKfosjzf5Vd7pOURkFDeTjss0uj984A9BmJx
        b8KY0PBHCx8kdUiUgIwjJfgA4yDz49lF8YdxpZpDyUN1R2Ama95uTHJM2w82RCpEzaMMfgakMTo8w
        qp93ckAA==;
Received: from [2601:1c0:6280:3f0::aec2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l7VOS-0006ta-3J; Thu, 04 Feb 2021 03:33:20 +0000
Subject: Re: [PATCH V2] drivers: net: ethernet: i825xx: Fix couple of
 spellings and get rid of blank lines too in the file ether1.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210204011821.18356-1-unixbhaskar@gmail.com>
 <bea4f9c4-b1bb-eab6-3125-bfe69938fa5b@infradead.org>
 <YBtcy8WPPSz6wCfO@Gentoo>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7e5dfce3-1343-4bad-1d64-b8f2eff8e2a6@infradead.org>
Date:   Wed, 3 Feb 2021 19:33:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <YBtcy8WPPSz6wCfO@Gentoo>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/21 6:32 PM, Bhaskar Chowdhury wrote:
> On 18:09 Wed 03 Feb 2021, Randy Dunlap wrote:
>> On 2/3/21 5:18 PM, Bhaskar Chowdhury wrote:
>>>
>>> s/initialsation/initialisation/
>>> s/specifiing/specifying/
>>>
>>> Plus get rid of few blank lines.
>>>
>>> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>>> ---
>>> Changes from V1:
>>>    Fix typo in the subject line
>>>    Give explanation of all the changes in changelog text
>>>
>>>  drivers/net/ethernet/i825xx/ether1.c | 9 +++------
>>>  1 file changed, 3 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
>>> index a0bfb509e002..850ea32091ed 100644
>>> --- a/drivers/net/ethernet/i825xx/ether1.c
>>> +++ b/drivers/net/ethernet/i825xx/ether1.c
>>
>> a. don't delete the blank lines
>> b. the change below is not described and does not change any whitespace AFAICT.
>>   I.e., DDT [don't do that].
>>
> But what do you do when things getting automatically inducted in the
> patch???(You got to believe me)
> 
> I haven't had touch that bloody function with my keystroke and it gets it on
> its own! Bemusing!
> 
> Those blank lines too inducted from the fresh file(means in pristine form) ,so
> thought pruning would be good..hence the decision to get rid of those.
> 
> Wondering what the fuck is going on....

Yeah, it seems like you have had editor-doing-too-much-for-you issues before now...

-- 
~Randy

