Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E4F233C17
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgG3XXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729896AbgG3XXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 19:23:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB2E32083E;
        Thu, 30 Jul 2020 23:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596151417;
        bh=KaGJtcuChDzyaO1wwI5yIDzbYhpfEP4Jo3C2OljSuBo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kWwmZZtniW5revsOTjapoCjYgYU8uDKtlMN+cd3mKgpRq3d8gvIcyAapf5gjefw9T
         4xFJb5oLxixlkKU8LF/9BjlrqaozDxo91ecLJBorIDxXJFVvqHEXd5ZAycDs8AT/n+
         JK3N2cAV9RNJLfKViYPBo94Y/ENGdQCGxQJ4Xz9s=
Date:   Thu, 30 Jul 2020 16:23:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ganji Aravind <ganji.aravind@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, vishal@chelsio.com,
        rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Add support to flash firmware config
 image
Message-ID: <20200730162335.6a6aa4cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200730151138.394115-1-ganji.aravind@chelsio.com>
References: <20200730151138.394115-1-ganji.aravind@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020 20:41:38 +0530 Ganji Aravind wrote:
> Update set_flash to flash firmware configuration image
> to flash region.

And the reason why you need to flash some .ini files separately is?
