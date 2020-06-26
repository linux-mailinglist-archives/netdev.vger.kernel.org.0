Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDD120B58B
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 18:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgFZQB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 12:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgFZQB1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 12:01:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D4362053B;
        Fri, 26 Jun 2020 16:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593187286;
        bh=4aiQ+kJwIQi1NH71ULMWjqP8CHDWYLHb7BYi03+Lq1g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OnLqdNWmg2NaKzgJ6oD9DQY2QEDCi9zVNv5mrYok2NyMGYtJG7br14eRnbHIz9Txb
         B1Zp8NS7jJHFpK+qmMZWYU+JMDOUkgNq18EqkGMe1rIDxVNepfVg79i/FsqYSNVRlh
         ZwTog4L/jks3Mh3kyGbS+j/oj4cUEaW1s646MyPc=
Date:   Fri, 26 Jun 2020 09:01:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     dan.carpenter@oracle.com, kbuild@lists.01.org,
        netdev@vger.kernel.org, lkp@intel.com, kbuild-all@lists.01.org,
        davem@davemloft.net
Subject: Re: [PATCH net-next] Fix unchecked dereference
Message-ID: <20200626090125.7ae41142@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626085435.6627-1-justin.iurman@uliege.be>
References: <20200625105237.GC2549@kadam>
        <20200626085435.6627-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020 10:54:35 +0200 Justin Iurman wrote:
> If rhashtable_remove_fast returns an error, a rollback is applied. In
> that case, an unchecked dereference has been fixed.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>

My bot says this doesn't apply to net-next, could you double-check?
