Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B729918BF2E
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 19:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgCSSSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 14:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbgCSSSG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 14:18:06 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 141B320724;
        Thu, 19 Mar 2020 18:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584641886;
        bh=NEMFBIGj+DwZ47jEBb5YApgxzFVbRT/AGxWbxss8fvI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xuNiRLVXQhJ5TmCm3xrn5g5NAs+AIsZ0//fBVS0lxXwzaNWMDuGAPjaXFi8UxIu/Q
         JRC325T8b6K8mbkA7lZ7GA12KLBuCCINItwukZq3xaKUjmSo+hWOXNqX6eb8Hu3b3u
         S0Jmps4rCV6UFTxkmwsSQuQjD6mw+dfV6bOKN7wI=
Date:   Thu, 19 Mar 2020 11:18:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, borisp@mellanox.com, secdev@chelsio.com,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: Re: [PATCH net-next v2] Crypto/chtls: add/delete TLS header in
 driver
Message-ID: <20200319111804.59b5c8ff@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200319044121.6688-1-rohitm@chelsio.com>
References: <20200319044121.6688-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Mar 2020 10:11:21 +0530 Rohit Maheshwari wrote:
> Kernel TLS forms TLS header in kernel during encryption and removes
> while decryption before giving packet back to user application. The
> similar logic is introduced in chtls code as well.
> 
> v1->v2:
> - tls_proccess_cmsg() uses tls_handle_open_record() which is not required
>   in TOE-TLS. Don't mix TOE with other TLS types.
> 
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
