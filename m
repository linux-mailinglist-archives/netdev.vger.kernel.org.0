Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18F93ACD39
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbhFRON7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFRON6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 10:13:58 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80566C061574;
        Fri, 18 Jun 2021 07:11:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 1B3951280241;
        Fri, 18 Jun 2021 07:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1624025506;
        bh=4LBN5ONxoCRCcmkd/3TRY+Leu8+Z6eiVOBBAW6jThCc=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=ZOOaW8e7cDpvpBw4NDkdSQvvjKr3Tv3PpC3/84PPPXnDUohCTNaNIapIEV+QfwMMm
         MZ+qtKH6hkBXEtHHI9vrWTnL23mrzQhufRG7QTGP+P/f0yKe9SdYAMliHBYKYNy+lW
         0XkClXMLWyc+4x0i+eb5prohIqKqCYPH/QRUBqdU=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ef-HQXDtiAdB; Fri, 18 Jun 2021 07:11:46 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2D3291280021;
        Fri, 18 Jun 2021 07:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1624025505;
        bh=4LBN5ONxoCRCcmkd/3TRY+Leu8+Z6eiVOBBAW6jThCc=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=v5gjcRptKODpU0+TvxfBTk18Wz6cYOSQVqInEBg1CDw6wSl8BJsxg+4zb6b6L20t5
         Lf8hlOhryE6RTc778UvZDG1QLVK7TdwD1HsZ151o8S3/idPjYz1589NX7jhpLKl6ND
         PThgRTXDcqRWz6DK7IMwg9PXztNLVgRtFstqTJCE=
Message-ID: <cd7ffbe516255c30faab7a3ee3ee48f32e9aa797.camel@HansenPartnership.com>
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Hildenbrand <david@redhat.com>, Greg KH <greg@kroah.com>,
        Christoph Lameter <cl@gentwo.de>,
        Theodore Ts'o <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Date:   Fri, 18 Jun 2021 07:11:44 -0700
In-Reply-To: <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com>
References: <YIx7R6tmcRRCl/az@mit.edu>
         <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
         <YK+esqGjKaPb+b/Q@kroah.com>
         <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
         <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com>
         <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
         <20210610182318.jrxe3avfhkqq7xqn@nitro.local>
         <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
         <20210610152633.7e4a7304@oasis.local.home>
         <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
         <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-06-18 at 16:46 +0300, Laurent Pinchart wrote:
> For workshop or brainstorming types of sessions, the highest barrier
> to participation for remote attendees is local attendees not speaking
> in microphones. That's the number one rule that moderators would need
> to enforce, I think all the rest depends on it. This may require a
> larger number of microphones in the room than usual.

Plumbers has been pretty good at that.  Even before remote
participation, if people don't speak into the mic, it's not captured on
the recording, so we've spent ages developing protocols for this. 
Mostly centred around having someone in the room to remind everyone to
speak into the mic and easily throwable padded mic boxes.  Ironically,
this is the detail that meant we couldn't hold Plumbers in person under
the current hotel protocols ... the mic needs sanitizing after each
throw.

James


