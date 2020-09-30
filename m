Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1E527F0FD
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 20:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgI3SCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 14:02:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3SCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 14:02:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 908B020759;
        Wed, 30 Sep 2020 18:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601488920;
        bh=bRS4H8Aw5+HjYuQJZdHw9x6vvjwz8CvRvOJMHCsMSYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c5eT32kc7hHHMyQKxNjVpTXxukokvz8G8ioyPqTjtZLUaH/+nj7vmjQaOBUK7j3D8
         7mETiXE3sScIbvpyoTWH9L5oupy1UeaQU5njcnDcZmBEOZDwwhQ5qEnwlB0E8x6oF2
         9aci3ClMbZAM/d+A2ku37fsP4Wb7j1iKICC7pcoU=
Date:   Wed, 30 Sep 2020 11:01:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@nvidia.com,
        idosch@nvidia.com
Subject: Re: [PATCH net-next 3/4] dpaa2-eth: add basic devlink support
Message-ID: <20200930110157.55d85efa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200930171611.27121-4-ioana.ciornei@nxp.com>
References: <20200930171611.27121-1-ioana.ciornei@nxp.com>
        <20200930171611.27121-4-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 20:16:10 +0300 Ioana Ciornei wrote:
> Add basic support in dpaa2-eth for devlink. For the moment, just
> register the device with devlink, add the corresponding devlink port and
> implement the .info_get() callback.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

This one does not build, sadly.
