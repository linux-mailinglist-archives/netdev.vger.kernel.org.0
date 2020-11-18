Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B382C2B842F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgKRSvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:51:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgKRSvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:51:53 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F592064B;
        Wed, 18 Nov 2020 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605725512;
        bh=7wCdXJSkjykBIBjsvou6JchEjTTGH8GHqsDBAJxWlLs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CQeyF9KWw7TfpZOxvnB7Nz2Um5Hx+Rs3MfY+lhOOS+9v4+nRY0cAL3JzkpfP535dv
         9pv0/zNmDiOrVllyyH1h7JW1XdgVPiySYkZj3UnObzIhRSwnUOON/xsdvBeakTEW+t
         QMsuAbsc3D6KonsGKOPB1HiRn/oQaYF5vop3IqaA=
Date:   Wed, 18 Nov 2020 10:51:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1] ptp: document struct ptp_clock_request
 members
Message-ID: <20201118105147.64988938@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118130541.GD23320@hoboy.vegasvil.org>
References: <20201117213826.18235-1-a.fatoum@pengutronix.de>
        <20201118130541.GD23320@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 05:05:41 -0800 Richard Cochran wrote:
> On Tue, Nov 17, 2020 at 10:38:26PM +0100, Ahmad Fatoum wrote:
> > It's arguable most people interested in configuring a PPS signal
> > want it as external output, not as kernel input. PTP_CLK_REQ_PPS
> > is for input though. Add documentation to nudge readers into
> > the correct direction.
> > 
> > Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>  
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Applied, thanks!
