Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68232F88C1
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 23:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbhAOWrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 17:47:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbhAOWrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 17:47:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0ACA221E2;
        Fri, 15 Jan 2021 22:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610750786;
        bh=0i+bIfqW9WLFWve9mUUoq2bB7zfI5uH9yUGxgX7bR1c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lQtni3CRYbQaGo2J+jAjC4cTlkv+qhDtr260lFb6q9hhGCevErcV4mglsV4sME4eu
         zqZGy+UANooDaln+IVddJ/udHlzj6sED5kOYCt077sUrNe62WjBRrPgHncHzYtd0Rk
         3s5TZ1wf9H6PeHU9agqw8bWPaZRKX/3SXOiWUFp2QjK0WSsZfWTVpBEGgKbQe1sOCG
         SOpNiw1LDMlTuLjRIiq/in3cIaeOAiAaMVuckbQ6znG9I3koBQErd+cI5p6lMfEnUt
         NJRortdeRZCHSVp/64qeReSgZvVJHTit/wmaOwQKUNkayQc3G8uoqsScF6M58dXcEW
         d1YwP6j7vDHhg==
Date:   Fri, 15 Jan 2021 14:46:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: Re: [PATCHv2 net-next 2/2] Revert "bareudp: Fixed bareudp receive
 handling"
Message-ID: <20210115144624.51fd70b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1984207281c8f03b61968731487cd436dba40b80.1610695758.git.lucien.xin@gmail.com>
References: <cover.1610695758.git.lucien.xin@gmail.com>
        <f85095ae5835c102d0b8434214f48084f4f4f279.1610695758.git.lucien.xin@gmail.com>
        <1984207281c8f03b61968731487cd436dba40b80.1610695758.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 15:30:09 +0800 Xin Long wrote:
> As udp_encap_enable() is already called in udp_tunnel_encap_enable()
> since the last patch, and we don't need it any more. So remove it by
> reverting commit 81f954a44567567c7d74a97b1db78fb43afc253d.

missing signoff on this one
