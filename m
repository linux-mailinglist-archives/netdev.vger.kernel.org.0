Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C99289C2B
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 01:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgJIXjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 19:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbgJIXgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 19:36:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A40D2222E;
        Fri,  9 Oct 2020 23:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602286599;
        bh=Jvxr+9LMEXmvfTkfbLCKuJ2KSDBhJcLzE/ZlVggUpig=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aAgXLDDg2OIbityeIxE/BN3t+WPA2SD7NNrvD6ybw9v+RT64wacmGARjzm9MFjFxH
         DjduEKM6htrgY9WFtIUAMrZ8DqcAMNbPUFjvXmXjZfWohUfgAZ0LBzZ9MFlbQsXvCN
         Fl5RqkqRPwqWIFy1QyfTQR/zk5N8OoY/7te9u/9o=
Date:   Fri, 9 Oct 2020 16:36:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Jaroslaw Gawin <jaroslawx.gawin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 1/3] i40e: Allow changing FEC settings on X722 if
 supported by FW
Message-ID: <20201009163638.6d4c76bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007231050.1438704-2-anthony.l.nguyen@intel.com>
References: <20201007231050.1438704-1-anthony.l.nguyen@intel.com>
        <20201007231050.1438704-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 16:10:48 -0700 Tony Nguyen wrote:
> +	if (hw->mac.type == I40E_MAC_X722 &&
> +	    !(hw->flags & I40E_HW_FLAG_X722_FEC_REQUEST_CAPABLE)) {
> +		netdev_err(netdev, "Setting FEC encoding not supported by firmware. Please update the NVM image.\n");
> +		return -EINVAL;

EOPNOTSUPP, since no FEC settings are supported by the device 
at the time of request.
