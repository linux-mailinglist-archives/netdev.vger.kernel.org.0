Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7811E2A0A9D
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgJ3QB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgJ3QB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 12:01:26 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDCB32067D;
        Fri, 30 Oct 2020 16:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604073686;
        bh=/Srs9mWmOMgwoy9OWc+JxhHK1mHDwTz+8wKEKE3UhQc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tQ+SkXiqijFWIwb79tWgNsjef0anjfs7ogK3OOe+sJHEnHJo0SjHqIBqp+CwAALHv
         VMORq3hiTZMS42sLk2df6fCq6m+cb9E2qHFZysHDi43gdOt/JcSOsMGuNB09Mwm5HK
         NHJX8KOBOK1VP6KUfbKyAPECiWE5GCHOXi/yOL1g=
Date:   Fri, 30 Oct 2020 09:01:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Branimir Rajtar <branimir.rajtar@5x9networks.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] typos in rtnetlink
Message-ID: <20201030090124.5027220c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <6b9672e299364cc9b42829fc24774fb230346e46.camel@5x9networks.com>
References: <83c34b90a2f7c87e84b73911a7837de2e087ad8f.camel@5x9networks.com>
        <06351e24b36f55ee16fda8e34130a7a454c1cdea.camel@5x9networks.com>
        <6b9672e299364cc9b42829fc24774fb230346e46.camel@5x9networks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 08:22:01 +0000 Branimir Rajtar wrote:
> Hi,
> 
> I'm repeating my email since I had HTML in text and was treated as
> spam.

I don't see any patch, try git-send-email?
