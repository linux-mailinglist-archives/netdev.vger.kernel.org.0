Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892C9394896
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 00:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhE1WQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 18:16:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229494AbhE1WQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 18:16:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 926B56128B;
        Fri, 28 May 2021 22:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622240083;
        bh=ztCPRvU6NRK6l5jviH/lJT3uF5HAhXuqCFmqIzpnNB0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KwTitbSEl9rnsD3ZTcQ1bOUBN0wXNvAOibO6bR56gYUOU3fRETFgkpXOm6xV0KZzz
         1VnH/ug4TL7KNOE/8MbcjyLxYqDcUFcYBs9G6iQyxE3ejAN1VUxXIHPhvyX1ZBIsdR
         uW3KHGKCk4RXkw6UmN0vb6BNdfPYi8cp3wTKshA2a8RFejih5AFdj3N+T0GQF4QPEe
         fDcsFu+O3H4lywkV31V9HhLdz/uKx5cV/RZpXCDMA7utvFSEG+G5mKo72FhyyMeN0d
         TQt2fx4ocy3lZ0ga0DlleKeOmo2Dt6SFO2FvUhdKl3YPolmALJ3HnwsYW8CurBKTTH
         KQkoZzXk11gRw==
Date:   Fri, 28 May 2021 15:14:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Thompson <davthompson@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <limings@nvidia.com>, Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet
 driver
Message-ID: <20210528151442.470bbca7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210528193719.6132-1-davthompson@nvidia.com>
References: <20210528193719.6132-1-davthompson@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 15:37:19 -0400 David Thompson wrote:
> This patch adds build and driver logic for the "mlxbf_gige"
> Ethernet driver from Mellanox Technologies. The second
> generation BlueField SoC from Mellanox supports an
> out-of-band GigaBit Ethernet management port to the Arm
> subsystem.  This driver supports TCP/IP network connectivity
> for that port, and provides back-end routines to handle
> basic ethtool requests.

Please address the 32 bit build warnings.
