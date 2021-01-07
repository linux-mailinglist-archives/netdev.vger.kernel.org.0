Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E552ED775
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbhAGTa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:30:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:47004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbhAGTaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 14:30:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED20823433;
        Thu,  7 Jan 2021 19:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610047785;
        bh=WqlPpCdqee1pSKbrmGmk8ns+Kt793L1rRiRPZIZBEZE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SdmcIDfI09WKCxUwJRMKk420v/Kwy5TyGEofkl/t1hlWaUEg3pzyc/qYG+EM2ZEBH
         PHU3Fem+nVJxIDLjrrSoaPFq4jGPu1FcxHmDLXl+zUdkVHiEQIqgGXxrSePleLvbEN
         JZMwW11xeUQ7BXn2q2vpZCEDZqxNSeS8mJAhjr+zwRZu5Qrxumo/xkRH7PLYFD2SCY
         JN+UtQfr9OnbgRxgCgWJcfIjx5cJMYrOKTtUZ1ZhFHET75Nyd0Mm4U4TgidqaojN9E
         6VnFl9oahxYMPR+SQFWQkkliyijoVFudew4nqUrp0tTxgFw7Fjh1WfKLs9b0gxjjms
         +vIF0x3n0+Fig==
Date:   Thu, 7 Jan 2021 11:29:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, roland@kernel.org
Subject: Re: [PATCH 1/3] usbnet: specify naming of
 usbnet_set/get_link_ksettings
Message-ID: <20210107112943.780bf661@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107113518.21322-2-oneukum@suse.com>
References: <20210107113518.21322-1-oneukum@suse.com>
        <20210107113518.21322-2-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 12:35:16 +0100 Oliver Neukum wrote:
> Signed-off-by : Oliver Neukum <oneukum@suse.com>

Since seems like you may respin with Andrew's suggestion: nit - extra
space before :.
