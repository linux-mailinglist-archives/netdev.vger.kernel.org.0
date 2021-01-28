Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26073068BC
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 01:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhA1Ajb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:39:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:59172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhA1Aiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 19:38:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EE8D60C3D;
        Thu, 28 Jan 2021 00:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611794293;
        bh=tYOqKlJNe68s8knlGa09rULG0afNwiuJ8DHiuRlHmT8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MqxoCWHWBToX8n2PKuDZL0FSQLgOPv5IP+N92erMGtwiG0DlSq8DwNq7nDpqO2XWS
         GJ7YXMmF7U3YdCkQSRlewfIQdpEoq9teIVAt4LHElICHxgdUGPO13XbOoUI7RYcwFR
         3BF3UX3natIy4CnJJEB8hhEfaNXcZrR+AAkBUsZEFTZCkHfEvYiYEgqXSZ9X8f+omv
         ipVloD6ll/9qHwUPBSszg8o5e39gcBL+A7tJwjgvMr3BI0GD6WoQCyf3MNP9PbjCWZ
         2GehUitnv12Y+YLku91DonZME7aTw1ndMSfDROO+/5N7gapIMVry3qLjVYgO/3/1EJ
         fTlJZk6JJ72Zw==
Date:   Wed, 27 Jan 2021 16:38:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: core: devlink: add 'dropped' stats
 field for DROP trap action
Message-ID: <20210127163812.76fa0411@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210125123121.1540-1-oleksandr.mazur@plvision.eu>
References: <20210125123121.1540-1-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 14:31:21 +0200 Oleksandr Mazur wrote:
> Whenever query statistics is issued for trap with DROP action,
> devlink subsystem would also fill-in statistics 'dropped' field.
> In case if device driver did't register callback for hard drop
> statistics querying, 'dropped' field will be omitted and not filled.
> Add trap_drop_counter_get callback implementation to the netdevsim.
> Add new test cases for netdevsim, to test both the callback
> functionality, as well as drop statistics alteration check.
> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

Please stick to RFC since there is no upstream user for this (if you
need to repost).
