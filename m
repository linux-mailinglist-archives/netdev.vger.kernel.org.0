Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74523BDFAA
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 01:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhGFXRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 19:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhGFXRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 19:17:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EAEB61C83;
        Tue,  6 Jul 2021 23:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625613273;
        bh=T73yaSFXrDNYxqB9hxov58NWOm4NhSguozQkp5Mm6FY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rYjYsWEKG4YbDT0a7BIv3ZMCc8gClTx2L30QzT8UyjfAe1NZQ2/WR8PwLrZD/mOOD
         6tbGvUpm2flRzhJce7wfaQxf4GBrJQm/ggo/uGsJl/iHilvdrZVg49/jOIKKTqnACK
         tIyGA6pFu7FvnmWfAc4riV0an2V8w4LOqEbfLNEQHkqf9PdSiOMIG6j1wGfEMlOY+p
         6ijN4nrnxJAY/RxQgrw/MPDh6DZLPjlaxLBljocdpOJI4UEH3g9gaCOUl2i3YgP3nQ
         55zr26riv20uiSmJDX9E1Cp6X0bny1ETnAPggRrOSQxc2WBJbAiMGOOB7X/4bXQ6FM
         boNqt2C5sDYUQ==
Date:   Tue, 6 Jul 2021 16:14:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: Re: [RFC PATCH net-next 3/8] net: hns3: add support for devlink get
 info for PF
Message-ID: <20210706161432.7196c6b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1625553692-2773-4-git-send-email-huangguangbin2@huawei.com>
References: <1625553692-2773-1-git-send-email-huangguangbin2@huawei.com>
        <1625553692-2773-4-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Jul 2021 14:41:27 +0800 Guangbin Huang wrote:
> +	return devlink_info_version_running_put(req, "fw-version", version_str);

Please use one of the existing names instead of "fw-version",
e.g. DEVLINK_INFO_VERSION_GENERIC_FW.
