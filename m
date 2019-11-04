Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0348EEDFE2
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 13:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfKDMUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 07:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:47618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727430AbfKDMUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 07:20:17 -0500
Received: from localhost (unknown [89.205.135.36])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC8432053B;
        Mon,  4 Nov 2019 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572870016;
        bh=q+5CsE1R6eI+gms5EsuP+pT+In6Ccjn15PiekdN1X3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tck1HNmfadKcdco76MQiYsj1JnAksj3ANetsIpltNpINg+G5q2mzdd3IqdvBRp84F
         E3TBLS50w9Nwra2GEQqlUhwhjW/miSJmo+v0Ee5VDTT1mdryav6ax9d3DQovhPE3zy
         1ZNc9UmyDmQ29N2ChbncKf7RzXxcTaYNnpmdqndc=
Date:   Mon, 4 Nov 2019 13:20:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Ping CHNG <jack.ping.chng@intel.com>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        andriy.shevchenko@intel.com, mallikarjunax.reddy@linux.intel.com,
        cheol.yong.kim@intel.com
Subject: Re: [PATCH v1] staging: intel-dpa: gswip: Introduce Gigabit Ethernet
 Switch (GSWIP) device driver
Message-ID: <20191104122009.GA2126921@kroah.com>
References: <03832ecb6a34876ef26a24910816f22694c0e325.1572863013.git.jack.ping.chng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03832ecb6a34876ef26a24910816f22694c0e325.1572863013.git.jack.ping.chng@intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 07:22:20PM +0800, Jack Ping CHNG wrote:
> This driver enables the Intel's LGM SoC GSWIP block.
> GSWIP is a core module tailored for L2/L3/L4+ data plane and QoS functions.
> It allows CPUs and other accelerators connected to the SoC datapath
> to enqueue and dequeue packets through DMAs.
> Most configuration values are stored in tables such as
> Parsing and Classification Engine tables, Buffer Manager tables and
> Pseudo MAC tables.

Why is this being submitted to staging?  What is wrong with the "real"
part of the kernel for this?

Your TODO file is really vague, and doesn't give anyone any real things
to work on with you, which is odd.

> Signed-off-by: Jack Ping CHNG <jack.ping.chng@intel.com>
> Signed-off-by: Amireddy Mallikarjuna reddy <mallikarjunax.reddy@linux.intel.com>

There is a group of people within Intel that you have to get code
reviewed by before you can send it to me.  Please go by that process and
not try to circumvent it by dumping it on staging without that review.
It is there for good reasons.

greg k-h
