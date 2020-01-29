Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2217814CDEF
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 17:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgA2QHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 11:07:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgA2QHq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 11:07:46 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE8A92070E;
        Wed, 29 Jan 2020 16:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580314065;
        bh=9yBPj4UNwYUOR69iyQMVsIStEM9u9/xr9i6+RNqmRhQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fl5XgjQ+SnLlbl0rM+bpIjYDd20EP14WvCAR+KQIDika0zrOrjd0rKtbQsfXjy8nD
         qFXiG9PsccCnfn2XJcXD7KJibmVFqcBvdY36zRsWEEYMI7R1qK0rm30iB/pobWCUBD
         mvk/RGPGsJIPX1SBaxbS/GtRi//lOu0CZr1agG9g=
Date:   Wed, 29 Jan 2020 08:07:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sameeh Jubran <sameehj@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Arthur Kiyanovski <akiyano@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>
Subject: Re: [PATCH V1 net 07/11] net: ena: fix incorrectly saving queue
 numbers when setting RSS indirection table
Message-ID: <20200129080744.52be661e@cakuba>
In-Reply-To: <20200129140422.20166-8-sameehj@amazon.com>
References: <20200129140422.20166-1-sameehj@amazon.com>
        <20200129140422.20166-8-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jan 2020 14:04:18 +0000, Sameeh Jubran wrote:
> Also move the set code to a standalone function for code clarity.

This is unrelated, and should not be a part of a fix. Fixes are
supposed to be small, please never do code refactoring in them.
