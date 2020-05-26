Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4322E1E1878
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 02:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388211AbgEZAYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 20:24:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:33142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgEZAXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 20:23:54 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 793B9206F1;
        Tue, 26 May 2020 00:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590452633;
        bh=VAmWJ0WQFjz+KCENLj1hGyitZRXq2nPkLEJ+kzap/e8=;
        h=Date:From:To:To:To:To:Cc:CC:Cc:Subject:In-Reply-To:References:
         From;
        b=rlKj/s0eLw8tR+haIHGuGQfXE9jJ025BDdQt+vwN7WY9ZC61u+0Ardz9xspym6Egz
         r3ZjsWMAceICK165O3rSLAaBWEpTgq4lZnNVnlPyf6tNnkWcm9+ua4yp5b8ko5De5Y
         FMFHir19hbtP8mVKKkzy3u8meDWCko++VaX0z6PM=
Date:   Tue, 26 May 2020 00:23:52 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     Eric Joyner <eric.joyner@intel.com>
To:     davem@davemloft.net
Cc:     Eric Joyner <eric.joyner@intel.com>, netdev@vger.kernel.org
CC:     stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [net-next 11/17] ice: Fix resource leak on early exit from function
In-Reply-To: <20200522065607.1680050-12-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-12-jeffrey.t.kirsher@intel.com>
Message-Id: <20200526002353.793B9206F1@mail.kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181, v4.9.224, v4.4.224.

v5.6.14: Build OK!
v5.4.42: Failed to apply! Possible dependencies:
    31ad4e4ee1e4 ("ice: Allocate flow profile")
    451f2c4406e0 ("ice: Populate TCAM filter software structures")
    c90ed40cefe1 ("ice: Enable writing hardware filtering tables")
    eff380aaffed ("ice: Introduce ice_base.c")

v4.19.124: Failed to apply! Possible dependencies:
    0f9d5027a749 ("ice: Refactor VSI allocation, deletion and rebuild flow")
    28c2a6457388 ("ice: Move common functions out of ice_main.c part 4/7")
    31ad4e4ee1e4 ("ice: Allocate flow profile")
    451f2c4406e0 ("ice: Populate TCAM filter software structures")
    45d3d428eafc ("ice: Move common functions out of ice_main.c part 1/7")
    4f74dcc1b86d ("ice: Enable VSI Rx/Tx pruning only when VLAN 0 is active")
    5153a18e57ff ("ice: Move common functions out of ice_main.c part 3/7")
    72adf2421d9b ("ice: Move common functions out of ice_main.c part 2/7")
    75d2b253026b ("ice: Add support to detect SR-IOV capability and mailbox queues")
    80d144c9ac82 ("ice: Refactor switch rule management structures and functions")
    8b97ceb1dc0f ("ice: Enable firmware logging during device initialization.")
    995c90f2de81 ("ice: Calculate guaranteed VSIs per function and use it")
    9e4ab4c29a62 ("ice: Add support for dynamic interrupt moderation")
    b3969fd727aa ("ice: Add support for Tx hang, Tx timeout and malicious driver detection")
    f80eaa421076 ("ice: Clean up register file")

v4.14.181: Failed to apply! Possible dependencies:
    31ad4e4ee1e4 ("ice: Allocate flow profile")
    3a858ba392c3 ("ice: Add support for VSI allocation and deallocation")
    451f2c4406e0 ("ice: Populate TCAM filter software structures")
    7ec59eeac804 ("ice: Add support for control queues")
    837f08fdecbe ("ice: Add basic driver framework for Intel(R) E800 Series")
    940b61af02f4 ("ice: Initialize PF and setup miscellaneous interrupt")
    9c20346b6309 ("ice: Get switch config, scheduler config and device capabilities")
    9daf8208dd4d ("ice: Add support for switch filter programming")
    dc49c7723676 ("ice: Get MAC/PHY/link info and scheduler topology")
    f31e4b6fe227 ("ice: Start hardware initialization")

v4.9.224: Failed to apply! Possible dependencies:
    31ad4e4ee1e4 ("ice: Allocate flow profile")
    3a858ba392c3 ("ice: Add support for VSI allocation and deallocation")
    451f2c4406e0 ("ice: Populate TCAM filter software structures")
    7ec59eeac804 ("ice: Add support for control queues")
    837f08fdecbe ("ice: Add basic driver framework for Intel(R) E800 Series")
    940b61af02f4 ("ice: Initialize PF and setup miscellaneous interrupt")
    9c20346b6309 ("ice: Get switch config, scheduler config and device capabilities")
    9daf8208dd4d ("ice: Add support for switch filter programming")
    dc49c7723676 ("ice: Get MAC/PHY/link info and scheduler topology")
    f31e4b6fe227 ("ice: Start hardware initialization")

v4.4.224: Failed to apply! Possible dependencies:
    31ad4e4ee1e4 ("ice: Allocate flow profile")
    3a858ba392c3 ("ice: Add support for VSI allocation and deallocation")
    451f2c4406e0 ("ice: Populate TCAM filter software structures")
    7ec59eeac804 ("ice: Add support for control queues")
    837f08fdecbe ("ice: Add basic driver framework for Intel(R) E800 Series")
    940b61af02f4 ("ice: Initialize PF and setup miscellaneous interrupt")
    9c20346b6309 ("ice: Get switch config, scheduler config and device capabilities")
    9daf8208dd4d ("ice: Add support for switch filter programming")
    dc49c7723676 ("ice: Get MAC/PHY/link info and scheduler topology")
    f31e4b6fe227 ("ice: Start hardware initialization")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
