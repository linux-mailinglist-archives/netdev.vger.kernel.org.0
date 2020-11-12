Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D462B12B7
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgKLXZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:25:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKLXZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 18:25:24 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F006216C4;
        Thu, 12 Nov 2020 23:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605223523;
        bh=+M+SFw0G+ApwR9Ct4A6HcDsdhooPuMpK4hkQ9kX4VyI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FwRFYfDWdwAZwz503N3gol3RK2E2bokFGBlw1h5gInLan2B88Ylwzw29dHaEmLYsb
         pPmHCQrD3t3IOLt/Yn320/qgKBe+AfVxZp8Uv+n9WwjY9d1iGhD1SSdo0qKbH3yPRu
         70GDnVUuWpfOMHUIV109+zJaMr/xxasII5CnV00A=
Date:   Thu, 12 Nov 2020 15:25:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-next@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: kcov: don't select SKB_EXTENSIONS when
 there is no NET
Message-ID: <20201112152522.02af9fa2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110175746.11437-1-rdunlap@infradead.org>
References: <20201110175746.11437-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 09:57:46 -0800 Randy Dunlap wrote:
> Fix kconfig warning when CONFIG_NET is not set/enabled:
> 
> WARNING: unmet direct dependencies detected for SKB_EXTENSIONS
>   Depends on [n]: NET [=n]
>   Selected by [y]:
>   - KCOV [=y] && ARCH_HAS_KCOV [=y] && (CC_HAS_SANCOV_TRACE_PC [=y] || GCC_PLUGINS [=n])
> 
> Fixes: 6370cc3bbd8a ("net: add kcov handle to skb extensions")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

> This is from linux-next. I'm only guessing that it is in net-next.

Yup, applied, thanks!
