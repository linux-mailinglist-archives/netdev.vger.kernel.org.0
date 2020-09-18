Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631A22702C7
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgIRRCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgIRRCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:02:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58CC4208DB;
        Fri, 18 Sep 2020 17:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600448574;
        bh=AxXbdQV2aAtC/YNZPZUsFNW8+CdwbbV8j5h4G7lflpU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sZtVy9TkgwvSpIWeVT0RA4TlisH/ljPN07REkF8xfRYYLamBmK0WJP2O0VK4jHZjn
         lwuC5zRaXUa/8VxgJN1bT8QfzJ7DLlBa56NY8fbMU2ZFnmTY3m3CklmeEToKwpLqdP
         novakhMfLzoxYvlfJSpCNY+MDl2zt1LjWtXLjJlE=
Date:   Fri, 18 Sep 2020 10:02:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v5 net-next 2/5] devlink: collect flash notify params
 into a struct
Message-ID: <20200918100252.0f3dfcd7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200918011327.31577-3-snelson@pensando.io>
References: <20200918011327.31577-1-snelson@pensando.io>
        <20200918011327.31577-3-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 18:13:24 -0700 Shannon Nelson wrote:
> The dev flash status notify function parameter lists are getting
> rather long, so add a struct to be filled and passed rather than
> continuously changing the function signatures.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Good luck in the rebase roulette :(
