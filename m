Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1B24599AB
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 02:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhKWB0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 20:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231601AbhKWB0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 20:26:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DCA860FED;
        Tue, 23 Nov 2021 01:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637630578;
        bh=iYsDybsy5v30IxKH/zxDg+JRKzcQF/Euu9hrDYlzsW8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=In1mJ4cpBGRVZfwyi00O4PNFyYgE/UUuyDt+yo0IKgXJTu3wf+YRXcbBnzyPgUP8y
         neQwTITgQbydMGvpRiKq/jtFAOBY9J4NWp/HtlP2XiscqewK1vc8plIcGZDoGUoAeQ
         YGrv7vSEi1rNX2lNcIcSrg6kQ0qc3wYN8MDRueNM/o5Sj6dWlbHPWHygbi29VLUoGI
         PULSXO2h4zYlO1p7lOeowdrur7UZpNYzl0h5Wi8Ll2ZIZkwBjPfJ4G2jzI2WK9j4Cy
         7wWBtGAVuHYCG4Nd/Buv+h8wxeKob6F+QZm/hvhNeweXzQ5Vg46NVX7R/q7sYbo66V
         NuqSCz+CUaSOg==
Date:   Mon, 22 Nov 2021 17:22:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Rani <sunrani@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <parav@nvidia.com>, <jiri@nvidia.com>, <saeedm@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211122144307.218021-2-sunrani@nvidia.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211122144307.218021-2-sunrani@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Nov 2021 16:43:06 +0200 Sunil Rani wrote:
> The device/firmware decides how to define privileges and access to resources.

Great API definition. nack
