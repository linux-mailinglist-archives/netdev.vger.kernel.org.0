Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4B3180ADB
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgCJVvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:51:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgCJVvh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 17:51:37 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BDB4215A4;
        Tue, 10 Mar 2020 21:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583877096;
        bh=4HoT8oJzkS1hzmnjBdt48DmiRfb+57xcj1RZq2sgmpA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m+0NKtZkHZzCZP7n6h0e8XffPjIcBwqysT0MiSG6OBEjaBdUppmcFVFVy/JfN5BNs
         CEttC9sGh+5j8+2s4ubHknklXO7CHaodTC//vpeEXyO1rbn9VzX+Vr4zncGcYBeO9d
         IhLIccRuRp8nZiMHGn1PeJppi1NZEVkRepD7OVOg=
Date:   Tue, 10 Mar 2020 14:51:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next v2 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2020-03-10
Message-ID: <20200310145134.7937946c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
References: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Mar 2020 13:45:19 -0700 Jeff Kirsher wrote:
> This series contains updates to ice and iavf drivers.
...
> v2: Dropped patch 5 of the original series, where Tony added tunnel
>     offload support.  Based on community feedback, the patch needed
>     changes, so giving Tony additional time to work on those changes and
>     not hold up the remaining changes in the series.

Acked-by: Jakub Kicinski <kuba@kernel.org>
