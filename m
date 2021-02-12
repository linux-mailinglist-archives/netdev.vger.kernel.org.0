Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE16E319B20
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 09:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhBLIVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 03:21:42 -0500
Received: from ozlabs.org ([203.11.71.1]:38277 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229965AbhBLIVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 03:21:22 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DcRJl6cDgz9sB4;
        Fri, 12 Feb 2021 19:20:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1613118040; bh=5MaJGvBp35LQnuv/WVy3idsdObN11F6uoStWZVNU/UI=;
        h=Subject:From:To:Cc:Date:From;
        b=XaDGk5uIbxaWhSzEJt36kiLPkmiWMSWiVkeF+4aukmx1DY5TiNdhV6fvx5GgtmtZA
         8Ud9mo9FC5ZT9LFHj024lLLsth5rO5RzVdkxxdKy4O4RR9/bMPYGQkH0xcgANUBCY7
         vyfj35OGztexp/f13vsbHcYXJzcNVq8YQuGIQJyDMM7B/2x7sJho7SIRmeNidgdtpU
         OVOZNk7EpJ8kKfF+RGqlbqB9m1ceTPPkEsbhfQffhGQujPVs9kHRR76owtBcc9yhaG
         tISKemoQv4IRQZifiGgJ78U2lWlq86avkj1iwf9UjFfBoBLcgOwQPW8ASjItOdsmao
         pH01HNJAO6pxw==
Message-ID: <98cea51e699d405ebe9a6d475e51608f318a4209.camel@ozlabs.org>
Subject: Proposal for a new protocol family - AF_MCTP
From:   Jeremy Kerr <jk@ozlabs.org>
To:     netdev@vger.kernel.org
Cc:     linux-can@vger.kernel.org
Date:   Fri, 12 Feb 2021 16:20:39 +0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm currently working on implementing support for the Management
Controller Transport Protocol (MCTP). Briefly, MCTP is a protocol for
intra-system communication between a management controller (typically a
BMC), and the devices it manages. If you're after the full details, the
DMTF have a specification (DSP0236) up at:

  https://www.dmtf.org/standards/pmci

In short, this involves adding a new protocol / address family
("AF_MCTP"), the supporting types for a sockets API, and netlink
protocol definitions.

At the moment, I'm currently at the design & prototyping stage - so no
patches to send just yet! However, if you're super keen, you can have a
review of the design outline for the OpenBMC project, up at:

  https://github.com/jk-ozlabs/openbmc-docs/blob/mctp/designs/mctp/mctp-kernel.md

If you'd like to send feedback on any aspects of that, I'm keen to hear
them. You can either respond to me via email, or participate in the
gerrit review of that document, which is at:

  https://gerrit.openbmc-project.xyz/c/openbmc/docs/+/40514

Otherwise, if you prefer to review as code instead, I'll be sending
patches to netdev once we've done a few passes of the design doc with
the OpenBMC community.

linux-can folks: the structure of MCTP is a little similar to CAN, and
I've been referring to net/can/ a little for the mctp implementation,
hence including the list here. If you have any particular hindsight you
have from your work, I'd be keen to hear about it too.

Cheers,


Jeremy
 


