Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB242656B1
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgIKBeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:34:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgIKBeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:34:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A11A7208FE;
        Fri, 11 Sep 2020 01:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599788046;
        bh=Pl8J4qofYLsVjEdHM0tm8W6Jfx0LLfHzIF3cpbOB2Rg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gPYiS7rDBT6Q9/zc2u71cBI3Dium+pAWCcbaDXXfMxKMDeu8E6mRQ0ES2S79qEVob
         6tBlz6i2R+F+jr7O/qFDuxS67Jzs8AdLO8dPRRz5YJUoDhoQRToExvx5Lpyv63Wpxl
         4KveTBzRx80JDmKk+FCp/PcDUKg4Qdko39XvDqEI=
Date:   Thu, 10 Sep 2020 18:34:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [net-next v5 3/5] devlink: introduce flash update overwrite
 mask
Message-ID: <20200910183405.16bbfe34@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200910183229.72b808f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200910212812.2242377-1-jacob.e.keller@intel.com>
        <20200910212812.2242377-4-jacob.e.keller@intel.com>
        <20200910183229.72b808f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 18:32:29 -0700 Jakub Kicinski wrote:
> On Thu, 10 Sep 2020 14:28:10 -0700 Jacob Keller wrote:
> > +#define DEVLINK_FLASH_OVERWRITE_SETTINGS BIT(DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT)
> > +#define DEVLINK_FLASH_OVERWRITE_IDENTIFIERS BIT(DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT)  
> 
> You got two more here.

Ah! FWIW I found the macro you can use instead: _BITUL(x)
Couldn't grep that one out yesterday.
