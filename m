Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1FF1FF852
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731694AbgFRP5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731645AbgFRP5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 11:57:24 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A63120732;
        Thu, 18 Jun 2020 15:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592495843;
        bh=yOK9ZKCV3aiXNG3VrKpU+lumJHKMGUHzmP+zlrZ+sHI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NtRbu2cPtnbgaGOMa0dnWnL1RR3W8MiGitf3FvkvVz9kshmKUIS7Z50lDxYKU8F7F
         4DWhSkltMASyAZpN+SBwaoRuPPBojQH5mPjgZp7ryRjaceWh7pJd9AxpSOZEh6nS2F
         W2CDlpX6fT+FR0mb5bPNnU+yeQT8m1//fgLk/K3Y=
Date:   Thu, 18 Jun 2020 08:57:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net] ibmveth: Fix max MTU limit
Message-ID: <20200618085722.110f3702@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1592495026-27202-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1592495026-27202-1-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jun 2020 10:43:46 -0500 Thomas Falcon wrote:
> The max MTU limit defined for ibmveth is not accounting for
> virtual ethernet buffer overhead, which is twenty-two additional
> bytes set aside for the ethernet header and eight additional bytes
> of an opaque handle reserved for use by the hypervisor. Update the
> max MTU to reflect this overhead.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

How about

Fixes: d894be57ca92 ("ethernet: use net core MTU range checking in more drivers")
Fixes: 110447f8269a ("ethernet: fix min/max MTU typos")

?
