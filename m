Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFB52A366F
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 23:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgKBWXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 17:23:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgKBWXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 17:23:10 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEEF420786;
        Mon,  2 Nov 2020 22:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604355790;
        bh=tsPeAhkY6m0D2PMg9baceJ6VrUbgKm1p22Nk4xpgXog=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2RUx0M1U5SZpOl/aR2APVJxfQt9L5eHpVfojICGKErv9a0YLGS+BMrI/Pm18GFZ1B
         OGB26w/mOLIzT7/ViSTW3Q4D4FwT6wOpDVFLIRCVe5L6Z3Esp0BeQrQfd8iyhuqSpb
         3zOlGmZQ55lnV9+3rZsBKzyIRDMMFPbWiPZxSHvw=
Date:   Mon, 2 Nov 2020 14:23:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next] selftests/net: timestamping: add ptp v2
 support
Message-ID: <20201102142308.48d85efa@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201101020141.GA2683@hoboy.vegasvil.org>
References: <20201029190931.30883-1-grygorii.strashko@ti.com>
        <20201031114040.1facec0b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201101020141.GA2683@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 19:01:41 -0700 Richard Cochran wrote:
> On Sat, Oct 31, 2020 at 11:40:40AM -0700, Jakub Kicinski wrote:
> > On Thu, 29 Oct 2020 21:09:31 +0200 Grygorii Strashko wrote:  
> > > The timestamping tool is supporting now only PTPv1 (IEEE-1588 2002) while
> > > modern HW often supports also/only PTPv2.
> > > 
> > > Hence timestamping tool is still useful for sanity testing of PTP drivers
> > > HW timestamping capabilities it's reasonable to upstate it to support
> > > PTPv2. This patch adds corresponding support which can be enabled by using
> > > new parameter "PTPV2".
> > > 
> > > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>  
> > 
> > CC: Richard  
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Applied, thanks!
