Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B4E185405
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 03:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgCNCgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 22:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgCNCgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 22:36:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B4E72074B;
        Sat, 14 Mar 2020 02:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584153400;
        bh=1pW85oOOhfsTgmi9io6OSE9zKksK/Q4NpH9Vurgl1a8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=apOSd0eSG99lJd7DXjd30V3Csb4lJOZaDW2+34B7i3iUn5uakWpykDyO8yLdkQJZV
         8rhgtIE5g8Gr0fZv3rN82V9G5EuBrt62OYTPgRfuS6V3qAWs0wNLjoMpPnDF4f9XJf
         4FeVCSmiedPaDYjtjsH1JzBqHvLMNbzhpk5tJDOk=
Date:   Fri, 13 Mar 2020 19:36:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: [net-next 07/14] net/mlx5: E-Switch, Update VF vports config
 when num of VFs changed
Message-ID: <20200313193638.6d9fdff8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200314011622.64939-8-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
        <20200314011622.64939-8-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Mar 2020 18:16:15 -0700 Saeed Mahameed wrote:
> From: Bodong Wang <bodong@mellanox.com>
> 
> Currently, ECPF eswitch manager does one-time only configuration for
> VF vports when device switches to offloads mode. However, when num of
> VFs changed from host side, driver doesn't update VF vports
> configurations.
> 
> Hence, perform VFs vport configuration update whenever num_vfs change
> event occurs.

Oh, I thought you kept max_vfs number of reprs on the ECPF, always.
Or was that just the initial plan?
