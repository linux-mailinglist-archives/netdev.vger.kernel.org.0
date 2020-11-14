Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1C52B30E8
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 22:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgKNVFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 16:05:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:37288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgKNVFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 16:05:45 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89EAB20A8B;
        Sat, 14 Nov 2020 21:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605387944;
        bh=DH2LkJlNbWMWRry1f5gJkyXuhr1ISKUNy2w7SHUemk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FwDp5orrYcg2caCsTaPyv2h6noy2YEmgxMGK3KJvtg9r+ZMqpSrQZOCZz102qXP7E
         H6qBU54eZJ38PlKJNRb6aLFlDYmPOsQCwXT5SmbcXA38vIM3lCcqb+EP4iLYcuvG5I
         fGfVD9mMH2s1gZoIwgb2KP3bE4Kwt3UPRL8GUbnM=
Date:   Sat, 14 Nov 2020 13:05:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 00/13] mptcp: improve multiple xmit streams
 support
Message-ID: <20201114130543.426c5a60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1605199807.git.pabeni@redhat.com>
References: <cover.1605199807.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 18:45:20 +0100 Paolo Abeni wrote:
> This series improves MPTCP handling of multiple concurrent
> xmit streams.

Umpf, looks like it no longer applies after the net->net-next merge.
Please respin.
