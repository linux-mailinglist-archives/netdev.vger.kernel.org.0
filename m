Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9339352140
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 23:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbhDAVC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 17:02:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233665AbhDAVC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 17:02:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lS4St-00EOkO-RD; Thu, 01 Apr 2021 23:02:55 +0200
Date:   Thu, 1 Apr 2021 23:02:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next 00/12] ionic: add PTP and hw clock support
Message-ID: <YGY0/4Ab8Sf4NdHb@lunn.ch>
References: <20210401175610.44431-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401175610.44431-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 10:55:58AM -0700, Shannon Nelson wrote:
> This patchset adds support for accessing the DSC hardware clock and
> for offloading PTP timestamping.

Hi Shannon

Please always Cc: the PTP maintainer for PTP patches.
Richard Cochran <richardcochran@gmail.com>

	Andrew
