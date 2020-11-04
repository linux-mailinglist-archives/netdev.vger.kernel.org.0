Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CA52A6D07
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 19:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731613AbgKDSnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 13:43:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730812AbgKDSno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 13:43:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B50F206C1;
        Wed,  4 Nov 2020 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604515424;
        bh=m20eoaOMo1ubqQ0jnlkDeXkxvSLTxtTfttk+YX60QgA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G7AmRI6lbMhJPYZGwW8Dz2xNu0XDnabbji7VDCaQuFbBmBFE/9XK4ri9EC5l38yN9
         DI0vqNWjggKDYggjzS8IiK7raV8T3o5FrezOh7qLS4BwrPfQ96Ev45j/jdBgzZesVF
         seuZ3aVOzaPSsIaT4j8kAISuRfm+8AE/IjY4mb5E=
Date:   Wed, 4 Nov 2020 10:43:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: pull-request: can 2020-11-03
Message-ID: <20201104104342.0dc17023@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 23:06:09 +0100 Marc Kleine-Budde wrote:
> Hello Jakub, hello David,
> 
> here's a pull request for net/master consisting of 27 patches for net/master.

Pulled, thanks!
