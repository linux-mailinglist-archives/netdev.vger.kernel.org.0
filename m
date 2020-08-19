Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BBF24A6D0
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgHSTXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:23:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgHSTXa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 15:23:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B8B52078D;
        Wed, 19 Aug 2020 19:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597865010;
        bh=FsCoB6iuixAJ/SfdnQrOC7nGOEN1FlDIv7Yr3RW2df0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cI11N8FARZJbui/StysjqncPtNWD0Apjx0jufTYeFwMmgek2IxS3PaARgQTl0PLJe
         L89qdhav21ZjZ9fOgDFyGl2f0rE/awSfai0Olp3rxuOnnN95R+UB5pw00dwSXiOj29
         c94fhZ4YAqYUvIF7MVmdoTBs2dfs0OrdEcnygd8o=
Date:   Wed, 19 Aug 2020 12:23:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com
Subject: Re: [PATCH net-next 6/6] net: mvneta: enable jumbo frames for XDP
Message-ID: <20200819122328.0dab6a53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3e0d98fafaf955868205272354e36f0eccc80430.1597842004.git.lorenzo@kernel.org>
References: <cover.1597842004.git.lorenzo@kernel.org>
        <3e0d98fafaf955868205272354e36f0eccc80430.1597842004.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 15:13:51 +0200 Lorenzo Bianconi wrote:
> Enable the capability to receive jumbo frames even if the interface is
> running in XDP mode
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Hm, already? Is all the infra in place? Or does it not imply
multi-buffer.
