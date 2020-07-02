Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD03B211761
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgGBAq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbgGBAq0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 20:46:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ED7720748;
        Thu,  2 Jul 2020 00:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593650786;
        bh=gpSFlKIRQhGy9Pcff5rGyW49xRTs44UEmc7xVqaH0aY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tb5r0O2FyFMvnDPjOsPuFO9XN5emL54dmwQDUBvPETXtwe7za37wRLfC6LJ60ZCt6
         K5Ydq91U9W4K0ZbECJiL+11xNSXRAk3aD6G6nMMfCKXeD8/u+E+DXQ8zbLWd5y7zUI
         O5KbpiJbtno8hnxrLtwJXD3WrAjmh1f8/1yfQ19o=
Date:   Wed, 1 Jul 2020 17:46:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Wei Yongjun <weiyongjun1@huawei.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 03/12] iavf: fix error return code in
 iavf_init_get_resources()
Message-ID: <20200701174624.7d5238de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200701223412.2675606-4-anthony.l.nguyen@intel.com>
References: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
        <20200701223412.2675606-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  1 Jul 2020 15:34:03 -0700 Tony Nguyen wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Fix to return negative error code -ENOMEM from the error handling
> case instead of 0, as done elsewhere in this function.
> 
> Fixes: b66c7bc1cd4d ("iavf: Refactor init state machine")

This commit is in net..

> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
