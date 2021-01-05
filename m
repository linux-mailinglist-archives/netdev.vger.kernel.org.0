Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C4E2EB4F4
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 22:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbhAEVmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 16:42:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbhAEVmM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 16:42:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3A1D22D71;
        Tue,  5 Jan 2021 21:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609882892;
        bh=OelK+qgzX6t7hhkvaJ7otSRazKurzK9vq49QioveRqk=;
        h=Date:From:To:Cc:Subject:From;
        b=EfqIh3BfpXgIySUiJT6YvveDOfPnK0YBRZAVZbQoYgFSWdLeH9xlAtKHLeOOra2nU
         B3F4XT7ouuj/aIsJSNyvyio8ZtwiGEOxCpNYlnESkbvGoIhGpZqpDT1+Qca+nCbLSZ
         6Lb96WoKcQZY0dgo8pkECw9VHpLWPXqZe7pjJab9Ls3kEn/Ox+kk7B5QB+VldUcmJR
         cIqUvZs396GlW3C+9SxVuEoFHBwWaoif/J6CslSOXsp7PiqHWeU9BXrcb0YPOWr9xn
         lAymztt9hjw57QScqHEiEHkCdTOLl3nUH/wd8Ar768vQt2AL+sE8WkE++6tjINTNrM
         2udO2znF3kEeQ==
Date:   Tue, 5 Jan 2021 13:41:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>
Subject: net-next is OPEN
Message-ID: <20210105134130.6b51b09f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear netdevians,

Trees are forwarded now, new features etc. will be accepted.

Once again big thanks to everyone participating in code reviews.

Thanks!
