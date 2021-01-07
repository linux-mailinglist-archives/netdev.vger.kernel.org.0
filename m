Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA692ED77C
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 20:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbhAGTcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 14:32:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:47210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbhAGTcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 14:32:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDCC923433;
        Thu,  7 Jan 2021 19:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610047934;
        bh=KD2d/HjId3c1d07ZMR758SvSHkBSpYzckecXXV8Y640=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FmebzbIu/KDboa1VvrNV7qrwDBvEihhwTe9bzQX7ttgGhy7uXsnn4xXiXyuKxAlWT
         Tudq8I+6UCfY+Sxbhh6EGCjgt6B6lyUQNLCr5Zy7Zsht/QH7d/WzzFp5nBAxTEElbt
         SKhySQ2U63s+RYLittUfVx7TXULUK8lmsmqG1VvnrOdMAIkwsskFeJGWDtSyMozNlr
         IlfER7FKuo8txdYhG2t4WJ0siNv+3UF23oFr2nBDwmFkmbpfrl4rJcNtLjVlFaANHP
         DimpT3+8hHlpjsrZpS5wN7688BDDUPfSAQgtHQXEwHxIpq3c8Phxx5kvRuYVV+8e5b
         nmnm2HAvNee0g==
Date:   Thu, 7 Jan 2021 11:32:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, roland@kernel.org
Subject: Re: support for USB network devices without MDIO to report speed
Message-ID: <20210107113213.4193cac5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107113518.21322-1-oneukum@suse.com>
References: <20210107113518.21322-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 12:35:15 +0100 Oliver Neukum wrote:
> The assumption that a USB network devices would contain an MDIO
> accessible to the host is true only for a subset of genuine
> ethernet devices. It is not true for class devices like NCM.
> Hence an implementation purely internal to usbnet is needed.

Would you mind putting the standard prefix/tag on the cover letter
([PATCH 0/3])? It seems patchwork does not recognize the cover letter
otherwise.

Please keep checkpatch happy WRT alignment of continuation lines vs (
