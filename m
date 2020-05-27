Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B961E50D9
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 00:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgE0WDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 18:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgE0WDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 18:03:12 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34DBF207D8;
        Wed, 27 May 2020 22:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590616992;
        bh=tVoiOfsSq9ZkTnPaHvGAieLut2TpEHFi89VjxbleT0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HiauU7HsmQp9EFKoF5u0tm35m8HMFyNCUlkGiv5kSck3mSHzJphl6ihOiaRPCR6xE
         KQqwpF/5oGSjLo8+pHE5Z8BvoS+4wUyJnodirEfHgsIn9AZ7nyPRs2ANX6cwudof5t
         7rsCvLre66ZHM1nbcKl9DSwLNmGrRQk9izJ26mqw=
Date:   Wed, 27 May 2020 15:03:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next RFC 00/15] Intel Ethernet Common Module and Data
Message-ID: <20200527150310.362b99e4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527042921.3951830-1-jeffrey.t.kirsher@intel.com>
References: <20200527042921.3951830-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 21:29:06 -0700 Jeff Kirsher wrote:
> This series introduces both the Intel Ethernet Common Module and the Intel
> Data Plane Function.  The patches also incorporate extended features and
> functionality added in the virtchnl.h file.

Is this a driver for your SmartNIC? Or a common layer for ice, iavf,
or whatnot to use? Could you clarify the relationship with existing
drivers?
