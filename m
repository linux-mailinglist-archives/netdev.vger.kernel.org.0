Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178AF454D08
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 19:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239021AbhKQS0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 13:26:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234263AbhKQS0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 13:26:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEFD361BC1;
        Wed, 17 Nov 2021 18:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637173382;
        bh=sWJKe/8SQVs6SgDfWnpRWDalKpe+YyM+HJZGdR1UHtc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JmdKwVZTmueZEXGZMFqJYQfR5/Jy5cmEcFSy6rhizmg6ZYIUgmFfvtRNwgcrQqpiQ
         e6GXRfxT2hL65t9ZAwQJpw2/FbvQOPDvlx5R6yFkyDIYdPJtRSZ0oHUln2byNlzYJF
         l32Kuy/BVJ7bQ/pGUkU6Kz7xFWUf3KDnDEdhuNDlXbypFXeXZjEo4GcuWrI4HE8ZnI
         De1mQ5t/jP+wzG+08eBg3sQcozmBO5FjbZq/T1MecdALHcW5LLtsEOF9HSoq2vsYL/
         SLQrJzJH7GcKgz9w2COMHanpKVUJ3rFl0pYuP1umbgDczpci3NC795DhjCYQwOXWc9
         tTQ2Ek80wOSNw==
Date:   Wed, 17 Nov 2021 10:23:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kumar Thangavel <kumarthangavel.hcl@gmail.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>, openbmc@lists.ozlabs.org,
        linux-aspeed@lists.ozlabs.org, netdev@vger.kernel.org,
        patrickw3@fb.com, Amithash Prasad <amithash@fb.com>,
        sdasari@fb.com, velumanit@hcl.com
Subject: Re: [PATCH v6] Add payload to be 32-bit aligned to fix dropped
 packets
Message-ID: <20211117102300.68d00e9a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211117075513.GA12199@gmail.com>
References: <20211117075513.GA12199@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 13:25:13 +0530 Kumar Thangavel wrote:
> +const int padding_bytes = 26;

net/ncsi/ncsi-cmd.c:21:11: warning: symbol 'padding_bytes' was not declared. Should it be static?
