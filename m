Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC29C198805
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbgC3XU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729863AbgC3XUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 19:20:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5ECD20733;
        Mon, 30 Mar 2020 23:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585610425;
        bh=Dp/YRjdxhKGahkcv6Vu1GC37hpiOSRUEBiUecNgSW8I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lQuwTBZbDhhIvOK5Rl+J0Z1j+9XyK7GxPJaRMz3TUXQwTYt4yxkriNbiGCrVkzgKm
         hpOUMO7O8GJsLhxTg+HXXbE9K8LxtdrFPRXSMb1slAFbnxN0Zs0Jbs1st+oP2QJe3q
         YK1+CpF1NHbhlyJNM63RGTdn3Q3rex2gp/tLiaYk=
Date:   Mon, 30 Mar 2020 16:20:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v3 05/15] devlink: Allow setting of packet trap
 group parameters
Message-ID: <20200330162023.0c8e8283@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200330193832.2359876-6-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
        <20200330193832.2359876-6-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Mar 2020 22:38:22 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> The previous patch allowed device drivers to publish their default
> binding between packet trap policers and packet trap groups. However,
> some users might not be content with this binding and would like to
> change it.
> 
> In case user space passed a packet trap policer identifier when setting
> a packet trap group, invoke the appropriate device driver callback and
> pass the new policer identifier.
> 
> v2:
> * Check for presence of 'DEVLINK_ATTR_TRAP_POLICER_ID' in
>   devlink_trap_group_set() and bail if not present
> * Add extack error message in case trap group was partially modified
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
