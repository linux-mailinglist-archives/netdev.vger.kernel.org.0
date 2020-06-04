Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A63A1EDB98
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 05:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgFDDQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 23:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgFDDQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 23:16:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F5D0206E6;
        Thu,  4 Jun 2020 03:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591240601;
        bh=DH3/wYrz2NoPFDpg41/G+HwQ0LSfqDhy1kNtgQsCWmY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F+6viXnBJbdOB+njxTqXaj2vDeVxc8zNq7WYGI36Kg0CBuNvtznLUFG1kHPKiQtVi
         sbk8V/w1liS28WwHIUXpDEKqGGIz8muvKiWmlI0hvCrIRCuYPf/GeSSCaeC4aP2sXY
         Ir5ABMwljPKe8T8fSREQdZAcvXtirBG6fLfyGwLU=
Date:   Wed, 3 Jun 2020 20:16:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Danielle Ratson <danieller@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, michael.chan@broadcom.com,
        jeffrey.t.kirsher@intel.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Petr Machata <petrm@mellanox.com>
Subject: Re: [RFC PATCH net-next 8/8] selftests: net: Add port split test
Message-ID: <20200603201638.608cfdb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <619b71e5-57c2-0368-f1b6-8b052819cd22@gmail.com>
References: <20200602113119.36665-1-danieller@mellanox.com>
        <20200602113119.36665-9-danieller@mellanox.com>
        <619b71e5-57c2-0368-f1b6-8b052819cd22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Jun 2020 11:12:51 -0700 Florian Fainelli wrote:
> Any reason why this is written in python versus shell?

Perhaps personal preference of the author :) 

I'd be curious to hear the disadvantages, is python too big for
embedded targets?
