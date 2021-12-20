Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E6B47AEF5
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 16:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239169AbhLTPGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 10:06:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35072 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240051AbhLTPEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 10:04:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uQXb7egn3pE9k1PlLaJGkQqt7vEJ0Aw4oroAURCmKmk=; b=d3hrEW5DaITZy6b3ZTvR6Jugxo
        X18Oz3m2QohxC5yIyD8hDB9uYBs8icdJ/Tya9WwxfxNJmpzh0Ob3oRvrUBObh7gDbLIO5di7ROw81
        a3A8QFUCtzqDdD+5g/+xBPXS3Qf5h/V6ERa2KMfNJbb7R1I/Wmirib2M0n9ccGtZcBho=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mzKDL-00H3W1-PQ; Mon, 20 Dec 2021 16:04:35 +0100
Date:   Mon, 20 Dec 2021 16:04:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        christian.herber@nxp.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH 1/3] ptp: add PTP_PEROUT_REVERSE_POLARITY flag
Message-ID: <YcCbg7drgpf6vSXG@lunn.ch>
References: <20211220120859.140453-1-radu-nicolae.pirea@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220120859.140453-1-radu-nicolae.pirea@oss.nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 02:08:57PM +0200, Radu Pirea (NXP OSS) wrote:
> Some ptp controllers may be able to reverse the polarity of the periodic
> output signal. Using the PTP_PEROUT_REVERSE_POLARITY flag we can tell the
> drivers to reverse the polarity of the signal.

Please always Cc: the PTP maintainer, Richard Cochran
<richardcochran@gmail.com>.

For a patch set, please also include a patch 0/X which explains what
the patches as a whole do.

    Andrew
