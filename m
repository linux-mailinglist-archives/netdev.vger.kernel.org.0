Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D303B78CE
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 21:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233329AbhF2Tqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 15:46:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232257AbhF2Tqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 15:46:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 920F0613E3;
        Tue, 29 Jun 2021 19:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624995851;
        bh=OZrBhbXTadX/iBB2INbThE0RbsKhauY1nJYvEZSTXC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GWye6AZghNOY0SYx6xGWIM5A8/4NLrJZuRzdwtU6HEQ31bSBLgl6WiH2eIIcyeDUc
         bZZ14iqQjfaZFuv41mwkVcVvBBJybv3rLB+GN/fg37ZhVtzb1Fj+Qg9NjnK8dqVRGe
         XmybOm2jw2LumuHr+FBXgyfz8r+bR2lWktlAZH8yYqdbRp5dvrF6s4QuFhGQG3QE7f
         yq/iwIRZaPeUxepACp63e2USU4no4d3eCttGp+ZmNxuCFcs/7HDbBKyV1DpN0P09Co
         neT4i3OSSSeEBLSiBOJJZaZqjMhcL3CGypAuW/IqafbD8duBG4VWbc0Lr92l38637E
         oLO8v6ISdvxMQ==
Received: by pali.im (Postfix)
        id 1DC3EAA8; Tue, 29 Jun 2021 21:44:09 +0200 (CEST)
Date:   Tue, 29 Jun 2021 21:44:08 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        vladyslavt@nvidia.com, moshe@nvidia.com, vadimp@nvidia.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to write to
 transceiver module EEPROMs
Message-ID: <20210629194408.eu7rcxb3uprfdk6p@pali>
References: <20210623075925.2610908-1-idosch@idosch.org>
 <YNOBKRzk4S7ZTeJr@lunn.ch>
 <YNTfMzKn2SN28Icq@shredder>
 <YNTqofVlJTgsvDqH@lunn.ch>
 <YNhT6aAFUwOF8qrL@shredder>
 <YNiVWhoqyHSVa+K4@lunn.ch>
 <YNl7YlkYGxqsdyqA@shredder>
 <YNskdT/FMWERmtF5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNskdT/FMWERmtF5@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 29 June 2021 15:47:33 Andrew Lunn wrote:
> > Even with the proposed approach, the kernel sits in the middle between
> > the module and user space. As such, it can maintain an "allow list" that
> > only allows access to modules with a specific memory map (CMIS and
> > SFF-8636 for now) and only to a subset of the pages which are
> > standardized by the specifications.
> 
> Hi Ido
> 
> This seems like a reasonable compromise. But i would go further. Limit
> it to just what is needed for firmware upgrade.
> 
>    Andrew

Hello! If this is just because for CMIS firmware upgrade, what about
rather providing kernel driver for CMIS firmware upgrade?
