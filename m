Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBD42F4086
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404629AbhAMAm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:42:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392029AbhALXzQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 18:55:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60130230FC;
        Tue, 12 Jan 2021 23:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610495675;
        bh=eZ9BVxpJjvZmiUbvt5nOCN/rIs99k/a7ZTgiM539i00=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ci3f+S1l2tIRHtepsR7dAoS7nT9l867Q5Z1bDDBcdcs1W+oo8KujTF/0Euiy7Qb5r
         GapGnMbi3TgNz22/gYG3T59fINf8/5Y0xtfnyqKCDW7t7IoRKloWculA9RxqzTQBjD
         FKlT1rE2sirbRudmIyZhC+wgbO64V24/rcskAXMqjJq2/B11tm/WVGFdEhWSH43Zi6
         x35oMTLmsT3Uf7H9KCJdq6aX12QSwPS7JAnJjxCs0DmbT1hi1WEHAW00X3si3h4StM
         yfd0NYUGxpLmV605vOLGISxo4EdVAR8F315GTHwW+f9Z3J1SiNBhMJaeDc2N0i/Ds5
         ywZQ6L6yxCVdw==
Date:   Tue, 12 Jan 2021 15:54:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] a set of fixes of coding style
Message-ID: <20210112155434.38005330@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112064305.31606-1-lijunp213@gmail.com>
References: <20210112064305.31606-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 00:42:58 -0600 Lijun Pan wrote:
> This series address several coding style problems.

Erm, are you sure this series will not conflict with the fixes
Sukadev is sending?
