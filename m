Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C39847F947
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 23:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhLZWVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 17:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbhLZWVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 17:21:24 -0500
Received: from mirix.in-vpn.de (mirix.in-vpn.de [IPv6:2001:67c:1407:a0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615E9C06173E;
        Sun, 26 Dec 2021 14:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mirix.org;
        s=43974b1a7d21b2cf; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7De30OQXHXn/EwHrALqoLTxxV5a/BJPIL1qEA+ZZFZw=; b=HlzBxIxra9A5qgDYiHoODsriNI
        5khyRlJdmCbnXzfK2nc4aXWvRMUh3AJMoO3wSFw/8McSepBm46UksH6odYkk0auBED7XlE6jdlJH8
        tLosoORDBhnu9104940r+nWV+zmL6ZFXSHdBA4vd/wbj6rlO4g92XRzc40RAEEttwDGGOIkrnio7o
        J2hN53jg5XxnqlcC0DG+YLiMIxPkFrbsA3TZevqVEANXA26DfoQf1WCQkgYo3mz7o8J8tMd2h5XmT
        hKBQWZny/5A6wcLamcnDXRH7UDqcZ7YVRiIPSHvNBe++gkPpgBxZXwvu0YnDxnGibbFjkOrb+ItRl
        SlDWp4XA==;
Received: from [::1] (helo=localhost.localdomain)
        by mirix.in-vpn.de with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim)
        id 1n1btJ-00065U-Gl; Sun, 26 Dec 2021 22:21:21 +0000
Subject: Re: [PATCH] net: usb: pegasus: Do not drop long Ethernet frames
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Petko Manolov <petkan@nucleusys.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211226132930.7220-1-ott@mirix.org> <YciMrJBDk6bA5+Nv@lunn.ch>
 <a87c4ea5-72ef-8dd3-de98-01f799d627ef@mirix.org> <YciY8Useao5hfIAF@lunn.ch>
From:   Matthias-Christian Ott <ott@mirix.org>
Message-ID: <e8c4c087-f6f1-eb41-e433-6a73264281b7@mirix.org>
Date:   Sun, 26 Dec 2021 23:21:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YciY8Useao5hfIAF@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/12/2021 17:31, Andrew Lunn wrote:
>>> I've nothing against this patch, but if you are working on the driver,
>>> it would be nice to replace these hex numbers with #defines using BIT,
>>> or FIELD. It will make the code more readable.
>>
>> Replacing the constants with macros is on my list of things that I want
>> to do. In this case, I did not do it because I wanted to a have small
>> patch that gets easily accepted and allows me to figure out the current
>> process to submit patches after years of inactivity.
> 
> Agreed, keep fixes simple.
> 
> A few other hints. If you consider this a fix which should be back
> ported, please add a Fixes: tag, where the issue started. This can be
> back as far as the first commit for the driver. Fixes should also be
> sent to the net tree, not net-next. See the netdev FAQ about the two
> different trees.

I made a v2 of the patch and also added the prefix flag to indicate that
the patch is destined for the "next" tree. There is still something that
can be improved a about it, please let me know. Otherwise, I will also
resend the other patch that I sent for the driver to indicate that it is
destined for the "next" tree.

Kind regards,
Matthias-Christian Ott
