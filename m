Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE8333E0B6
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhCPVk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:40:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhCPVk2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 17:40:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F6D064F4F;
        Tue, 16 Mar 2021 21:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615930828;
        bh=a/MYbzhbI18oPMRN+ZWu63CNTttZQcUEThVHUPTxa5s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d+hUfEv38nMQyvQYTLf74mvEh88kIjKKciUtAJpW3zsz5AC2h92pkaLm3UkXoOTmm
         OUmpvC8u72B39X3eYomgQ4deNxY6JZpBPoo8fPksaycYzbLeWwZ6YvTi7Kny8shv8a
         EzzMXF1fs+YSQA62GH1J6BQ2bt5DTGY6Mog5hNhnMMA2GVYl6cBYu4avxYb8b5PU+q
         CLRGYrjNni3siHzSa6TZRE+eNLfF9OELTj4Lipv7bhkRn7r/NM5/LD18UC+XbmL3ap
         u4+dHbTAp/qQ6iCCxoCUKgNbihjNTLE0AN85CzSPH5LPQR7c4a5/1guCODwYCX8R98
         440oP0oqYTLpw==
Date:   Tue, 16 Mar 2021 14:40:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        ruxandra.radulescu@nxp.com, yangbo.lu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 0/5] dpaa2-switch: small cleanup
Message-ID: <20210316144027.43a7dec7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316145512.2152374-1-ciorneiioana@gmail.com>
References: <20210316145512.2152374-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 16:55:07 +0200 Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set addresses various low-hanging issues in both dpaa2-switch
> and dpaa2-eth drivers.
> Unused ABI functions are removed from dpaa2-switch, all the kernel-doc
> warnings are fixed up in both drivers and the coding style for the
> remaining ABIs is fixed-up a bit.

Acked-by: Jakub Kicinski <kuba@kernel.org>
