Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2DA25CC96
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbgICVqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgICVqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 17:46:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07F8720658;
        Thu,  3 Sep 2020 21:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599169561;
        bh=rJoJ3cZq7T9HThm5ZEIJRn0LI/xBoOxKva2gLJGyqAU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q2z/CyRlKgkgq6xbGHdnKc7ZklXz48UpNU5LP+bcw6NRohjqA4B7rQZYKzoy1JDk6
         VDCkk+/ecZls9Kl2Ifbq+8VEwobOdgzF45Ssvri2qxuWkxSkn3NpOZolaGsjQl3u0C
         4M9pnA0gfr/+6nKmeRhS0g/s6BsfYde7RWFXZHJk=
Date:   Thu, 3 Sep 2020 14:45:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 2/2] ionic: add devlink firmware update
Message-ID: <20200903144559.4aae08f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bd395a37-92b1-8d5f-eea5-66bb82a02e94@pensando.io>
References: <20200902195717.56830-1-snelson@pensando.io>
        <20200902195717.56830-3-snelson@pensando.io>
        <20200903125350.4bc345e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bd395a37-92b1-8d5f-eea5-66bb82a02e94@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 14:37:40 -0700 Shannon Nelson wrote:
> On 9/3/20 12:53 PM, Jakub Kicinski wrote:
> > On Wed,  2 Sep 2020 12:57:17 -0700 Shannon Nelson wrote:  
> >> Add support for firmware update through the devlink interface.
> >> This update copies the firmware object into the device, asks
> >> the current firmware to install it, then asks the firmware to
> >> set the device to use the new firmware on the next boot-up.  
> > Activate sounds too much like fw-active in Moshe's patches.
> >
> > Just to be clear - you're not actually switching from the current
> > FW to the new one here, right?

Please answer this.

> > If it's more analogous to switching between flash images perhaps
> > selecting would be a better term?
> >  
> >> The install and activate steps are launched as asynchronous
> >> requests, which are then followed up with status requests
> >> commands.  These status request commands will be answered with
> >> an EAGAIN return value and will try again until the request
> >> has completed or reached the timeout specified.  
> 
> I think I can find a way to reword that - perhaps "enable" would be 
> better than "activate"?

I was saying "select". But "enable" is fine.
