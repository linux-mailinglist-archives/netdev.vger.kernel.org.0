Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D2A23ADBF
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 21:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgHCTsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 15:48:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgHCTsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 15:48:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA34E20672;
        Mon,  3 Aug 2020 19:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596484100;
        bh=TYwSKctwtfyWMcxzfWbRO0/nzXNAk2+dqsadKDSMcW0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yp26KhrMpYKeBxjbGyLe6bxIrhY2mIFOVxeMNzcpCeGSh+hnHpNtZI/BNhZZTFdge
         eVBljEhZZQyXRVxdX1i2bYn1aTuR/qTfp/VFi1YZY1tevAv9LaTEGqvs1hzTmdS+rj
         lAL3J/JWoPR79AUpWvyMTD5IhHhp9vPrYj4SLoE0=
Date:   Mon, 3 Aug 2020 12:48:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ahmed Abdelsalam <ahabdels@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
Subject: Re: [net-next v2] seg6: using DSCP of inner IPv4 packets
Message-ID: <20200803124817.5068e06d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200803181417.1320-1-ahabdels@gmail.com>
References: <20200803181417.1320-1-ahabdels@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Aug 2020 18:14:17 +0000 Ahmed Abdelsalam wrote:
> This patch allows copying the DSCP from inner IPv4 header to the
> outer IPv6 header, when doing SRv6 Encapsulation.
> 
> This allows forwarding packet across the SRv6 fabric based on their
> original traffic class.
> 
> Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>

Please make sure it builds cleanly with W=1 C=1:

net/ipv6/seg6_iptunnel.c:131:21: warning: incorrect type in assignment (different base types)
net/ipv6/seg6_iptunnel.c:131:21:    expected restricted __be32 [usertype] tos
net/ipv6/seg6_iptunnel.c:131:21:    got unsigned char
net/ipv6/seg6_iptunnel.c:133:21: warning: incorrect type in assignment (different base types)
net/ipv6/seg6_iptunnel.c:133:21:    expected restricted __be32 [usertype] tos
net/ipv6/seg6_iptunnel.c:133:21:    got unsigned char [usertype] tos
net/ipv6/seg6_iptunnel.c:144:27: warning: incorrect type in argument 2 (different base types)
net/ipv6/seg6_iptunnel.c:144:27:    expected unsigned int tclass
net/ipv6/seg6_iptunnel.c:144:27:    got restricted __be32 [usertype] tos
