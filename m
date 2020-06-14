Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD9F1F8772
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 09:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgFNHPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 03:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgFNHPk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 03:15:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0C9620747;
        Sun, 14 Jun 2020 07:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592118940;
        bh=L9AfSSTBubpQfdQR/vJSPzKQJFvcWlmqrQMK1lj9rqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wgfJuP09nhgfIBJTYFkj9RIcEhuXPgT2CvBexhNow4MH70MeLUCa2Q/s7xKDwgQpG
         g6vrBivlj3pvZiNYhpgObR7uku816Yy9gp80WEQbkVWINtrHqX9aXyhFm8YXumqTGd
         oqAQtt4UXw38pa6VY+aiPjZ70LGs00PQJRNQALZA=
Date:   Sun, 14 Jun 2020 09:15:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Aditya Pakki <pakki001@umn.edu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Kangjie Lu <kjlu@umn.edu>, Qiushi Wu <wu000273@umn.edu>
Subject: Re: [PATCH] test_objagg: Fix memory leak in test_hints_case()
Message-ID: <20200614071535.GF2629255@kroah.com>
References: <d248479f-7209-d8f8-6270-0580351d606a@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d248479f-7209-d8f8-6270-0580351d606a@web.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 13, 2020 at 08:36:36AM +0200, Markus Elfring wrote:
> > … The patch fixes this issue.
> 
> I propose to replace this information by the tag “Fixes”.
> Please choose another imperative wording for your change description.
> 
> Regards,
> Markus

Hi,

This is the semi-friendly patch-bot of Greg Kroah-Hartman.

Markus, you seem to have sent a nonsensical or otherwise pointless
review comment to a patch submission on a Linux kernel developer mailing
list.  I strongly suggest that you not do this anymore.  Please do not
bother developers who are actively working to produce patches and
features with comments that, in the end, are a waste of time.

Patch submitter, please ignore Markus's suggestion; you do not need to
follow it at all.  The person/bot/AI that sent it is being ignored by
almost all Linux kernel maintainers for having a persistent pattern of
behavior of producing distracting and pointless commentary, and
inability to adapt to feedback.  Please feel free to also ignore emails
from them.

thanks,

greg k-h's patch email bot
