Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6B914F1C8
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgAaSHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:07:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaSHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:07:00 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C00CE20663;
        Fri, 31 Jan 2020 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580494020;
        bh=yIcBwMZoeLqOp3rSMlUjGAT9QzEYV84B4f/BkpXcI2s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZgSkWa+zWgoJpk6s65AfUYppW+2cd7rczoa7ypZ6/WPyI/50UfKFUuF4jZVW5lKPj
         o+MMtcEVLj08vj5gPowmMGzbvAJSHcdOgT0VUEMlIlpm4S1ISD/1RoOG0vOmuIqtm9
         L/qYnm6SmS94dwTKkQOCeXBtfsx/ZinY2CNgtyPY=
Date:   Fri, 31 Jan 2020 10:06:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
Subject: Re: [RFC PATCH 00/13] devlink direct region reading
Message-ID: <20200131100658.718d3be6@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200130225913.1671982-1-jacob.e.keller@intel.com>
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jan 2020 14:58:55 -0800, Jacob Keller wrote:
> Finally, the last 3 patches implement a new region in the ice driver for
> accessing the shadow RAM. This region will support the immediate trigger
> operation as well as a new read operation that enables directly reading from
> the shadow RAM without a region.

... without a snapshot?
