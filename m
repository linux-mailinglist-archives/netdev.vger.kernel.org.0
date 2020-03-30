Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F158C198812
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbgC3XUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:20:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729422AbgC3XUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 19:20:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B6E20733;
        Mon, 30 Mar 2020 23:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585610446;
        bh=CH8oOKuP9m5HUKiJkdXilcUc8fE1PVaRvXjlazz2QJs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WY6hISi9GHeSK69luYwf+RxWyb5/zsx/F7IrA0dKzkdbGjEswpzO7X7YF0wOlhAHD
         W+wO0MY2Gar/jSdJOkA0KB4hjvSUzaa2dMgBHtaozb7MWK0Fk9lbPQb9n3sHK/Fhzc
         Qhpiq06XFsdM+VKBpVk82G/nOtGcLpGaWjh5H4XA=
Date:   Mon, 30 Mar 2020 16:20:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v3 06/15] netdevsim: Add support for setting of
 packet trap group parameters
Message-ID: <20200330162044.4b217b80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200330193832.2359876-7-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
        <20200330193832.2359876-7-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Mar 2020 22:38:23 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Add a dummy callback to set trap group parameters. Return an error when
> the 'fail_trap_group_set' debugfs file is set in order to exercise error
> paths and verify that error is propagated to user space when should.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
