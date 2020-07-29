Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF9F2327ED
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbgG2XQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:16:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbgG2XQG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 19:16:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 956012067D;
        Wed, 29 Jul 2020 23:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596064566;
        bh=HEhksm37C2LqlrQOg8kfMNy1as7m75lwe8lyTzhjhEk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FZS7rxOwXjJzlGHQ0+37DlD3WaH47TsEFD61mZRnRuL0+T26kp0JpEpKKhcbn5kfP
         84CxyXlafAKypd/9CplDWfmxhz86sXu4lpoQ3PFw5ebboNbQZ4skE+HtxUzO+fDk3z
         WQyvOILVJo5ekV2VaO5Ryyr4wSSR46jIXZDZH1MM=
Date:   Wed, 29 Jul 2020 16:16:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to
 flash update
Message-ID: <20200729161603.1aeeb5cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a0994590-f818-43cd-6c28-0cd628be9602@intel.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
        <20200717183541.797878-7-jacob.e.keller@intel.com>
        <20200720100953.GB2235@nanopsycho>
        <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200721135356.GB2205@nanopsycho>
        <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200722105139.GA3154@nanopsycho>
        <02874ECE860811409154E81DA85FBB58C8AF3382@fmsmsx101.amr.corp.intel.com>
        <20200722095228.2f2c61b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a0994590-f818-43cd-6c28-0cd628be9602@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jul 2020 15:49:05 -0700 Jacob Keller wrote:
> The security revision is tied into the management firmware image and
> would always be updated when an image is updated, but the minimum
> revision is only updated on an explicit request request.

Does it have to be updated during FW flashing? Can't it be a devlink
param?
