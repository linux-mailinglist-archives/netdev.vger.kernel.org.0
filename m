Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F7E220D81
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731344AbgGOM5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:57:05 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:47314 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731193AbgGOM5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:57:04 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DAC7860054;
        Wed, 15 Jul 2020 12:57:03 +0000 (UTC)
Received: from us4-mdac16-19.ut7.mdlocal (unknown [10.7.65.243])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D8E312009B;
        Wed, 15 Jul 2020 12:57:03 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.199])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 428AB220059;
        Wed, 15 Jul 2020 12:57:03 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AE4BA18005C;
        Wed, 15 Jul 2020 12:57:02 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 15 Jul
 2020 13:56:57 +0100
Subject: Re: [RFC] bonding driver terminology change proposal
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, Jarod Wilson <jarod@redhat.com>
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz>
 <20200713154118.3a1edd66@hermes.lan>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <e515b840-c6f1-bc07-9369-c95e352573b2@solarflare.com>
Date:   Wed, 15 Jul 2020 13:56:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200713154118.3a1edd66@hermes.lan>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25542.003
X-TM-AS-Result: No-0.579800-8.000000-10
X-TMASE-MatchedRID: 0dFPYP4mu5RqJ1y0VLNhDudNi+0D4LmKiqCjW9swDxLk1kyQDpEj8AQ9
        n8U23GDfKUwQqjfwoPu3U0269csg/M3FNToAKymtZdorcofH/GkZSo6PM4LsipTEsxwAmHMKMFd
        dv+pLbrc5NGlKD0XZ6yRPmj8a2XhZ5Wx142l2+L/TzWmGCXkX+X01kx2nmbm+5y4de7Rh0xqjCB
        cNmUxr3E6SiAvF+7NDxOXIQGXwOUSg55FxP4iWsVD5LQ3Tl9H7jIW07F8rFN+AOGCpibw+mGeOl
        PXKNa/qLdzlgoDRKkiIRuUyGe19WjyiuyvdUmaIndu3heVAxaPcKg1KuXSMccBIEjzZTOUNiYOY
        r0xK836s/AATyx6tAPj+q43GrOGitCUKfxFPSAUsisyWO3dp28iRuLC8ilKQe7ijHq7g9oYIT9S
        GkZdz8KgtFVlNkavT4fVLSna0NDsiDrsceLMV4W/cQcw0FIMYfS0Ip2eEHnzWRN8STJpl3PoLR4
        +zsDTtF/a6QWbgQ22X2Ke7NbrCuRuXcQ8/x31RI3HdRysKG7QlGPhOmoCyyHnljlE6tMY7G45pe
        6ddGMbkq5r9MqSaJNanJqzpETIz6uGEplOoFRtR029mOM6P0LrcE8xytxC5d5hZXZFoB8P6SR/o
        eE+wFw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.579800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25542.003
X-MDID: 1594817823-uq1VMsMk8s5O
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once again, the opinions below are my own and definitely do not
 represent anything my employer would be seen dead in the same
 room as.

On 13/07/2020 23:41, Stephen Hemminger wrote:
> As far as userspace, maybe keep the old API's but provide deprecation nags.
Why would you need to deprecate the old APIs?
If the user echoes 'slave' into some sysfs file (or whatever), that
 indicates that they don't have any problem with using the word.
So there's no reason toever remove that support — its _mere
 existence_ isn't problematic for anyone not actively seeking to be
 offended.
Which I think is more evidence that this change is not motivated by
 practical concerns but by a kind of performative ritual purity.

This is dumb.  I suspect you all, including Jarod, know that this
 is dumb, but you're either going along with it or keeping your
 head down in the hope that it will all blow over and you can go
 back to normal.  Unfortunately, it doesn't work like that; the
 activists who push this stuff are never satisfied; making
 concessions to them results not in peace but in further demands;
 and just as the corporations today are caving to the current
 demands for fear of being singled out by the mob, so they will
 cave again to the next round of demands, and you'll be back in
 the same position, trying to deal with bosses wanting you to
 break uAPI without even a technical reason.
And next time around, the mob will be bolder and the bosses more
 pliant, because by giving in this time we'll have signalled that
 we're weak and easily dominated.  I would advise anyone still in
 doubt of this point to read Kipling's poem "Dane-geld".
And we'll all be left wondering why kernel development is so
 soulless and joyless that no-one, of _any_ colour, aspires to
 become a kernel hacker any more.

It's not too late to stop the crazy, if we all just stop
 pretending it's sane.

-ed
