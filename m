Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B11213B3E
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfEDQrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:47:48 -0400
Received: from mail.thelounge.net ([91.118.73.15]:27655 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfEDQrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:47:48 -0400
Received: from srv-rhsoft.rhsoft.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 44xFKt1tZjzXQW;
        Sat,  4 May 2019 18:47:46 +0200 (CEST)
Subject: Re: CVE-2019-11683
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
References: <7a1c575b-b341-261c-1f22-92d656d6d9ae@thelounge.net>
 <0ca5c3b7-49e5-6fdd-13ba-4aaee72f2060@gmail.com>
 <f81bad23-97d5-1b2b-20a1-f29cfc63ff79@thelounge.net>
 <f84d6562-3108-df30-36f7-0580bd6ea4e2@gmail.com>
 <65007ac9-97f2-425e-66f4-3b552deb20ac@thelounge.net>
 <b29aea5d-930e-778a-1627-1bfd85cbe849@gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Openpgp: id=9D2B46CDBC140A36753AE4D733174D5A5892B7B8;
 url=https://arrakis-tls.thelounge.net/gpg/h.reindl_thelounge.net.pub.txt
Organization: the lounge interactive design
Message-ID: <c22a5cdf-c752-c03a-a9ed-d3f8f4b25b98@thelounge.net>
Date:   Sat, 4 May 2019 18:47:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b29aea5d-930e-778a-1627-1bfd85cbe849@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-CH
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 04.05.19 um 18:43 schrieb Eric Dumazet:
> In any case, this discussion has nothing to do with netdev@
> 
> Are you suggesting that we should not fix bugs at given period of times,
> just because a 'release of some stable kernel' happened one day before?

sorry to get cynical but that's likely the reason the fix for conncount
panics (https://bugzilla.kernel.org/show_bug.cgi?id=202065) took from
2018-12-28 to 2019-01-29 making it in any release while every kernel
from 4.19.0 to 4.20.4 was just fucked up terrible
