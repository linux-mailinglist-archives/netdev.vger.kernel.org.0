Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7002B09A0
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgKLQMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 11:12:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbgKLQMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 11:12:34 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F8952085B;
        Thu, 12 Nov 2020 16:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605197554;
        bh=S3DED15DdhftiCDicms1yyB5w94yipk0Rb9seTjbqPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F+RuezPCOuEN4TcLA9/qG9zCvBdO2hPmW+sdhrEmxjIm8mTV0eevqDa1RVmWFPz4o
         UNLfJ6tpvymTPdZpQYaV4dhCXjFWTOVcOfkQSUlXhEEkm66ULUqhOPH4ARFLPOSrNL
         UIthQBNjKjeSJDIdv54PR5zM9UIstsV6TX17MQMk=
Date:   Thu, 12 Nov 2020 11:12:32 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        stable <stable@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, linux-gpio@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [4.9] Security fixes (pinctrl, i40e, geneve)
Message-ID: <20201112161232.GD403069@sasha-vm>
References: <add9899fca821cbe47025c7710ebb63e9c16597c.camel@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <add9899fca821cbe47025c7710ebb63e9c16597c.camel@codethink.co.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 02:10:27AM +0000, Ben Hutchings wrote:
>Here are backports of some fixes to the 4.9 stable branch.
>
>I wasn't able to test the pinctrl fix (no idea how to reproduce it).
>
>I wasn't able to test the i40e changes (no hardware and no reproducer
>available).
>
>I tested the geneve fix with libreswan as (roughly) described in the
>commit message.

Queued up, thanks Ben!

-- 
Thanks,
Sasha
