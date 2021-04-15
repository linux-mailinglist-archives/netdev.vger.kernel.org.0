Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF22236106B
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhDOQvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:51:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhDOQu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 12:50:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7D6F61166;
        Thu, 15 Apr 2021 16:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618505436;
        bh=q+HcLknxpYi2hboqrHezr6fbm1sVu0UUBg+P1EE1tiU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A7tBRRap177ziJYEfavdETeWJUOkDBe8kFIiIXazvffDaeApa78RabefSp4TQfjBy
         j2JGeCZbCEfT9B1H9O4OHyZTICEeww3xi6ataAX4y3SGqDe2ZgMElU20FnfMOkIinN
         UAIPchGoc89ABOKipaqU2YJFQZQfiRK0DuZ4vY4FMjDke4TXDSdvB7oltjHzZdK6Go
         eKnRcyuMQ5pDaQLlrqX+x65AWtNWyjQWeJFQvlv5QEVUbz6pgcTW7FJu6KcL2KSv4D
         k7TscGPEYuZDGOATgjb4RWC4qQCgqrJJm3k2inn2kH1AT/xFCSQSzcDwO4qwQXKnRu
         Syajo+hq7U4aA==
Date:   Thu, 15 Apr 2021 09:50:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [net-next] enetc: convert to schedule_work()
Message-ID: <20210415095034.09a6bedc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210415053455.10029-1-yangbo.lu@nxp.com>
References: <20210415053455.10029-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 13:34:55 +0800 Yangbo Lu wrote:
> Convert system_wq queue_work() to schedule_work() which is
> a wrapper around it, since the former is a rare construct.
> 
> Fixes: 7294380c5211 ("enetc: support PTP Sync packet one-step timestamping")
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
