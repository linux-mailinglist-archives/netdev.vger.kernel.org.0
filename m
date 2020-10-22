Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39C329570A
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 06:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgJVEID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 00:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgJVEID (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 00:08:03 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6EDA2225D;
        Thu, 22 Oct 2020 04:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603339683;
        bh=KARBaWZmoEKcirWSy8PNY9jPJ01eLNc/M+iu+6yG9Ec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DF6rJyQl+ZOaq7ZuehBuMmcX9/sFqagyaK756yGnZ+thg8y37vrSemNuR0+l2bio9
         Wh5J+hYTRq5wOxq7+7wVhOcYh+PFSQ7AvTMWPCzZYz4Znl67xC3S2ReX/JzqZ88b7z
         1oARYlah3wSoNOswelhym/O49FoILnIPlQI1BhoM=
Date:   Wed, 21 Oct 2020 21:08:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net] chelsio/chtls: fix tls record info to user
Message-ID: <20201021210800.0b48f05e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201020193930.12274-1-vinay.yadav@chelsio.com>
References: <20201020193930.12274-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 01:09:31 +0530 Vinay Kumar Yadav wrote:
> tls record header is not getting updated correctly causing
> application to close the connection in between data copy.
> fixing it by finalizing current record whenever tls header
> received.

Please improve this commit message.
