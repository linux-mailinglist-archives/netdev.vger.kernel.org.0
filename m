Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6896244F7F
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 23:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgHNVT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 17:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbgHNVT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 17:19:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79308206C0;
        Fri, 14 Aug 2020 21:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597439968;
        bh=Uds0UuZUOC8U8hrnFzYiC+/V/2ep8mxcw2gDYQIP8O0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JsZCc2pN3H79G8mU5ZJoL6VhjPku9cknMw/imsqFJlhliq2ENNqAhBZrcsehLug6a
         2zbJ3CF4/WjumDmg3bhTY3b/vUfs85CtYpe2Nt16D2Dr4Xt3KhnRZfSe+RHQY+g7WG
         EZVYUbw5uHsq8tE4JDKyvY+Uadc+WD9t5oc5tw7o=
Date:   Fri, 14 Aug 2020 14:19:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net 2/3] i40e: Set RX_ONLY mode for unicast promiscuous on
 VLAN
Message-ID: <20200814141926.3a728c78@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200814203643.186034-3-anthony.l.nguyen@intel.com>
References: <20200814203643.186034-1-anthony.l.nguyen@intel.com>
        <20200814203643.186034-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Aug 2020 13:36:42 -0700 Tony Nguyen wrote:
> + * @hw: pointer to the hw struct
> + * @maj: api major value
> + * @min: api minor value

> +static bool i40e_is_aq_api_ver_ge(struct i40e_adminq_info *aq, u16 maj,
> +				  u16 min)

hw vs aq. Please build test the patches with W=1.
