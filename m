Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300F028D8A8
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 04:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgJNCq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 22:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727373AbgJNCq2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 22:46:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A68721775;
        Wed, 14 Oct 2020 02:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602643587;
        bh=PAAun9qZtcMnwHhRYDJ0GGq9ao3+kGi4K7cdlmWBKX8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wqUHOEyX/cFjRI/bTbuvusKroIF5tNJO9BwQ8gw8iZf1yxnq2YnrBQhKCY9BkFE9k
         H1CRY74EBLtqrv2m03j3VY9PUUPXrJDqHD0VPQjbZuCmvCszRveNsVEYAAin3lNNIz
         ztkMuFOLPcalohQ1B4b4W6X75SUFlgEyG0xS+5zY=
Date:   Tue, 13 Oct 2020 19:46:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next v2 0/2][pull request] 40GbE Intel Wired LAN Driver
 Updates 2020-10-12
Message-ID: <20201013194626.680c01fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012181346.3073618-1-anthony.l.nguyen@intel.com>
References: <20201012181346.3073618-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 11:13:44 -0700 Tony Nguyen wrote:
> This series contains updates to i40e and e1000 drivers.
> 
> Jaroslaw adds support for changing FEC on i40e if the firmware supports it.
> 
> Jesse fixes a kbuild-bot warning regarding ternary operator on e1000. 
> 
> v2: Return -EOPNOTSUPP instead of -EINVAL when FEC settings are not
> supported by firmware. Remove, unneeded, done label and return errors
> directly in i40e_set_fec_param() for patch 1. Dropped, previous patch 2,
> to send to net. 

Applied, thanks!
