Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B496E688715
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbjBBSuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbjBBSuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:50:07 -0500
X-Greylist: delayed 348 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 02 Feb 2023 10:50:05 PST
Received: from mail.aperture-lab.de (mail.aperture-lab.de [IPv6:2a01:4f8:c2c:665b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A2316327
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:50:05 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id E5C9D417DD;
        Thu,  2 Feb 2023 19:44:09 +0100 (CET)
Date:   Thu, 2 Feb 2023 19:44:06 +0100
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Simon Wunderlich <sw@simonwunderlich.de>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
Message-ID: <Y9wEdn1MJBOjgE5h@sellars>
References: <20230127102133.700173-1-sw@simonwunderlich.de>
 <20230127102133.700173-2-sw@simonwunderlich.de>
 <Y9faTA0rNSXg/sLD@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9faTA0rNSXg/sLD@nanopsycho>
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 03:55:08PM +0100, Jiri Pirko wrote:
> Fri, Jan 27, 2023 at 11:21:29AM CET, sw@simonwunderlich.de wrote:
> >This version will contain all the (major or even only minor) changes for
> >Linux 6.3.
> >
> >The version number isn't a semantic version number with major and minor
> >information. It is just encoding the year of the expected publishing as
> >Linux -rc1 and the number of published versions this year (starting at 0).
> 
> I wonder, what is this versioning good for?

The best reason in my opinion is that it's useful to convince
ordinary people that they should update :-).

Usually when debugging reported issues one of the first things we ask
users is to provide the output of "batctl -v":

```
$ batctl -v
batctl debian-2023.0-1 [batman-adv: 2022.3]
```

If there is a very old year in there I think it's easier to tell
and convince people to try again with newer versions and to
update.

And also as a developer I find it easier to (roughly) memorize
when a feature was added by year than by kernel version number.
So I know by heart that TVLVs were added in 2014 and multicast
snooping patches and new multicast handling was added around 2019
for instance. But don't ask me which kernel version that was :D.
I'd have to look that up. So if "batctl -v" displayed a kernel
version number that would be less helpful for me.

Also makes it easier for ordinary users to look up and
compare their version with our news archive:
https://www.open-mesh.org/projects/open-mesh/wiki/News-archive

Also note that we can't do a simple kernel version to year
notation mapping in userspace in batctl. OpenWrt uses the most
recent Linux LTS release. But might feature a backport of a more
recent batman-adv which is newer than the one this stable kernel
would provide. Or people also often use Debian stable but compile
and use the latest batman-adv version with it.

Does that make sense?
