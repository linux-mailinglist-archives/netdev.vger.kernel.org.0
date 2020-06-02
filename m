Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827801EC21C
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 20:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbgFBSrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 14:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgFBSrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 14:47:55 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A56A42072F;
        Tue,  2 Jun 2020 18:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591123674;
        bh=nKAYpcbrKGnoCm92xdog2g07vfEhY5AgWp6/b4kjoVA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IxXsbHGG2KYP+QEE70AeGG1bQPmyGN0Auk8/IDZGDCE3krQJ2BjGX6zkCFaI5XR/j
         ozhJQM5pCpmfJW1qCdDIOc8cpad4RAGyaAaXnL+thIWGnm0SdUd5LAsUyX7W2WrKkO
         FDZCVryrj/WygfAoMi9pjQNP+MSbRaTsXUcKYD3s=
Date:   Tue, 2 Jun 2020 11:47:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net] crypto/chcr: error seen if
 CONFIG_CHELSIO_TLS_DEVICE isn't set
Message-ID: <20200602114753.4bac9108@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200602064213.3356-1-rohitm@chelsio.com>
References: <20200602064213.3356-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Jun 2020 12:12:13 +0530 Rohit Maheshwari wrote:
> cxgb4_uld_in_use() is used only by cxgb4_ktls_det_feature() which
> is under CONFIG_CHELSIO_TLS_DEVICE macro.
> 
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Please provide Fixes tags on your patches to net.
