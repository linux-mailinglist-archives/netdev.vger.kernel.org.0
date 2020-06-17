Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8C21FD1DF
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgFQQVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgFQQVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 12:21:38 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 619CF208D5;
        Wed, 17 Jun 2020 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592410898;
        bh=YXgQ1YZQCS6NhGcs/eN/xEdHsDP894Qz0GjRPsDsY5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eKGhySD7CEGcGV41abJM8zMlsJLfLjodL1jQ8ZPn38PcMWg2HwNic7nKmrNlcej2p
         V278RDmC5/cR+hjbFvvF/EPZsqwPIF2LMJx6lnfN379Mt/vesk9LVrjxuGrLya5nVK
         7QTJ6byKrs1sW2BKGVeZrlbS8hsiT5z6NN6k6AQ0=
Date:   Wed, 17 Jun 2020 09:21:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Martin <martin.varghese@nokia.com>
Subject: Re: [PATCH net v2] bareudp: Fixed multiproto mode configuration
Message-ID: <20200617092137.72ef352d@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1592368299-8428-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1592368299-8428-1-git-send-email-martinvarghesenokia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 10:01:39 +0530 Martin Varghese wrote:
> From: Martin <martin.varghese@nokia.com>
> 
> Code to handle multiproto configuration is missing.
> 
> Signed-off-by: Martin <martin.varghese@nokia.com>

No Fixes tag on this one?
