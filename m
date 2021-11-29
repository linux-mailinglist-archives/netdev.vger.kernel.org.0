Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBDD461D44
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 19:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348315AbhK2SFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 13:05:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48920 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350918AbhK2SDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 13:03:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E026BB80EE4
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B30C53FAD;
        Mon, 29 Nov 2021 17:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638208789;
        bh=pumOr14SEPuRBt4uFWVYENXsSXCvMX8ziKVxmo5xBfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ljWYAYQP39OtkEqvelwN4RGRumXcn8bIzjhIhdrQWo9PFETfjQSWyyqPfuOgwinsg
         9RP2UD47S6P7EKbs7jVKEK9qo6B5kv6dPTco8vxVzjxmOFtcxmvv+0mbfEY/panLQ8
         tqg5agUhFatdwcgdpgvDu216qnVXXNWhlJ9f7f0PKC2c86FzdxUdAGFgkSMRLdKFhw
         OThRoaFL7/SE/xchi0tb+OXUaIFkqUQelCZoUi5aS1gyta3c1G5CA5FZGx0bbDX5d9
         doAtTFnUzv4ZPDTznPoRwqkAo49BiIWzyvnPruavGyeSVqPoZzjEmhc8CQE1zYEfTV
         KnEjlTfwtbwZQ==
Date:   Mon, 29 Nov 2021 09:59:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <nic_swsd@realtek.com>, intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC PATCH 0/4] r8169: support dash
Message-ID: <20211129095947.547a765f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211129101315.16372-381-nic_swsd@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 18:13:11 +0800 Hayes Wang wrote:
> These patches are used to support dash for RTL8111EP and
> RTL8111FP(RTL81117).

If I understand correctly DASH is a DMTF standard for remote control.

Since it's a standard I think we should have a common way of
configuring it across drivers. Is enable/disable the only configuration
that we will need?

We don't use sysfs too much these days, can we move the knob to
devlink, please? (If we only need an on/off switch generic devlink param
should be fine).
