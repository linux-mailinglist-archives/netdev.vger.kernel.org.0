Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74258263B4D
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 05:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgIJDUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 23:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgIJDUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 23:20:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51E3422209;
        Thu, 10 Sep 2020 00:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599699212;
        bh=ij30UWMMhcAJkdLuQtqNup0C06SemhqhqQPx0uL5psA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vf9AcQn8sCXGBd4EeYFHRteyADWM+Vprhtx3ARMMWEOhRFg2YKOFJwkopSXc11nd0
         LUZ+AIS3S+sRGDttApuLCWyvHXUnrDPKFiz/C9EcgWs5Ja1DorDTRcuGPP4EmL+DJA
         vbzzcoL9vlif382xFGpa4RJ6EECLxx6Hd3ZrTUTE=
Date:   Wed, 9 Sep 2020 17:53:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [net-next v4 1/5] devlink: check flash_update parameter support
 in net core
Message-ID: <20200909175330.00665135@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200909222653.32994-2-jacob.e.keller@intel.com>
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
        <20200909222653.32994-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Sep 2020 15:26:49 -0700 Jacob Keller wrote:
> +		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT)) {
> +			NL_SET_ERR_MSG_ATTR(info->extack, nla_component,
> +					    "component update is not supported");

If you need to respin for other reasons - ".. for this device"?
