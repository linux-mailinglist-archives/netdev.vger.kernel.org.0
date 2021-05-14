Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412E03810BA
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 21:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhENT3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 15:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhENT3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 15:29:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3528961454;
        Fri, 14 May 2021 19:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621020470;
        bh=QkbloS0HYvsxucC0LooIPfXa5alsqmun9aaNrqoDmVc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fg5+e2x2uYDdStrSSjiarXQ/1hCahYL3p2scVfYWHGTXVRJNfhehKPMNmP6X2fPz/
         gOqkxdirXiY/tMFI+5NYKVV5oxJbAzq+NOFeRVaRGlMP8rMyONBKH+w7OOEmG7b1bd
         KGTyp0wd/kfkT2iIhiY9QcHKm6WRR7pHDXuAIbHcxiUj61eIlzot99oilT1r+ScKhe
         lVcb5Y9+Kn4aZ74EZYqfezya8IBv/N0SaG6y4COuombbVPGqIkUNl/DKZxFiv1AeyY
         CjLmy3PTTpSzmpNWlAzcZ9tXyQGwgwSO1Jqptj9pnn4fGnhfGQt/7s1Kt1JOGBx5jH
         z6IAZjsqRr6hQ==
Date:   Fri, 14 May 2021 12:27:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jim Ma <majinjing3@gmail.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] tls splice: check SPLICE_F_NONBLOCK instead of
 MSG_DONTWAIT
Message-ID: <20210514122749.6dd15b9e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <96f2e74095e655a401bb921062a6f09e94f8a57a.1620961779.git.majinjing3@gmail.com>
References: <96f2e74095e655a401bb921062a6f09e94f8a57a.1620961779.git.majinjing3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 May 2021 11:11:02 +0800 Jim Ma wrote:
> In tls_sw_splice_read, checkout MSG_* is inappropriate, should use
> SPLICE_*, update tls_wait_data to accept nonblock arguments instead
> of flags for recvmsg and splice.
> 
> Signed-off-by: Jim Ma <majinjing3@gmail.com>

Fixes: c46234ebb4d1 ("tls: RX path for ktls")

right?
