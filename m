Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA97A1E186D
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 02:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgEZAX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 20:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgEZAX4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 20:23:56 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2FAE20657;
        Tue, 26 May 2020 00:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590452635;
        bh=EdW5NYMp6ATe8s+lyPksNDso63SdeWOWL6ezBJjliq8=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Bwd09wa+XWVpuz0l4p7amN0yge1s+baMHK9wwDMxwGusHdWDUb5GE1UUfhYEEjorU
         qJYKrbcZhpJAxmzdt5sPqGpSlu8uR7SHL7NzZfXvKBgK0FUJvECe11payCaRE4eAxA
         GVOtWuI1yZ8JKY7YiLeK9/lIrj1DrrDKadXrL0jY=
Date:   Tue, 26 May 2020 00:23:55 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Chen Yu <yu.c.chen@intel.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     <Stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] e1000e: Do not wake up the system via WOL if device wakeup is disabled
In-Reply-To: <9f7ede2e2e8152704258fc11ba3755ae93f50741.1590081982.git.yu.c.chen@intel.com>
References: <9f7ede2e2e8152704258fc11ba3755ae93f50741.1590081982.git.yu.c.chen@intel.com>
Message-Id: <20200526002355.B2FAE20657@mail.kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)").

The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181, v4.9.224, v4.4.224.

v5.6.14: Build OK!
v5.4.42: Build OK!
v4.19.124: Build OK!
v4.14.181: Build OK!
v4.9.224: Failed to apply! Possible dependencies:
    c8744f44aeae ("e1000e: Add Support for CannonLake")

v4.4.224: Failed to apply! Possible dependencies:
    16ecba59bc33 ("e1000e: Do not read ICR in Other interrupt")
    18dd23920703 ("e1000e: use BIT() macro for bit defines")
    74f31299a41e ("e1000e: Increase PHY PLL clock gate timing")
    c8744f44aeae ("e1000e: Add Support for CannonLake")
    f3ed935de059 ("e1000e: initial support for i219-LM (3)")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
