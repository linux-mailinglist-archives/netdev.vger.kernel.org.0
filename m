Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA4A233C99
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730906AbgGaAjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:39:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbgGaAja (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 20:39:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30EAF2074B;
        Fri, 31 Jul 2020 00:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596155970;
        bh=iroX4p9O4VFY7E6zUDbpOIF0/Eimnn0FRMlZ3dSM06A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uZLfpnGfT1qAPEKsWpSGbVoh2QHv4j3zYI4SfSBdKhh3Dn2c+sjTBYQUtBZKwC41E
         7L3rbtsuU9JIlUQQZFzOk6tx4nrLjBRs8LKDHgAEVMFr3m32SAaKx8wtdmAk7n/n4H
         bZzgpjA2/ghoXoE6rWTk0K5VqvimTa1QJs8VYGXE=
Date:   Thu, 30 Jul 2020 17:39:28 -0700
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
Subject: Re: [net-next 0/4] devlink flash update overwrite mask
Message-ID: <20200730173928.676a7a29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200730232008.2648488-1-jacob.e.keller@intel.com>
References: <20200730232008.2648488-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LGTM,

minor suggestions:
 - could you add opt-in support flags to struct devlink_ops, a'la
   ethtool_ops->supported_coalesce_params so that you don't have to
   modify all drivers to reject unsupported things?
 - could you split patch 2 into an ice change and a devlink core
   change?
