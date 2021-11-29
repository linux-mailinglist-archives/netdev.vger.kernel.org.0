Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5256461CF2
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 18:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349274AbhK2Rso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 12:48:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40730 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348660AbhK2Rqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 12:46:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30ABDB8159D
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2C0C53FCD;
        Mon, 29 Nov 2021 17:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638207802;
        bh=f7eOOlEqzRNsJN8jk+V2Gs4/yuEYxoCeLNTNCDHdK90=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nJI6ZXczzg/TJoyMfCuyu8xwIoKfXtoB6ptg5T7k+iBIDviTuvzJyhgbLl/U7bIqs
         BN/CLsJPFbr8RTp8+13hqioEG15wixXa43aduTIrvRKiX4jdjXlONx8EPGkYQe27em
         8hpdRfQiHySFVvB15h4xg5cFWM3OPd8oSQv5BnDthg/mrNZfUPKAzaAP6gK4ERzwEG
         M4lWeYz92AxB2Xu2XJ3Jvlt9qQZDfRKxlTJEqLA4/AT6aHWEcGy988fGJqoidFO9fY
         CtRHQMdaluA5iDp4ywu2y9qcCSJTb1QPilKqt1/wzOvn8sYg6Cw0RWuuCzNNWzrUIP
         pdX0ilNYVVdpA==
Date:   Mon, 29 Nov 2021 09:43:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/4] ethtool: Add ability to query
 transceiver modules' firmware information
Message-ID: <20211129094321.31092e40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211127174530.3600237-2-idosch@idosch.org>
References: <20211127174530.3600237-1-idosch@idosch.org>
        <20211127174530.3600237-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Nov 2021 19:45:27 +0200 Ido Schimmel wrote:
> + * @committed: Whether the image is run upon resets.

Isn't activation tangential to state of the image?

> + * @valid: Whether the image is runnable and persistently stored completely
> + *	undamaged.

Is it worth distinguishing empty vs broken? How do we let the user know
that the device has downgraded the FW image because of bad flash vs the
device was never updated? Some statistic?
