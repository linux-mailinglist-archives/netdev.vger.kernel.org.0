Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE54036E098
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 22:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhD1Uzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 16:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229995AbhD1Uza (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 16:55:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55DE16144C;
        Wed, 28 Apr 2021 20:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619643284;
        bh=kfb/bt4V9KtXsOBKI/6iSTdUbEorej15R+qLz3SaquA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BC1KXD8bp2Q0OC2Z6k9lhAIaVSGnBFc4WuEBk8w7qRyUARbdQlTWS/tgnWf7i171V
         DoFl6Hw4Lz/V2gLrHEelci0wbL3S1wHzU/bwRzaZj2o/UhLvT1KSlkZAiveCpCPxmq
         f+qT05H9HeEie+sTi13rlxQyapHNF4xlInIrv7pwuzy7OvepSKvs7oCAKz0Ee7dhkc
         yUwzkF+prqkIxOeKuKm5m5avaHX1V380WcBDIVHVKL8qI8zMIt2Jl9U9yqMQBY7d8p
         SOV6InAIS/oXk1Dj4/IGnQPZdEpc9yGQDcWYI4lH5Fkq9fyEaIU7gdESqnnWY/UrxF
         /US3rBsHgZH3w==
Date:   Wed, 28 Apr 2021 13:54:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: remove Wingman Kwok
Message-ID: <20210428135443.7c1ef0f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210428085607.32075-1-michael@walle.cc>
References: <20210428085607.32075-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Apr 2021 10:56:06 +0200 Michael Walle wrote:
> His email bounces with permanent error "550 Invalid recipient". His last
> email on the LKML was from 2015-10-22 on the LKML.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

FWIW does not apply to any networking tree, whose tree 
are you targeting?
