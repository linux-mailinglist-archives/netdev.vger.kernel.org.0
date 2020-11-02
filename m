Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E4E2A3272
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 19:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgKBSAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 13:00:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbgKBSAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 13:00:55 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2991F21D91;
        Mon,  2 Nov 2020 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604340054;
        bh=lq6cb1Ev49wdlwiBhnykejHZ/Hnu5irybGDCe8+2Gz4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G/M3zvTgzZ2t5siUW93i8sy991Zi6T5OUyGg6NnNBqcF9An5Um6RNU7KgD2s4X7OV
         TuTU3pph75O1LhiDKu6liM9siYtYGrC3kWS6DblkZFT0sFHZp66G5Z3JhsJOSleJiM
         N6XKRHDNngN3mP4SNB+bqLyvuYeF6ICwr0C2lI2Y=
Date:   Mon, 2 Nov 2020 10:00:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George Cherian <george.cherian@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <masahiroy@kernel.org>
Subject: Re: [net-next PATCH 0/3] Add devlink and devlink health reporters
 to
Message-ID: <20201102100053.06013217@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201102050649.2188434-1-george.cherian@marvell.com>
References: <20201102050649.2188434-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 10:36:46 +0530 George Cherian wrote:
> Add basic devlink and devlink health reporters.
> Devlink health reporters are added for NPA and NIX blocks.
> These reporters report the error count in respective blocks.
> 
> Address Jakub's comment to add devlink support for error reporting.
> https://www.spinics.net/lists/netdev/msg670712.html

Please make sure you fix all new warnings when built with W=1 C=1.
