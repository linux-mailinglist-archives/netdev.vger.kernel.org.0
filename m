Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2CF71A4D54
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 03:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDKBmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 21:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgDKBmS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 21:42:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51C2720787;
        Sat, 11 Apr 2020 01:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586569338;
        bh=TlWPRcugfxTM2kUJcDCVDhwnxcm0WQOANdo5r72TpYI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hmxI6CLym6qPnsXFq1HyNF0HVYbj9UyfzznsUgu5FfC5vekDR3xPskA/hm3F8W7Ls
         jgTX+dxO4x7/SB5bSPgjyjEoiIYWO2NCSxp73vjxKOaLdG6JOMnlPaIS0rnsmorHFW
         6BYZpwryklmiHPJGKOGT9QLmpc9PnwjTzeNzh54E=
Date:   Fri, 10 Apr 2020 18:42:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Konstantin Kharlamov <Hi-Angel@yandex.ru>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] scsi: cxgb3i: move docs to functions documented
Message-ID: <20200410184216.0a64b1c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200410170732.411665-1-Hi-Angel@yandex.ru>
References: <20200410170732.411665-1-Hi-Angel@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Apr 2020 20:07:32 +0300 Konstantin Kharlamov wrote:
> Move documentation for push_tx_frames near the push_tx_frames function,
> and likewise for release_offload_resources.
> 
> Signed-off-by: Konstantin Kharlamov <Hi-Angel@yandex.ru>

While at this could you also update the name of the parameter?
s/c3cn/csk/.

> +/**
> + * release_offload_resources - release offload resource
> + * @c3cn: the offloaded iscsi tcp connection.
> + * Release resources held by an offload connection (TID, L2T entry, etc.)
> + */
>  static void release_offload_resources(struct cxgbi_sock *csk)
