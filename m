Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367DA2CCBE4
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 02:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgLCBya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 20:54:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbgLCBya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 20:54:30 -0500
Date:   Wed, 2 Dec 2020 17:53:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606960429;
        bh=qGJylSv/S3dB8ZwknctI8ONNkBho9UNAM1cSlTbraFk=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=r0PrjEMmvjTygwJAhSZ1UNBWefP90ioF8uVuRo9ZUWDolvUopiH05DF/ET5UtpBjP
         WCYO1zxnZiQplLk+U4RavO5l7OS10B8kP6Gc8rXKVGPBDKnE9LmIbZrVWdJlM560d7
         7TVbemcTFIjIY8eldzhRGgyM1HcGayiuYucPVffIEHlEQRHP+ehsLWgdU84oev2jv+
         RpJTdKZYrfC4ICzUOdmfcjO65C35je81SbFCPwel0DxElZKqs2kZ4hhdQDSfzjNPN3
         XS7XXgNUOPm/SdUGO6buE9RjdpTac5+CN2D8zqDmqe79FBE8GS74RX8wStMEFaQPz7
         2LdEUBc18YtKA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v1 1/9] ethtool: Add support for configuring
 frame preemption
Message-ID: <20201202175347.3ee19c51@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202045325.3254757-2-vinicius.gomes@intel.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
        <20201202045325.3254757-2-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Dec 2020 20:53:17 -0800 Vinicius Costa Gomes wrote:
> Frame preemption (described in IEEE 802.3br-2016) defines the concept
> of preemptible and express queues. It allows traffic from express
> queues to "interrupt" traffic from preemptible queues, which are
> "resumed" after the express traffic has finished transmitting.
> 
> Frame preemption can only be used when both the local device and the
> link partner support it.
> 
> Only parameters for enabling/disabling frame preemption and
> configuring the minimum fragment size are included here. Expressing
> which queues are marked as preemptible is left to mqprio/taprio, as
> having that information there should be easier on the user.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

CC: Michal
