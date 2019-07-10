Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC6E640D4
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 07:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfGJF4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 01:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbfGJF4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 01:56:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B65F720838;
        Wed, 10 Jul 2019 05:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562738191;
        bh=V9iaENcRfclKrRlxtMr6FYwVEOvk/HuSF0jjt+eARO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iUi3f2iayn9lfkE/YOYo0Yov3kvzO7+KOEyaS9Fml7JycwWRssHNDg7wVhtU5esPw
         EoM52iaiWfmiaPubKM1oCY3H+8qeExOy+hWruR3E06hQYBobvtIjycEbSPoCRnbB/Z
         +wlk3mSulTMRn5+41mKp91hHlSbguwHX7MgqGniE=
Date:   Wed, 10 Jul 2019 07:56:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     adobriyan@gmail.com, akpm@linux-foundation.org,
        anna.schumaker@netapp.com, arjan@linux.intel.com,
        bfields@fieldses.org, chuck.lever@oracle.com, davem@davemloft.net,
        jlayton@kernel.org, luto@kernel.org, mingo@kernel.org,
        Nadia.Derbey@bull.net, paulmck@linux.vnet.ibm.com,
        semen.protsenko@linaro.org, stable@kernel.org,
        stern@rowland.harvard.edu, tglx@linutronix.de,
        torvalds@linux-foundation.org, trond.myklebust@hammerspace.com,
        viresh.kumar@linaro.org, vvs@virtuozzo.com,
        alex.huangjianhui@huawei.com, dylix.dailei@huawei.com,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/3] kernel/notifier.c: avoid duplicate registration
Message-ID: <20190710055628.GB5778@kroah.com>
References: <1562728147-30251-1-git-send-email-nixiaoming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562728147-30251-1-git-send-email-nixiaoming@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 11:09:07AM +0800, Xiaoming Ni wrote:
> Registering the same notifier to a hook repeatedly can cause the hook
> list to form a ring or lose other members of the list.

Then don't do that :)

Is there any in-kernel users that do do this?  If so, please just fix
them.

thanks,

greg k-h
