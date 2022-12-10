Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD75E648F6F
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 16:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiLJP20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 10:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiLJP20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 10:28:26 -0500
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AA413E0A
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 07:28:24 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2BAFSFiF1559998;
        Sat, 10 Dec 2022 16:28:15 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2BAFSFiF1559998
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1670686096;
        bh=ycG5A4w37ZuQvAMEx6qr+o0mAH7EGnlee9ZMbaduZSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nl/AJWfpSSc1GmNj+oqyevD/Q6EVyL312Wlf1u3chTppKrs/ZJW2bVhfJOxAn5w3p
         OcZTHaWqWXxggxmOttl2BAraKYwovQP7bTZJ1haSYfZHrX39DocV9DbdIQXUvGYQW9
         /0u3yhN4Lu5TDZgtaZjxtpnxUjvHIt9A1AAyWXtI=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2BAFSEtJ1559997;
        Sat, 10 Dec 2022 16:28:14 +0100
Date:   Sat, 10 Dec 2022 16:28:14 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Dave Taht <dave.taht@gmail.com>, David Ahern <dsahern@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: iproute2 - one line mode should be deprecated?
Message-ID: <Y5SljoNciDZmitBS@electric-eye.fr.zoreil.com>
References: <20221209101318.2c1b1359@hermes.local>
 <CAA93jw56DJKuP+yVim4Hq8UJs9gMJgew_4czNNW+obL3WZ7puA@mail.gmail.com>
 <f11a6a89-8fef-e67a-7d54-0058dee84b0b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f11a6a89-8fef-e67a-7d54-0058dee84b0b@gmail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> :
> On 12/9/22 11:16 AM, Dave Taht wrote:
> > I'm terribly old-fashioned myself and still use one-line mode, and the
> > kinds of scripts I use still use awk. I may be the last one standing
> > here...
> > 
> 
> I use oneline a lot as well for a quick list of netdevs and network
> addresses.

Either that or diff as well as socket list ('ss') here.

I'm probably < 50 vs > 50 between plain 'ss' output + masochistic awk
and one line output + gory grep/sed/cut ('ss' does not even produce
json).

'ss' oneline output option differs from 'ip' one: it does not help using
either imho :o/

Deprecation then removal won't hurt me.

-- 
Ueimor
