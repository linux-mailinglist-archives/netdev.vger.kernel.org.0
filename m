Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D10843D30B
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243977AbhJ0Uoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:44:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53558 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243997AbhJ0Uov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:44:51 -0400
Received: from usagi.middle.earth (ethbase.usagi.not.afront.org [IPv6:2620:137:e001:0:1897:4108:901b:c660])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E25DF4F66417C;
        Wed, 27 Oct 2021 13:42:17 -0700 (PDT)
Subject: Re: Unsubscription Incident
To:     Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     Slade Watkins <slade@sladewatkins.com>,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com>
 <YXY15jCBCAgB88uT@d3>
 <CA+pv=HPyCEXvLbqpAgWutmxTmZ8TzHyxf3U3UK_KQ=ePXSigBQ@mail.gmail.com>
 <61f29617-1334-ea71-bc35-0541b0104607@pensando.io>
 <20211027123408.0d4f36f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   John 'Warthog9' Hawley <warthog9@eaglescrag.net>
Openpgp: preference=signencrypt
Message-ID: <61e27841-5ceb-1975-ab3b-abdf8973c9f2@eaglescrag.net>
Date:   Wed, 27 Oct 2021 13:42:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211027123408.0d4f36f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 27 Oct 2021 13:42:18 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/21 12:34 PM, Jakub Kicinski wrote:
> On Mon, 25 Oct 2021 11:34:28 -0700 Shannon Nelson wrote:
>>>> It happened to a bunch of people on gmail:
>>>> https://lore.kernel.org/netdev/1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com/t/#u  
>>> I can at least confirm that this didn't happen to me on my hosted
>>> Gmail through Google Workspace. Could be wrong, but it seems isolated
>>> to normal @gmail.com accounts.
>>>
>>> Best,
>>>               -slade  
>>
>> Alternatively, I can confirm that my pensando.io address through gmail 
>> was affected until I re-subscribed.
> 
> Did it just work after re-subscribing again? Without cleaning the inbox?
> John indicated off list that Gmail started returning errors related to
> quota, no idea what that translates to in reality maybe they added some
> heuristic on too many emails from one source?

At least for the users I've had anyone mention to me (which for the
record apparently this happened on the 11th, and people are only
reaching out now about), the reasons for the unsubscribe was that the
upstream servers were reporting that the users in question were over
quota permanently.  We take that hinting at face value, and since the
server is telling us (basically) that the user isn't going to be
accepting mail anytime soon, we go ahead and unsubscribe them and clear
the queue so that the users don't cause unnecessary back log.  Noting,
this is an automated process that runs and deals with this that runs
periodically.

Also noting, that there's not a good way to notify individuals when this
happens because, unsurprisingly, their email providers aren't accepting
mail from us.

If folks reach out to postmaster@ I'm more than happy to take a look at
the 'why' something happened, and I'm happy to re-subscribe folks in the
backend saving them the back and forth with majorodomo's command system.

If I had to speculate, something glitched at gmail, a subset of users
got an odd error code returned (which likely wasn't the correct error
code for the situation, and noting the number of affected users is
fairly small given the number of users from gmail that are subscribed).
 Likely similar to when gmail had that big outage and it reported
something way off base and as a result every gmail user got unsubscribed
(and subsequently resubscribed in the backend by me when the outage was
over).

- John 'Warthog9' Hawley
