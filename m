Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17442A8580
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgKESBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:01:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:39384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKESBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 13:01:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C22B52074B;
        Thu,  5 Nov 2020 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604599278;
        bh=tI/9NrFXs1krmS2k4mRHzWEMxzWpez4bxbIl37i4PO0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xFm3mP1tobn5Z7PI7lCFQYXKSDzBwhszYpCq77ayQRsJsNxfyYA+wIWghRxsFrP1U
         bwP77Ti8gvHTqDyemRr03f+Q9D4ECIUF/9CfAB5SMOZwci+1e6lpJjFWVjM0S4TmQP
         ORxslFdEFPIrzhvfybzqcaRKxljNff3Mu1HLWJ/M=
Date:   Thu, 5 Nov 2020 10:01:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net] ionic: check port ptr before use
Message-ID: <20201105100116.59767173@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104195606.61184-1-snelson@pensando.io>
References: <20201104195606.61184-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 11:56:06 -0800 Shannon Nelson wrote:
> Check for corner case of port_init failure before using
> the port_info pointer.
> 
> Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied, thanks.
