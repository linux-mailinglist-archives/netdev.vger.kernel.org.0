Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A02D3BDFAF
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 01:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhGFXTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 19:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhGFXTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 19:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1612361C93;
        Tue,  6 Jul 2021 23:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625613387;
        bh=fpFDfMJtp0MCWNbRYY4Rj1xmLtC/oWXftjqlTpP9PzI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iDU05JtbtSLySmlNKwKGotblC9r2YyXgUjfCB5EGPXTCi1qEkjpb1XSNakwaWTG2s
         gLrTdkcSlFENyAwU/uMTpx/ckAmYOsBjVnc4+CIsLUrA3np7suRe5/bQuw5gsD1HUD
         a+QKqt10o+LZKticZofr6j5eVPBSeQ/gc+GWLzieiLgyTCIRWg3DyMbUxIWUjYJU9x
         ZNxPsio1U/xfpVVUkwU7UXNji8PFBRs5jFF2giWt+wOzQuciDF1v28EYLsQf4JaHeM
         nyXAthgOc2zmCRhM5TvhTfHCJ8JqC1ZOSICYpmBRRQziQiAj7vvdOZlc+SjiW/7mnj
         t5ZMHGjt132Pg==
Date:   Tue, 6 Jul 2021 16:16:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: Re: [RFC PATCH net-next 7/8] net: hns3: add support for PF setting
 rx/tx buffer size by devlink param
Message-ID: <20210706161626.05548f65@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1625553692-2773-8-git-send-email-huangguangbin2@huawei.com>
References: <1625553692-2773-1-git-send-email-huangguangbin2@huawei.com>
        <1625553692-2773-8-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Jul 2021 14:41:31 +0800 Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
> 
> Add support for PF setting rx/tx buffer size by devlink param

Please document what this parameter does under
Documentation/networking/devlink/ - see the driver
documentation already present there.
