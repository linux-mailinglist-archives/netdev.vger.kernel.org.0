Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FEE16EDF2
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 19:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgBYSZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 13:25:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726699AbgBYSZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 13:25:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C19C2082F;
        Tue, 25 Feb 2020 18:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582655156;
        bh=eIoXI4wSLBT6JPR+L1eENAOFJ0cypa/nQNqRasNy3xo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IKzDUgHcY0yBPbJlfCXMz6ifNFwE3mSq2MMXK+N5F2esT0pju2bn1EgVfEZU3p54Q
         8fslwMxf3iXVjj7OJ/73EgEDTa+EBf/oiXZ+8TJKmkt3bvnMsroN7eeAVasoJNwpCM
         eBr6IDiExVAs/8dIUNbLZdM2ipg10rh2GkWf5xa4=
Date:   Tue, 25 Feb 2020 10:25:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v2 09/10] netdevsim: add ACL trap reporting
 cookie as a metadata
Message-ID: <20200225102553.0771c3d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200225104527.2849-10-jiri@resnulli.us>
References: <20200225104527.2849-1-jiri@resnulli.us>
        <20200225104527.2849-10-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Feb 2020 11:45:26 +0100 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Add new trap ACL which reports flow action cookie in a metadata. Allow
> used to setup the cookie using debugfs file.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
