Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8B229F723
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 22:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgJ2VsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 17:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ2VsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 17:48:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ED0320809;
        Thu, 29 Oct 2020 21:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604008080;
        bh=0v2aJM+OIecye23o+eUCuQ116eASdwdbszD4AQSDnhQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fFgbkyMIq0SeM7q5OimcV+oFlHawLCOBRq+gdYaP0e0VqP6qjSpIRBOHgCI5g0q7l
         ysZmIY94UbVdZXIkwE9ukqKB2whWP+bzSdyn1S2kKwKAL3C3BDHqQvsW14YFqXaIZ9
         wGDyHw3W9ufCYtFWszFen4QnxSd0RZsRaCTJOgcc=
Date:   Thu, 29 Oct 2020 14:47:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH net-next 0/2] net trigraph fixes for W=1
Message-ID: <20201029144759.023cac81@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201028002235.928999-1-andrew@lunn.ch>
References: <20201028002235.928999-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 01:22:33 +0100 Andrew Lunn wrote:
> Both the Marvell mvneta and rose driver accidentally make use of a
> trigraph. When compiling with W=1 an warning is issues because we have
> trigraphs disabled. So for mvneta, which is only a diagnostic print,
> remove the trigraph. For rose, since this is a sysfs file, escape the
> sequence to make it clear it is not supposed to be trigraph.

Feel free to resubmit, with the mentions of W=1 adjusted. 
No preference here.
