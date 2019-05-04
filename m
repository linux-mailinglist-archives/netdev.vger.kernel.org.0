Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2022313B33
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfEDQjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:39:18 -0400
Received: from mail.thelounge.net ([91.118.73.15]:46393 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfEDQjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:39:18 -0400
Received: from srv-rhsoft.rhsoft.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 44xF83757DzXQY;
        Sat,  4 May 2019 18:39:15 +0200 (CEST)
Subject: Re: CVE-2019-11683
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
References: <7a1c575b-b341-261c-1f22-92d656d6d9ae@thelounge.net>
 <0ca5c3b7-49e5-6fdd-13ba-4aaee72f2060@gmail.com>
 <f81bad23-97d5-1b2b-20a1-f29cfc63ff79@thelounge.net>
 <f84d6562-3108-df30-36f7-0580bd6ea4e2@gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Openpgp: id=9D2B46CDBC140A36753AE4D733174D5A5892B7B8;
 url=https://arrakis-tls.thelounge.net/gpg/h.reindl_thelounge.net.pub.txt
Organization: the lounge interactive design
Message-ID: <65007ac9-97f2-425e-66f4-3b552deb20ac@thelounge.net>
Date:   Sat, 4 May 2019 18:39:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f84d6562-3108-df30-36f7-0580bd6ea4e2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-CH
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 04.05.19 um 18:32 schrieb Eric Dumazet:
> On 5/4/19 12:13 PM, Reindl Harald wrote:
>>
>> ok, so the answer is no
>>
>> what's the point then release every 2 days a new "stable" kernel?
>> even distributions like Fedora are not able to cope with that
> 
> That is a question for distros, not for netdev@ ?

maybe, but the point is that we go in a direction where you have every 2
or 3 days a "stable" update up to days where at 9:00 AM a "stable" point
release appears at kernel.org and one hour later the next one from Linus
himself to fix a regression in the release an hour ago

release-realy-release-often is fine, but that smells like rush and
nobody downstream be it a sysadmin or a distribution can cope with that
when you are in a testing stage a while start deploy there are 2 new
releases with a long changelog

just because you never know if what you intended to deploy now better
should be skipped or joust go ahead because the next one a few days
later brings a regression and which ones are the regressions adn which
ones are the fixes which for me personally now leads to just randomly
update every few weaks
