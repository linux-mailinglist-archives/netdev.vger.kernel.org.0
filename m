Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110D52B122F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgKLWvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:51:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgKLWvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 17:51:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 417702085B;
        Thu, 12 Nov 2020 22:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605221471;
        bh=gi2SexDw7owP08GVeAp+9TWvgkqx4UBdNBiK+ZQCmUg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=of5FXxJr67R3bapelz887OCVc3tLIguYZwAeu19W8O9xSTIgZ4ey/6JAajA1+BFRP
         QKRrcygwrlFhJpAnB9ZOxzY+rM70Pg6MzEirqeiDsIN+MMsafvSs+PKkH+XY/DlOtb
         axCS8So8eeGCpuka10JyZ0YWFeX3GKtu1wCBiwlc=
Date:   Thu, 12 Nov 2020 14:51:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [PATCH v3 net-next 0/7] smsc W=1 warning fixes
Message-ID: <20201112145110.2a7082d5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110030248.1480413-1-andrew@lunn.ch>
References: <20201110030248.1480413-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 04:02:41 +0100 Andrew Lunn wrote:
> Fixup various W=1 warnings, and then add COMPILE_TEST support, which
> explains why these where missed on the previous pass.
> 
> v2:
> Use while (0)
> Rework buffer alignment to make it clearer
> 
> v3:
> Access the length from the hardware and Use __always_unused to tell the
> compiler we want to discard the value.

Applied, thank you!
