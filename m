Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B955301862
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbhAWUlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:41:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbhAWUlM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 15:41:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA3C122C7C;
        Sat, 23 Jan 2021 20:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611434432;
        bh=RMqVof+qgq8rEi1YabhKRw6lnIKaudnxh4wvZ8tY8xQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IQo+FQPtFFIc8EwJiwECyHYh2+xynFfDzjfYURVfUdCuAUzdjizMhca061mKKRdIR
         JY0bKWjWqJ/DO4DVa3qcZGGXKGaDCrFilMlplm4SJ22IdYQWFj75PLJ+SXJQPrwfbH
         ySwhN8YpaCdofmBcSHcmfeRViAR52pt9/e5JTJPfJnzRkP83+i8iGKmkmj0YCzvT47
         PdFfMOoDOeKMS63mqXXxraFDs/fTJUo69dqjKq0Cl9omfyCm0+P1PVRmHwJGxDXjbM
         eRJ2yka4HZDYlaShPlTXxoNfnXbpy+WgYaH1RXs2aSvxfzqng55TCxBnbWVkdZBJts
         WxhLonltJi2MQ==
Date:   Sat, 23 Jan 2021 12:40:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] fix and move definitions of MRP data
 structures
Message-ID: <20210123124031.29cba9e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121204037.61390-1-rasmus.villemoes@prevas.dk>
References: <20210121204037.61390-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 21:40:35 +0100 Rasmus Villemoes wrote:
> v2: update commit log of the patch to include comments on 32 bit
> alignment; include second patch moving the structs out of uapi.

Applied, thanks!
