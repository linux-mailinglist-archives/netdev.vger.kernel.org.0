Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5A12A57C5
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732326AbgKCVpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:45:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732182AbgKCVpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 16:45:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D84B120786;
        Tue,  3 Nov 2020 21:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604439951;
        bh=5y+qQKN21W2RbWzGwI/LBl36uc2wysN9nyXWy/4e4xI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D/slZ7c/RrjWE2b4lBwre3GM69M08EXxXs8j6iCui7YHz5vmmXBswuWJs1iKLfJlG
         caN3o/xQDsubeuTcMXSBLDjcAIQw/pad6h39imNknytuLFIBp5SXBpKDgYR3TOSCp/
         8rdF9CThbJ0iYOu4qU4gDHFh8BDokufwrZhQy8lI=
Date:   Tue, 3 Nov 2020 13:45:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net 1/1] ptp: idt82p33: add adjphase support
Message-ID: <20201103134549.31a8b1d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604330848-25567-1-git-send-email-min.li.xe@renesas.com>
References: <1604330848-25567-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Nov 2020 10:27:28 -0500 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Add idt82p33_adjwritephase() to support PHC write phase mode.
> 
> Changes since v1:
> - Fix broken build on 32 bit machine due to 64 bit division.

Oh, and also please mark this as [PATCH net-next] in the subject,
rather than [PATCH net]. This is not a bug fix AFAICT.
