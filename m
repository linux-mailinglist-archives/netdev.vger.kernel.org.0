Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B53745D15D
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236529AbhKXXtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:49:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:42402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236890AbhKXXtR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:49:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F05C760E73;
        Wed, 24 Nov 2021 23:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637797567;
        bh=n7a5oCksDgGhC3VtTl3Kf08mmayDH5Qn/tJNStOCQqE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=supXiW40RKLEubGKLo86wHTYnUqsBOPxOWRZ/zl5h41R0m0sTwqSUtuZ3CCc6i3yp
         HOcVtcE+OMF3R+1OM4QAzhbecJPLV+KTR6OpqyANwVPjSSgXQwUAhIpEoSA1jCc5l7
         eyruuP208volmpwWY6MS8A2qBY0yaRqaDn7GcbTqjxO5YWMsl8x46oOgZz+uJ3NKnz
         PmOk7Cf2c5MrF+Q2gDJbAsyVFFiylcwMeKNAuWsHZahJWalo+awpP1B850lG6Si0pC
         N/VAKIgISmhLxdLd1l1yojoQ3a8nfAL7ouYP2GQu0oq2qio6a4750B1bdm5pknFty1
         +Pf4jlyPP+CxQ==
Date:   Wed, 24 Nov 2021 15:46:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Patryk =?UTF-8?B?TWHFgmVr?= <patryk.malek@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: Re: [PATCH net-next 02/12] iavf: Add change MTU message
Message-ID: <20211124154606.47936e48@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124171652.831184-3-anthony.l.nguyen@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
        <20211124171652.831184-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 09:16:42 -0800 Tony Nguyen wrote:
> Add a netdev_info log entry in case of a change of MTU so that user is
> notified about this change in the same manner as in case of pf driver.

Why is this an important piece of information, tho? Other major vendors
don't print this.
