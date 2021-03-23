Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05DF346000
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhCWNnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231388AbhCWNnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 09:43:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E56861931;
        Tue, 23 Mar 2021 13:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616507019;
        bh=mdddZvp5x0zYX5TOootSoD8M/E3qTJFRI7zcAyCNzc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fgQvH++0twRXNDTu/cPfTIYlyVyOJEqBWS+5UQiZmrkY2adgzzxy17Td4E3SmQXN1
         lN17vSk3dHdIDybVhkRj1VqBr5akdnljlOZ+K/SOjfjehzLtmrQubFMzRQfWLbLcma
         Txb65BrK+muM1RPEvT2GGxfphZzA1DPqHIBSkI+0=
Date:   Tue, 23 Mar 2021 14:43:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xiaoming Ni <nixiaoming@huawei.com>
Cc:     linux-kernel@vger.kernel.org, kiyin@tencent.com,
        stable@vger.kernel.org, sameo@linux.intel.com,
        linville@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        mkl@pengutronix.de, stefan@datenfreihafen.org,
        matthieu.baerts@tessares.net, netdev@vger.kernel.org,
        wangle6@huawei.com, xiaoqian9@huawei.com
Subject: Re: [PATCH 0/4] nfc: fix Resource leakage and endless loop
Message-ID: <YFnwiFmgejk/TKOX@kroah.com>
References: <20210303061654.127666-1-nixiaoming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210303061654.127666-1-nixiaoming@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 03, 2021 at 02:16:50PM +0800, Xiaoming Ni wrote:
> fix Resource leakage and endless loop in net/nfc/llcp_sock.c,
>  reported by "kiyin(尹亮)".
> 
> Link: https://www.openwall.com/lists/oss-security/2020/11/01/1

What happened to this series?

Does it need to be resent against the latest networking tree?

thanks,

greg k-h
