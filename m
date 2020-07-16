Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC83B221ADC
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgGPDe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbgGPDe4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 23:34:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FC0D20663;
        Thu, 16 Jul 2020 03:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594870495;
        bh=H10niYhCOD51oV4cjPAgIcvgQLll9XZwC4zecYnyZYY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oMFf0eMfz9l7O/DkExLwh/lXZhv+nH0QBDu5JU/JbY4Lf/iVdJWDGmvpDs2nK/d6b
         nyVX5cpsi06GmB4LmNmg/942tSviIUMpICvMmdHy9nPy9qPBvkPoptjaAH7m6DfyvX
         MD5Qx8cnosEryphMG4xhUqQ6ChGuzwsJoymMPs1M=
Date:   Wed, 15 Jul 2020 20:34:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 3/9 v2 net-next] net: wimax: fix duplicate words in
 comments
Message-ID: <20200715203453.4781ddee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200715164246.9054-3-rdunlap@infradead.org>
References: <20200715164246.9054-1-rdunlap@infradead.org>
        <20200715164246.9054-3-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 09:42:40 -0700 Randy Dunlap wrote:
>  /*
> - * CPP sintatic sugar to generate A_B like symbol names when one of
> - * the arguments is a a preprocessor #define.
> + * CPP syntatic sugar to generate A_B like symbol names when one of

synta*c*tic

Let me fix that up before applying.

> + * the arguments is a preprocessor #define.
>   */

