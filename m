Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 291CC14F1D3
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgAaSHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:07:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaSHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:07:34 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C2B320663;
        Fri, 31 Jan 2020 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580494054;
        bh=2f4/48ICTux6mAR3S9zWGr8brFiBJbNtcOEyMtwiSBs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QGua5GQmC4wiT+9OMhNsiYcNIbJOSQLL7KBw97JMswvTgipxHG6SehwHZnElk416H
         uDanvGmqHqdxD0r7o6nU/kYI96dlAkBXOg2Ic+m4+3Gr2PJ2dA1Y99gJ4jj1Tf8G9y
         5YPPIpWV1yw0sz9DjUicdYXloGOlm91tuiKLbPLM=
Date:   Fri, 31 Jan 2020 10:07:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [PATCH 11/15] ice: add board identifier info to devlink
 .info_get
Message-ID: <20200131100733.113d5a17@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130225913.1671982-12-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
        <20200130225913.1671982-12-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 14:59:06 -0800, Jacob Keller wrote:
> Export a unique board identifier using "board.id" for devlink's
> .info_get command.
> 
> Obtain this by reading the NVM for the PBA identification string.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

In general for the devlink info it'd be really useful to have example
outputs to see what the values actually are.
