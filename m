Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061192FC36A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbhASW1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:51398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbhASW1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 17:27:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA26422E01;
        Tue, 19 Jan 2021 22:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611095197;
        bh=uIOT/3L5GhxgcjUmYU3MpTLKoR48A8k1lXBlag+18cQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WAyHPLWnmhvqIncFgn7Q4nZmharmkj5xddMzG9yqXWrVu47KjnuoqeWo+CQRBZ9rx
         AOHGIcxpChGklHBehBcg5aapURS11ksyzFniCFBRhbrCP/kwOYIoje+qi/wg0TJj79
         /lwk9jhqfCU0EvlzRZ8NVOVSoedER2AxFVlmVUpQlmt9jUrgWV7Gjw4Ei16iEbB62d
         A7KsQyBA6oD0q9qaiSe+Fx5tMYvMu8kferZpoYX5Ht1q1lDyTA6Rt6wjD/t7YLcr9z
         JcTzpP2R3tLtsmUDjMwBNXwYui6fF2i+2rX3O6BIsvg1AiMLXP4cMEVkeoqe93Q3v0
         oO4LG9QTQbyWQ==
Date:   Tue, 19 Jan 2021 14:26:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v5] net/af_unix: don't create a path for a bound socket
Message-ID: <20210119142635.186110b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119112446.21180-1-kda@linux-powerpc.org>
References: <20210119112446.21180-1-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 14:24:46 +0300 Denis Kirjanov wrote:
> In the case of a socket which is already bound to an adress
> there is no sense to create a path in the next attempts
> 
> here is a program that shows the issue:

Appears to not build in allmodconfig net-next:

ERROR: modpost: "kern_path_locked" [net/unix/unix.ko] undefined!
