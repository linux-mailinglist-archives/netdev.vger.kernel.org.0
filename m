Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBC13B6B0F
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbhF1Ww3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233035AbhF1Ww2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 18:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47AE561CC9;
        Mon, 28 Jun 2021 22:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624920601;
        bh=H6BL1k486TKe+t4QpXrk9/os9QpgymxfGXvSn9ApgfI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NvejgrmrTGG2Ow0MhsxMV88gEqLQbJWWg9NEY0YbP3dF+SEZ7U7dYEKYQcnp4zGo0
         okoOG7CD4AeJDg7qyvKv3n+xVYJIpuPSIdemNWCcrtaGdiz3H3ovHUGuOmyOSR1ReT
         IlF0x6BaNBI2O0qTqBeeW37JWTfSDwwVn2jSkytvjMn9Wb+knlMSyJhDt52YL5GqJG
         lM9LUdQ6qk5FTI7FKh5G3Ht7UdGBzvj9beCfkHKKLuY63tC66ywv1WW2c4TA2NcuWW
         GR7P0yPQZtOOsZ8lafqTIPaMpQmJSDObkMxbjTHR6viS331xLVgJ8w4L7BfCkirBcM
         svSGvo0KPoI5w==
Date:   Tue, 29 Jun 2021 00:49:58 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Kurt Cancemi <kurt@x64architecture.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: phy: marvell: Fixed handing of delays with
 plain RGMII interface
Message-ID: <20210629004958.40f3b98c@thinkpad>
In-Reply-To: <20210628192826.1855132-2-kurt@x64architecture.com>
References: <20210628192826.1855132-1-kurt@x64architecture.com>
        <20210628192826.1855132-2-kurt@x64architecture.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Jun 2021 15:28:26 -0400
Kurt Cancemi <kurt@x64architecture.com> wrote:

> This patch changes the default behavior to enable RX and TX delays for
> the PHY_INTERFACE_MODE_RGMII case by default.

And why would we want that? I was under the impression that we have the
_ID variants for enabling these delays.

Marek
