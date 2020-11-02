Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365D92A3756
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKBXxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:53:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgKBXxZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:53:25 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0B08206C0;
        Mon,  2 Nov 2020 23:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604361205;
        bh=hW/OhqSTIJ/tbx2yNfd/9DnjnHDbzS2bkTgg9/dKu5M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LTYwa3UH6A7XP2tihYsbZIqpGA/afCb4F3XdQm5+RIaG3K+gchByxx/F8OYbIPPL6
         tA46M8pTSyA4h/EyNHS4LPgt6yZP1AGkBaSBBADQs8pNBTT7uYYIXpZ+C5yLlu5+gG
         LH/2wslHPtfjWuUp6QXgrsWsqCB0cISz+rXDhoF8=
Date:   Mon, 2 Nov 2020 15:53:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] davicom W=1 fixes
Message-ID: <20201102155324.6fd7c922@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031005833.1060316-1-andrew@lunn.ch>
References: <20201031005833.1060316-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 01:58:31 +0100 Andrew Lunn wrote:
> Fixup various W=1 warnings, and then add COMPILE_TEST support, which
> explains why these where missed on the previous pass.

Applied, thanks!
