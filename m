Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706EA82FAD
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 12:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732569AbfHFKZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 06:25:20 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46889 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732515AbfHFKZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 06:25:20 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 462rPB1kgNz9s00;
        Tue,  6 Aug 2019 20:25:17 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>, netdev@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net-next] ibmveth: Allow users to update reported speed and duplex
In-Reply-To: <1565033086-21778-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1565033086-21778-1-git-send-email-tlfalcon@linux.ibm.com>
Date:   Tue, 06 Aug 2019 20:25:15 +1000
Message-ID: <87zhkmvbec.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas Falcon <tlfalcon@linux.ibm.com> writes:
> Reported ethtool link settings for the ibmveth driver are currently
> hardcoded and no longer reflect the actual capabilities of supported
> hardware. There is no interface designed for retrieving this information
> from device firmware nor is there any way to update current settings
> to reflect observed or expected link speeds.
>
> To avoid confusion, initially define speed and duplex as unknown and

Doesn't that risk break existing setups?

> allow the user to alter these settings to match the expected
> capabilities of underlying hardware if needed. This update would allow
> the use of configurations that rely on certain link speed settings,
> such as LACP. This patch is based on the implementation in virtio_net.

Wouldn't it be safer to keep the current values as the default, and then
also allow them to be overridden by a motivated user.

cheers
