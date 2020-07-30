Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93635233C1E
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbgG3X1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbgG3X1F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 19:27:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F512083B;
        Thu, 30 Jul 2020 23:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596151625;
        bh=F+6sr4a9ENeUpbzHVuys/GfcQn3qHZZVaSVXM459RU4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hGlCKfSztopYhZ70/TUP6rgMuDOdyx4r8Vl6HqWLIa9gqwqcYOBQn5+eJo5l33x/u
         Xg9NeH0G+JsEOfZ3Q81s3OxCuFKxE1ljBeICpoPR0ahpWGMHjtYEyQZUjE6Zu7b9mY
         aonU+zi7FEVUgq75/iimQsusglHsLsNNp8rGWJkI=
Date:   Thu, 30 Jul 2020 16:27:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com
Subject: Re: [net 0/2][pull request] Intel Wired LAN Driver Updates
 2020-07-30
Message-ID: <20200730162703.277cc07b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200730170938.3766899-1-anthony.l.nguyen@intel.com>
References: <20200730170938.3766899-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020 10:09:36 -0700 Tony Nguyen wrote:
> This series contains updates to the e1000e and igb drivers.
> 
> Aaron Ma allows PHY initialization to continue if ULP disable failed for
> e1000e.
> 
> Francesco Ruggeri fixes race conditions in igb reset that could cause panics. 

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

In the future please try to add Fixes tags on all net submissions
(patch 2). Also - are similar fixes for other Intel drivers in the
works?
